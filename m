Return-Path: <linux-kernel-owner+w=401wt.eu-S1946012AbXBICpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946012AbXBICpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946025AbXBICpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:45:23 -0500
Received: from alpha.polcom.net ([217.79.150.67]:40821 "EHLO alpha.polcom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946012AbXBICpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:45:22 -0500
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 21:45:22 EST
Date: Fri, 9 Feb 2007 03:26:42 +0100 (CET)
From: Grzegorz Kulewski <kangur@polcom.net>
To: linux-kernel@vger.kernel.org
Subject: Strange oops in iret_exc with my own module
Message-ID: <Pine.LNX.4.63.0702090309050.6097@alpha.polcom.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I written really simple and stupid module (the design wasn't mine). One 
tester of this module provided me the following oops it caused quite often 
(on many automated tests):

[17179765.492000] BUG: unable to handle kernel NULL pointer dereference at 
virtual address 00000000
[17179765.492000]  printing eip:
[17179765.492000] c02c4845
[17179765.492000] *pde = 00000000
[17179765.492000] Oops: 0002 [#1]
[17179765.492000] Modules linked in: altpinfo rfcomm l2cap bluetooth ppdev 
cpufreq_userspace cpufreq_stats freq_table
cpufreq_powersave cpufreq_ondemand cpufreq_conservative video button 
battery container ac af_packet dm_mod md_mod ipv6
lp snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq 
snd_via82xx gameport snd_ac97_codec snd_ac97_bus
via686a snd_pcm_oss snd_mixer_oss tsdev i2c_isa i2c_viapro usbhid snd_pcm 
snd_timer snd_page_alloc snd_mpu401_uart
snd_rawmidi snd_seq_device i2c_core snd soundcore psmouse 8139too mii 
pcspkr floppy serio_raw parport_pc rtc via_agp
agpgart parport shpchp pci_hotplug evdev ext3 jbd mbcache ide_generic 
uhci_hcd usbcore ide_cd cdrom ide_disk via82cxxx
generic thermal processor fan vga16fb cfbcopyarea vgastate cfbimgblt 
cfbfillrect
[17179765.492000] CPU:    0
[17179765.492000] EIP:    0060:[<c02c4845>]    Not tainted VLI
[17179765.492000] EFLAGS: 00210246   (2.6.17.13nopreempt #3)
[17179765.492000] EIP is at iret_exc+0x4fd/0x75d
[17179765.492000] eax: 00000000   ebx: 00000000   ecx: 2b646970   edx: 
336e3094
[17179765.492000] esi: 0809c724   edi: 00000000   ebp: 00000003   esp: 
c32b3f34
[17179765.492000] ds: 007b   es: 007b   ss: 0068
[17179765.492000] Process so6-3-test (pid: 7227, threadinfo=c32b2000 
task=c620e550)
[17179765.492000] Stack: 00000000 2b646970 00000000 2b646970 d0833913 
00000000 0809c724 2b646970
[17179765.492000]        0809c720 c47c8d40 40040c01 0809c720 c016a5f2 
cadb0624 c47c8d40 40040c01
[17179765.492000]        0809c720 c47c8d40 00000000 c016a654 c015845a 
cffefa80 c47c8d40 c016a90d
[17179765.492000] Call Trace:
[17179765.492000]  <d0833913> altpinfo_ioctl+0x103/0x170 [altpinfo] 
<c016a5f2> do_ioctl+0x52/0x60
[17179765.492000]  <c016a654> vfs_ioctl+0x54/0x2b0  <c015845a> 
do_sys_open+0x9a/0xd0
[17179765.492000]  <c016a90d> sys_ioctl+0x5d/0x90  <c0102d27> 
syscall_call+0x7/0xb
[17179765.492000] Code: 5c 24 28 c7 03 f2 ff ff ff e9 12 be f0 ff ba f2 ff 
ff ff e9 6d c0 f0 ff 8d 0c 8a e9 8f c0 f0 ff
01 c1 eb 03 8d 0c 88 51 50 31 c0 <f3> aa 58 59 e9 ca c0 f0 ff 8d 0c 88 51 
50 31 c0 f3 aa 58 59 e9
[17179765.492000] EIP: [<c02c4845>] iret_exc+0x4fd/0x75d SS:ESP 
0068:c32b3f34
[17179765.492000]  <6>altpinfo: unloaded


The function altpinfo_ioctl looks like this:

static int altpinfo_ioctl(struct inode *inode, struct file *f, unsigned 
int cmd, unsigned long arg)
{
         int ret = 0;

         switch (cmd) {

         case API_GET_FMT:
                 ret = put_fmt((char __user *)arg);
                 break;

         case API_SET_FMT:
                 if (!capable(CAP_SYS_ADMIN)) {
                         return -EPERM;
                 }

                 ret = get_fmt((char __user *)arg);
                 break;

         case API_GET_CURLEN:
                 ret = put_curlen(f, (int __user *)arg);
                 break;

         default:
                 ret = -ENOTTY;
                 break;

         }

         return ret;
}


Helper functions look like this:

static int put_curlen(struct file *f, int __user *arg)
{
         int left;
         struct private_data *p = (struct private_data *) f->private_data;

         if (down_interruptible(&p->sem) != 0) {
                 return -ERESTARTSYS;
         }

         left = p->buffer_size - f->f_pos;

         up(&p->sem);

         return put_user(left, arg);
}

static int put_fmt(char __user *arg)
{
         char *fmt;
         int ret;

         ret = get_format_string(&fmt);

         if (ret != 0) {
                 return ret;
         }

         if (copy_to_user(arg, fmt, strlen(fmt)) != 0) {
                 return -EIO;
         }

         kfree(fmt);

         return 0;
}

/* Better make arg buffer at least 4 bytes alligned in userspace! */
static int get_fmt(char __user *arg)
{
         int ret;
         int len;
         char *buf;

         ret = get_user(len, (int __user *)arg);

         if (ret != 0) {
                 return ret;
         }

         buf = kcalloc(len, sizeof(char), GFP_KERNEL);

         if (copy_from_user(buf, arg + 4, len) != 0) {
                 kfree(buf);
                 return -EIO;
         }

         buf[len] = '\0';

         ret = parse_format(buf);

         if (ret != 0) {
                 kfree(buf);
                 return ret;
         }

         return 0;
}


I wonder what does this oops mean and what that function iret_exc really 
does and why? It looks like some automagical exception handler but I am 
not sure about it.

I can't reproduce this oops for now on my machine. Could anybody tell me 
why that code is wrong and why is this oops in iret_exc? (At the same time 
I am waiting for further info from the tester but I am not sure when and 
how much I will get.)

Any help on tracing this down would be appreciated.


Thanks,

Grzegorz Kulewski


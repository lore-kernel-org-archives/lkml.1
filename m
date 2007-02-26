Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbXBZB0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbXBZB0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 20:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933738AbXBZB0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 20:26:11 -0500
Received: from web52904.mail.yahoo.com ([206.190.49.14]:44602 "HELO
	web52904.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933743AbXBZB0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 20:26:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=r8PVRHjEx0w5fqTGp40Iquh2KP3nZnTnsMqh1vp6VqPVsiAioD2XgcHrBAie5+gydNiz2B7OEQEtWyfr5hwrgVJHlhAOXHwTu3giXTfFNYYfsec8FmlIEkkpIviu1otnxfRTCVI6XDvXYMHB/I1N6JVZuzI1jY+x1Dktz/hoxUE=;
X-YMail-OSG: dDUxsrwVM1nNsmMS1_B1wZx4mr0HQOxE9LMwE.4VFc0vENNBOcwhdK48Nirm8KbaXw8zfKcFVaAIDL6ARzxlYAG.DkvffUw_mxH__Nm6le10LO1L7lE.DFDOxSaTkaOyk8oKcuA3aU3K2KI-
Date: Mon, 26 Feb 2007 01:26:06 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] Linux 2.6.20.1 - unable to handle kernel paging request - accessing freed memory?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <689096.76239.qm@web52904.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This looks like a memory fault to me; are those 0x6b characters "slab poisoning"? This is the dual
P4 Xeon / 2 GB RAM machine, and I'm guessing that udevd has just loaded snd_rtctimer (because
that's the module at the top of the list):

BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
 printing eip:
c013010b
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
Modules linked in: snd_rtctimer radeon drm pwc eeprom cpufreq_ondemand p4_clockmod speedstep_lib
nfsd exportfs ipv6 autofs4 nfs lockd sunrpc af_packet firmware_class binfmt_misc video thermal
processor fan button ac lp parport_pc parport nvram video1394 raw1394 eth1394 compat_ioctl32
videodev snd_usb_audio sd_mod snd_usb_lib v4l2_common sg v4l1_compat snd_emu10k1_synth
snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus
snd_seq_dummy snd_seq_oss ohci1394 snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ieee1394
snd_pcm ehci_hcd snd_seq_device uhci_hcd snd_timer snd_page_alloc snd_util_mem sata_sil libata
e7xxx_edac edac_mc snd_hwdep i2c_i801 e1000 serio_raw psmouse scsi_mod snd soundcore pcspkr
i2c_core intel_agp agpgart ide_cd cdrom usbcore ext3 jbd
CPU:    0
EIP:    0060:[<c013010b>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20.1 #1)
EIP is at module_put+0x20/0x52
eax: 6b6b6ceb   ebx: 6b6b6b6b   ecx: 00000001   edx: e5bf0000
esi: e9040b08   edi: 6b6b6b6b   ebp: eae0bb3c   esp: e5bf0f58
ds: 007b   es: 007b   ss: 0068
Process udevd (pid: 18662, ti=e5bf0000 task=e6aaa030 task.ti=e5bf0000)
Stack: eb3ff7bc c01839fe 00000010 ed009b7c ed9291d0 c015124b 00000000 00000000
       f7ff2208 ed009b7c f7bd0678 00000000 ed009b7c c014ed88 00000003 00000003
       f7bd0678 f7bd06f8 c014fd81 00000003 00000007 00000003 e5bf0000 c0102bce
Call Trace:
 [<c01839fe>] sysfs_release+0x2d/0x4c
 [<c015124b>] __fput+0x96/0x13c
 [<c014ed88>] filp_close+0x51/0x58
 [<c014fd81>] sys_close+0x70/0xa7
 [<c0102bce>] sysenter_past_esp+0x5f/0x85
 [<c0270033>] __sched_text_start+0x703/0x958
 =======================
Code: 00 89 f0 83 c4 0c 5b 5e 5f 5d c3 53 89 c3 85 c0 74 49 b8 01 00 00 00 e8 63 49 fe ff e8 e3 5a
07 00 c1 e0 07 8d 84 18 80 01 00 00 <ff> 08 83 3b 02 75 0b 8b 83 88 05 00 00 e8 ad 45 fe ff b8 01
00
EIP: [<c013010b>] module_put+0x20/0x52 SS:ESP 0068:e5bf0f58
 <6>note: udevd[18662] exited with preempt_count 1
BUG: scheduling while atomic: udevd/0x10000001/18662
 [<c026f986>] __sched_text_start+0x56/0x958
 [<c011cc6e>] irq_exit+0x37/0x42
 [<c010d1d3>] smp_apic_timer_interrupt+0x70/0x79
 [<c010369c>] apic_timer_interrupt+0x28/0x30
 [<c0114afd>] __cond_resched+0x12/0x2c
 [<c027088c>] cond_resched+0x26/0x31
 [<c01404ca>] unmap_vmas+0x3d3/0x4df
 [<c0142ced>] exit_mmap+0x7e/0x10a
 [<c0116bd3>] mmput+0x1d/0x78
 [<c011b31e>] do_exit+0x1b2/0x6d8
 [<c011007b>] sys_vm86+0x9d/0x21d
 [<c01040f7>] die+0x1f2/0x217
 [<c011180a>] do_page_fault+0x442/0x510
 [<c01113c8>] do_page_fault+0x0/0x510
 [<c02722b4>] error_code+0x7c/0x84
 [<c013010b>] module_put+0x20/0x52
 [<c01839fe>] sysfs_release+0x2d/0x4c
 [<c015124b>] __fput+0x96/0x13c
 [<c014ed88>] filp_close+0x51/0x58
 [<c014fd81>] sys_close+0x70/0xa7
 [<c0102bce>] sysenter_past_esp+0x5f/0x85
 [<c0270033>] __sched_text_start+0x703/0x958
 =======================



		
___________________________________________________________ 
All New Yahoo! Mail – Tired of unwanted email come-ons? Let our SpamGuard protect you. http://uk.docs.yahoo.com/nowyoucan.html

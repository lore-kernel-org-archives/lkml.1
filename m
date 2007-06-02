Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbXFBIfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbXFBIfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 04:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXFBIfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 04:35:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016AbXFBIfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 04:35:09 -0400
Date: Sat, 2 Jun 2007 01:35:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOPS (NULL pointer dereference) in v2.6.22-rc3
Message-Id: <20070602013502.a20ad424.akpm@linux-foundation.org>
In-Reply-To: <20070601221515.GA6673@steel.home>
References: <20070601221515.GA6673@steel.home>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 00:15:15 +0200 Alex Riesen <raa.lkml@gmail.com> wrote:

> Ubuntu 7.04, P4, SMT, hyperthreading active. Not reproducable, context unknown,
> seen only two times :(
> 
> kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> kernel:  printing eip:
> kernel: 00000000
> kernel: *pde = 00000000
> kernel: Oops: 0000 [#1]
> kernel: SMP 
> kernel: Modules linked in: binfmt_misc fan button firmware_class it87 hwmon_vid hwmon i2c_isa p4_clockmod speedstep_lib ipv6 snd_intel8x0 snd_ac97_codec sr_mod cdrom ac97_bus usb_storage snd_pcm_oss sg piix snd_pcm snd_mixer_oss snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd e100 floppy generic ehci_hcd uhci_hcd soundcore snd_page_alloc intel_agp agpgart ide_core evdev
> kernel: CPU:    1
> kernel: EIP:    0060:[<00000000>]    Not tainted VLI
> kernel: EFLAGS: 00210246   (2.6.22-rc3-t #74)
> kernel: EIP is at 0x0
> kernel: eax: f635b040   ebx: c02df2e0   ecx: 00005403   edx: d2b798c0
> kernel: esi: d2b798c0   edi: bfca8f48   ebp: e9df5f6c   esp: e9df5f54
> kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> kernel: Process watch (pid: 24035, ti=e9df5000 task=e2ed8030 task.ti=e9df5000)
> kernel: Stack: c0164f04 bfca8f48 00005403 d2b798c0 d2b798c0 bfca8f48 e9df5f98 c016514d 
> kernel:        00000001 e9fb8f49 00000644 00010612 e2ed8140 c1817980 d2b798c0 fffffff7 
> kernel:        b7e95ff4 e9df5fb0 c0165191 bfca8f48 00000000 00000001 bfca8f48 e9df5000 
> kernel: Call Trace:
> kernel:  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
> kernel:  [show_stack_log_lvl+157/165] show_stack_log_lvl+0x9d/0xa5
> kernel:  [show_registers+441/651] show_registers+0x1b9/0x28b
> kernel:  [die+273/530] die+0x111/0x212
> kernel:  [do_page_fault+1060/1266] do_page_fault+0x424/0x4f2
> kernel:  [error_code+114/120] error_code+0x72/0x78
> kernel:  [vfs_ioctl+562/581] vfs_ioctl+0x232/0x245
> kernel:  [sys_ioctl+49/72] sys_ioctl+0x31/0x48
> kernel:  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
> kernel:  =======================
> kernel: Code:  Bad EIP value.
> kernel: EIP: [<00000000>] 0x0 SS:ESP 0068:e9df5f54
> gconfd (raa-2316): Exiting
> init: tty4 main process (1607) killed by TERM signal
> init: tty5 main process (1608) killed by TERM signal
> init: tty2 main process (1610) killed by TERM signal
> init: tty3 main process (1613) killed by TERM signal
> init: tty1 main process (1614) killed by TERM signal
> init: tty6 main process (1615) killed by TERM signal
> gdm[1950]: GDM detected a halt or restart in progress.
> kernel: mtrr: no MTRR for ec000000,4000000 found
> kernel: mtrr: no MTRR for e8000000,4000000 found
> postfix/master[2041]: terminating on signal 15
> exiting on signal 15
> 

I think we've seen a report of that before.  Do you recall what the system
was doing at the time?

Anyway, please add this, which might catch it:

--- a/fs/ioctl.c~a
+++ a/fs/ioctl.c
@@ -20,6 +20,7 @@ static long do_ioctl(struct file *filp, 
 		unsigned long arg)
 {
 	int error = -ENOTTY;
+	void *f;
 
 	if (!filp->f_op)
 		goto out;
@@ -29,10 +30,15 @@ static long do_ioctl(struct file *filp, 
 		if (error == -ENOIOCTLCMD)
 			error = -EINVAL;
 		goto out;
-	} else if (filp->f_op->ioctl) {
+	} else if ((f = filp->f_op->ioctl)) {
 		lock_kernel();
-		error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
-					  filp, cmd, arg);
+		if (!filp->f_op->ioctl) {
+			printk("%s: ioctl %p disappeared\n", __FUNCTION__, f);
+			error = 0;
+		} else {
+			error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
+						  filp, cmd, arg);
+		}
 		unlock_kernel();
 	}
 
_


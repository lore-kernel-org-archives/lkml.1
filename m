Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZGCCVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZGCCVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZGCCVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:21:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbZGCCVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:21:04 -0400
Date: Thu, 2 Jul 2009 19:20:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Subject: Re: mmotm 2009-06-30-12-50 dies during early boot
Message-Id: <20090702192047.10b81ada.akpm@linux-foundation.org>
In-Reply-To: <11314.1246585948@turing-police.cc.vt.edu>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
	<11314.1246585948@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jul 2009 21:52:28 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> (Would have gotten this out the door earlier, but I got confused about what
> that 'G' in the 'Tainted' meant, and put off reporting till I could reproduce
> it without the NVidia driver. Turns out it was untainted except for the
> warning I already reported...)
> 
> Dies fairly early during boot, somewhere in the first few lines of rc.sysinit.
> 
> It *looks* like it dies in this call:
> 
> 	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);
> 
> in selinux_bprm_committed_creds().  Not sure which part of that is the duff
> pointer, though...
> 
> [   16.829082] hub 1-2:1.0: hub_suspend
> [   16.848165] usb 1-2: unlink qh256-0001/ffff88007e053140 start 1 [1/0 us]
> [   16.867813] usb 1-2: usb auto-suspend
> [   17.827106] cat used greatest stack depth: 4280 bytes left
> [   17.846392] Oops: 0000 [#1] PREEMPT SMP 
> [   17.847007] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda2/dev
> [   17.847007] CPU 0 
> [   17.847007] Modules linked in:
> [   17.847007] Pid: 887, comm: mount Tainted: G        W  2.6.31-rc1-mmotm0630 #1 Latitude D820                   
> [   17.847007] RIP: 0010:[<ffffffff81040873>]  [<ffffffff81040873>] child_wait_callback+0x3d/0x5f
> [   17.847007] RSP: 0018:ffff88007f051c28  EFLAGS: 00010046
> [   17.847007] RAX: 000000000000000e RBX: 0000000000000001 RCX: 0000000000000000
> [   17.847007] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88007eb9bf20
> [   17.847007] RBP: ffff88007f051c28 R08: 0000000000000000 R09: 0000000000000001
> [   17.847007] R10: ffff88007f051c68 R11: ffff88007f051c68 R12: 0000000000000001
> [   17.847007] R13: ffff88007f9965e0 R14: 0000000000000000 R15: 0000000000000000
> [   17.847007] FS:  00007fa8f6c646f0(0000) GS:ffff880002121000(0000) knlGS:0000000000000000
> [   17.847007] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   17.847007] CR2: 0000000000000270 CR3: 000000007fb3f000 CR4: 00000000000006f0
> [   17.847007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   17.847007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   17.847007] Process mount (pid: 887, threadinfo ffff88007f050000, task ffff88007eb96a80)
> [   17.847007] Stack:
> [   17.847007]  ffff88007f051c78 ffffffff8102df4a 0000000000000000 ffff88007f9965f8
> [   17.847007] <0> ffff88007f051c78 ffff88007f9965c8 0000000000000282 ffff88007e3acbc0
> [   17.847007] <0> ffff88007f051f58 00007fd172b0faf0 ffff88007f051cb8 ffffffff810305d8
> [   17.847007] Call Trace:
> [   17.847007]  [<ffffffff8102df4a>] __wake_up_common+0x49/0x7f
> [   17.847007]  [<ffffffff810305d8>] __wake_up+0x34/0x48
> [   17.847007]  [<ffffffff81176a19>] selinux_bprm_committed_creds+0x11d/0x132
> [   17.847007]  [<ffffffff8105be4d>] ? commit_creds+0x1d5/0x1df
> [   17.847007]  [<ffffffff8116dc46>] security_bprm_committed_creds+0x11/0x13
> [   17.847007]  [<ffffffff810d5420>] install_exec_creds+0x30/0x35
> [   17.847007]  [<ffffffff81110de5>] load_elf_binary+0x10d1/0x1990
> [   17.847007]  [<ffffffff814a8bc0>] ? sub_preempt_count+0x35/0x48
> [   17.847007]  [<ffffffff810d5101>] search_binary_handler+0xbd/0x2cc
> [   17.847007]  [<ffffffff8110fd14>] ? load_elf_binary+0x0/0x1990
> [   17.847007]  [<ffffffff810d69e8>] do_execve+0x26e/0x3c2
> [   17.847007]  [<ffffffff81009b15>] sys_execve+0x5b/0x78
> [   17.847007]  [<ffffffff8100b7ca>] stub_execve+0x6a/0xc0
> [   17.847007] Code: 81 00 03 00 00 eb 14 89 c0 48 6b c0 18 48 03 81 c0 02 00 00 48 8b 80 00 03 00 00 48 3b 47 e0 75 21 8b 47 dc 41 89 c0 41 c1 e8 1f <83> b9 70 02 00 00 11 41 0f 95 c1 45 38 c1 74 0b a9 00 00 00 40 
> [   17.847007] RIP  [<ffffffff81040873>] child_wait_callback+0x3d/0x5f
> [   17.847007]  RSP <ffff88007f051c28>
> [   17.847007] CR2: 0000000000000270
> [   17.847007] ---[ end trace a7919e7f17c0a727 ]---

Well I'm not seeing any significant changes to security/selinux/hooks.c
in ages.  Perhaps this was a result of some Oleg changes, or some
credentials changes elsewhere.



Something's gone wrong with your oops output - it did't actually tell
us why it oopsed.  Perhaps because we've screwed up the printk facility
levels in there and at your loglevel some messages are being
suppressed.

Anyway, scripts/decodecode says

[ 17.847007] Code: 81 00 03 00 00 eb 14 89 c0 48 6b c0 18 48 03 81 c0 02 00 00 48 8b 80 00 03 00 00 48 3b 47 e0 75 21 8b 47 dc 41 89 c0 41 c1 e8 1f <83> b9 70 02 00 00 11 41 0f 95 c1 45 38 c1 74 0b a9 00 00 00 40
All code
========
   0:	81 00 03 00 00 eb    	addl   $0xeb000003,(%rax)
   6:	14 89                	adc    $0x89,%al
   8:	c0 48 6b c0          	rorb   $0xc0,0x6b(%rax)
   c:	18 48 03             	sbb    %cl,0x3(%rax)
   f:	81 c0 02 00 00 48    	add    $0x48000002,%eax
  15:	8b 80 00 03 00 00    	mov    0x300(%rax),%eax
  1b:	48 3b 47 e0          	cmp    -0x20(%rdi),%rax
  1f:	75 21                	jne    0x42
  21:	8b 47 dc             	mov    -0x24(%rdi),%eax
  24:	41 89 c0             	mov    %eax,%r8d
  27:	41 c1 e8 1f          	shr    $0x1f,%r8d
  2b:*	83 b9 70 02 00 00 11 	cmpl   $0x11,0x270(%rcx)     <-- trapping instruction
  32:	41 0f 95 c1          	setne  %r9b
  36:	45 38 c1             	cmp    %r8b,%r9b
  39:	74 0b                	je     0x46
  3b:	a9 00 00 00 40       	test   $0x40000000,%eax

Code starting with the faulting instruction
===========================================
   0:	83 b9 70 02 00 00 11 	cmpl   $0x11,0x270(%rcx)
   7:	41 0f 95 c1          	setne  %r9b
   b:	45 38 c1             	cmp    %r8b,%r9b
   e:	74 0b                	je     0x1b
  10:	a9 00 00 00 40       	test   $0x40000000,%eax


and your %rcx is zero, so it's a null-pointer deref.

Let me see if I can do another mmotm - perhaps we magically fixed it.


Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753177AbYLQVfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbYLQVfb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYLQVey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:34:54 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38962 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbYLQVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:34:53 -0500
Date: Wed, 17 Dec 2008 22:34:48 +0100
From: Sebastian Andrzej Siewior <linuxppc-dev@ml.breakpoint.cc>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: "booke: Fix problem with _tlbil_va being interrupted" causes BUG()
Message-ID: <20081217213448.GA27343@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just pulled from Linus and the Kernel I booted gave me this:
| Freeing unused kernel memory: 152k init
| BUG: sleeping function called from invalid context at /home/bigeasy/git/linux-2.6-powerpc/fs/exec.c:417
| in_atomic(): 0, irqs_disabled(): 1, pid: 1, name: swapper
| Call Trace:
| [ef831dd0] [c0007764] show_stack+0x48/0x154 (unreliable)
| [ef831e00] [c002b4d0] __might_sleep+0x118/0x11c
| [ef831e10] [c009bcfc] copy_strings+0x70/0x324
| [ef831e70] [c009bfd0] copy_strings_kernel+0x20/0x38
| [ef831e90] [c009d3b8] do_execve+0x15c/0x1ec
| [ef831ec0] [c00084ac] sys_execve+0x58/0x84
| [ef831ee0] [c000f0e8] ret_from_syscall+0x0/0x3c
| [ef831fa0] [c0001d68] init_post+0x54/0x174
| [ef831fc0] [c038a1c0] kernel_init+0xdc/0x104
| [ef831ff0] [c000ee68] kernel_thread+0x4c/0x68
| ------------[ cut here ]------------

It looks like userspace starts here. A bisect leads to

|commit e5e774d8833de1a0037be2384efccadf16935675
|Author: Kumar Gala <galak@kernel.crashing.org>
|Date:   Sat Dec 13 17:01:37 2008 -0600
|
|    powerpc/fsl-booke: Fix problem with _tlbil_va being interrupted
|    
|    An example calling sequence which we did see:
|    
|    copy_user_highpage -> kmap_atomic -> flush_tlb_page -> _tlbil_va
|    
|    We got interrupted after setting up the MAS registers before the
|    tlbwe and the interrupt handler that caused the interrupt also did
|    a kmap_atomic (ide code) and thus on returning from the interrupt
|    the MAS registers no longer contained the proper values.
|    
|    Since we dont save/restore MAS registers for normal interrupts we
|    need to disable interrupts in _tlbil_va to ensure atomicity.
|    
|    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
|
|:040000 040000 1f298a8930bd2704f4481307f3d22589943bb5c0 7e3847dab748c332c8533111de32d23731ec778b M      arch

as the guilty commit.
This box has highmem.

Sebastian

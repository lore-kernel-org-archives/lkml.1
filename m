Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0BOGaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:30:24 -0500
Received: from ozlabs.org ([203.10.76.45]:42770 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab0BOGaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:30:22 -0500
From: Michael Neuling <mikey@neuling.org>
To: Jouni Malinen <j@w1.fi>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       anton@samba.org
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
In-reply-to: <20100214164023.GA2726@jm.kir.nu>
References: <20100214164023.GA2726@jm.kir.nu>
Comments: In-reply-to Jouni Malinen <j@w1.fi>
   message dated "Sun, 14 Feb 2010 18:40:23 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Mon, 15 Feb 2010 17:30:20 +1100
Message-ID: <12468.1266215420@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <20100214164023.GA2726@jm.kir.nu> you wrote:
> It looks like the commit 803bf5ec259941936262d10ecc84511b76a20921
> (fs/exec.c: restrict initial stack space expansion to rlimit) broke my
> user mode Linux setup by somehow preventing system setup from running
> properly (or killing some processes that try to mount things, etc.).
> This commit turned up as the reason based on git bisect and reverting it
> fixes my UML test setup (Ubuntu 9.10 on both host and in UML and AMD64
> arch for both). I have no idea what exactly would be the main cause for
> this issue, but this looks like a somewhat unfortunately timed
> regression in 2.6.33-rc8.
> 
> The failed run shows like this (with current linux-2.6.git):
> 
> ...
> EXT3-fs (ubda): mounted filesystem with writeback data mode
> VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> mountall: mount /sys/kernel/debug [218] killed by KILL signal
> mountall: Filesystem could not be mounted: /sys/kernel/debug
> mountall: mount /dev [219] killed by KILL signal
> mountall: Filesystem could not be mounted: /dev
> mountall: mount /tmp [220] killed by KILL signal
> mountall: Filesystem could not be mounted: /tmp
> mountall: mount /var/lock [222] killed by KILL signal
> mountall: Filesystem could not be mounted: /var/lock
> ...
> 
> 
> With 803bf5ec reverted, UML comes up and the output looks like this:
> 
> ...
> EXT3-fs (ubda): mounted filesystem with writeback data mode
> VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> init: procps main process (226) terminated with status 255
> fsck from util-linux-ng 2.16
> ...

Jouni,

I can reproduce this now.  

We got the logic wrong in one of the cleanups and hence we aren't
actually changing the stack reservation ever, when we intended on
allocating up to 20 new pages.  

The:
	rlim_stack = min(rlim_stack, stack_size);
always chooses stack_size hence we end up not changing the stack at all.
This seems to cause fatal problems on UML, but is obviously not what was
intended for archs as well.  

The following works for me on PPC64 64k and 4k pages and UML on x86_64. 

Let me know if it fixes it for you also.

Mikey


exec/fs: fix initial stack reservation

803bf5ec259941936262d10ecc84511b76a20921 (fs/exec.c: restrict initial
stack space expansion to rlimit) attempts to limit the initial stack to
20*PAGE_SIZE.  Unfortunately, in also attempting ensure the stack is not
reduced in size, we ended up not changing the stack at all.  

This caused a regression in UML resulting in most guest processes to be
killed. 

Signed-off-by: Michael Neuling <mikey@neuling.org>
cc: <stable@kernel.org>

diff --git a/fs/exec.c b/fs/exec.c
index e95c692..e0e7b3c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -637,15 +637,16 @@ int setup_arg_pages(struct linux_binprm *bprm,
 	 * will align it up.
 	 */
 	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
-	rlim_stack = min(rlim_stack, stack_size);
 #ifdef CONFIG_STACK_GROWSUP
 	if (stack_size + stack_expand > rlim_stack)
-		stack_base = vma->vm_start + rlim_stack;
+		/*  Expand only to rlimit, making sure not to shrink it */
+		stack_base = vma->vm_start + max(rlim_stack,stack_size);
 	else
 		stack_base = vma->vm_end + stack_expand;
 #else
 	if (stack_size + stack_expand > rlim_stack)
-		stack_base = vma->vm_end - rlim_stack;
+		/*  Expand only to rlimit, making sure not to shrink it */
+		stack_base = vma->vm_end - max(rlim_stack,stack_size);
 	else
 		stack_base = vma->vm_start - stack_expand;
 #endif



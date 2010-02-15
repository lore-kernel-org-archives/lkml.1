Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab0BOI5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 03:57:14 -0500
Received: from ozlabs.org ([203.10.76.45]:41839 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab0BOI5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:57:12 -0500
From: Michael Neuling <mikey@neuling.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Jouni Malinen <j@w1.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, anton@samba.org
Subject: [PATCH] exec/fs: fix initial stack reservation
In-reply-to: <20100215155821.7298.A69D9226@jp.fujitsu.com>
References: <20100214164023.GA2726@jm.kir.nu> <12468.1266215420@neuling.org> <20100215155821.7298.A69D9226@jp.fujitsu.com>
Comments: In-reply-to KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
   message dated "Mon, 15 Feb 2010 15:59:26 +0900."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Mon, 15 Feb 2010 19:57:11 +1100
Message-ID: <15521.1266224231@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20100215155821.7298.A69D9226@jp.fujitsu.com> you wrote:
> > 
> > 
> > In message <20100214164023.GA2726@jm.kir.nu> you wrote:
> > > It looks like the commit 803bf5ec259941936262d10ecc84511b76a20921
> > > (fs/exec.c: restrict initial stack space expansion to rlimit) broke my
> > > user mode Linux setup by somehow preventing system setup from running
> > > properly (or killing some processes that try to mount things, etc.).
> > > This commit turned up as the reason based on git bisect and reverting it
> > > fixes my UML test setup (Ubuntu 9.10 on both host and in UML and AMD64
> > > arch for both). I have no idea what exactly would be the main cause for
> > > this issue, but this looks like a somewhat unfortunately timed
> > > regression in 2.6.33-rc8.
> > > 
> > > The failed run shows like this (with current linux-2.6.git):
> > > 
> > > ...
> > > EXT3-fs (ubda): mounted filesystem with writeback data mode
> > > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> > > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> > > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > > mountall: mount /sys/kernel/debug [218] killed by KILL signal
> > > mountall: Filesystem could not be mounted: /sys/kernel/debug
> > > mountall: mount /dev [219] killed by KILL signal
> > > mountall: Filesystem could not be mounted: /dev
> > > mountall: mount /tmp [220] killed by KILL signal
> > > mountall: Filesystem could not be mounted: /tmp
> > > mountall: mount /var/lock [222] killed by KILL signal
> > > mountall: Filesystem could not be mounted: /var/lock
> > > ...
> > > 
> > > 
> > > With 803bf5ec reverted, UML comes up and the output looks like this:
> > > 
> > > ...
> > > EXT3-fs (ubda): mounted filesystem with writeback data mode
> > > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> > > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> > > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > > init: procps main process (226) terminated with status 255
> > > fsck from util-linux-ng 2.16
> > > ...
> > 
> > Jouni,
> > 
> > I can reproduce this now.  
> > 
> > We got the logic wrong in one of the cleanups and hence we aren't
> > actually changing the stack reservation ever, when we intended on
> > allocating up to 20 new pages.  
> > 
> > The:
> > 	rlim_stack = min(rlim_stack, stack_size);
> > always chooses stack_size hence we end up not changing the stack at all.
> > This seems to cause fatal problems on UML, but is obviously not what was
> > intended for archs as well.  
> > 
> > The following works for me on PPC64 64k and 4k pages and UML on x86_64. 
> > 
> > Let me know if it fixes it for you also.
> > 
> > Mikey
> > 
> > 
> > exec/fs: fix initial stack reservation
> > 
> > 803bf5ec259941936262d10ecc84511b76a20921 (fs/exec.c: restrict initial
> > stack space expansion to rlimit) attempts to limit the initial stack to
> > 20*PAGE_SIZE.  Unfortunately, in also attempting ensure the stack is not
> > reduced in size, we ended up not changing the stack at all.  
> > 
> > This caused a regression in UML resulting in most guest processes to be
> > killed. 
> > 
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > cc: <stable@kernel.org>
> > 
> > diff --git a/fs/exec.c b/fs/exec.c
> > index e95c692..e0e7b3c 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -637,15 +637,16 @@ int setup_arg_pages(struct linux_binprm *bprm,
> >  	 * will align it up.
> >  	 */
> >  	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
> > -	rlim_stack = min(rlim_stack, stack_size);
> >  #ifdef CONFIG_STACK_GROWSUP
> >  	if (stack_size + stack_expand > rlim_stack)
> > -		stack_base = vma->vm_start + rlim_stack;
> > +		/*  Expand only to rlimit, making sure not to shrink it */
> > +		stack_base = vma->vm_start + max(rlim_stack,stack_size);
> >  	else
> >  		stack_base = vma->vm_end + stack_expand;
> >  #else
> >  	if (stack_size + stack_expand > rlim_stack)
> > -		stack_base = vma->vm_end - rlim_stack;
> > +		/*  Expand only to rlimit, making sure not to shrink it */
> > +		stack_base = vma->vm_end - max(rlim_stack,stack_size);
> >  	else
> >  		stack_base = vma->vm_start - stack_expand;
> >  #endif
> 
> -	rlim_stack = min(rlim_stack, stack_size);
> +	/*  Expand only to rlimit, making sure not to shrink it */
> +	rlim_stack = max(rlim_stack, stack_size);
> 
> is better fix?

Actually, I think we can just get rid of min() line altogether.
expand_stack checks to make sure the stack is getting bigger, otherwise
it does nothing.  We don't need to bother with this check.

The below works for me on UML x86_64 and ppc64 64k and 4k pages.

Mikey

exec/fs: fix initial stack reservation

803bf5ec259941936262d10ecc84511b76a20921 (fs/exec.c: restrict initial
stack space expansion to rlimit) attempts to limit the initial stack to
20*PAGE_SIZE.  Unfortunately, in attempting ensure the stack is not
reduced in size, we ended up not changing the stack at all.

This size reduction check is not necessary as the expand_stack call does
this already.

This caused a regression in UML resulting in most guest processes being
killed.

Signed-off-by: Michael Neuling <mikey@neuling.org>
cc: <stable@kernel.org>
---
 fs/exec.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6-ozlabs/fs/exec.c
===================================================================
--- linux-2.6-ozlabs.orig/fs/exec.c
+++ linux-2.6-ozlabs/fs/exec.c
@@ -637,7 +637,6 @@ int setup_arg_pages(struct linux_binprm 
 	 * will align it up.
 	 */
 	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
-	rlim_stack = min(rlim_stack, stack_size);
 #ifdef CONFIG_STACK_GROWSUP
 	if (stack_size + stack_expand > rlim_stack)
 		stack_base = vma->vm_start + rlim_stack;

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0BOJEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:04:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50443 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0BOJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:04:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH] exec/fs: fix initial stack reservation
Cc: kosaki.motohiro@jp.fujitsu.com, Jouni Malinen <j@w1.fi>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       anton@samba.org
In-Reply-To: <15521.1266224231@neuling.org>
References: <20100215155821.7298.A69D9226@jp.fujitsu.com> <15521.1266224231@neuling.org>
Message-Id: <20100215180347.72AD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Feb 2010 18:04:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In message <20100215155821.7298.A69D9226@jp.fujitsu.com> you wrote:
> > > 
> > > 
> > > In message <20100214164023.GA2726@jm.kir.nu> you wrote:
> > > > It looks like the commit 803bf5ec259941936262d10ecc84511b76a20921
> > > > (fs/exec.c: restrict initial stack space expansion to rlimit) broke my
> > > > user mode Linux setup by somehow preventing system setup from running
> > > > properly (or killing some processes that try to mount things, etc.).
> > > > This commit turned up as the reason based on git bisect and reverting it
> > > > fixes my UML test setup (Ubuntu 9.10 on both host and in UML and AMD64
> > > > arch for both). I have no idea what exactly would be the main cause for
> > > > this issue, but this looks like a somewhat unfortunately timed
> > > > regression in 2.6.33-rc8.
> > > > 
> > > > The failed run shows like this (with current linux-2.6.git):
> > > > 
> > > > ...
> > > > EXT3-fs (ubda): mounted filesystem with writeback data mode
> > > > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> > > > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> > > > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> > > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > > > mountall: mount /sys/kernel/debug [218] killed by KILL signal
> > > > mountall: Filesystem could not be mounted: /sys/kernel/debug
> > > > mountall: mount /dev [219] killed by KILL signal
> > > > mountall: Filesystem could not be mounted: /dev
> > > > mountall: mount /tmp [220] killed by KILL signal
> > > > mountall: Filesystem could not be mounted: /tmp
> > > > mountall: mount /var/lock [222] killed by KILL signal
> > > > mountall: Filesystem could not be mounted: /var/lock
> > > > ...
> > > > 
> > > > 
> > > > With 803bf5ec reverted, UML comes up and the output looks like this:
> > > > 
> > > > ...
> > > > EXT3-fs (ubda): mounted filesystem with writeback data mode
> > > > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> > > > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> > > > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> > > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > > > init: procps main process (226) terminated with status 255
> > > > fsck from util-linux-ng 2.16
> > > > ...
> > > 
> > > Jouni,
> > > 
> > > I can reproduce this now.  
> > > 
> > > We got the logic wrong in one of the cleanups and hence we aren't
> > > actually changing the stack reservation ever, when we intended on
> > > allocating up to 20 new pages.  
> > > 
> > > The:
> > > 	rlim_stack = min(rlim_stack, stack_size);
> > > always chooses stack_size hence we end up not changing the stack at all.
> > > This seems to cause fatal problems on UML, but is obviously not what was
> > > intended for archs as well.  
> > > 
> > > The following works for me on PPC64 64k and 4k pages and UML on x86_64. 
> > > 
> > > Let me know if it fixes it for you also.
> > > 
> > > Mikey
> > > 
> > > 
> > > exec/fs: fix initial stack reservation
> > > 
> > > 803bf5ec259941936262d10ecc84511b76a20921 (fs/exec.c: restrict initial
> > > stack space expansion to rlimit) attempts to limit the initial stack to
> > > 20*PAGE_SIZE.  Unfortunately, in also attempting ensure the stack is not
> > > reduced in size, we ended up not changing the stack at all.  
> > > 
> > > This caused a regression in UML resulting in most guest processes to be
> > > killed. 
> > > 
> > > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > > cc: <stable@kernel.org>
> > > 
> > > diff --git a/fs/exec.c b/fs/exec.c
> > > index e95c692..e0e7b3c 100644
> > > --- a/fs/exec.c
> > > +++ b/fs/exec.c
> > > @@ -637,15 +637,16 @@ int setup_arg_pages(struct linux_binprm *bprm,
> > >  	 * will align it up.
> > >  	 */
> > >  	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
> > > -	rlim_stack = min(rlim_stack, stack_size);
> > >  #ifdef CONFIG_STACK_GROWSUP
> > >  	if (stack_size + stack_expand > rlim_stack)
> > > -		stack_base = vma->vm_start + rlim_stack;
> > > +		/*  Expand only to rlimit, making sure not to shrink it */
> > > +		stack_base = vma->vm_start + max(rlim_stack,stack_size);
> > >  	else
> > >  		stack_base = vma->vm_end + stack_expand;
> > >  #else
> > >  	if (stack_size + stack_expand > rlim_stack)
> > > -		stack_base = vma->vm_end - rlim_stack;
> > > +		/*  Expand only to rlimit, making sure not to shrink it */
> > > +		stack_base = vma->vm_end - max(rlim_stack,stack_size);
> > >  	else
> > >  		stack_base = vma->vm_start - stack_expand;
> > >  #endif
> > 
> > -	rlim_stack = min(rlim_stack, stack_size);
> > +	/*  Expand only to rlimit, making sure not to shrink it */
> > +	rlim_stack = max(rlim_stack, stack_size);
> > 
> > is better fix?
> 
> Actually, I think we can just get rid of min() line altogether.
> expand_stack checks to make sure the stack is getting bigger, otherwise
> it does nothing.  We don't need to bother with this check.
> 
> The below works for me on UML x86_64 and ppc64 64k and 4k pages.

OK, Right you are.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> 
> Mikey
> 
> exec/fs: fix initial stack reservation
> 
> 803bf5ec259941936262d10ecc84511b76a20921 (fs/exec.c: restrict initial
> stack space expansion to rlimit) attempts to limit the initial stack to
> 20*PAGE_SIZE.  Unfortunately, in attempting ensure the stack is not
> reduced in size, we ended up not changing the stack at all.
> 
> This size reduction check is not necessary as the expand_stack call does
> this already.
> 
> This caused a regression in UML resulting in most guest processes being
> killed.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> cc: <stable@kernel.org>
> ---
>  fs/exec.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linux-2.6-ozlabs/fs/exec.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/fs/exec.c
> +++ linux-2.6-ozlabs/fs/exec.c
> @@ -637,7 +637,6 @@ int setup_arg_pages(struct linux_binprm 
>  	 * will align it up.
>  	 */
>  	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
> -	rlim_stack = min(rlim_stack, stack_size);
>  #ifdef CONFIG_STACK_GROWSUP
>  	if (stack_size + stack_expand > rlim_stack)
>  		stack_base = vma->vm_start + rlim_stack;




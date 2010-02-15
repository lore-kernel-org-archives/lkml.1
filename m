Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0BOJF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:05:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63499 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0BOJFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:05:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GtusRrF49oevlO+SRM2ejYa4T+iKCwbSio3jHctwHYREM622UtoIJbruZMh7OcjH2z
         pf95bG3ES66cbDOQtangrF7eJvEq9WYfs92jSREVUu5puEVXbn6TwY/OkYgrB8ivQeK4
         upu3FXw0O3akZW5Xz/hYfsADWhUBzUKuEiC4M=
Date: Mon, 15 Feb 2010 17:08:02 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jouni Malinen <j@w1.fi>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       anton@samba.org
Subject: Re: [PATCH] exec/fs: fix initial stack reservation
Message-ID: <20100215090802.GH12076@hack.private>
References: <20100214164023.GA2726@jm.kir.nu> <12468.1266215420@neuling.org> <20100215155821.7298.A69D9226@jp.fujitsu.com> <15521.1266224231@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15521.1266224231@neuling.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 07:57:11PM +1100, Michael Neuling wrote:
>In message <20100215155821.7298.A69D9226@jp.fujitsu.com> you wrote:
>> > 
>> > 
>> > In message <20100214164023.GA2726@jm.kir.nu> you wrote:
>> > > It looks like the commit 803bf5ec259941936262d10ecc84511b76a20921
>> > > (fs/exec.c: restrict initial stack space expansion to rlimit) broke my
>> > > user mode Linux setup by somehow preventing system setup from running
>> > > properly (or killing some processes that try to mount things, etc.).
>> > > This commit turned up as the reason based on git bisect and reverting it
>> > > fixes my UML test setup (Ubuntu 9.10 on both host and in UML and AMD64
>> > > arch for both). I have no idea what exactly would be the main cause for
>> > > this issue, but this looks like a somewhat unfortunately timed
>> > > regression in 2.6.33-rc8.
>> > > 
>> > > The failed run shows like this (with current linux-2.6.git):
>> > > 
>> > > ...
>> > > EXT3-fs (ubda): mounted filesystem with writeback data mode
>> > > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
>> > > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
>> > > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
>> > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
>> > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
>> > > mountall: mount /sys/kernel/debug [218] killed by KILL signal
>> > > mountall: Filesystem could not be mounted: /sys/kernel/debug
>> > > mountall: mount /dev [219] killed by KILL signal
>> > > mountall: Filesystem could not be mounted: /dev
>> > > mountall: mount /tmp [220] killed by KILL signal
>> > > mountall: Filesystem could not be mounted: /tmp
>> > > mountall: mount /var/lock [222] killed by KILL signal
>> > > mountall: Filesystem could not be mounted: /var/lock
>> > > ...
>> > > 
>> > > 
>> > > With 803bf5ec reverted, UML comes up and the output looks like this:
>> > > 
>> > > ...
>> > > EXT3-fs (ubda): mounted filesystem with writeback data mode
>> > > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
>> > > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
>> > > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
>> > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
>> > > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
>> > > init: procps main process (226) terminated with status 255
>> > > fsck from util-linux-ng 2.16
>> > > ...
>> > 
>> > Jouni,
>> > 
>> > I can reproduce this now.  
>> > 
>> > We got the logic wrong in one of the cleanups and hence we aren't
>> > actually changing the stack reservation ever, when we intended on
>> > allocating up to 20 new pages.  
>> > 
>> > The:
>> > 	rlim_stack = min(rlim_stack, stack_size);
>> > always chooses stack_size hence we end up not changing the stack at all.
>> > This seems to cause fatal problems on UML, but is obviously not what was
>> > intended for archs as well.  
>> > 
>> > The following works for me on PPC64 64k and 4k pages and UML on x86_64. 
>> > 
>> > Let me know if it fixes it for you also.
>> > 
>> > Mikey
>> > 
>> > 
>> > exec/fs: fix initial stack reservation
>> > 
>> > 803bf5ec259941936262d10ecc84511b76a20921 (fs/exec.c: restrict initial
>> > stack space expansion to rlimit) attempts to limit the initial stack to
>> > 20*PAGE_SIZE.  Unfortunately, in also attempting ensure the stack is not
>> > reduced in size, we ended up not changing the stack at all.  
>> > 
>> > This caused a regression in UML resulting in most guest processes to be
>> > killed. 
>> > 
>> > Signed-off-by: Michael Neuling <mikey@neuling.org>
>> > cc: <stable@kernel.org>
>> > 
>> > diff --git a/fs/exec.c b/fs/exec.c
>> > index e95c692..e0e7b3c 100644
>> > --- a/fs/exec.c
>> > +++ b/fs/exec.c
>> > @@ -637,15 +637,16 @@ int setup_arg_pages(struct linux_binprm *bprm,
>> >  	 * will align it up.
>> >  	 */
>> >  	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
>> > -	rlim_stack = min(rlim_stack, stack_size);
>> >  #ifdef CONFIG_STACK_GROWSUP
>> >  	if (stack_size + stack_expand > rlim_stack)
>> > -		stack_base = vma->vm_start + rlim_stack;
>> > +		/*  Expand only to rlimit, making sure not to shrink it */
>> > +		stack_base = vma->vm_start + max(rlim_stack,stack_size);
>> >  	else
>> >  		stack_base = vma->vm_end + stack_expand;
>> >  #else
>> >  	if (stack_size + stack_expand > rlim_stack)
>> > -		stack_base = vma->vm_end - rlim_stack;
>> > +		/*  Expand only to rlimit, making sure not to shrink it */
>> > +		stack_base = vma->vm_end - max(rlim_stack,stack_size);
>> >  	else
>> >  		stack_base = vma->vm_start - stack_expand;
>> >  #endif
>> 
>> -	rlim_stack = min(rlim_stack, stack_size);
>> +	/*  Expand only to rlimit, making sure not to shrink it */
>> +	rlim_stack = max(rlim_stack, stack_size);
>> 
>> is better fix?
>
>Actually, I think we can just get rid of min() line altogether.
>expand_stack checks to make sure the stack is getting bigger, otherwise
>it does nothing.  We don't need to bother with this check.
>

Right...

Above change makes me confused. :-( But now, everything is clear.


>The below works for me on UML x86_64 and ppc64 64k and 4k pages.
>
>Mikey
>
>exec/fs: fix initial stack reservation
>
>803bf5ec259941936262d10ecc84511b76a20921 (fs/exec.c: restrict initial
>stack space expansion to rlimit) attempts to limit the initial stack to
>20*PAGE_SIZE.  Unfortunately, in attempting ensure the stack is not
>reduced in size, we ended up not changing the stack at all.
>
>This size reduction check is not necessary as the expand_stack call does
>this already.
>
>This caused a regression in UML resulting in most guest processes being
>killed.
>
>Signed-off-by: Michael Neuling <mikey@neuling.org>
>cc: <stable@kernel.org>


This one definitely better.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

>---
> fs/exec.c |    1 -
> 1 file changed, 1 deletion(-)
>
>Index: linux-2.6-ozlabs/fs/exec.c
>===================================================================
>--- linux-2.6-ozlabs.orig/fs/exec.c
>+++ linux-2.6-ozlabs/fs/exec.c
>@@ -637,7 +637,6 @@ int setup_arg_pages(struct linux_binprm 
> 	 * will align it up.
> 	 */
> 	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
>-	rlim_stack = min(rlim_stack, stack_size);
> #ifdef CONFIG_STACK_GROWSUP
> 	if (stack_size + stack_expand > rlim_stack)
> 		stack_base = vma->vm_start + rlim_stack;
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0BOJDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:03:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36300 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0BOJDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:03:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
Cc: kosaki.motohiro@jp.fujitsu.com, Michael Neuling <mikey@neuling.org>,
       Jouni Malinen <j@w1.fi>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, anton@samba.org
In-Reply-To: <20100215085743.GF12076@hack.private>
References: <20100215155821.7298.A69D9226@jp.fujitsu.com> <20100215085743.GF12076@hack.private>
Message-Id: <20100215180156.72AA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Feb 2010 18:03:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Feb 15, 2010 at 03:59:26PM +0900, KOSAKI Motohiro wrote:
> >> 
> >> 
> >> In message <20100214164023.GA2726@jm.kir.nu> you wrote:
> >> > It looks like the commit 803bf5ec259941936262d10ecc84511b76a20921
> >> > (fs/exec.c: restrict initial stack space expansion to rlimit) broke my
> >> > user mode Linux setup by somehow preventing system setup from running
> >> > properly (or killing some processes that try to mount things, etc.).
> >> > This commit turned up as the reason based on git bisect and reverting it
> >> > fixes my UML test setup (Ubuntu 9.10 on both host and in UML and AMD64
> >> > arch for both). I have no idea what exactly would be the main cause for
> >> > this issue, but this looks like a somewhat unfortunately timed
> >> > regression in 2.6.33-rc8.
> >> > 
> >> > The failed run shows like this (with current linux-2.6.git):
> >> > 
> >> > ...
> >> > EXT3-fs (ubda): mounted filesystem with writeback data mode
> >> > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> >> > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > mountall: mount /sys/kernel/debug [218] killed by KILL signal
> >> > mountall: Filesystem could not be mounted: /sys/kernel/debug
> >> > mountall: mount /dev [219] killed by KILL signal
> >> > mountall: Filesystem could not be mounted: /dev
> >> > mountall: mount /tmp [220] killed by KILL signal
> >> > mountall: Filesystem could not be mounted: /tmp
> >> > mountall: mount /var/lock [222] killed by KILL signal
> >> > mountall: Filesystem could not be mounted: /var/lock
> >> > ...
> >> > 
> >> > 
> >> > With 803bf5ec reverted, UML comes up and the output looks like this:
> >> > 
> >> > ...
> >> > EXT3-fs (ubda): mounted filesystem with writeback data mode
> >> > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> >> > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> >> > init: procps main process (226) terminated with status 255
> >> > fsck from util-linux-ng 2.16
> >> > ...
> >> 
> >> Jouni,
> >> 
> >> I can reproduce this now.  
> >> 
> >> We got the logic wrong in one of the cleanups and hence we aren't
> >> actually changing the stack reservation ever, when we intended on
> >> allocating up to 20 new pages.  
> >> 
> >> The:
> >> 	rlim_stack = min(rlim_stack, stack_size);
> >> always chooses stack_size hence we end up not changing the stack at all.
> >> This seems to cause fatal problems on UML, but is obviously not what was
> >> intended for archs as well.  
> >> 
> >> The following works for me on PPC64 64k and 4k pages and UML on x86_64. 
> >> 
> >> Let me know if it fixes it for you also.
> >> 
> >> Mikey
> >> 
> >> 
> >> exec/fs: fix initial stack reservation
> >> 
> >> 803bf5ec259941936262d10ecc84511b76a20921 (fs/exec.c: restrict initial
> >> stack space expansion to rlimit) attempts to limit the initial stack to
> >> 20*PAGE_SIZE.  Unfortunately, in also attempting ensure the stack is not
> >> reduced in size, we ended up not changing the stack at all.  
> >> 
> >> This caused a regression in UML resulting in most guest processes to be
> >> killed. 
> >> 
> >> Signed-off-by: Michael Neuling <mikey@neuling.org>
> >> cc: <stable@kernel.org>
> >> 
> >> diff --git a/fs/exec.c b/fs/exec.c
> >> index e95c692..e0e7b3c 100644
> >> --- a/fs/exec.c
> >> +++ b/fs/exec.c
> >> @@ -637,15 +637,16 @@ int setup_arg_pages(struct linux_binprm *bprm,
> >>  	 * will align it up.
> >>  	 */
> >>  	rlim_stack = rlimit(RLIMIT_STACK) & PAGE_MASK;
> >> -	rlim_stack = min(rlim_stack, stack_size);
> >>  #ifdef CONFIG_STACK_GROWSUP
> >>  	if (stack_size + stack_expand > rlim_stack)
> >> -		stack_base = vma->vm_start + rlim_stack;
> >> +		/*  Expand only to rlimit, making sure not to shrink it */
> >> +		stack_base = vma->vm_start + max(rlim_stack,stack_size);
> >>  	else
> >>  		stack_base = vma->vm_end + stack_expand;
> >>  #else
> >>  	if (stack_size + stack_expand > rlim_stack)
> >> -		stack_base = vma->vm_end - rlim_stack;
> >> +		/*  Expand only to rlimit, making sure not to shrink it */
> >> +		stack_base = vma->vm_end - max(rlim_stack,stack_size);
> >>  	else
> >>  		stack_base = vma->vm_start - stack_expand;
> >>  #endif
> >
> >-	rlim_stack = min(rlim_stack, stack_size);
> >+	/*  Expand only to rlimit, making sure not to shrink it */
> >+	rlim_stack = max(rlim_stack, stack_size);
> >
> >is better fix?
> >
> 
> Odd. If this is the right fix, 'stack_size" will be able to exceed
> stack rlimit, then Michael's previous rlimit patch will be useless.
> Am I missing something?
> 

This function is in exec processing, IOW user process doesn't start yet,
and stack_size is always PAGE_SIZE. 

No problem.

This expression only mean we parse "ulimit -s 1" as "ulimit -s 4".
(round up to one-page)




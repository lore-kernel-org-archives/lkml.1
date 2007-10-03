Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbXJCMUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbXJCMUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbXJCMUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:20:25 -0400
Received: from aun.it.uu.se ([130.238.12.36]:58767 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbXJCMUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:20:24 -0400
Date: Wed, 3 Oct 2007 14:20:07 +0200 (MEST)
Message-Id: <200710031220.l93CK75T028343@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org, shiwh@cn.fujitsu.com
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound occurs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Oct 2007 17:06:24 +0900, Shi Weihua wrote:
> Fixing alternative signal stack wraparound.
> 
> If a process uses alternative signal stack by using sigaltstack()
> and that stack overflow, stack wraparound occurs.
> This patch checks whether the signal frame is on the alternative
> stack. If the frame is not on there, kill a signal SIGSEGV to the process forcedly
> then the process will be terminated.
> 
> This patch is for i386,version is 2.6.23-rc8.
> 
> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
> 
> diff -pur linux-2.6.23-rc8.orig/arch/i386/kernel/signal.c linux-2.6.23-rc8/arch/i386/kernel/signal.c
> --- linux-2.6.23-rc8.orig/arch/i386/kernel/signal.c	2007-09-26 09:44:08.000000000 +0900
> +++ linux-2.6.23-rc8/arch/i386/kernel/signal.c	2007-09-26 13:14:25.000000000 +0900
> @@ -332,6 +332,10 @@ static int setup_frame(int sig, struct k
> 
>   	frame = get_sigframe(ka, regs, sizeof(*frame));
> 
> +	if ((ka->sa.sa_flags & SA_ONSTACK) &&
> +		!sas_ss_flags((unsigned long)frame))
> +		goto give_sigsegv;
> +
>   	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
>   		goto give_sigsegv;
> 
> @@ -425,6 +429,10 @@ static int setup_rt_frame(int sig, struc
> 
>   	frame = get_sigframe(ka, regs, sizeof(*frame));
> 
> +	if ((ka->sa.sa_flags & SA_ONSTACK) &&
> +		!sas_ss_flags((unsigned long)frame))
> +		goto give_sigsegv;
> +
>   	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
>   		goto give_sigsegv;

Your patch description is a little terse. What you do is that
after the kernel has decided where to put the signal frame,
you add a check that the base of the frame still lies in the
altstack range if altstack delivery is requested for the signal,
and if it doesn't a hard error is forced.

The coding of that logic is fine.

What I don't agree with is the logic itself:
- You only catch altstack overflow caused by the kernel pushing
  a sigframe. You don't catch overflow caused by the user-space
  signal handler pushing its own stack frame after the sigframe.
- SUSv3 specifies the effect of altstack overflow as "undefined".
- The overflow problem can be solved in user-space: allocate the
  altstack with mmap(), then mprotect() the lowest page to prevent
  accesses to it. Any overflow into it, by the kernel's signal
  delivery code or by the user-space signal handler, will be caught.

So this patch gets a NAK from me.

/Mikael

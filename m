Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYBENKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYBENKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYBENKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:10:06 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55845 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYBENKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:10:04 -0500
Date: Tue, 5 Feb 2008 13:08:55 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jiri Kosina <jkosina@suse.cz>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Abel Bernabeu <abel.bernabeu@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: brk randomization breaks columns
In-Reply-To: <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0802051243240.542@blonde.site>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Jiri Kosina wrote:
> Now, you are right that the return value from brk() is bogus in these 
> cases. The patch below should make it behave, as you can easily check with 
> strace, right? Does anyone have any comments regarding this patch please?

Your patch below looks good to me, whatever the outcome of the
randomize_brk debate.  I can't imagine what end_code has to do
with it: an ELF binary that specifies the code is to go up the
top of the address space seems perfectly reasonable to me.

> Still, it will probably not fix your particular program crashes, just 
> because it will always assume that brk starts immediately after the end of 
> the bss, which is plain wrong and has never been assured. Could you please 
> check whether there is any compat-* package available for you 
> distribution, that upgrades libc.so.5 to any fixed version?

But I was myself surprised by your randomize_brk patch: like the
buggy program, I'd imagined that data immediately followed by bss
immediately followed by brk was an invariant (whereas I never
supposed the position of the code had anything to do with it).
Just my ignorance, but not surprising if it's shared by others.

So, I didn't really expect the randomize_brk patch to get this far,
thought it would hit trouble earlier.  What to do now?  On the one
hand Pavel rightly regards this as a regression, on the other hand
we've had programs which make bad assumptions about their address
space layout before, and have not always deferred to them.

If such cases are few (can we be sure of that yet?), is it going
to be good enough to rely on adding the ELF note to disable their
randomization?

In my usual dither, I'm rather hoping Arjan will have a clear answer.

Hugh

> From: Jiri Kosina <jkosina@suse.cz>
> 
> brk: check the lower bound properly
> 
> There is a check in sys_brk(), that tries to make sure that we do not 
> underflow the area that is dedicated to brk heap.
> 
> The check is however wrong, as it assumes that brk area starts immediately 
> after the end of the code (+bss), which is wrong for example in 
> environments with randomized brk start. The proper way is to check whether 
> the address is not below the start_brk address.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Hugh Dickins <hugh@veritas.com>

> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 8295577..1c3b48f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -241,7 +241,7 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
>  
>  	down_write(&mm->mmap_sem);
>  
> -	if (brk < mm->end_code)
> +	if (brk < mm->start_brk)
>  		goto out;
>  
>  	/*

Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbZJHPFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbZJHPFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932487AbZJHPFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:05:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306AbZJHPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:05:05 -0400
Date: Thu, 8 Oct 2009 08:03:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Wu Zhangjin <wuzhangjin@gmail.com>, Arnd Bergmann <arnd@arndb.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Christoph Hellwig <hch@lst.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] kernel/time/tick-sched.c: fix warning of printk's argument
 format
In-Reply-To: <1255013172-31599-1-git-send-email-wuzhangjin@gmail.com>
Message-ID: <alpine.LFD.2.01.0910080755390.3432@localhost.localdomain>
References: <1255013172-31599-1-git-send-email-wuzhangjin@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Oct 2009, Wu Zhangjin wrote:
>
> This patch will fix the following warning:

No it won't. It will add a lot of new warnings.

The thing is, almost all architectures (including x86) have

	unsigned int __softirq_pending;

but then in <asm-generic/hardirq.h> we have

	unsigned long __softirq_pending;

for some unfathomable reason. Quite frankly, I think Arnd just screwed up 
the "generic" version, and the fix is almost certainly to just make the 
generic version match all the main architectures. 

I don't have any architectures using the generic header file, though, so 
I'm not going to do that change blindly. People who do should look at it 
(alpha, powerpc and mips look like the only ones that might be 64-bit, but 
I didn't check very carefully - just grepped for it)

Added Cc's for some people that have worked on, or used, that generic 
header file. Is there any possible reason why it is "unsigned long" in 
that one?

		Linus

---
> kernel/time/tick-sched.c: In function 'tick_nohz_stop_sched_tick':
> kernel/time/tick-sched.c:261: warning: format '%02x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  kernel/time/tick-sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index e0f59a2..26370b0 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -257,7 +257,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>  		static int ratelimit;
>  
>  		if (ratelimit < 10) {
> -			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
> +			printk(KERN_ERR "NOHZ: local_softirq_pending %02lx\n",
>  			       local_softirq_pending());
>  			ratelimit++;
>  		}
> -- 
> 1.6.2.1
> 

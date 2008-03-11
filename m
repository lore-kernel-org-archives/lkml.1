Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYCKCkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYCKCkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbYCKCkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:40:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbYCKCkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:40:31 -0400
Date: Mon, 10 Mar 2008 19:39:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for
 pageattr-test.c
Message-Id: <20080310193955.9f30bf20.akpm@linux-foundation.org>
In-Reply-To: <20080311013014.GA28682@basil.nowhere.org>
References: <20080311013014.GA28682@basil.nowhere.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008 02:30:14 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> Use an own random generator for pageattr-test.c
> 
> [Repost. Please ack/nack. This is a bug fix and imho a .25 late merge 
> candidate because it fixes a subtle bug]

An Ingo/Thomas thing.

> pageattr-test attempts to be repeatable and uses srandom32 to get a 
> repeatable random number sequence.
> 
> Using srandom32() wasn't a good idea for various reasons:
> - it is per cpu and if the cpu changes on a preemptible kernel it gets lost
> - networking and random32 puts in some own state
> - srandom32() does not actually reset the state, but just adds bits to 
> it
> 
> Instead use a very simple private standard rnd that gives repeatable
> results. I took the reference rand() from ISO-C.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/x86/mm/pageattr-test.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/mm/pageattr-test.c
> ===================================================================
> --- linux.orig/arch/x86/mm/pageattr-test.c
> +++ linux/arch/x86/mm/pageattr-test.c
> @@ -101,6 +101,14 @@ static int print_split(struct split_stat
>  static unsigned long addr[NTEST];
>  static unsigned int len[NTEST];
>  
> +static int next = 100;
> +
> +static unsigned my_rand(void)
> +{
> +	next = next * 1103515245 + 12345;
> +	return next;
> +}

`next' should be local to my_rand().

>  /* Change the global bit on random pages in the direct mapping */
>  static int pageattr_test(void)
>  {
> @@ -123,10 +131,9 @@ static int pageattr_test(void)
>  	memset(bm, 0, (max_pfn_mapped + 7) / 8);
>  
>  	failed += print_split(&sa);
> -	srandom32(100);
>  
>  	for (i = 0; i < NTEST; i++) {
> -		unsigned long pfn = random32() % max_pfn_mapped;
> +		unsigned long pfn = my_rand() % max_pfn_mapped;
>  
>  		addr[i] = (unsigned long)__va(pfn << PAGE_SHIFT);
>  		len[i] = random32() % 100;

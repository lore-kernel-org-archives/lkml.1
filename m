Return-Path: <linux-kernel-owner+w=401wt.eu-S1760126AbYBSV0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760126AbYBSV0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYBSV0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:26:34 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:40837 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYBSV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:26:33 -0500
Date: Tue, 19 Feb 2008 13:25:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jonathan Lim <jlim@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Provide u64 version of jiffies_to_usecs() in
 kernel/tsacct.c
Message-Id: <20080219132525.a81e8264.randy.dunlap@oracle.com>
In-Reply-To: <200802192052.m1JKqk9K002857@sabah.engr.sgi.com>
References: <no.id>
	<200802192052.m1JKqk9K002857@sabah.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 12:52:46 -0800 (PST) Jonathan Lim wrote:

> It's possible that the values used in and returned from jiffies_to_usecs() are
> incorrect because of truncation when variables of type u64 are involved.  So a
> function specific to that type is used instead.
> 
> Diff'd against: linux/kernel/git/torvalds/linux-2.6.git
> 
> Signed-off-by: Jonathan Lim <jlim@sgi.com>
> 
> --- a/include/linux/jiffies.h	Thu Feb 14 18:04:14 PST 2008
> +++ b/include/linux/jiffies.h	Thu Feb 14 18:07:17 PST 2008
> @@ -42,7 +42,7 @@
>  /* LATCH is used in the interval timer and ftape setup. */
>  #define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
>  
> -/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, then we can
> +/* Suppose we want to divide two numbers NOM and DEN: NOM/DEN, then we can
>   * improve accuracy by shifting LSH bits, hence calculating:
>   *     (NOM << LSH) / DEN
>   * This however means trouble for large NOM, because (NOM << LSH) may no
> @@ -204,7 +204,7 @@ extern unsigned long preset_lpj;
>   * operator if the result is a long long AND at least one of the
>   * operands is cast to long long (usually just prior to the "*" so as
>   * not to confuse it into thinking it really has a 64-bit operand,
> - * which, buy the way, it can do, but it takes more code and at least 2
> + * which, by the way, it can do, but it takes more code and at least 2
>   * mpys).
>  
>   * We also need to be aware that one second in nanoseconds is only a
> @@ -269,6 +269,7 @@ extern unsigned long preset_lpj;
>   */
>  extern unsigned int jiffies_to_msecs(const unsigned long j);
>  extern unsigned int jiffies_to_usecs(const unsigned long j);
> +extern u64 jiffies_64_to_usecs(const u64 j);
>  extern unsigned long msecs_to_jiffies(const unsigned int m);
>  extern unsigned long usecs_to_jiffies(const unsigned int u);
>  extern unsigned long timespec_to_jiffies(const struct timespec *value);
> --- a/kernel/time.c	Thu Feb 14 18:05:12 PST 2008
> +++ b/kernel/time.c	Tue Feb 19 12:44:03 PST 2008
> @@ -268,6 +268,14 @@ unsigned int inline jiffies_to_usecs(con
>  }
>  EXPORT_SYMBOL(jiffies_to_usecs);
>  
> +u64 inline jiffies_64_to_usecs(const u64 j)
> +{
> +	u64 tmp = j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1;
> +	do_div(tmp, HZ_TO_USEC_DEN);

do_div() is:
 * The semantics of do_div() are:
 *
 * uint32_t do_div(uint64_t *n, uint32_t base)

Maybe you want div64_64().

> +	return tmp;
> +}
> +EXPORT_SYMBOL(jiffies_64_to_usecs);
> +
>  /**
>   * timespec_trunc - Truncate timespec to a granularity
>   * @t: Timespec
> --- a/kernel/tsacct.c	Thu Feb 14 18:06:17 PST 2008
> +++ b/kernel/tsacct.c	Thu Feb 14 18:08:47 PST 2008
> @@ -85,8 +85,8 @@ void xacct_add_tsk(struct taskstats *sta
>  	struct mm_struct *mm;
>  
>  	/* convert pages-jiffies to Mbyte-usec */
> -	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
> -	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
> +	stats->coremem = jiffies_64_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
> +	stats->virtmem = jiffies_64_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
>  	mm = get_task_mm(p);
>  	if (mm) {
>  		/* adjust to KB unit */
> --


---
~Randy

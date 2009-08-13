Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZHMVXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZHMVXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZHMVXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:23:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbZHMVXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:23:46 -0400
Date: Thu, 13 Aug 2009 14:21:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Use bool for boolean flag in printk_once()
Message-Id: <20090813142144.37509d52.akpm@linux-foundation.org>
In-Reply-To: <adak5174ezp.fsf@cisco.com>
References: <adak5174ezp.fsf@cisco.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 13:48:26 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> Using the type bool (instead of int) for the __print_once flag in the
> printk_once() macro matches the intent of the code better, and allows
> the compiler to generate smaller code; eg a typical callsite with gcc
> 4.3.3 on i386:
> 
> add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-6 (-6)
> function                                     old     new   delta
> static.__print_once                            4       1      -3
> get_cpu_vendor                               146     143      -3
> 
> Saving 6 bytes of object size per callsite by slightly improving the
> readability of the source seems like a win to me.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
>  include/linux/kernel.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d6320a3..f828ce9 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -249,10 +249,10 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>   * Print a one-time message (analogous to WARN_ONCE() et al):
>   */
>  #define printk_once(x...) ({			\
> -	static int __print_once = 1;		\
> +	static bool __print_once = true;	\
>  						\
>  	if (__print_once) {			\
> -		__print_once = 0;		\
> +		__print_once = false;		\
>  		printk(x);			\
>  	}					\
>  })

hm, OK,  in trace_recursive_lock() we get:

	cmpl	$0, __print_once.28104(%rip)	#, __print_once
	je	.L719	#,

changed to

	cmpb	$0, __print_once.28104(%rip)	# __print_once
	je	.L719	#,


so the compiler used a byte for the bool.

Interestingly that bool is in section `data'.  I bet printk_once()
should use __read_mostly.

Also, that bool still uses four bytes of storage:

   text    data     bss     dec     hex filename
  22527    1445    6392   30364    769c kernel/trace/ring_buffer.o
  22524    1445    6392   30361    7699 kernel/trace/ring_buffer.o (patched)

I wonder if there's some way in which we could/should cause all these
little random __read_mostly bytes to get packed together somewhere.



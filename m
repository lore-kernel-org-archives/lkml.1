Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYCQFfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYCQFfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYCQFe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:34:57 -0400
Received: from n54.bullet.mail.sp1.yahoo.com ([98.136.44.32]:42302 "HELO
	n54.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751127AbYCQFe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:34:56 -0400
X-Yahoo-Newman-Id: 84438.11415.bm@omp423.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dJxxUqJZyuLbI8HU+EuPeEMnWOY0nLPB9EyUFEIZ1u5dsVjyalwCU2WNdfIDnSJRyLELl3u0F37DRF4IVO50+D4FK6vRB+7XqpQzzJDsNWUR5nYyfgB7qOfc0R2PzHnwyhMYz4rnj/m2jBkZ/Usmn+N1vLg/0VfbSzYFoqwYlvg=  ;
X-YMail-OSG: pH4Mpt0VM1kEfaIjTy9hQbrKz1sLdKdGDD_4Bv_u_aLLG8a2BRsGfmUC9arj0vfHJqkKZFH4lg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] fix misplaced mb() in rcu_enter/exit_nohz()
Date: Mon, 17 Mar 2008 14:09:06 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu, ego@in.ibm.com,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, akpm@linux-foundation.org, josh@freedesktop.org,
       tglx@linutronix.de, niv@us.ibm.com
References: <20080317010821.GA29875@linux.vnet.ibm.com>
In-Reply-To: <20080317010821.GA29875@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171409.08148.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008 12:08, Paul E. McKenney wrote:
> Hello!
>
> In the process of writing up the mechanical proof of correctness for the
> dynticks/preemptable-RCU interface, I noticed misplaced memory barriers
> in rcu_enter_nohz() and rcu_exit_nohz().  This patch puts them in the
> right place and adds a comment.  The key thing to keep in mind is that
> rcu_enter_nohz() is -exiting- the mode that can legally execute RCU
> read-side critical sections.  The memory barrier must be between any
> potential RCU read-side critical sections and the increment of the per-CPU
> dynticks_progress_counter, and thus must come -before- this increment.
> And vice versa for rcu_exit_nohz().
>
> The locking in the scheduler is probably saving us for the moment.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>
>  rcupreempt.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -urpNa -X dontdiff linux-2.6.25-rc6/include/linux/rcupreempt.h
> linux-2.6.25-rc6-rcu_nohz-fix/include/linux/rcupreempt.h ---
> linux-2.6.25-rc6/include/linux/rcupreempt.h	2008-03-16 17:45:16.000000000
> -0700 +++
> linux-2.6.25-rc6-rcu_nohz-fix/include/linux/rcupreempt.h	2008-03-16
> 17:59:24.000000000 -0700 @@ -87,15 +87,15 @@ DECLARE_PER_CPU(long,
> dynticks_progress_
>
>  static inline void rcu_enter_nohz(void)
>  {
> +	mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
>  	__get_cpu_var(dynticks_progress_counter)++;
>  	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
> -	mb();
>  }
>
>  static inline void rcu_exit_nohz(void)
>  {
> -	mb();
>  	__get_cpu_var(dynticks_progress_counter)++;
> +	mb(); /* CPUs seeing ++ must see subsequent RCU read-side crit sects */
>  	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
>  }

Can you make these smp_mb() as well?

Thanks,
Nick


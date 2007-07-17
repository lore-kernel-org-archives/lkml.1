Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbXGQJqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbXGQJqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXGQJqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:46:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbXGQJqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:46:33 -0400
Date: Tue, 17 Jul 2007 02:46:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com
Subject: Re: [PATCH] Immunize rcu_dereference() against crazy compiler
 writers
Message-Id: <20070717024600.0aab7f36.akpm@linux-foundation.org>
In-Reply-To: <20070712010058.GA30869@linux.vnet.ibm.com>
References: <20070712010058.GA30869@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 18:00:58 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> Turns out that compiler writers are a bit more aggressive about optimizing
> than one might expect.  This patch prevents a number of such optimizations
> from messing up rcu_deference().  This is not merely a theoretical
> problem, as evidenced by the rmb() in mce_log().
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcupdate.h |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff -urpNa -X dontdiff linux-2.6.22/include/linux/rcupdate.h linux-2.6.22-volrcud/include/linux/rcupdate.h
> --- linux-2.6.22/include/linux/rcupdate.h	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-volrcud/include/linux/rcupdate.h	2007-07-11 17:21:09.000000000 -0700
> @@ -217,6 +217,18 @@ extern int rcu_needs_cpu(int cpu);
>  		local_bh_enable(); \
>  	} while(0)
>  
> +/*
> + * Prevent the compiler from merging or refetching accesses.  The compiler
> + * is also forbidden from reordering successive instances of ACCESS_ONCE(),
> + * but only when the compiler is aware of some particular ordering.  One way
> + * to make the compiler aware of ordering is to put the two invocations of 
> + * ACCESS_ONCE() in different C statements.
> + *
> + * This macro does absolutely -nothing- to prevent the CPU from reordering,
> + * merging, or refetching absolutely anything at any time.
> + */
> +#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))

drivers/net/hamradio/bpqether.c: In function 'bpq_seq_next':
drivers/net/hamradio/bpqether.c:421: error: invalid lvalue in unary '&'

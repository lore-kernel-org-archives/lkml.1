Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbXGQNx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbXGQNx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXGQNxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:53:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44691 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbXGQNxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:53:21 -0400
Date: Tue, 17 Jul 2007 06:53:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com
Subject: Re: [PATCH] Immunize rcu_dereference() against crazy compiler writers
Message-ID: <20070717135318.GC8763@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070712010058.GA30869@linux.vnet.ibm.com> <20070717024600.0aab7f36.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717024600.0aab7f36.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 02:46:00AM -0700, Andrew Morton wrote:
> On Wed, 11 Jul 2007 18:00:58 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Turns out that compiler writers are a bit more aggressive about optimizing
> > than one might expect.  This patch prevents a number of such optimizations
> > from messing up rcu_deference().  This is not merely a theoretical
> > problem, as evidenced by the rmb() in mce_log().
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  rcupdate.h |   14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff -urpNa -X dontdiff linux-2.6.22/include/linux/rcupdate.h linux-2.6.22-volrcud/include/linux/rcupdate.h
> > --- linux-2.6.22/include/linux/rcupdate.h	2007-07-08 16:32:17.000000000 -0700
> > +++ linux-2.6.22-volrcud/include/linux/rcupdate.h	2007-07-11 17:21:09.000000000 -0700
> > @@ -217,6 +217,18 @@ extern int rcu_needs_cpu(int cpu);
> >  		local_bh_enable(); \
> >  	} while(0)
> >  
> > +/*
> > + * Prevent the compiler from merging or refetching accesses.  The compiler
> > + * is also forbidden from reordering successive instances of ACCESS_ONCE(),
> > + * but only when the compiler is aware of some particular ordering.  One way
> > + * to make the compiler aware of ordering is to put the two invocations of 
> > + * ACCESS_ONCE() in different C statements.
> > + *
> > + * This macro does absolutely -nothing- to prevent the CPU from reordering,
> > + * merging, or refetching absolutely anything at any time.
> > + */
> > +#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> 
> drivers/net/hamradio/bpqether.c: In function 'bpq_seq_next':
> drivers/net/hamradio/bpqether.c:421: error: invalid lvalue in unary '&'

This is a bug in bpqether.c, and here is a patch that compiles.
I don't have the necessary hardware to test.  As you might expect, I
assert that the fact that the new implementation of rcu_dereference()
detects improper use on rvalues is a feature.  ;-)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 bpqether.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22/drivers/net/hamradio/bpqether.c linux-2.6.22-volrcud-hamfix/drivers/net/hamradio/bpqether.c
--- linux-2.6.22/drivers/net/hamradio/bpqether.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-volrcud-hamfix/drivers/net/hamradio/bpqether.c	2007-07-17 06:46:16.000000000 -0700
@@ -413,12 +413,12 @@ static void *bpq_seq_next(struct seq_fil
 	++*pos;
 
 	if (v == SEQ_START_TOKEN)
-		p = bpq_devices.next;
+		p = rcu_dereference(bpq_devices.next);
 	else
-		p = ((struct bpqdev *)v)->bpq_list.next;
+		p = rcu_dereference(((struct bpqdev *)v)->bpq_list.next);
 
 	return (p == &bpq_devices) ? NULL 
-		: rcu_dereference(list_entry(p, struct bpqdev, bpq_list));
+		: list_entry(p, struct bpqdev, bpq_list);
 }
 
 static void bpq_seq_stop(struct seq_file *seq, void *v)

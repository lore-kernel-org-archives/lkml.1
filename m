Return-Path: <linux-kernel-owner+w=401wt.eu-S933328AbXBHAYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbXBHAYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbXBHAYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:24:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47492 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328AbXBHAYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:24:09 -0500
Date: Wed, 7 Feb 2007 16:22:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Josh Triplett <josh@kernel.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 3/3] rcutorture: Remove redundant assignment to cur_ops
 in for loop
Message-Id: <20070207162228.bd7fd822.akpm@linux-foundation.org>
In-Reply-To: <45CA6711.40502@student.ltu.se>
References: <45CA206C.2080205@kernel.org>
	<45CA212A.7000504@kernel.org>
	<45CA6711.40502@student.ltu.se>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Feb 2007 00:56:01 +0100
Richard Knutsson <ricknu-0@student.ltu.se> wrote:

> Josh Triplett wrote:
> > The for loop in rcutorture_init uses the condition
> > cur_ops = torture_ops[i], cur_ops
> > but then makes the same assignment to cur_ops inside the loop.  Remove the
> > redundant assignment inside the loop, and remove now-unnecessary braces.
> >
> > Signed-off-by: Josh Triplett <josh@kernel.org>
> > ---
> >  kernel/rcutorture.c |    7 ++-----
> >  1 files changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 0c7bf0c..7258bcb 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -875,12 +875,9 @@ rcu_torture_init(void)
> >  
> >  	/* Process args and tell the world that the torturer is on the job. */
> >  
> > -	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
> > -		cur_ops = torture_ops[i];
> > -		if (strcmp(torture_type, cur_ops->name) == 0) {
> > +	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++)
> >   
> May be tired right now, but wouldn't it be more logical with:
> 
> for (i = 0; cur_ops = torture_ops[i], i++)
> 
> Right now it seems to have two conditions for cur_ops.
> 

I suspect we can do better than that...

--- a/kernel/rcutorture.c~rcutorture-remove-redundant-assignment-to-cur_ops-in
+++ a/kernel/rcutorture.c
@@ -569,10 +569,6 @@ static struct rcu_torture_ops sched_ops 
 	.name = "sched"
 };
 
-static struct rcu_torture_ops *torture_ops[] =
-	{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
-	  &srcu_ops, &qrcu_ops, &sched_ops, NULL };
-
 /*
  * RCU torture writer kthread.  Repeatedly substitutes a new structure
  * for that pointed to by rcu_torture_current, freeing the old structure
@@ -939,14 +935,15 @@ rcu_torture_init(void)
 	int i;
 	int cpu;
 	int firsterr = 0;
+	static struct rcu_torture_ops *torture_ops[] =
+		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
+		  &srcu_ops, &qrcu_ops, &sched_ops, };
 
 	/* Process args and tell the world that the torturer is on the job. */
-
-	for (i = 0; cur_ops = torture_ops[i], cur_ops; i++) {
+	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
 		cur_ops = torture_ops[i];
-		if (strcmp(torture_type, cur_ops->name) == 0) {
+		if (strcmp(torture_type, cur_ops->name) == 0)
 			break;
-		}
 	}
 	if (cur_ops == NULL) {
 		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
_


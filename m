Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbZJNXhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbZJNXhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762106AbZJNXhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:37:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33801 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762061AbZJNXhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:37:16 -0400
Date: Wed, 14 Oct 2009 16:36:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, npiggin@suse.de,
       jens.axboe@oracle.com
Subject: Re: [PATCH tip/core/rcu 5/6] rcu: add rnp->blocked_tasks to tracing
Message-ID: <20091014233638.GE6763@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091014171517.GA13635@linux.vnet.ibm.com> <20091014202649.GC2395@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014202649.GC2395@feather>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 01:26:50PM -0700, Josh Triplett wrote:
> On Wed, Oct 14, 2009 at 10:15:58AM -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree_trace.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> > index 4b31c77..f9d01a3 100644
> > --- a/kernel/rcutree_trace.c
> > +++ b/kernel/rcutree_trace.c
> > @@ -155,12 +155,13 @@ static const struct file_operations rcudata_csv_fops = {
> >  
> >  static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
> >  {
> > +	long gpnum;
> >  	int level = 0;
> >  	struct rcu_node *rnp;
> >  
> >  	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
> >  		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
> > -		   rsp->completed, rsp->gpnum, rsp->signaled,
> > +		   rsp->completed, gpnum = rsp->gpnum, rsp->signaled,
> 
> Please don't hide this or any other assignment in the middle of a print
> statement.  Just put it immediately preceeding the statement.

Good point, here is the updated patch.

							Thanx, Paul

rcu: add rnp->blocked_tasks to tracing

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

 rcutree_trace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 4b31c77..1984cdc 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -155,12 +155,14 @@ static const struct file_operations rcudata_csv_fops = {
 
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
+	long gpnum;
 	int level = 0;
 	struct rcu_node *rnp;
 
+	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
-		   rsp->completed, rsp->gpnum, rsp->signaled,
+		   rsp->completed, gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
@@ -171,8 +173,10 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 			seq_puts(m, "\n");
 			level = rnp->level;
 		}
-		seq_printf(m, "%lx/%lx %d:%d ^%d    ",
+		seq_printf(m, "%lx/%lx %c>%c %d:%d ^%d    ",
 			   rnp->qsmask, rnp->qsmaskinit,
+			   "T."[list_empty(&rnp->blocked_tasks[gpnum & 1])],
+			   "T."[list_empty(&rnp->blocked_tasks[!(gpnum & 1)])],
 			   rnp->grplo, rnp->grphi, rnp->grpnum);
 	}
 	seq_puts(m, "\n");

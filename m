Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbZK3W0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbZK3W0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZK3W0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:26:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZK3W0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:26:35 -0500
Date: Mon, 30 Nov 2009 17:24:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 03/21] blkio: Implement macro to traverse each idle
	tree in group
Message-ID: <20091130222440.GM11670@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <1259549968-10369-4-git-send-email-vgoyal@redhat.com> <af41c7c40911301213j51bec79ev4d07c77b8de523f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af41c7c40911301213j51bec79ev4d07c77b8de523f6@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 01:43:16AM +0530, Divyesh Shah wrote:
> On Mon, Nov 30, 2009 at 8:29 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o Implement a macro to traverse each service tree in the group. This avoids
> >  usage of double for loop and special condition for idle tree 4 times.
> >
> > o Macro is little twisted because of special handling of idle class service
> >  tree.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/cfq-iosched.c |   35 +++++++++++++++++++++--------------
> >  1 files changed, 21 insertions(+), 14 deletions(-)
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 3baa3f4..c73ff44 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -303,6 +303,15 @@ CFQ_CFQQ_FNS(deep);
> >  #define cfq_log(cfqd, fmt, args...)    \
> >        blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
> >
> > +/* Traverses through cfq group service trees */
> > +#define for_each_cfqg_st(cfqg, i, j, st) \
> > +       for (i = 0; i < 3; i++) \
> > +               for (j = 0, st = i < 2 ? &cfqg->service_trees[i][j] : \
> > +                       &cfqg->service_tree_idle; \
> > +                       (i < 2 && j < 3) || (i == 2 && j < 1); \
> > +                       j++, st = i < 2 ? &cfqg->service_trees[i][j]: NULL) \
> 
> Can this be simplified a bit by moving the service tree assignments
> out of the for statement?

Not sure how that can be done. One way is that st assignment happens in
the body of the for loop. That means I shall have to open braces for for
loop in the macro and user of the macro will close the braces. That will
look really ugly.

	for_each_cfqg_st()
	}

Do you have other ideas.

> Also is it possible to use macros for the various service classes instead of
> 1, 2, 3?
> 

Please find attached the new version of patch. I have used macro names for
various classses instead of numbers. Hopefully this one is little better
to read.


o Implement a macro to traverse each service tree in the group. This avoids
  usage of double for loop and special condition for idle tree 4 times.

o Macro is little twisted because of special handling of idle class service
  tree.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

Index: linux10/block/cfq-iosched.c
===================================================================
--- linux10.orig/block/cfq-iosched.c	2009-11-30 17:20:42.000000000 -0500
+++ linux10/block/cfq-iosched.c	2009-11-30 17:22:45.000000000 -0500
@@ -140,9 +140,9 @@ struct cfq_queue {
  * IDLE is handled separately, so it has negative index
  */
 enum wl_prio_t {
-	IDLE_WORKLOAD = -1,
 	BE_WORKLOAD = 0,
-	RT_WORKLOAD = 1
+	RT_WORKLOAD = 1,
+	IDLE_WORKLOAD = 2,
 };
 
 /*
@@ -303,6 +303,17 @@ CFQ_CFQQ_FNS(deep);
 #define cfq_log(cfqd, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
 
+/* Traverses through cfq group service trees */
+#define for_each_cfqg_st(cfqg, i, j, st) \
+	for (i = 0; i <= IDLE_WORKLOAD; i++) \
+		for (j = 0, st = i < IDLE_WORKLOAD ? &cfqg->service_trees[i][j]\
+			: &cfqg->service_tree_idle; \
+			(i < IDLE_WORKLOAD && j <= SYNC_WORKLOAD) || \
+			(i == IDLE_WORKLOAD && j == 0); \
+			j++, st = i < IDLE_WORKLOAD ? \
+			&cfqg->service_trees[i][j]: NULL) \
+
+
 static inline enum wl_prio_t cfqq_prio(struct cfq_queue *cfqq)
 {
 	if (cfq_class_idle(cfqq))
@@ -565,6 +576,10 @@ cfq_choose_req(struct cfq_data *cfqd, st
  */
 static struct cfq_queue *cfq_rb_first(struct cfq_rb_root *root)
 {
+	/* Service tree is empty */
+	if (!root->count)
+		return NULL;
+
 	if (!root->left)
 		root->left = rb_first(&root->rb);
 
@@ -1592,18 +1607,14 @@ static int cfq_forced_dispatch(struct cf
 	int dispatched = 0;
 	int i, j;
 	struct cfq_group *cfqg = &cfqd->root_group;
+	struct cfq_rb_root *st;
 
-	for (i = 0; i < 2; ++i)
-		for (j = 0; j < 3; ++j)
-			while ((cfqq = cfq_rb_first(&cfqg->service_trees[i][j]))
-				!= NULL)
-				dispatched += __cfq_forced_dispatch_cfqq(cfqq);
-
-	while ((cfqq = cfq_rb_first(&cfqg->service_tree_idle)) != NULL)
-		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+	for_each_cfqg_st(cfqg, i, j, st) {
+		while ((cfqq = cfq_rb_first(st)) != NULL)
+			dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+	}
 
 	cfq_slice_expired(cfqd, 0);
-
 	BUG_ON(cfqd->busy_queues);
 
 	cfq_log(cfqd, "forced_dispatch=%d", dispatched);
@@ -2974,6 +2985,7 @@ static void *cfq_init_queue(struct reque
 	struct cfq_data *cfqd;
 	int i, j;
 	struct cfq_group *cfqg;
+	struct cfq_rb_root *st;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
@@ -2981,11 +2993,8 @@ static void *cfq_init_queue(struct reque
 
 	/* Init root group */
 	cfqg = &cfqd->root_group;
-
-	for (i = 0; i < 2; ++i)
-		for (j = 0; j < 3; ++j)
-			cfqg->service_trees[i][j] = CFQ_RB_ROOT;
-	cfqg->service_tree_idle = CFQ_RB_ROOT;
+	for_each_cfqg_st(cfqg, i, j, st)
+		*st = CFQ_RB_ROOT;
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we

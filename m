Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZA1BTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZA1BTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 20:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZA1BTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 20:19:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbZA1BTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 20:19:07 -0500
Date: Tue, 27 Jan 2009 17:18:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: rakib.mullick@gmail.com, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: Fix compile time warning on kernel/auditsc.c
Message-Id: <20090127171816.9a2c3b73.akpm@linux-foundation.org>
In-Reply-To: <20090126133854.GA18859@elte.hu>
References: <b9df5fa10901231150i1b9ea0f4n14d1cf60a9296a78@mail.gmail.com>
	<32272.1232853509@turing-police.cc.vt.edu>
	<b9df5fa10901242201h75f40e40ic27dfb089dd90fc8@mail.gmail.com>
	<20090126133854.GA18859@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 14:38:54 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > +static inline void audit_set_auditable(struct audit_context *ctx)
> > +{
> > +#ifdef CONFIG_AUDIT_TREE
> > +	if (!ctx->prio) {
> > +		ctx->prio = 1;
> > +		ctx->current_state = AUDIT_RECORD_CONTEXT;
> > +	}
> > +#endif
> > +}
> > +
> >  #ifdef CONFIG_AUDIT_TREE
> >  extern struct audit_chunk *audit_tree_lookup(const struct inode *);
> >  extern void audit_put_chunk(struct audit_chunk *);
> > 
> > ------
> > Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> > 
> > --- linux-2.6-orig/kernel/auditsc.c	2009-01-23 18:28:45.000000000 +0600
> > +++ linux-2.6/kernel/auditsc.c	2009-01-25 11:50:25.712731936 +0600
> > @@ -741,14 +741,6 @@ void audit_filter_inodes(struct task_str
> >  	rcu_read_unlock();
> >  }
> > 
> > -static void audit_set_auditable(struct audit_context *ctx)
> > -{
> > -	if (!ctx->prio) {
> > -		ctx->prio = 1;
> > -		ctx->current_state = AUDIT_RECORD_CONTEXT;
> > -	}
> > -}
> > -
> 
> i dont see how this is an improvement in code quality. A non-oneliner 
> function got inlined and an ugly #ifdef got added.

We can just move the function inside an existing ifdef block.


--- a/kernel/auditsc.c~a
+++ a/kernel/auditsc.c
@@ -364,6 +364,15 @@ static int grow_tree_refs(struct audit_c
 	ctx->tree_count = 31;
 	return 1;
 }
+
+static void audit_set_auditable(struct audit_context *ctx)
+{
+	if (!ctx->prio) {
+		ctx->prio = 1;
+		ctx->current_state = AUDIT_RECORD_CONTEXT;
+	}
+}
+
 #endif
 
 static void unroll_tree_refs(struct audit_context *ctx,
@@ -741,14 +750,6 @@ void audit_filter_inodes(struct task_str
 	rcu_read_unlock();
 }
 
-static void audit_set_auditable(struct audit_context *ctx)
-{
-	if (!ctx->prio) {
-		ctx->prio = 1;
-		ctx->current_state = AUDIT_RECORD_CONTEXT;
-	}
-}
-
 static inline struct audit_context *audit_get_context(struct task_struct *tsk,
 						      int return_valid,
 						      int return_code)
_




That file takes a rather unpleasing approach to this problem.  Things
like

static void unroll_tree_refs(struct audit_context *ctx,
		      struct audit_tree_refs *p, int count)
{
#ifdef CONFIG_AUDIT_TREE
	struct audit_tree_refs *q;
	int n;
	if (!p) {
		/* we started with empty chain */
		p = ctx->first_trees;
		count = 31;
		/* if the very first allocation has failed, nothing to do */
		if (!p)
			return;
	}
	n = count;
	for (q = p; q != ctx->trees; q = q->next, n = 31) {
		while (n--) {
			audit_put_chunk(q->c[n]);
			q->c[n] = NULL;
		}
	}
	while (n-- > ctx->tree_count) {
		audit_put_chunk(q->c[n]);
		q->c[n] = NULL;
	}
	ctx->trees = p;
	ctx->tree_count = count;
#endif
}

all over the place.  It needs help.



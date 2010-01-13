Return-Path: <linux-kernel-owner+w=401wt.eu-S932073Ab0AMKac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0AMKac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505Ab0AMKaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:30:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:58897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab0AMKaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:30:21 -0500
Date: Wed, 13 Jan 2010 10:29:47 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12626570512685-git-send-email->
References: <12626570512685-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] idr: Apply lockdep-based diagnostics to rcu_dereference() uses
Message-ID: <tip-213cdf3c7de6a6205b69e2d6439cebcbeea709dd@git.kernel.org>
Git-Commit-ID: 213cdf3c7de6a6205b69e2d6439cebcbeea709dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:29:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  213cdf3c7de6a6205b69e2d6439cebcbeea709dd
Gitweb:     http://git.kernel.org/tip/213cdf3c7de6a6205b69e2d6439cebcbeea709dd
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 18:04:11 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:06:09 +0100

idr: Apply lockdep-based diagnostics to rcu_dereference() uses

Because idr can be used with any of a number of locks or with
any flavor of RCU, just disable the lockdep-based diagnostics.

If idr needs diagnostics, the check expression will need to be
passed into the relevant idr primitives as an additional
argument.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <12626570512685-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 lib/idr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 1cac726..4877fce 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -502,7 +502,7 @@ void *idr_find(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
-	p = rcu_dereference(idp->top);
+	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 	n = (p->layer+1) * IDR_BITS;
@@ -517,7 +517,7 @@ void *idr_find(struct idr *idp, int id)
 	while (n > 0 && p) {
 		n -= IDR_BITS;
 		BUG_ON(n != p->layer*IDR_BITS);
-		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
+		p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
 }
@@ -550,7 +550,7 @@ int idr_for_each(struct idr *idp,
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = rcu_dereference(idp->top);
+	p = rcu_dereference_raw(idp->top);
 	max = 1 << n;
 
 	id = 0;
@@ -558,7 +558,7 @@ int idr_for_each(struct idr *idp,
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
-			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
+			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
 		}
 
 		if (p) {

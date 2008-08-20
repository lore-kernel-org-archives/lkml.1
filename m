Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYHTT2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYHTT2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbYHTT0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:26:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33236 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbYHTT0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:26:11 -0400
Subject: [RFC v2][PATCH 8/9] Remove some BUG_ON()s that need some proper error handling instead.
To: arnd@arndb.de
Cc: orenl@cs.columbia.edu, jeremy@goop.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 Aug 2008 12:26:07 -0700
References: <20080820192557.98788FAB@nimitz>
In-Reply-To: <20080820192557.98788FAB@nimitz>
Message-Id: <20080820192607.91E0AFF2@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




---

 oren-cr.git-dave/checkpoint/checkpoint.c |   12 ++++++++++--
 oren-cr.git-dave/checkpoint/restart.c    |   15 +++++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff -puN checkpoint/checkpoint.c~0002-Remove-some-BUG_ON-s-that-need-some-proper-error-ha checkpoint/checkpoint.c
--- oren-cr.git/checkpoint/checkpoint.c~0002-Remove-some-BUG_ON-s-that-need-some-proper-error-ha	2008-08-20 12:12:51.000000000 -0700
+++ oren-cr.git-dave/checkpoint/checkpoint.c	2008-08-20 12:12:51.000000000 -0700
@@ -125,7 +125,8 @@ static int cr_write_tail(struct cr_ctx *
 	h.id = 0;
 
 	hh->magic = CR_HEADER_MAGIC;
-	hh->cksum[0] = hh->cksum[1] = 1;	/* TBD ... */
+	hh->cksum[0] = 1;
+       	hh->cksum[1] = 1;	/* TBD ... */
 
 	ret = cr_write_obj(ctx, &h, hh);
 	kfree(hh);
@@ -183,7 +184,14 @@ static int cr_write_task(struct cr_ctx *
 {
 	int ret ;
 
-	BUG_ON(t->state == TASK_DEAD);
+	/*
+	 * This was a BUG_ON(), which kinda makes sense if you
+	 * are only allowing checkpointing of 'current'.  But,
+	 * it is still pretty silly in that case.  Make it
+	 * something a bit more sensible.
+	 */
+	if (t->state == TASK_DEAD)
+		return -EAGAIN;
 
 	ret = cr_write_task_struct(ctx, t);
 	pr_debug("ret (task_struct) %d\n", ret);
diff -puN checkpoint/restart.c~0002-Remove-some-BUG_ON-s-that-need-some-proper-error-ha checkpoint/restart.c
--- oren-cr.git/checkpoint/restart.c~0002-Remove-some-BUG_ON-s-that-need-some-proper-error-ha	2008-08-20 12:12:51.000000000 -0700
+++ oren-cr.git-dave/checkpoint/restart.c	2008-08-20 12:12:51.000000000 -0700
@@ -74,6 +74,11 @@ static int cr_read_hdr(struct cr_ctx *ct
 	struct cr_hdr_head *hh = kmalloc(sizeof(*hh), GFP_KERNEL);
 	int ret;
 
+	if (!hh) {
+		pr_debug("unable to get %d bytes from ctx buf for header\n",
+				sizeof(*hh));
+		return -ENOMEM;
+	}
 	ret = cr_read_obj_type(ctx, hh, sizeof(*hh), CR_HDR_HEAD);
 	if (ret < 0)
 		return ret;
@@ -99,6 +104,11 @@ static int cr_read_tail(struct cr_ctx *c
 	struct cr_hdr_tail *hh = kmalloc(sizeof(*hh), GFP_KERNEL);
 	int ret;
 
+	if (!hh) {
+		pr_debug("unable to get %d bytes from ctx buf for tail\n",
+				sizeof(*hh));
+		return -ENOMEM;
+	}
 	ret = cr_read_obj_type(ctx, hh, sizeof(*hh), CR_HDR_TAIL);
 	if (ret < 0)
 		return ret;
@@ -118,6 +128,11 @@ static int cr_read_task_struct(struct cr
 	struct task_struct *t = current;
 	int ret;
 
+	if (!hh) {
+		pr_debug("unable to get %d bytes from ctx buf for task\n",
+				sizeof(*hh));
+		return -ENOMEM;
+	}
 	ret = cr_read_obj_type(ctx, hh, sizeof(*hh), CR_HDR_TASK);
 	if (ret < 0)
 		return ret;
_

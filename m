Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYEVPDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYEVPDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYEVPC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:02:57 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:2020 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbYEVPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:02:56 -0400
Subject: [PATCH] block: reorder cfq_queue to save space on 64bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: axboe@kernel.dk
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 16:02:47 +0100
Message-Id: <1211468567.3024.6.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

saves 8 bytes of padding & increases objects/slab from 30 to 32 on my
AMD64 config 
    
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---

patch against 2.6.26-rc2
running successfully on my AMD64 desktop

Richard


diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b399c62..4df3f05 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -124,6 +124,8 @@ struct cfq_data {
 struct cfq_queue {
 	/* reference count */
 	atomic_t ref;
+	/* various state flags, see below */
+	unsigned int flags;
 	/* parent cfq_data */
 	struct cfq_data *cfqd;
 	/* service_tree member */
@@ -138,14 +140,14 @@ struct cfq_queue {
 	int queued[2];
 	/* currently allocated requests */
 	int allocated[2];
-	/* pending metadata requests */
-	int meta_pending;
 	/* fifo list of requests in sort_list */
 	struct list_head fifo;
 
 	unsigned long slice_end;
 	long slice_resid;
 
+	/* pending metadata requests */
+	int meta_pending;
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
 
@@ -153,8 +155,6 @@ struct cfq_queue {
 	unsigned short ioprio, org_ioprio;
 	unsigned short ioprio_class, org_ioprio_class;
 
-	/* various state flags, see below */
-	unsigned int flags;
 };
 
 enum cfqq_state_flags {




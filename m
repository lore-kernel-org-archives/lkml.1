Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYHMInB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYHMInB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbYHMIjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:31 -0400
Received: from smtp.nokia.com ([192.100.122.233]:46386 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbYHMIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:28 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: improve budgeting checks
Date: Wed, 13 Aug 2008 13:17:46 +0300
Message-Id: <1218622675-28853-18-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:03.0737 (UTC) FILETIME=[0A85A290:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Budgeting is a crucial UBIFS subsystem - add more assertions
to improve requests checking. This is not compiled in when
UBIFS debugging is disabled.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/budget.c |   12 ++++++++++++
 fs/ubifs/ubifs.h  |    8 +++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 12a1717..f5afce5 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -543,6 +543,12 @@ int ubifs_budget_space(struct ubifs_info *c, struct ubifs_budget_req *req)
 	int err, idx_growth, data_growth, dd_growth;
 	struct retries_info ri;
 
+	ubifs_assert(req->new_page <= 1);
+	ubifs_assert(req->dirtied_page <= 1);
+	ubifs_assert(req->new_dent <= 1);
+	ubifs_assert(req->mod_dent <= 1);
+	ubifs_assert(req->new_ino <= 1);
+	ubifs_assert(req->new_ino_d <= UBIFS_MAX_INO_DATA);
 	ubifs_assert(req->dirtied_ino <= 4);
 	ubifs_assert(req->dirtied_ino_d <= UBIFS_MAX_INO_DATA * 4);
 
@@ -618,6 +624,12 @@ again:
  */
 void ubifs_release_budget(struct ubifs_info *c, struct ubifs_budget_req *req)
 {
+	ubifs_assert(req->new_page <= 1);
+	ubifs_assert(req->dirtied_page <= 1);
+	ubifs_assert(req->new_dent <= 1);
+	ubifs_assert(req->mod_dent <= 1);
+	ubifs_assert(req->new_ino <= 1);
+	ubifs_assert(req->new_ino_d <= UBIFS_MAX_INO_DATA);
 	ubifs_assert(req->dirtied_ino <= 4);
 	ubifs_assert(req->dirtied_ino_d <= UBIFS_MAX_INO_DATA * 4);
 	if (!req->recalculate) {
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index d342c69..565dca2 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -812,17 +812,23 @@ struct ubifs_compressor {
 struct ubifs_budget_req {
 	unsigned int fast:1;
 	unsigned int recalculate:1;
+#ifndef UBIFS_DEBUG
 	unsigned int new_page:1;
 	unsigned int dirtied_page:1;
 	unsigned int new_dent:1;
 	unsigned int mod_dent:1;
 	unsigned int new_ino:1;
 	unsigned int new_ino_d:13;
-#ifndef UBIFS_DEBUG
 	unsigned int dirtied_ino:4;
 	unsigned int dirtied_ino_d:15;
 #else
 	/* Not bit-fields to check for overflows */
+	unsigned int new_page;
+	unsigned int dirtied_page;
+	unsigned int new_dent;
+	unsigned int mod_dent;
+	unsigned int new_ino;
+	unsigned int new_ino_d;
 	unsigned int dirtied_ino;
 	unsigned int dirtied_ino_d;
 #endif
-- 
1.5.4.1


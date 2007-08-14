Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbXHNKLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbXHNKLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbXHNKKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbXHNKKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:37 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] Clear othercon pointers when a connection is closed
Date: Tue, 14 Aug 2007 10:47:05 +0100
Message-Id: <11870848365-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfield <pcaulfie@redhat.com>

This patch clears the othercon pointer and frees the memory when a connnection
is closed. This could cause a small memory leak when nodes leave the cluster.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index dd36273..d15fd5f 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -327,6 +327,8 @@ static void close_connection(struct connection *con, bool and_other)
 	if (con->othercon && and_other) {
 		/* Will only re-enter once. */
 		close_connection(con->othercon, false);
+		kmem_cache_free(con_cache, con->othercon);
+		con->othercon = NULL;
 	}
 	if (con->rx_page) {
 		__free_page(con->rx_page);
-- 
1.5.1.2


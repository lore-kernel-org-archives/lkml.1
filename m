Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbYLWQQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbYLWQQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLWQNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48928 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYLWQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:04 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/10] dlm: remove kmap/kunmap
Date: Tue, 23 Dec 2008 10:58:36 -0600
Message-Id: <1230051523-5478-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The pages used in lowcomms are not highmem, so kmap is not necessary.

Cc: Christine Caulfield <ccaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 1e72031..103a5eb 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -824,7 +824,6 @@ static void sctp_init_assoc(struct connection *con)
 	len = e->len;
 	offset = e->offset;
 	spin_unlock(&con->writequeue_lock);
-	kmap(e->page);
 
 	/* Send the first block off the write queue */
 	iov[0].iov_base = page_address(e->page)+offset;
@@ -855,7 +854,6 @@ static void sctp_init_assoc(struct connection *con)
 
 		if (e->len == 0 && e->users == 0) {
 			list_del(&e->list);
-			kunmap(e->page);
 			free_entry(e);
 		}
 		spin_unlock(&con->writequeue_lock);
@@ -1204,8 +1202,6 @@ void *dlm_lowcomms_get_buffer(int nodeid, int len, gfp_t allocation, char **ppc)
 
 	if (e) {
 	got_one:
-		if (users == 0)
-			kmap(e->page);
 		*ppc = page_address(e->page) + offset;
 		return e;
 	}
@@ -1234,7 +1230,6 @@ void dlm_lowcomms_commit_buffer(void *mh)
 	if (users)
 		goto out;
 	e->len = e->end - e->offset;
-	kunmap(e->page);
 	spin_unlock(&con->writequeue_lock);
 
 	if (!test_and_set_bit(CF_WRITE_PENDING, &con->flags)) {
@@ -1273,7 +1268,6 @@ static void send_to_sock(struct connection *con)
 		offset = e->offset;
 		BUG_ON(len == 0 && e->users == 0);
 		spin_unlock(&con->writequeue_lock);
-		kmap(e->page);
 
 		ret = 0;
 		if (len) {
@@ -1295,7 +1289,6 @@ static void send_to_sock(struct connection *con)
 
 		if (e->len == 0 && e->users == 0) {
 			list_del(&e->list);
-			kunmap(e->page);
 			free_entry(e);
 			continue;
 		}
-- 
1.5.5.1


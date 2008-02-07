Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbYBGGWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbYBGGWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYBGGSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 10/16] dlm: make find_rsb() fail gracefully when namelen is too large
Date: Thu,  7 Feb 2008 00:09:13 -0600
Message-Id: <1202364559-9201-11-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

We *can* get there from receive_request() and dlm_recover_master_copy()
with namelen too large if incoming request is invalid; BUG() from
DLM_ASSERT() in allocate_rsb() is a bit excessive reaction to that
and in case of dlm_recover_master_copy() we would actually oops before
that while calculating hash of up to 64Kb worth of data - with data
actually being 64 _bytes_ in kmalloc()'ed struct.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 0593dd8..6d98cf9 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -436,11 +436,15 @@ static int find_rsb(struct dlm_ls *ls, char *name, int namelen,
 {
 	struct dlm_rsb *r, *tmp;
 	uint32_t hash, bucket;
-	int error = 0;
+	int error = -EINVAL;
+
+	if (namelen > DLM_RESNAME_MAXLEN)
+		goto out;
 
 	if (dlm_no_directory(ls))
 		flags |= R_CREATE;
 
+	error = 0;
 	hash = jhash(name, namelen, 0);
 	bucket = hash & (ls->ls_rsbtbl_size - 1);
 
-- 
1.5.3.3


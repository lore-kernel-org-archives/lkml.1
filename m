Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYBGGSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYBGGSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYBGGSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 07/16] dlm: validate data in dlm_recover_directory()
Date: Thu,  7 Feb 2008 00:09:10 -0600
Message-Id: <1202364559-9201-8-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index ce30136..831050e 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -220,6 +220,7 @@ int dlm_recover_directory(struct dlm_ls *ls)
 		last_len = 0;
 
 		for (;;) {
+			int left;
 			error = dlm_recovery_stopped(ls);
 			if (error)
 				goto out_free;
@@ -236,11 +237,20 @@ int dlm_recover_directory(struct dlm_ls *ls)
 			 */
 
 			b = ls->ls_recover_buf->rc_buf;
+			left = ls->ls_recover_buf->rc_header.h_length;
+			left -= sizeof(struct dlm_rcom);
 
 			for (;;) {
-				memcpy(&namelen, b, sizeof(uint16_t));
-				namelen = be16_to_cpu(namelen);
-				b += sizeof(uint16_t);
+				__be16 v;
+
+				error = -EINVAL;
+				if (left < sizeof(__be16))
+					goto out_free;
+
+				memcpy(&v, b, sizeof(__be16));
+				namelen = be16_to_cpu(v);
+				b += sizeof(__be16);
+				left -= sizeof(__be16);
 
 				/* namelen of 0xFFFFF marks end of names for
 				   this node; namelen of 0 marks end of the
@@ -251,6 +261,12 @@ int dlm_recover_directory(struct dlm_ls *ls)
 				if (!namelen)
 					break;
 
+				if (namelen > left)
+					goto out_free;
+
+				if (namelen > DLM_RESNAME_MAXLEN)
+					goto out_free;
+
 				error = -ENOMEM;
 				de = get_free_de(ls, namelen);
 				if (!de)
@@ -262,6 +278,7 @@ int dlm_recover_directory(struct dlm_ls *ls)
 				memcpy(de->name, b, namelen);
 				memcpy(last_name, b, namelen);
 				b += namelen;
+				left -= namelen;
 
 				add_entry_to_hash(ls, de);
 				count++;
-- 
1.5.3.3


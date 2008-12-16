Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYLPPEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYLPPEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYLPPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:04:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43716 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbYLPPEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:04:33 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com, niallain@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: fix buffer overrun in parse_DFS_referrals
Date: Tue, 16 Dec 2008 10:04:24 -0500
Message-Id: <1229439864-3903-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing a kernel with memory poisoning enabled, I saw some warnings
about the redzone getting clobbered when chasing DFS referrals. The
buffer allocation for the unicode converted version of the searchName is
too small and needs to take null termination into account.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifssmb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9395928..824df14 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3992,7 +3992,8 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 
 		node->flags = le16_to_cpu(pSMBr->DFSFlags);
 		if (is_unicode) {
-			__le16 *tmp = kmalloc(strlen(searchName)*2, GFP_KERNEL);
+			__le16 *tmp = kmalloc(strlen(searchName)*2 + 2,
+						GFP_KERNEL);
 			cifsConvertToUCS((__le16 *) tmp, searchName,
 					PATH_MAX, nls_codepage, remap);
 			node->path_consumed = hostlen_fromUCS(tmp,
-- 
1.5.5.1


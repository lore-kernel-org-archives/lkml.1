Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759575AbYLQLkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbYLQLkk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYLQLkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:40:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50136 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbYLQLkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:40:08 -0500
From: Jeff Layton <jlayton@redhat.com>
To: torvalds@linux-foundation.org, sfrench@gmail.com
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] cifs: fix buffer overrun in parse_DFS_referrals
Date: Wed, 17 Dec 2008 06:31:53 -0500
Message-Id: <1229513513-16445-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing a kernel with memory poisoning enabled, I saw some warnings
about the redzone getting clobbered when chasing DFS referrals. The
buffer allocation for the unicode converted version of the searchName is
too small and needs to take null termination into account.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Steve French <sfrench@us.ibm.com>
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbXH0UY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbXH0UY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbXH0UXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:23:03 -0400
Received: from mail.fieldses.org ([66.93.2.214]:43340 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759286AbXH0UW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:22:59 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: linux-kernel@vger.kernel.org
Cc: nfs@lists.sourceforge.net, Neil Brown <neilb@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [PATCH 07/15] knfsd: nfs4 name->id mapping not correctly parsing negative downcall
Date: Mon, 27 Aug 2007 16:22:48 -0400
Message-Id: <11882461773396-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.5.3.rc6.48.g17437
In-Reply-To: <1188246177195-git-send-email-bfields@fieldses.org>
References: <11882461763072-git-send-email-bfields@fieldses.org>
 <1188246176681-git-send-email-bfields@fieldses.org>
 <1188246176897-git-send-email-bfields@fieldses.org>
 <1188246177833-git-send-email-bfields@fieldses.org>
 <11882461773576-git-send-email-bfields@fieldses.org>
 <11882461771774-git-send-email-bfields@fieldses.org>
 <1188246177195-git-send-email-bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

Note that qword_get() returns length or -1, not an -ERROR.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
---
 fs/nfsd/nfs4idmap.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index 2ccffde..4c0c683 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -207,6 +207,7 @@ idtoname_parse(struct cache_detail *cd, char *buf, int buflen)
 {
 	struct ent ent, *res;
 	char *buf1, *bp;
+	int len;
 	int error = -EINVAL;
 
 	if (buf[buflen - 1] != '\n')
@@ -248,10 +249,11 @@ idtoname_parse(struct cache_detail *cd, char *buf, int buflen)
 		goto out;
 
 	/* Name */
-	error = qword_get(&buf, buf1, PAGE_SIZE);
-	if (error == -EINVAL)
+	error = -EINVAL;
+	len = qword_get(&buf, buf1, PAGE_SIZE);
+	if (len < 0)
 		goto out;
-	if (error == -ENOENT)
+	if (len == 0)
 		set_bit(CACHE_NEGATIVE, &ent.h.flags);
 	else {
 		if (error >= IDMAP_NAMESZ) {
-- 
1.5.3.rc5.19.g0734d


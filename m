Return-Path: <linux-kernel-owner+w=401wt.eu-S965895AbXBOLbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965895AbXBOLbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 06:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965897AbXBOLbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 06:31:18 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:46402 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965895AbXBOLbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 06:31:17 -0500
To: linux-kernel@vger.kernel.org
CC: devel@openvz.org
Subject: [PATCH]mm __page_symlink retry loop error code fix
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Thu, 15 Feb 2007 14:31:39 +0300
Message-ID: <87d54b4pyc.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


If prepare_write or commit_write return AOP_TRUNCATED_PAGE we jump to "retry"
label and than if find_or_create_page() failed function return incorrect error
code. Initilally i've add this fix as a part of prepare_write_retval patch,
but IMHO it is better to split this to separate fix.
Patch against 2.6.20-rc6-mm3.
Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
-------

--=-=-=
Content-Disposition: inline; filename=diff-mm-fs-page_symlink-fix

diff --git a/fs/namei.c b/fs/namei.c
index 723db81..6b6fe43 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2692,10 +2692,11 @@ int __page_symlink(struct inode *inode, const char *symname, int len,
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-	int err = -ENOMEM;
+	int err;
 	char *kaddr;
 
 retry:
+	err = -ENOMEM;
 	page = find_or_create_page(mapping, 0, gfp_mask);
 	if (!page)
 		goto fail;

--=-=-=--


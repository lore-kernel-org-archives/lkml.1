Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbYEHN40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbYEHN40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYEHNzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:55:20 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:38691 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbYEHNzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FKRYWfr+ekFMMyAdf7n5Dtpabw3X/JZNogMoFii914Zm9wnMSJIp0XzypzIN+BWiG95hdz2nosdjfcc+YNhes/+KIuhDOXsyDY4S0X9WXOi0ywH1g7B6xBdkUeJrbh7KtI02IH3nRUNYqQ19XUeKM/UKbanLV5ii93okMJuAHtw=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [Patch 3/9] fs/compat.c: fix resource leaks and wrong goto's
Date: Thu,  8 May 2008 21:52:28 +0800
Message-Id: <12102548033990-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use free_arg_pages() to free the pages allocated by copy_strings_kernel()
on failure. And fix some related wrong goto pathes.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---
diff --git a/fs/compat.c b/fs/compat.c
index 332a869..7e836ff 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1381,15 +1381,15 @@ int compat_do_execve(char * filename,
 
 	retval = security_bprm_alloc(bprm);
 	if (retval)
-		goto out;
+		goto out_mm;
 
 	retval = prepare_binprm(bprm);
 	if (retval < 0)
-		goto out;
+		goto out_sec;
 
 	retval = copy_strings_kernel(1, &bprm->filename, bprm);
 	if (retval < 0)
-		goto out;
+		goto out_sec;
 
 	bprm->exec = bprm->p;
 	retval = compat_copy_strings(bprm->envc, envp, bprm);
@@ -1403,6 +1403,7 @@ int compat_do_execve(char * filename,
 	retval = search_binary_handler(bprm, regs);
 	if (retval >= 0) {
 		/* execve success */
+		free_arg_pages(bprm);
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
 		kfree(bprm);
@@ -1410,6 +1411,9 @@ int compat_do_execve(char * filename,
 	}
 
 out:
+	free_arg_pages(bprm);
+
+out_sec:
 	if (bprm->security)
 		security_bprm_free(bprm);
 

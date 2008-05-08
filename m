Return-Path: <linux-kernel-owner+w=401wt.eu-S1760402AbYEHNzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402AbYEHNzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYEHNy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:54:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:7132 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283AbYEHNy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:54:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QYGpLNaakstsWQ23mzF2ZBiL1f+a7mtGMHHRIkSXmrGO6Ne83RxPb0E6YfSKZqjNiBqArYu2nImRIYuMllgtiIq2Q7KOuzx6mQ/H2oqMT//wQBP4XlNh9eKFw/9LuJhuqsrN8mv7EoTKgGgB7P664CIevLiQ7ILfTRUhHB77qOg=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [Patch 2/9] fs/exec.c: fix resource leaks and wrong goto's
Date: Thu,  8 May 2008 21:52:27 +0800
Message-Id: <1210254794469-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ->load_binary() successed, free_arg_pages() should be called to
clean the pages allocated by copy_strings_kernel() within it.

And also fixes some wrong goto pathes.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---
diff --git a/fs/exec.c b/fs/exec.c
index aeaa979..b49ba41 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1218,6 +1220,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 				if (bprm->file)
 					fput(bprm->file);
 				bprm->file = NULL;
+				free_arg_pages(bprm);
 				current->did_exec = 1;
 				proc_exec_connector(current);
 				return retval;
@@ -1298,15 +1301,15 @@ int do_execve(char * filename,
 
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
 	retval = copy_strings(bprm->envc, envp, bprm);
@@ -1331,6 +1334,8 @@ int do_execve(char * filename,
 
 out:
 	free_arg_pages(bprm);
+
+out_sec:
 	if (bprm->security)
 		security_bprm_free(bprm);
 

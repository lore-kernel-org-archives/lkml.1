Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbYEHN5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbYEHN5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYEHNzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:55:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:23167 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbYEHNzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VCk7jfjYY7J5fN49E6qic+r9ED4to58GoFD+JmlzhgvMjjxHOhi8Ifg5roue+Nu+AOI1oRanE8kmiWPHt5vqkRh+vtTUJNcGufpJm3xr9Y8dmbexjFb3p8uh6Db9ulaSxiAmW4rQkB3S4SA/YdEjpQ1LHaGXO8OBmxkE7WAuESw=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>
Subject: [Patch 5/9] fs/binfmt_em86.c: fix resource leaks
Date: Thu,  8 May 2008 21:52:30 +0800
Message-Id: <12102548313018-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 ->load_binary()'s caller only frees resources which ->load_binary() applied
when it succeeded, so ->load_binary() itself should free the resources on
failure.

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index f9c88d0..caa8466 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -69,11 +69,13 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
 	bprm->argc++;
 	if (i_arg) {
 		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval; 
+		if (retval < 0)
+			goto out;
 		bprm->argc++;
 	}
 	retval = copy_strings_kernel(1, &i_name, bprm);
-	if (retval < 0)	return retval;
+	if (retval < 0)
+		goto out;
 	bprm->argc++;
 
 	/*
@@ -82,16 +84,27 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
 	 * space, and we don't need to copy it.
 	 */
 	file = open_exec(interp);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
+	if (IS_ERR(file)) {
+		retval = PTR_ERR(file);
+		goto out;
+	}
 
 	bprm->file = file;
 
 	retval = prepare_binprm(bprm);
-	if (retval < 0)
-		return retval;
+	if (retval < 0) {
+		if (bprm->file) {
+			allow_write_access(bprm->file);
+			fput(bprm->file);
+		}
+		goto out;
+	}
 
 	return search_binary_handler(bprm, regs);
+
+out:
+	free_arg_pages(bprm);
+	return retval;
 }
 
 static struct linux_binfmt em86_format = {

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763007AbYEHN5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763007AbYEHN5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbYEHNzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:55:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:34732 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473AbYEHNzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V0CkjBQOyGzhMwp5IOAi8PxO85fbisf8zWm4JsIFkVmsoN2Z7KWRTFy/xafId+bkNTsYCi4IFItJu5CW2SmW0yllhrnBW24w4776dvYW21cGdGaRRR/qTe2jO2wE9qwmhfV50MF26NE7ArYTgCm04J5C61Y1ENPts/VBMs/ap+s=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>
Subject: [Patch 6/9] fs/binfmt_misc.c: fix resource leaks
Date: Thu,  8 May 2008 21:52:31 +0800
Message-Id: <12102548463329-git-send-email-xiyou.wangcong@gmail.com>
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
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 7191306..bcc628c 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -174,7 +174,7 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	/* add the interp as argv[0] */
 	retval = copy_strings_kernel (1, &iname_addr, bprm);
 	if (retval < 0)
-		goto _error;
+		goto _error_free;
 	bprm->argc ++;
 
 	bprm->interp = iname;	/* for binfmt_script */
@@ -182,7 +182,7 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	interp_file = open_exec (iname);
 	retval = PTR_ERR (interp_file);
 	if (IS_ERR (interp_file))
-		goto _error;
+		goto _error_free;
 
 	bprm->file = interp_file;
 	if (fmt->flags & MISC_FMT_CREDENTIALS) {
@@ -196,14 +196,22 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 		retval = prepare_binprm (bprm);
 
 	if (retval < 0)
-		goto _error;
+		goto _error_file;
 
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
-		goto _error;
+		goto _error_file;
 
 _ret:
 	return retval;
+
+_error_file:
+	allow_write_access(bprm->file);
+	fput(bprm->file);
+
+_error_free:
+	free_arg_pages(bprm);
+
 _error:
 	if (fd_binary > 0)
 		sys_close(fd_binary);

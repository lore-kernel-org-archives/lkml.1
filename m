Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbYEHN4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbYEHN4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbYEHNz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:55:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:23167 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbYEHNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:55:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cVBQVS3qTWMcb/T6B4s3KFa/L1Ph1+wFokDCR1C+2nGNa3jz65BnyAdo2w9xRuzQ5NIxGq8Bw/zxCw71T+YibIvlIN+ruFHDL2i5UNSd1HyXa4HrFE/meQeA3Z/V3NWqEQ4uAATw+o6dB+f0cy0+h27R+5XWxYd3y3tvKFETe9c=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>
Subject: [Patch 4/9] fs/binfmt_script.c: fix resource leaks
Date: Thu,  8 May 2008 21:52:29 +0800
Message-Id: <12102548233189-git-send-email-xiyou.wangcong@gmail.com>
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
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 9e3963f..2c10342 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -75,11 +75,13 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	bprm->argc++;
 	if (i_arg) {
 		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval; 
+		if (retval < 0)
+			goto out;
 		bprm->argc++;
 	}
 	retval = copy_strings_kernel(1, &i_name, bprm);
-	if (retval) return retval; 
+	if (retval)
+		goto out;
 	bprm->argc++;
 	bprm->interp = interp;
 
@@ -87,14 +89,26 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	 * OK, now restart the process with the interpreter's dentry.
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
+
 	return search_binary_handler(bprm,regs);
+
+out:
+	free_arg_pages(bprm);
+	return retval;
 }
 
 static struct linux_binfmt script_format = {

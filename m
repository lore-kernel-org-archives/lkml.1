Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbYEHN5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbYEHN5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYEHN4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:56:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:8626 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761046AbYEHN4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K754ZqvOuH9OQSVaMoh89t5Dd7PSBuoHHZFui+ssZNr7tuv9s6yCSfqoWcewBsh8qfW7RH28dGAltMsHQcyBEfijQn6nOaWEo686ilk8hjsE8Boh85IESx2kjPmToJNdFnKzC1RYnVhPet6CFidKXGV+CDdDeNcvyfrX/ZYdKaU=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [Patch 7/9] fs/exec.c: fix wrong return value of prepare_binprm()
Date: Thu,  8 May 2008 21:52:32 +0800
Message-Id: <12102548553947-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All prepare_binprm()'s callers assume that prepare_binprm() fails
when it returns negative. However, prepare_binprm() most probably returns
the return value of kernel_read(), which may return positive on failure!

Thus this should be fixed.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---
diff --git a/fs/exec.c b/fs/exec.c
index aeaa979..0237541 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1063,7 +1063,11 @@ int prepare_binprm(struct linux_binprm *bprm)
 		return retval;
 
 	memset(bprm->buf,0,BINPRM_BUF_SIZE);
-	return kernel_read(bprm->file,0,bprm->buf,BINPRM_BUF_SIZE);
+	retval = kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
+	if (retval < 0)
+		return retval;
+	if (retval != BINPRM_BUF_SIZE && retval != inode->i_size)
+		return -EIO;
+	return 0;
 }
 
 EXPORT_SYMBOL(prepare_binprm);

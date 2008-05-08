Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbYEHN6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbYEHN6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYEHN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:56:12 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:38268 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761046AbYEHN4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vqZKpft7ajV4mWqYx3QVQo2WpSUJsuzYnXtajBL1zJEt1eSjk728KnINpLbPTAfft8Myp3aO7PWEmm1db8fLt77I825sw6R6sUrOSA+E1N15H5z3ok+//Fq3Dgn5kJ0RinNYBMlRIAE4AJGDKO9uZgRI1oavCrEjKVcQ+3rjsrg=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       WANG Cong <wangcong@zeuux.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [Patch 8/9] fs/binfmt_elf.c: fix wrong return values
Date: Thu,  8 May 2008 21:52:33 +0800
Message-Id: <12102548671322-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_elf_tables() returns 0 on success. But when strnlen_user() "fails",
it returns 0 directly. So this is wrong.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 43254e3..10f9642 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -256,7 +256,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 			return -EFAULT;
 		len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
 		if (!len || len > MAX_ARG_STRLEN)
-			return 0;
+			return -EINVAL;
 		p += len;
 	}
 	if (__put_user(0, argv))
@@ -268,7 +268,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 			return -EFAULT;
 		len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
 		if (!len || len > MAX_ARG_STRLEN)
-			return 0;
+			return -EINVAL;
 		p += len;
 	}
 	if (__put_user(0, envp))

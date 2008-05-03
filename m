Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbYECOKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbYECOKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 10:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYECOK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 10:10:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:20710 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbYECOK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 10:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=o1sKSggdCfX6hEt3svXd7vyJZNs6SXieG0DSYP0437YLN7vMUJx9v0t8XOUk1W5PBe4cJpbKWxwOOPzfiAsDadVWHZ5DNX3NRO2fF2bEcTAVOAkS+2gig0nF2vE3VVYEu3RZO4CzdTSGUEzHigNBYrhaZLr8IHH0KDijQJFgS/Q=
Date: Sat, 3 May 2008 22:14:24 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@osdl.org>,
       linux-fsdevel@vger.kernel.org
Subject: [Patch] fs/binfmt_elf.c: fix wrong return values
Message-ID: <20080503141409.GC3986@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When strnlen_user() fails, return 0 is suspecious.
What's more, the caller returns 0 on success, so that logic is
obviously wrong.

I am not sure if returning -EINVAL is good enough. I think it's
better than -EFAULT here.

NOTE: This patch is _not_ tested yet!

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>

---
 fs/binfmt_elf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.5.4.1


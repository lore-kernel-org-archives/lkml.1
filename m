Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967776Ab0B0D6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 22:58:10 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:50916 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab0B0D6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 22:58:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=f0skYClkPQl8Zk5zigHSWNwlpj/Fi/lbvkq2QIOvvriAso5cl2i5v4R2+hCrekSCMb
         lUhg20Vg9TbX5UYjAZ/2LsUGZvjumUWTjStM/Hj0sHJLbeshORd29lk47AwC0mgQKLFQ
         60jY389fpkauhKLJbKFcwuYgtX/u/DSZzHTb4=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH] binfmt_elf: plug a memory leak situation on dump_seek()
Date: Fri, 26 Feb 2010 00:54:40 -0300
Message-Id: <322581998527c77c89d6fb91b8cbe02b5637c6dc.1267156293.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.94.gf7311
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 fs/binfmt_elf.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fd5b2ea..13b0845 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1096,6 +1096,8 @@ static int dump_write(struct file *file, const void *addr, int nr)
 
 static int dump_seek(struct file *file, loff_t off)
 {
+	int ret = 1;
+
 	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
 		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
 			return 0;
@@ -1107,13 +1109,15 @@ static int dump_seek(struct file *file, loff_t off)
 			unsigned long n = off;
 			if (n > PAGE_SIZE)
 				n = PAGE_SIZE;
-			if (!dump_write(file, buf, n))
-				return 0;
+			if (!dump_write(file, buf, n)) {
+				ret = 0;
+				break;
+			}
 			off -= n;
 		}
 		free_page((unsigned long)buf);
 	}
-	return 1;
+	return ret;
 }
 
 /*
-- 
1.7.0.94.gf7311


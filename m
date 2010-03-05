Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab0CFKnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 05:43:46 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62041 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0CFKno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 05:43:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=p2ieuRdzcIVUor4AGVSiE/9D8wiunvKHRrptZBCw3Joln7MJ8XjL6JIcHf+xx1xPVm
         p+5Z89J0WFvaZlI63g+8KAXgSGXjGLzQApviHaU0Z4ygA0C6zvE/8FtcirtN+xWxF8HH
         kh9fJvxQ0BA+8+OVjpDklE4RXpNlh99PFZOCk=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH] coredump: plug a memory leak situation on dump_seek()
Date: Fri,  5 Mar 2010 07:40:02 -0300
Message-Id: <fe97698815cd081b5ab33a8c25c8b69cd0371a99.1267785456.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.1.164.gbe2f
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After having started writing the coredump, if filesystem reports an error
anytime while writing part of the core file, we would leak a memory page
when bailing out.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/coredump.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index b3c91d7..8ba66a9 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -16,6 +16,8 @@ static inline int dump_write(struct file *file, const void *addr, int nr)
 
 static inline int dump_seek(struct file *file, loff_t off)
 {
+	int ret = 1;
+
 	if (file->f_op->llseek && file->f_op->llseek != no_llseek) {
 		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
 			return 0;
@@ -29,13 +31,15 @@ static inline int dump_seek(struct file *file, loff_t off)
 
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
 
 #endif /* _LINUX_COREDUMP_H */
-- 
1.7.0.1.164.gbe2f


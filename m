Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYCTURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYCTURT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYCTURA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:17:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:63359 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYCTUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:16:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oUnYMvXfvTA+5YOICFnTcg/bxyVVMqRojc6pK397d4HkFbUXyR5z60O5Ptsqd4bnstp8PBvwSdDWqO3x7u6AqxYbiDfbZmp/qZpOrvWzlnRfrLiRfoVl75s+z5l5W20+SYnyoLxh559qtrrZsxrSXMuAnyhX2DGheq4VuzYMIGw=
Subject: [PATCH] kernel: create linux/unaligned.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080320190953.GR10722@ZenIV.linux.org.uk>
References: <1206034454.17059.4.camel@brick>
	 <20080320182911.GQ10722@ZenIV.linux.org.uk>
	 <1206038244.17059.7.camel@brick>
	 <20080320190953.GR10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 13:16:57 -0700
Message-Id: <1206044217.17059.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for the following two patterns currently found in the
kernel:

le32_to_cpu(get_unaligned((__le32 *)p));
put_unaligned(cpu_to_le32(x), (__le32 *)p);

Becomes:
le32_to_cpu_unaligned(p);
cpu_to_le32_unaligned(x, p);

There are also some hand-rolled functions implementing this
with byte-shifts that can be replaced.  To avoid new indirect
includes of asm/unaligned.h, create linux/unaligned.h to make
it opt in for new code that wants to use these helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This is a rollup of all the previous ones, added kerneldocs and
have CC'd Randy.

 include/linux/unaligned.h |  138 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 138 insertions(+), 0 deletions(-)

diff --git a/include/linux/unaligned.h b/include/linux/unaligned.h
new file mode 100644
index 0000000..035c1c7
--- /dev/null
+++ b/include/linux/unaligned.h
@@ -0,0 +1,138 @@
+#ifndef _LINUX_UNALIGNED_H_
+#define _LINUX_UNALIGNED_H_
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
+
+#ifdef __KERNEL__
+
+/**
+ * le64_to_cpu_unaligned - read a le64 from a possibly unaligned pointer
+ * @p: pointer to read from
+ *
+ * Returns a u64 in cpu byteorder
+ */
+static inline u64 le64_to_cpu_unaligned(void *p)
+{
+	return le64_to_cpu(get_unaligned((__le64 *)p));
+}
+
+/**
+ * le32_to_cpu_unaligned - read a le32 from a possibly unaligned pointer
+ * @p: pointer to read from
+ *
+ * Returns a u32 in cpu byteorder
+ */
+static inline u32 le32_to_cpu_unaligned(void *p)
+{
+	return le32_to_cpu(get_unaligned((__le32 *)p));
+}
+
+/**
+ * le16_to_cpu_unaligned - read a le16 from a possibly unaligned pointer
+ * @p: pointer to read from
+ *
+ * Returns a u16 in cpu byteorder
+ */
+static inline u16 le16_to_cpu_unaligned(void *p)
+{
+	return le16_to_cpu(get_unaligned((__le16 *)p));
+}
+
+/**
+ * be64_to_cpu_unaligned - read a be64 from a possibly unaligned pointer
+ * @p: pointer to read from
+ *
+ * Returns a u64 in cpu byteorder
+ */
+static inline u64 be64_to_cpu_unaligned(void *p)
+{
+	return be64_to_cpu(get_unaligned((__be64 *)p));
+}
+
+/**
+ * be32_to_cpu_unaligned - read a be32 from a possibly unaligned pointer
+ * @p: pointer to read from
+ *
+ * Returns a u32 in cpu byteorder
+ */
+static inline u32 be32_to_cpu_unaligned(void *p)
+{
+	return be32_to_cpu(get_unaligned((__be32 *)p));
+}
+
+/**
+ * be16_to_cpu_unaligned - read a be16 from a possibly unaligned pointer
+ * @p: pointer to read from
+ *
+ * Returns a u16 in cpu byteorder
+ */
+static inline u16 be16_to_cpu_unaligned(void *p)
+{
+	return be16_to_cpu(get_unaligned((__be16 *)p));
+}
+
+/**
+ * le64_to_cpu_unaligned - write a u64 in le-byteorder to a possibly unaligned pointer
+ * @val: value to be written
+ * @p: pointer to write to
+ */
+static inline void cpu_to_le64_unaligned(u64 val, void *p)
+{
+	put_unaligned(cpu_to_le64(val), (__le64 *)p);
+}
+
+/**
+ * le32_to_cpu_unaligned - write a u32 in le-byteorder to a possibly unaligned pointer
+ * @val: value to be written
+ * @p: pointer to write to
+ */
+static inline void cpu_to_le32_unaligned(u32 val, void *p)
+{
+	put_unaligned(cpu_to_le32(val), (__le32 *)p);
+}
+
+/**
+ * le16_to_cpu_unaligned - write a u16 in le-byteorder to a possibly unaligned pointer
+ * @val: value to be written
+ * @p: pointer to write to
+ */
+static inline void cpu_to_le16_unaligned(u16 val, void *p)
+{
+	put_unaligned(cpu_to_le16(val), (__le16 *)p);
+}
+
+/**
+ * be64_to_cpu_unaligned - write a u64 in be-byteorder to a possibly unaligned pointer
+ * @val: value to be written
+ * @p: pointer to write to
+ */
+static inline void cpu_to_be64_unaligned(u64 val, void *p)
+{
+	put_unaligned(cpu_to_be64(val), (__be64 *)p);
+}
+
+/**
+ * be32_to_cpu_unaligned - write a u32 in be-byteorder to a possibly unaligned pointer
+ * @val: value to be written
+ * @p: pointer to write to
+ */
+static inline void cpu_to_be32_unaligned(u32 val, void *p)
+{
+	put_unaligned(cpu_to_be32(val), (__be32 *)p);
+}
+
+/**
+ * be16_to_cpu_unaligned - write a u16 in be-byteorder to a possibly unaligned pointer
+ * @val: value to be written
+ * @p: pointer to write to
+ */
+static inline void cpu_to_be16_unaligned(u16 val, void *p)
+{
+	put_unaligned(cpu_to_be16(val), (__be16 *)p);
+}
+
+#endif /* KERNEL */
+
+#endif /* _LINUX_UNALIGNED_H */
-- 
1.5.4.4.684.g0e08




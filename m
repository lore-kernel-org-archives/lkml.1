Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYLAISn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYLAISn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYLAISe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:18:34 -0500
Received: from ozlabs.org ([203.10.76.45]:58989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYLAISe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:18:34 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:48:31 +1030
Subject: [PATCH 5/6] bitmap: find_last_bit()
Cc: Ingo Molnar <mingo@redhat.com>, Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011848.31552.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: New API

As the name suggests.  For the moment everyone uses the generic one.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/bitops.h |   13 ++++++++++++-
 lib/Kconfig            |    4 ++++
 lib/Makefile           |    1 +
 lib/find_next_bit.c    |   31 +++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

diff -r 22df8a8dec81 include/linux/bitops.h
--- a/include/linux/bitops.h	Sat Oct 18 04:46:13 2008 +1100
+++ b/include/linux/bitops.h	Tue Oct 21 17:06:35 2008 +1100
@@ -134,8 +134,19 @@ extern unsigned long find_first_bit(cons
  */
 extern unsigned long find_first_zero_bit(const unsigned long *addr,
 					 unsigned long size);
+#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
-#endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
+#ifdef CONFIG_GENERIC_FIND_LAST_BIT
+/**
+ * find_last_bit - find the last set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit number of the first set bit, or size.
+ */
+extern unsigned long find_last_bit(const unsigned long *addr,
+				   unsigned long size);
+#endif /* CONFIG_GENERIC_FIND_LAST_BIT */
 
 #ifdef CONFIG_GENERIC_FIND_NEXT_BIT
 
diff -r 22df8a8dec81 lib/Kconfig
--- a/lib/Kconfig	Sat Oct 18 04:46:13 2008 +1100
+++ b/lib/Kconfig	Tue Oct 21 17:06:35 2008 +1100
@@ -12,6 +12,10 @@ config GENERIC_FIND_FIRST_BIT
 
 config GENERIC_FIND_NEXT_BIT
 	bool
+
+config GENERIC_FIND_LAST_BIT
+	bool
+	default y
 
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
diff -r 22df8a8dec81 lib/Makefile
--- a/lib/Makefile	Sat Oct 18 04:46:13 2008 +1100
+++ b/lib/Makefile	Tue Oct 21 17:06:35 2008 +1100
@@ -37,6 +37,7 @@ lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) +=
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
+lib-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
 obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_PLIST) += plist.o
diff -r 22df8a8dec81 lib/find_next_bit.c
--- a/lib/find_next_bit.c	Sat Oct 18 04:46:13 2008 +1100
+++ b/lib/find_next_bit.c	Tue Oct 21 17:06:35 2008 +1100
@@ -159,6 +159,37 @@ EXPORT_SYMBOL(find_first_zero_bit);
 EXPORT_SYMBOL(find_first_zero_bit);
 #endif /* CONFIG_GENERIC_FIND_FIRST_BIT */
 
+#ifdef CONFIG_GENERIC_FIND_LAST_BIT
+unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
+{
+	unsigned long words;
+	unsigned long tmp;
+
+	/* Start at final word. */
+	words = size / BITS_PER_LONG;
+
+	/* Partial final word? */
+	if (size & (BITS_PER_LONG-1)) {
+		tmp = (addr[words] & (~0UL >> (BITS_PER_LONG
+					 - (size & (BITS_PER_LONG-1)))));
+		if (tmp)
+			goto found;
+	}
+
+	while (words) {
+		tmp = addr[--words];
+		if (tmp) {
+found:
+			return words * BITS_PER_LONG + __fls(tmp);
+		}
+	}
+
+	/* Not found */
+	return size;
+}
+EXPORT_SYMBOL(find_last_bit);
+#endif /* CONFIG_GENERIC_FIND_LAST_BIT */
+
 #ifdef __BIG_ENDIAN
 
 /* include/linux/byteorder does not support "unsigned long" type */



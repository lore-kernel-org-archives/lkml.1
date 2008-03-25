Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYCYCVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYCYCVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 22:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYCYCT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 22:19:59 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50308 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752917AbYCYCT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 22:19:56 -0400
Message-Id: <20080325021955.802967000@polaris-admin.engr.sgi.com>
References: <20080325021954.979158000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 24 Mar 2008 19:19:59 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>
Subject: [PATCH 05/10] cpumask: Add cpumask_scnprintf_len function
Content-Disposition: inline; filename=add-cpumask_scnprintf_len
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function cpumask_scnprintf_len() to return the number of
characters needed to display "len" cpumask bits.  The current method
of allocating NR_CPUS bytes is incorrect as what's really needed is
9 characters per 32-bit word of cpumask bits (8 hex digits plus the
seperator [','] or the terminating NULL.)  This function provides the
caller the means to allocate the correct string length.

Based on linux-2.6.25-rc5-mm1

Cc: Paul Jackson <pj@sgi.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/bitmap.h  |    1 +
 include/linux/cpumask.h |    7 +++++++
 lib/bitmap.c            |   16 ++++++++++++++++
 3 files changed, 24 insertions(+)

--- linux-2.6.25-rc5.orig/include/linux/bitmap.h
+++ linux-2.6.25-rc5/include/linux/bitmap.h
@@ -110,6 +110,7 @@ extern int __bitmap_weight(const unsigne
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
+extern int bitmap_scnprintf_len(unsigned int len);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
--- linux-2.6.25-rc5.orig/include/linux/cpumask.h
+++ linux-2.6.25-rc5/include/linux/cpumask.h
@@ -277,6 +277,13 @@ static inline int __cpumask_scnprintf(ch
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
+#define cpumask_scnprintf_len(len) \
+			__cpumask_scnprintf_len((len))
+static inline int __cpumask_scnprintf_len(int len)
+{
+	return bitmap_scnprintf_len(len);
+}
+
 #define cpumask_parse_user(ubuf, ulen, dst) \
 			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
 static inline int __cpumask_parse_user(const char __user *buf, int len,
--- linux-2.6.25-rc5.orig/lib/bitmap.c
+++ linux-2.6.25-rc5/lib/bitmap.c
@@ -316,6 +316,22 @@ int bitmap_scnprintf(char *buf, unsigned
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
+ * bitmap_scnprintf_len - return buffer length needed to convert
+ * bitmap to an ASCII hex string.
+ * @len: number of bits to be converted
+ */
+int bitmap_scnprintf_len(unsigned int len)
+{
+	/* we need 9 chars per word for 32 bit words (8 hexdigits + sep/null) */
+	int bitslen = ALIGN(len, CHUNKSZ);
+	int wordlen = CHUNKSZ / 4;
+	int buflen = (bitslen / wordlen) * (wordlen + 1) * sizeof(char);
+
+	return buflen;
+}
+EXPORT_SYMBOL(bitmap_scnprintf_len);
+
+/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this

-- 

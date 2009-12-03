Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbZLCXlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbZLCXlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZLCXlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:41:46 -0500
Received: from cobra.newdream.net ([66.33.216.30]:36082 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZLCXgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:36:15 -0500
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 04/24] ceph: hash function
Date: Thu,  3 Dec 2009 15:41:11 -0800
Message-Id: <1259883691-1042-5-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259883691-1042-4-git-send-email-sage@newdream.net>
References: <1259883691-1042-1-git-send-email-sage@newdream.net>
 <1259883691-1042-2-git-send-email-sage@newdream.net>
 <1259883691-1042-3-git-send-email-sage@newdream.net>
 <1259883691-1042-4-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the hash functions used for placing dentries in directories
and for mapping objects into placement groups.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/ceph_hash.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/ceph_hash.h |   13 ++++++
 2 files changed, 131 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/ceph_hash.c
 create mode 100644 fs/ceph/ceph_hash.h

diff --git a/fs/ceph/ceph_hash.c b/fs/ceph/ceph_hash.c
new file mode 100644
index 0000000..bd57001
--- /dev/null
+++ b/fs/ceph/ceph_hash.c
@@ -0,0 +1,118 @@
+
+#include "types.h"
+
+/*
+ * Robert Jenkin's hash function.
+ * http://burtleburtle.net/bob/hash/evahash.html
+ * This is in the public domain.
+ */
+#define mix(a, b, c)						\
+	do {							\
+		a = a - b;  a = a - c;  a = a ^ (c >> 13);	\
+		b = b - c;  b = b - a;  b = b ^ (a << 8);	\
+		c = c - a;  c = c - b;  c = c ^ (b >> 13);	\
+		a = a - b;  a = a - c;  a = a ^ (c >> 12);	\
+		b = b - c;  b = b - a;  b = b ^ (a << 16);	\
+		c = c - a;  c = c - b;  c = c ^ (b >> 5);	\
+		a = a - b;  a = a - c;  a = a ^ (c >> 3);	\
+		b = b - c;  b = b - a;  b = b ^ (a << 10);	\
+		c = c - a;  c = c - b;  c = c ^ (b >> 15);	\
+	} while (0)
+
+unsigned ceph_str_hash_rjenkins(const char *str, unsigned length)
+{
+	const unsigned char *k = (const unsigned char *)str;
+	__u32 a, b, c;  /* the internal state */
+	__u32 len;      /* how many key bytes still need mixing */
+
+	/* Set up the internal state */
+	len = length;
+	a = 0x9e3779b9;      /* the golden ratio; an arbitrary value */
+	b = a;
+	c = 0;               /* variable initialization of internal state */
+
+	/* handle most of the key */
+	while (len >= 12) {
+		a = a + (k[0] + ((__u32)k[1] << 8) + ((__u32)k[2] << 16) +
+			 ((__u32)k[3] << 24));
+		b = b + (k[4] + ((__u32)k[5] << 8) + ((__u32)k[6] << 16) +
+			 ((__u32)k[7] << 24));
+		c = c + (k[8] + ((__u32)k[9] << 8) + ((__u32)k[10] << 16) +
+			 ((__u32)k[11] << 24));
+		mix(a, b, c);
+		k = k + 12;
+		len = len - 12;
+	}
+
+	/* handle the last 11 bytes */
+	c = c + length;
+	switch (len) {            /* all the case statements fall through */
+	case 11:
+		c = c + ((__u32)k[10] << 24);
+	case 10:
+		c = c + ((__u32)k[9] << 16);
+	case 9:
+		c = c + ((__u32)k[8] << 8);
+		/* the first byte of c is reserved for the length */
+	case 8:
+		b = b + ((__u32)k[7] << 24);
+	case 7:
+		b = b + ((__u32)k[6] << 16);
+	case 6:
+		b = b + ((__u32)k[5] << 8);
+	case 5:
+		b = b + k[4];
+	case 4:
+		a = a + ((__u32)k[3] << 24);
+	case 3:
+		a = a + ((__u32)k[2] << 16);
+	case 2:
+		a = a + ((__u32)k[1] << 8);
+	case 1:
+		a = a + k[0];
+		/* case 0: nothing left to add */
+	}
+	mix(a, b, c);
+
+	return c;
+}
+
+/*
+ * linux dcache hash
+ */
+unsigned ceph_str_hash_linux(const char *str, unsigned length)
+{
+	unsigned long hash = 0;
+	unsigned char c;
+
+	while (length--) {
+		c = *str++;
+		hash = (hash + (c << 4) + (c >> 4)) * 11;
+	}
+	return hash;
+}
+
+
+unsigned ceph_str_hash(int type, const char *s, unsigned len)
+{
+	switch (type) {
+	case CEPH_STR_HASH_LINUX:
+		return ceph_str_hash_linux(s, len);
+	case CEPH_STR_HASH_RJENKINS:
+		return ceph_str_hash_rjenkins(s, len);
+	default:
+		return -1;
+	}
+}
+
+const char *ceph_str_hash_name(int type)
+{
+	switch (type) {
+	case CEPH_STR_HASH_LINUX:
+		return "linux";
+	case CEPH_STR_HASH_RJENKINS:
+		return "rjenkins";
+	default:
+		return "unknown";
+	}
+}
diff --git a/fs/ceph/ceph_hash.h b/fs/ceph/ceph_hash.h
new file mode 100644
index 0000000..5ac470c
--- /dev/null
+++ b/fs/ceph/ceph_hash.h
@@ -0,0 +1,13 @@
+#ifndef _FS_CEPH_HASH_H
+#define _FS_CEPH_HASH_H
+
+#define CEPH_STR_HASH_LINUX      0x1  /* linux dcache hash */
+#define CEPH_STR_HASH_RJENKINS   0x2  /* robert jenkins' */
+
+extern unsigned ceph_str_hash_linux(const char *s, unsigned len);
+extern unsigned ceph_str_hash_rjenkins(const char *s, unsigned len);
+
+extern unsigned ceph_str_hash(int type, const char *s, unsigned len);
+extern const char *ceph_str_hash_name(int type);
+
+#endif
-- 
1.6.5


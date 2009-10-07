Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZJGEqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZJGEqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZJGEqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:46:23 -0400
Received: from mail.perches.com ([173.55.12.10]:1951 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbZJGEqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:46:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/8] lib/vsprintf.c: Add %pU to print UUID/GUIDs
Date: Tue,  6 Oct 2009 21:45:34 -0700
Message-Id: <05ab4473056a4a8a80e97f960837f788e5c4aad8.1254884776.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc2.17.gdbc1b.dirty
In-Reply-To: <1254890742-28245-1-git-send-email-joe@perches.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
In-Reply-To: <cover.1254884776.git.joe@perches.com>
References: <cover.1254884776.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UUID/GUIDs are somewhat common in kernel source.

Standardize the printed style of UUID/GUIDs by using
another extension to %p.

%pUb:   01020304-0506-0708-090a-0b0c0d0e0f10
%pUB:   01020304-0506-0708-090A-0B0C0D0E0F10 (upper case)
%pUl:   04030201-0605-0807-090a-0b0c0d0e0f10
%pUL:   04030201-0605-0807-090A-0B0C0D0E0F10 (upper case)

%pU defaults to %pUb

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/vsprintf.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 33bed5e..d24dc7f 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -790,6 +790,52 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, ip4_addr, spec);
 }
 
+static char *uuid_string(char *buf, char *end, const u8 *addr,
+			 struct printf_spec spec, const char *fmt)
+{
+	char uuid[sizeof("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")];
+	char *p = uuid;
+	int i;
+	static const u8 be[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
+	static const u8 le[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
+	const u8 *index = be;
+	bool uc = false;
+
+	switch (*(++fmt)) {
+	case 'L':
+		uc = true;		/* fall-through */
+	case 'l':
+		index = le;
+		break;
+	case 'B':
+		uc = true;
+		break;
+	}
+
+	for (i = 0; i < 16; i++) {
+		p = pack_hex_byte(p, addr[index[i]]);
+		switch (i) {
+		case 3:
+		case 5:
+		case 7:
+		case 9:
+			*p++ = '-';
+			break;
+		}
+	}
+
+	*p = 0;
+
+	if (uc) {
+		p = uuid;
+		do {
+			*p = toupper(*p);
+		} while (*(++p));
+	}
+
+	return string(buf, end, uuid, spec);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -814,6 +860,18 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
  *       IPv4 uses dot-separated decimal with leading 0's (010.123.045.006)
  * - 'I6c' for IPv6 addresses printed as specified by
  *       http://www.ietf.org/id/draft-kawamura-ipv6-text-representation-03.txt
+ * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
+ *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
+ *       Options for %pU are:
+ *         b big endian lower case hex (default)
+ *         B big endian UPPER case hex
+ *         l little endian lower case hex
+ *         L little endian UPPER case hex
+ *           big endian output byte order is:
+ *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
+ *           little endian output byte order is:
+ *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
+ *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
@@ -828,9 +886,9 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	case 'F':
 	case 'f':
 		ptr = dereference_function_descriptor(ptr);
-	case 's':
 		/* Fallthrough */
 	case 'S':
+	case 's':
 		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 		return resource_string(buf, end, ptr, spec);
@@ -853,6 +911,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return ip4_addr_string(buf, end, ptr, spec, fmt);
 		}
 		break;
+	case 'U':
+		return uuid_string(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-- 
1.6.3.1.10.g659a0.dirty


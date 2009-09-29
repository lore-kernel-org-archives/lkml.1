Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbZI2FBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbZI2FBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZI2FBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:01:12 -0400
Received: from mail.perches.com ([173.55.12.10]:1275 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbZI2FBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:01:10 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Alex Elder <aelder@sgi.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/9] lib/vsprintf.c: Add %pU to print UUID/GUIDs
Date: Mon, 28 Sep 2009 22:01:03 -0700
Message-Id: <f28939e0018c7e2a9e898722e0fb8514a843b14c.1254193019.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254193019.git.joe@perches.com>
References: <cover.1254193019.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UUID/GUIDs are somewhat common in kernel source.

Standardize the printed style of UUID/GUIDs by using
another extension to %p.

%pU:    01020304-0506-0708-090a-0b0c0d0e0f10
%pUr:   04030201-0605-0807-090a-0b0c0d0e0f10
%pU[r]X:Use upper case hex

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/vsprintf.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b91839e..68a49bb 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -790,6 +790,53 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, ip4_addr, spec);
 }
 
+static char *uuid_string(char *buf, char *end, const u8 *addr,
+			 struct printf_spec spec, const char *fmt)
+{
+	char uuid[sizeof("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")];
+	char *p = uuid;
+	int i;
+	static const u8 r[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
+	static const u8 n[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
+	const u8 *index = n;
+	bool uc = false;
+
+	while (isalnum(*(++fmt))) {
+		switch (*fmt) {
+		case 'r':
+			index = r;
+			break;
+		case 'X':
+			uc = true;
+			break;
+		}
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
+		while (*p) {
+			*p = toupper(*p);
+			p++;
+		}
+	}
+
+	return string(buf, end, uuid, spec);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -814,6 +861,13 @@ static char *ip4_addr_string(char *buf, char *end, const u8 *addr,
  *       IPv4 uses dot-separated decimal with leading 0's (010.123.045.006)
  * - 'I6c' for IPv6 addresses printed as specified by
  *       http://www.ietf.org/id/draft-kawamura-ipv6-text-representation-03.txt
+ * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
+ *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
+ *       Options for %pU are:
+ *       'X' use upper case hex digits
+ *       'r' use LE byte order for U32 and U16s equivalents.  Use indices:
+ *       [3][2][1][0]-[5][4]-[7][6]-[9][8]-[10]...[15]
+ *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
@@ -828,9 +882,9 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
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
@@ -853,6 +907,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
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


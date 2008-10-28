Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbYJ1EGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbYJ1EGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYJ1EGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:06:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:61819 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYJ1EGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=NpYC56pND5eMTYCFrAYnNVM0i+tpoojR3wqtdFx0KUQWKMlf6j6kIRLwLf95lywoZ9
         JcWffwjiFZPxFLeOdnMgpfs5JkiXjPXN4KQFmzQN+oxmnVAQiu/LgmbS9q4mxAOFd0ai
         AUqD0GadMrm9YsDKnpZOpElUTId2qLqnrLu7w=
Subject: [RFC PATCH 1/5] printk: add %p6 format specifier for IPv6 addresses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Johannes Berg <johannes@sipsolutions.net>, Joe Perches <joe@perches.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 21:05:17 -0700
Message-Id: <1225166717.5526.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takes a pointer to a IPv6 address and formats it in the usual
colon-separated hex format:
xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx

Each 16 bit word is printed in network-endian byteorder.

%#p6 is also supported and will omit the colons.

%p6 is a replacement for NIP6_FMT and NIP6()
%#p6 is a replacement for NIP6_SEQFMT and NIP6()

Note that NIP6() took a struct in6_addr whereas this takes a pointer
to a struct in6_addr.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Dave, I haven't seen the %pM ones hit your tree yet, but this should
be pretty trivial to put on top.

Regardless, I found what looks like a pretty blatent bug that is
separated in patch 2/5.  Consider this a beta as I haven't done
more than trivial tests thus far.  But it would be good to get
another set of eyes.

 lib/vsprintf.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 2025305..034e605 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -598,6 +598,24 @@ static char *mac_address(char *buf, char *end, u8 *addr, int field_width,
 	return string(buf, end, mac_addr, field_width, precision, flags & ~SPECIAL);
 }
 
+static char *ip6_addr_string(char *buf, char *end, u8 *addr, int field_width,
+			 int precision, int flags)
+{
+	char ip6_addr[8 * 5]; /* (8 * 4 hex digits), 7 colons and trailing zero */
+	char *p = ip6_addr;
+	int i;
+
+	for (i = 0; i < 8; i++) {
+		p = pack_hex_byte(p, addr[2 * i]);
+		p = pack_hex_byte(p, addr[2 * i + 1]);
+		if (!(flags & SPECIAL) && i != 7)
+			*p++ = ':';
+	}
+	*p = '\0';
+
+	return string(buf, end, ip6_addr, field_width, precision, flags & ~SPECIAL);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -611,6 +629,8 @@ static char *mac_address(char *buf, char *end, u8 *addr, int field_width,
  *       addresses (not the name nor the flags)
  * - 'M' For a 6-byte MAC address, it prints the address in the
  *       usual colon-separated hex notation
+ * - '6' For a IPv6 address prints the address in network-ordered 16 bit hex
+ *       with colon separators
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -628,6 +648,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 		return resource_string(buf, end, ptr, field_width, precision, flags);
 	case 'M':
 		return mac_address(buf, end, ptr, field_width, precision, flags);
+	case '6':
+		return ip6_addr_string(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
-- 
1.6.0.3.729.g6ea410



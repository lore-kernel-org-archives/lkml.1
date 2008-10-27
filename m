Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYJ0UB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYJ0UB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYJ0UBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:01:45 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:55124 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYJ0UBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:01:44 -0400
X-Greylist: delayed 2133 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2008 16:01:44 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pGeYUecEi1tSelRdxMTrTvWaR3Pr1nO+MsUirV6TQtom8F5qtf7QhFxMMCI8JAdPHW
         Z2W2GzSHmd8OaPYUIBlgty6jZbsi8CyMs8mVhrI1iWp0DpQNjAfsImkVXFY3/mW7xM9l
         ERFtqy891gPUfLaCUJQFjZM2HOtQ64NVjywQU=
Subject: [RFC PATCHv3] printk: add %pM format specifier for MAC addresses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, anders@anduras.de, netdev@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081027.123805.134354592.davem@davemloft.net>
References: <1225067465.5672.1.camel@brick>
	 <1225090765.3746.7.camel@johannes.berg> <1225124904.5440.1.camel@brick>
	 <20081027.123805.134354592.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 12:59:02 -0700
Message-Id: <1225137542.5396.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add format specifiers for printing out six colon-separated bytes:

MAC addresses (%pM):
xx:xx:xx:xx:xx:xx

%#pM is also supported and omits the colon separators.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Dave, this passes testing here, but I was wondering if perhaps it would be
better to allow a length to be specified as well, which would allow:

%pM6 for mac addresses, etc as there seem a lot of places in kernel that
print out a list of colon separated bytes of various lengths.

But if that was added, it may be more natural to call it 
%pB (bytes)
%pW (words)

Then mac addresses would be %pB6
IPv6 addresses would be %pW8 (8 words)

It would be trivial to add, but maybe I'm overthinking this.  In any event,
this patch only adds %pM for mac addresses.

 lib/vsprintf.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index a013bbc..2025305 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -581,6 +581,23 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
 	return string(buf, end, sym, field_width, precision, flags);
 }
 
+static char *mac_address(char *buf, char *end, u8 *addr, int field_width,
+			 int precision, int flags)
+{
+	char mac_addr[6 * 3]; /* (6 * 2 hex digits), 5 colons and trailing zero */
+	char *p = mac_addr;
+	int i;
+
+	for (i = 0; i < 6; i++) {
+		p = pack_hex_byte(p, addr[i]);
+		if (!(flags & SPECIAL) && i != 5)
+			*p++ = ':';
+	}
+	*p = '\0';
+
+	return string(buf, end, mac_addr, field_width, precision, flags & ~SPECIAL);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -592,6 +609,8 @@ static char *resource_string(char *buf, char *end, struct resource *res, int fie
  * - 'S' For symbolic direct pointers
  * - 'R' For a struct resource pointer, it prints the range of
  *       addresses (not the name nor the flags)
+ * - 'M' For a 6-byte MAC address, it prints the address in the
+ *       usual colon-separated hex notation
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -607,6 +626,8 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr, int field
 		return symbol_string(buf, end, ptr, field_width, precision, flags);
 	case 'R':
 		return resource_string(buf, end, ptr, field_width, precision, flags);
+	case 'M':
+		return mac_address(buf, end, ptr, field_width, precision, flags);
 	}
 	flags |= SMALL;
 	if (field_width == -1) {
-- 
1.6.0.3.729.g6ea410




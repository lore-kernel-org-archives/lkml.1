Return-Path: <linux-kernel-owner+w=401wt.eu-S936724AbZLQEqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936724AbZLQEqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935548AbZLQEqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:46:15 -0500
Received: from kroah.org ([198.145.64.141]:55318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763292AbZLQEDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:49 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:46 2009
Message-Id: <20091217035645.929446109@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [023/151] ssb: Fix range check in sprom write
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

commit e33761e6f23881de9f3ee77cc2204ab2e26f3d9a upstream.

The range check in the sprom image parser hex2sprom() is broken.
One sprom word is 4 hex characters.
This fixes the check and also adds much better sanity checks to the code.
We better make sure the image is OK by doing some sanity checks to avoid
bricking the device by accident.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ssb/sprom.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -13,6 +13,8 @@
 
 #include "ssb_private.h"
 
+#include <linux/ctype.h>
+
 
 static const struct ssb_sprom *fallback_sprom;
 
@@ -33,17 +35,27 @@ static int sprom2hex(const u16 *sprom, c
 static int hex2sprom(u16 *sprom, const char *dump, size_t len,
 		     size_t sprom_size_words)
 {
-	char tmp[5] = { 0 };
-	int cnt = 0;
+	char c, tmp[5] = { 0 };
+	int err, cnt = 0;
 	unsigned long parsed;
 
-	if (len < sprom_size_words * 2)
+	/* Strip whitespace at the end. */
+	while (len) {
+		c = dump[len - 1];
+		if (!isspace(c) && c != '\0')
+			break;
+		len--;
+	}
+	/* Length must match exactly. */
+	if (len != sprom_size_words * 4)
 		return -EINVAL;
 
 	while (cnt < sprom_size_words) {
 		memcpy(tmp, dump, 4);
 		dump += 4;
-		parsed = simple_strtoul(tmp, NULL, 16);
+		err = strict_strtoul(tmp, 16, &parsed);
+		if (err)
+			return err;
 		sprom[cnt++] = swab16((u16)parsed);
 	}
 



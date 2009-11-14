Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZKOHOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZKOHOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZKOHOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:17 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:40952 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZKOHOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:14:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=vFjjNNMwIk5pEw5z0WDvGJDdi92ByVtcRqhrO0S7FFG7KnRdjvZBHGtK27DmjQ1PNs
         RP5G0/dgwvXTeMUVndCyfG9RBebYB9+0iQpH1UGbxHJUldJ0iKKvYQ6ESWZpSM6oRGWE
         ufjvRGjztHHO3HhAyszkC3JkbW+XTjfyBoGE0=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 07/12] vsprintf: factor out skip_space code in a separate function
Date: Sat, 14 Nov 2009 05:11:55 -0200
Message-Id: <386ab0c1bdf5c81ac02e7e3ed9a8e84edede6321.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting more caller sites, the inline decision will be left up to gcc.

It decreases code size:
 text    data     bss     dec     hex filename
15710       0       8   15718    3d66 vsprintf.o (ex lib/lib.a-BEFORE)
15534       0       8   15542    3cb6 vsprintf.o (ex lib/lib.a-AFTER)

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 8b60f77..f6492b5 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1733,6 +1733,13 @@ EXPORT_SYMBOL_GPL(bprintf);
 
 #endif /* CONFIG_BINARY_PRINTF */
 
+static noinline char *skip_space(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return (char *)str;
+}
+
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer
@@ -1754,10 +1761,8 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 		 * white space, including none, in the input.
 		 */
 		if (isspace(*fmt)) {
-			while (isspace(*fmt))
-				++fmt;
-			while (isspace(*str))
-				++str;
+			fmt = skip_space(fmt);
+			str = skip_space(str);
 		}
 
 		/* anything that is not a conversion must match exactly */
@@ -1827,8 +1832,7 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 			if (field_width == -1)
 				field_width = INT_MAX;
 			/* first, skip leading white space in buffer */
-			while (isspace(*str))
-				str++;
+			str = skip_space(str);
 
 			/* now copy until next white space */
 			while (*str && !isspace(*str) && field_width--)
@@ -1870,8 +1874,7 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 		/* have some sort of integer conversion.
 		 * first, skip white space in buffer.
 		 */
-		while (isspace(*str))
-			str++;
+		str = skip_space(str);
 
 		digit = *str;
 		if (is_sign && digit == '-')
-- 
1.6.5.2.180.gc5b3e.dirty


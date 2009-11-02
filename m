Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZKBR1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZKBR1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbZKBR1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:27:13 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:43316 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbZKBR1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:27:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Urk45cfEJ7QgQrGkfZT94nAXyKq60+wC+HtWJuw4hH59g0i4aaOyFUpA2YeQU6F6Cf
         17sgQF77yr1FwCQmlecotM1hAqOwqOjcUyZ++Hdd80PnNnHb6I8AoNKQeEUJYaisF1do
         JglxsCgzD5tU7701VHubTBcNoxB/NbKmPQiLc=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 2 Nov 2009 15:26:55 -0200
Message-ID: <b8bf37780911020926p77ca30d1maa4384f21323adb@mail.gmail.com>
Subject: [PATCH v2 7/7] vsprintf: factor out skip_space code in a separate 
	function
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 584d9bfc7c1d41b76a05655b4562b98fcbef6ee4 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sun, 1 Nov 2009 14:09:06 -0200
Subject: [PATCH v2 7/7] vsprintf: factor out skip_space code in a
separate function
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It decreases code size:
   text    data     bss     dec     hex filename
  15703       0       8   15711    3d5f lib/vsprintf.o-before
  15527       0       8   15535    3caf lib/vsprintf.o-after

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/vsprintf.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 957e252..c3b19d7 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1745,6 +1745,13 @@ EXPORT_SYMBOL_GPL(bprintf);

 #endif /* CONFIG_BINARY_PRINTF */

+static noinline const char *skip_space(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return str;
+}
+
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer
@@ -1766,10 +1773,8 @@ int vsscanf(const char *buf, const char *fmt,
va_list args)
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
@@ -1839,8 +1844,7 @@ int vsscanf(const char *buf, const char *fmt,
va_list args)
 			if (field_width == -1)
 				field_width = INT_MAX;
 			/* first, skip leading white space in buffer */
-			while (isspace(*str))
-				str++;
+			str = skip_space(str);

 			/* now copy until next white space */
 			while (*str && !isspace(*str) && field_width--)
@@ -1882,8 +1886,7 @@ int vsscanf(const char *buf, const char *fmt,
va_list args)
 		/* have some sort of integer conversion.
 		 * first, skip white space in buffer.
 		 */
-		while (isspace(*str))
-			str++;
+		str = skip_space(str);

 		digit = *str;
 		if (is_sign && digit == '-')
-- 
1.6.5.2.140.g5f809

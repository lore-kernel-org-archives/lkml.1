Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZKDOtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZKDOtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbZKDOtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:49:31 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46847 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbZKDOt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:49:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hWubGFH6kxt+PaspCDCfTe5dc0Ss6iWpKhoeMGQsCAjLllPOH2nMl/JJRlW+pYd67C
         cuO6D6P+VdE+UIvigfFb30pgCIm9AI6niquW1Bigd7RhSMsFVI1hQSWtXl7VnVPnu/FP
         WyxRo9k9NvMScZkEqrqq1tC5kGtE+RIms9EMs=
MIME-Version: 1.0
In-Reply-To: <b8bf37780911040625r3fe0d18dx4f74c7be54f5dc3@mail.gmail.com>
References: <b8bf37780911020926p77ca30d1maa4384f21323adb@mail.gmail.com> 
	<20091102192706.GA30939@elte.hu> <b8bf37780911040625r3fe0d18dx4f74c7be54f5dc3@mail.gmail.com>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 12:49:14 -0200
Message-ID: <b8bf37780911040649sb378ccal3d315ff631d21d1d@mail.gmail.com>
Subject: [PATCH v3 7/7] vsprintf: factor out skip_space code in a separate 
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

From: André Goddard Rosa <andre.goddard@gmail.com>
Date: Tue, 3 Nov 2009 11:02:09 -0200
Subject: [PATCH v3 7/7] vsprintf: factor out skip_space code in a
separate function
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It decreases code size:
   text    data     bss     dec     hex filename
  15719       0       8   15727    3d6f lib/vsprintf.o-before
  15543       0       8   15551    3cbf lib/vsprintf.o-after

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index f703fdf..566c947 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1736,6 +1736,13 @@ EXPORT_SYMBOL_GPL(bprintf);

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
@@ -1757,10 +1764,8 @@ int vsscanf(const char *buf, const char *fmt,
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
@@ -1830,8 +1835,7 @@ int vsscanf(const char *buf, const char *fmt,
va_list args)
 			if (field_width == -1)
 				field_width = INT_MAX;
 			/* first, skip leading white space in buffer */
-			while (isspace(*str))
-				str++;
+			str = skip_space(str);

 			/* now copy until next white space */
 			while (*str && !isspace(*str) && field_width--)
@@ -1873,8 +1877,7 @@ int vsscanf(const char *buf, const char *fmt,
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
1.6.5.2.143.g8cc62.dirty

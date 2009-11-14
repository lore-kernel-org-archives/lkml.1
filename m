Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZKOHOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZKOHOH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 02:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZKOHOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 02:14:05 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:53038 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZKOHOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 02:14:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=spI2S1SEwX0UPtVagEsVB2UQeRx7PHiPXJz6U4cf4Bq3ZVPBuGAiMgqkCHGFIyPsdF
         d8jfMl+ewf9O9kdq3wDd6CDcuZJ6aEfp3fc47GRviMeEA5AmxOFNSpTdYYvTGkah+vs5
         PcqCPMEQ1bBYcF9GSDA7R498r2T8Zh5sDTNSA=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v5 04/12] vsprintf: use TOLOWER whenever possible
Date: Sat, 14 Nov 2009 05:11:52 -0200
Message-Id: <b99ea41ea1e6c817ec9663577b4a9aa519b7e5ee.1258181837.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e.dirty
In-Reply-To: <cover.1258181836.git.andre.goddard@gmail.com>
References: <cover.1258181836.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It decreases code size as well:
 text    data     bss     dec     hex filename
15758       0       8   15766    3d96 vsprintf.o (ex lib/lib.a-BEFORE)
15726       0       8   15734    3d76 vsprintf.o (ex lib/lib.a-TOLOWER)

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 84fa8f4..d107583 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -981,8 +981,8 @@ precision:
 qualifier:
 	/* get the conversion qualifier */
 	spec->qualifier = -1;
-	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
-	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
+	if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
+	    TOLOWER(*fmt) == 'z' || *fmt == 't') {
 		spec->qualifier = *fmt++;
 		if (unlikely(spec->qualifier == *fmt)) {
 			if (spec->qualifier == 'l') {
@@ -1049,7 +1049,7 @@ qualifier:
 			spec->type = FORMAT_TYPE_LONG;
 		else
 			spec->type = FORMAT_TYPE_ULONG;
-	} else if (spec->qualifier == 'Z' || spec->qualifier == 'z') {
+	} else if (TOLOWER(spec->qualifier) == 'z') {
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
@@ -1196,8 +1196,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			if (qualifier == 'l') {
 				long *ip = va_arg(args, long *);
 				*ip = (str - buf);
-			} else if (qualifier == 'Z' ||
-					qualifier == 'z') {
+			} else if (TOLOWER(qualifier) == 'z') {
 				size_t *ip = va_arg(args, size_t *);
 				*ip = (str - buf);
 			} else {
@@ -1487,7 +1486,7 @@ do {									\
 			void *skip_arg;
 			if (qualifier == 'l')
 				skip_arg = va_arg(args, long *);
-			else if (qualifier == 'Z' || qualifier == 'z')
+			else if (TOLOWER(qualifier) == 'z')
 				skip_arg = va_arg(args, size_t *);
 			else
 				skip_arg = va_arg(args, int *);
@@ -1798,8 +1797,8 @@ int vsscanf(const char *buf, const char *fmt, va_list args)
 
 		/* get conversion qualifier */
 		qualifier = -1;
-		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
-		    *fmt == 'Z' || *fmt == 'z') {
+		if (*fmt == 'h' || TOLOWER(*fmt) == 'l' ||
+		    TOLOWER(*fmt) == 'z') {
 			qualifier = *fmt++;
 			if (unlikely(qualifier == *fmt)) {
 				if (qualifier == 'h') {
-- 
1.6.5.2.180.gc5b3e.dirty


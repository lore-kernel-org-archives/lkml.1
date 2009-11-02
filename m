Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbZKBR0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbZKBR0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbZKBR0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:26:47 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:43316 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbZKBR0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:26:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=V4b/XVeD8+a0xM1o6FTvLQ718MAD6QpW92ZbO4r1WzZb47xNPFnstcE4hOERfRvEhA
         G9A1lqjvt1lp6Or6Wi0cv10L4GJFafZjiA9dyiwfY3IFI4CyP02C+pYvI1VVqSs6nLxM
         fMvtU+tH7eON3y2KMe4fng3E9gEy+0SMiJULY=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Mon, 2 Nov 2009 15:26:30 -0200
Message-ID: <b8bf37780911020926n702a92c6kcf73de773722185a@mail.gmail.com>
Subject: [PATCH v2 4/7] vsprintf: use TOLOWER whenever possible
To: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       mingo@elte.hu, davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a9098d7fdff2c3f382f3933591f67e36ca049472 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Sun, 1 Nov 2009 13:42:32 -0200
Subject: [PATCH v2 4/7] vsprintf: use TOLOWER whenever possible
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It decreases code size as well:
   text    data     bss     dec     hex filename
  15767       0       8   15775    3d9f lib/vsprintf.o-before
  15735       0       8   15743    3d7f lib/vsprintf.o-TOLOWER

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/vsprintf.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 00153c5..14e4197 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -983,8 +983,8 @@ precision:
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
@@ -1051,7 +1051,7 @@ qualifier:
 			spec->type = FORMAT_TYPE_LONG;
 		else
 			spec->type = FORMAT_TYPE_ULONG;
-	} else if (spec->qualifier == 'Z' || spec->qualifier == 'z') {
+	} else if (TOLOWER(spec->qualifier) == 'z') {
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
@@ -1198,8 +1198,7 @@ int vsnprintf(char *buf, size_t size, const char
*fmt, va_list args)
 			if (qualifier == 'l') {
 				long *ip = va_arg(args, long *);
 				*ip = (str - buf);
-			} else if (qualifier == 'Z' ||
-					qualifier == 'z') {
+			} else if (TOLOWER(qualifier) == 'z') {
 				size_t *ip = va_arg(args, size_t *);
 				*ip = (str - buf);
 			} else {
@@ -1490,7 +1489,7 @@ do {									\
 			void *skip_arg;
 			if (qualifier == 'l')
 				skip_arg = va_arg(args, long *);
-			else if (qualifier == 'Z' || qualifier == 'z')
+			else if (TOLOWER(qualifier) == 'z')
 				skip_arg = va_arg(args, size_t *);
 			else
 				skip_arg = va_arg(args, int *);
@@ -1801,8 +1800,8 @@ int vsscanf(const char *buf, const char *fmt,
va_list args)

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
1.6.5.2.140.g5f809

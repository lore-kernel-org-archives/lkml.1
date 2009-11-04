Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZKDOs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZKDOs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbZKDOsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:48:54 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46847 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbZKDOsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:48:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lis0StNTBnLsL4MlRxfe/ZKlGO4R18g9KXaRDzuAp0poBRrjOOOums4xoxvfcyCGrL
         GZliRT4bZ/1ZoQXOXNs6EMkl5uCYUT2bQbvNql2oK80JhqCNxQ/ru1Ezx4essHAW+RB6
         55GkYU9/pkloUy23/pe3EPKZkKb5NYf7La9U0=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 12:48:37 -0200
Message-ID: <b8bf37780911040648w65dfbcc0vb9fecc0e80fa8d2e@mail.gmail.com>
Subject: [PATCH v3 4/7] vsprintf: use TOLOWER whenever possible
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
Date: Tue, 3 Nov 2009 10:48:25 -0200
Subject: [PATCH v3 4/7] vsprintf: use TOLOWER whenever possible
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It decreases code size as well:
   text    data     bss     dec     hex filename
  15767       0       8   15775    3d9f lib/vsprintf.o-before
  15735       0       8   15743    3d7f lib/vsprintf.o-TOLOWER

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.6.5.2.143.g8cc62.dirty

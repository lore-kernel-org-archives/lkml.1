Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZKDOs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZKDOs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbZKDOs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:48:26 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:46847 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbZKDOsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:48:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=C3QvUsuu9wqgKXqxqvy+w7/ti8RhJt6uICK+7mURqxO7+5VjlEuRLYRiYUs49O9Hke
         /WHcbzTiIipXLztIbpy3li356DoTj5Wa8g3OnjO3OYiMJtvHIQ0xc9lGyo89tVox7Gth
         hYBtri70O7IBcvXEqrsHTWtw/SJ/XR+GIlYTQ=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 12:48:11 -0200
Message-ID: <b8bf37780911040648h7e4bae3dg21ce15c6b0e680d3@mail.gmail.com>
Subject: [PATCH v3 1/7] vsprintf: factorize "(null)" string
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
Date: Tue, 3 Nov 2009 11:07:21 -0200
Subject: [PATCH v3 1/7] vsprintf: factorize "(null)" string
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Change "<NULL>" to "(null)" and make it a static const char[] hoping that
the compiler will make null_str a label to a read-only area containing it.

See:
http://people.redhat.com/drepper/dsohowto.pdf part 2.4.2
http://udrepper.livejournal.com/13851.html
http://udrepper.livejournal.com/15119.html

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 lib/vsprintf.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 33bed5e..002f462 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -34,6 +34,8 @@
 /* Works only for digits and letters, but small and fast */
 #define TOLOWER(x) ((x) | 0x20)

+static const char null_str[] = "(null)";
+
 static unsigned int simple_guess_base(const char *cp)
 {
 	if (cp[0] == '0') {
@@ -546,12 +548,12 @@ static char *number(char *buf, char *end,
unsigned long long num,
 	return buf;
 }

-static char *string(char *buf, char *end, char *s, struct printf_spec spec)
+static char *string(char *buf, char *end, const char *s, struct
printf_spec spec)
 {
 	int len, i;

 	if ((unsigned long)s < PAGE_SIZE)
-		s = "<NULL>";
+		s = null_str;

 	len = strnlen(s, spec.precision);

@@ -822,7 +824,7 @@ static char *pointer(const char *fmt, char *buf,
char *end, void *ptr,
 			struct printf_spec spec)
 {
 	if (!ptr)
-		return string(buf, end, "(null)", spec);
+		return string(buf, end, null_str, spec);

 	switch (*fmt) {
 	case 'F':
@@ -1445,7 +1447,7 @@ do {									\
 			size_t len;
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
 					|| (unsigned long)save_str < PAGE_SIZE)
-				save_str = "<NULL>";
+				save_str = null_str;
 			len = strlen(save_str);
 			if (str + len + 1 < end)
 				memcpy(str, save_str, len + 1);
-- 
1.6.5.2.143.g8cc62.dirty

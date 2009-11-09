Return-Path: <linux-kernel-owner+w=401wt.eu-S1751452AbZKIKWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbZKIKWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 05:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbZKIKWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 05:22:16 -0500
Received: from gw1.transmode.se ([213.115.205.20]:55462 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZKIKWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 05:22:16 -0500
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH] zlib: Optimize inffast even more
Date: Mon, 9 Nov 2009 11:22:16 +0100
Message-Id: <1257762136-17593-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-09 11:22:19,
	Serialize by Router on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-09 11:22:19,
	Serialize complete at 2009-11-09 11:22:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This improves zlib: Optimize inffast when copying direct from output
and gives another 3-4% improvement for my MPC8321 target.
Does not need CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,
uses get_unaligned() but only in one place.
The copy loop just above this one can also use this
optimization, but I havn't done so as I have not tested if it
is a win there too.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---

 Someone with a little endian target should test too.

 arch/powerpc/boot/Makefile |    1 +
 lib/zlib_inflate/inffast.c |   54 ++++++++++++++++++++++----------------------
 2 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 9ae7b7e..33335be 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -34,6 +34,7 @@ BOOTCFLAGS	+= -fno-stack-protector
 endif
 
 BOOTCFLAGS	+= -I$(obj) -I$(srctree)/$(obj)
+BOOTCFLAGS	+= -Iarch/powerpc/include
 
 DTS_FLAGS	?= -p 1024
 
diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
index 0588fbf..4f78567 100644
--- a/lib/zlib_inflate/inffast.c
+++ b/lib/zlib_inflate/inffast.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/zutil.h>
+#include <asm/unaligned.h>
 #include "inftrees.h"
 #include "inflate.h"
 #include "inffast.h"
@@ -24,9 +25,11 @@
 #ifdef POSTINC
 #  define OFF 0
 #  define PUP(a) *(a)++
+#  define UP_UNALIGNED(a) get_unaligned((a)++)
 #else
 #  define OFF 1
 #  define PUP(a) *++(a)
+#  define UP_UNALIGNED(a) get_unaligned(++(a))
 #endif
 
 /*
@@ -240,52 +243,49 @@ void inflate_fast(z_streamp strm, unsigned start)
                 }
                 else {
                     from = out - dist;          /* copy direct from output */
-#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
                     /* minimum length is three */
 		    if (dist > 2 ) {
-			unsigned short *sout = (unsigned short *)(out - OFF);
-			unsigned short *sfrom = (unsigned short *)(from - OFF);
-			unsigned long loops = len >> 1;
+			unsigned short *sout;
+			unsigned short *sfrom;
+			unsigned long loops;
 
+			/* Align out addr, only sfrom might be unaligned */
+			if (!((long)(out - 1 + OFF)) & 1) {
+			    PUP(out) = PUP(from);
+			    len--;
+			}
+			sout = (unsigned short *)(out - OFF);
+			sfrom = (unsigned short *)(from - OFF);
+			loops = len >> 1;
 			do
-			    PUP(sout) = PUP(sfrom);
+			    PUP(sout) = UP_UNALIGNED(sfrom);
 			while (--loops);
 			out = (unsigned char *)sout + OFF;
 			from = (unsigned char *)sfrom + OFF;
 			if (len & 1)
 			    PUP(out) = PUP(from);
-		    } else if (dist == 2) {
-			unsigned short *sout = (unsigned short *)(out - OFF);
+		    } else { /* dist == 1 or dist == 2 */
+			unsigned short *sout;
 			unsigned short pat16;
-			unsigned long loops = len >> 1;
+			unsigned long loops;
 
+			/* Align out addr */
+			if (!((long)(out - 1 + OFF)) & 1) {
+			    PUP(out) = PUP(from);
+			    len--;
+			}
+			sout = (unsigned short *)(out - OFF);
 			pat16 = *(sout-2+2*OFF);
+			if (dist == 1)
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);
+			loops = len >> 1;
 			do
 			    PUP(sout) = pat16;
 			while (--loops);
 			out = (unsigned char *)sout + OFF;
 			if (len & 1)
 			    PUP(out) = PUP(from);
-		    } else {
-			unsigned char pat8 = *(out - 1 + OFF);
-
-			do {
-			    PUP(out) = pat8;
-			} while (--len);
 		    }
-#else
-                    do {                        /* minimum length is three */
-                        PUP(out) = PUP(from);
-                        PUP(out) = PUP(from);
-                        PUP(out) = PUP(from);
-                        len -= 3;
-                    } while (len > 2);
-                    if (len) {
-                        PUP(out) = PUP(from);
-                        if (len > 1)
-                            PUP(out) = PUP(from);
-                    }
-#endif
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */
-- 
1.6.4.4


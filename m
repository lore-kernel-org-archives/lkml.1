Return-Path: <linux-kernel-owner+w=401wt.eu-S1751703AbZKLJMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbZKLJMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 04:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZKLJMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 04:12:41 -0500
Received: from gw1.transmode.se ([213.115.205.20]:51488 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbZKLJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 04:12:40 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 04:12:40 EST
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: roel kluin <roel.kluin@gmail.com>, akpm@linux-foundation.org,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH] zlib: Optimize inffast when copying direct from output
Date: Thu, 12 Nov 2009 10:04:12 +0100
Message-Id: <1258016652-10082-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-12 10:04:15,
	Serialize by Router on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-12 10:04:15,
	Serialize complete at 2009-11-12 10:04:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JFFS2 uses lesser compression ratio and inflate always
ends up in "copy direct from output" case.
This patch tries to optimize the direct copy procedure.
Uses get_unaligned() but only in one place.
The copy loop just above this one can also use this
optimization, but I havn't done so as I have not tested if it
is a win there too.
On my MPC8321 this is about 17% faster on my JFFS2 root FS
than the original.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---

 This version replaces all previous versions.
 Changes:
 - Fix aligment check (Roel Kluin)
 - Fix problem for LE targets.

 arch/powerpc/boot/Makefile |    4 ++-
 lib/zlib_inflate/inffast.c |   55 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 9ae7b7e..98e4c4f 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -20,7 +20,7 @@
 all: $(obj)/zImage
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-		 -fno-strict-aliasing -Os -msoft-float -pipe \
+		 -fno-strict-aliasing -Os -msoft-float -pipe -D__KERNEL__\
 		 -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 -isystem $(shell $(CROSS32CC) -print-file-name=include)
 BOOTAFLAGS	:= -D__ASSEMBLY__ $(BOOTCFLAGS) -traditional -nostdinc
@@ -34,6 +34,8 @@ BOOTCFLAGS	+= -fno-stack-protector
 endif
 
 BOOTCFLAGS	+= -I$(obj) -I$(srctree)/$(obj)
+BOOTCFLAGS	+= -include include/linux/autoconf.h -Iarch/powerpc/include
+BOOTCFLAGS	+= -Iinclude
 
 DTS_FLAGS	?= -p 1024
 
diff --git a/lib/zlib_inflate/inffast.c b/lib/zlib_inflate/inffast.c
index 8550b0c..c6740ae 100644
--- a/lib/zlib_inflate/inffast.c
+++ b/lib/zlib_inflate/inffast.c
@@ -4,6 +4,8 @@
  */
 
 #include <linux/zutil.h>
+#include <asm/unaligned.h>
+#include <asm/byteorder.h>
 #include "inftrees.h"
 #include "inflate.h"
 #include "inffast.h"
@@ -24,9 +26,11 @@
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
@@ -239,18 +243,47 @@ void inflate_fast(z_streamp strm, unsigned start)
                     }
                 }
                 else {
+		    unsigned short *sout;
+		    unsigned long loops;
+
                     from = out - dist;          /* copy direct from output */
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
+                    /* minimum length is three */
+		    /* Align out addr */
+		    if (!((long)(out - 1 + OFF) & 1)) {
+			PUP(out) = PUP(from);
+			len--;
+		    }
+		    sout = (unsigned short *)(out - OFF);
+		    if (dist > 2 ) {
+			unsigned short *sfrom;
+
+			sfrom = (unsigned short *)(from - OFF);
+			loops = len >> 1;
+			do
+			    PUP(sout) = UP_UNALIGNED(sfrom);
+			while (--loops);
+			out = (unsigned char *)sout + OFF;
+			from = (unsigned char *)sfrom + OFF;
+		    } else { /* dist == 1 or dist == 2 */
+			unsigned short pat16;
+
+			pat16 = *(sout-2+2*OFF);
+			if (dist == 1)
+#if defined(__BIG_ENDIAN)
+			    pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);
+#elif defined(__LITTLE_ENDIAN)
+			    pat16 = (pat16 & 0xff00) | ((pat16 & 0xff00 ) >> 8);
+#else
+#error __BIG_ENDIAN nor __LITTLE_ENDIAN is defined
+#endif
+			loops = len >> 1;
+			do
+			    PUP(sout) = pat16;
+			while (--loops);
+			out = (unsigned char *)sout + OFF;
+		    }
+		    if (len & 1)
+			PUP(out) = PUP(from);
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */
-- 
1.6.4.4


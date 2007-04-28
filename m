Return-Path: <linux-kernel-owner+w=401wt.eu-S1030933AbXD1CUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030933AbXD1CUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030932AbXD1CUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:20:09 -0400
Received: from gw.goop.org ([64.81.55.164]:49689 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030933AbXD1CUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:20:07 -0400
Message-ID: <4632AF57.1070102@goop.org>
Date: Fri, 27 Apr 2007 19:20:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>
Subject: [PATCH] deflate inflate_dynamic too
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

inflate_dynamic() has piggy stack usage too, so heap allocate it too.
I'm not sure it actually gets used, but it shows up large in "make
checkstack".

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 lib/inflate.c |   63 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 21 deletions(-)

===================================================================
--- a/lib/inflate.c
+++ b/lib/inflate.c
@@ -798,15 +798,18 @@ STATIC int noinline INIT inflate_dynamic
   unsigned nb;          /* number of bit length codes */
   unsigned nl;          /* number of literal/length codes */
   unsigned nd;          /* number of distance codes */
-#ifdef PKZIP_BUG_WORKAROUND
-  unsigned ll[288+32];  /* literal/length and distance code lengths */
-#else
-  unsigned ll[286+30];  /* literal/length and distance code lengths */
-#endif
+  unsigned *ll;         /* literal/length and distance code lengths */
   register ulg b;       /* bit buffer */
   register unsigned k;  /* number of bits in bit buffer */
+  int ret;
 
 DEBG("<dyn");
+
+#ifdef PKZIP_BUG_WORKAROUND
+  ll = malloc(sizeof(*ll) * (288+32));  /* literal/length and distance code lengths */
+#else
+  ll = malloc(sizeof(*ll) * (286+30));  /* literal/length and distance code lengths */
+#endif
 
   /* make local bit buffer */
   b = bb;
@@ -828,7 +831,10 @@ DEBG("<dyn");
 #else
   if (nl > 286 || nd > 30)
 #endif
-    return 1;                   /* bad lengths */
+  {
+    ret = 1;             /* bad lengths */
+    goto out;
+  }
 
 DEBG("dyn1 ");
 
@@ -850,7 +856,8 @@ DEBG("dyn2 ");
   {
     if (i == 1)
       huft_free(tl);
-    return i;                   /* incomplete code set */
+    ret = i;                   /* incomplete code set */
+    goto out;
   }
 
 DEBG("dyn3 ");
@@ -872,8 +879,10 @@ DEBG("dyn3 ");
       NEEDBITS(2)
       j = 3 + ((unsigned)b & 3);
       DUMPBITS(2)
-      if ((unsigned)i + j > n)
-        return 1;
+      if ((unsigned)i + j > n) {
+        ret = 1;
+	goto out;
+      }
       while (j--)
         ll[i++] = l;
     }
@@ -882,8 +891,10 @@ DEBG("dyn3 ");
       NEEDBITS(3)
       j = 3 + ((unsigned)b & 7);
       DUMPBITS(3)
-      if ((unsigned)i + j > n)
-        return 1;
+      if ((unsigned)i + j > n) {
+        ret = 1;
+	goto out;
+      }
       while (j--)
         ll[i++] = 0;
       l = 0;
@@ -893,8 +904,10 @@ DEBG("dyn3 ");
       NEEDBITS(7)
       j = 11 + ((unsigned)b & 0x7f);
       DUMPBITS(7)
-      if ((unsigned)i + j > n)
-        return 1;
+      if ((unsigned)i + j > n) {
+        ret = 1;
+	goto out;
+      }
       while (j--)
         ll[i++] = 0;
       l = 0;
@@ -923,7 +936,8 @@ DEBG("dyn5b ");
       error("incomplete literal tree");
       huft_free(tl);
     }
-    return i;                   /* incomplete code set */
+    ret = i;                   /* incomplete code set */
+    goto out;
   }
 DEBG("dyn5c ");
   bd = dbits;
@@ -939,15 +953,18 @@ DEBG("dyn5d ");
       huft_free(td);
     }
     huft_free(tl);
-    return i;                   /* incomplete code set */
+    ret = i;                   /* incomplete code set */
+    goto out;
 #endif
   }
 
 DEBG("dyn6 ");
 
   /* decompress until an end-of-block code */
-  if (inflate_codes(tl, td, bl, bd))
-    return 1;
+  if (inflate_codes(tl, td, bl, bd)) {
+    ret = 1;
+    goto out;
+  }
 
 DEBG("dyn7 ");
 
@@ -956,10 +973,14 @@ DEBG("dyn7 ");
   huft_free(td);
 
   DEBG(">");
-  return 0;
-
- underrun:
-  return 4;			/* Input underrun */
+  ret = 0;
+out:
+  free(ll);
+  return ret;
+
+underrun:
+  ret = 4;			/* Input underrun */
+  goto out;
 }
 
 


Return-Path: <linux-kernel-owner+w=401wt.eu-S1765671AbYEGS1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765671AbYEGS1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbYEGS1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:27:32 -0400
Received: from n2b.bullet.mail.in2.yahoo.com ([203.104.19.41]:37443 "HELO
	n2b.bullet.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755271AbYEGS13 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:27:29 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 14:27:28 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 126012.81224.bm@omp105.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=laHVVY3Ymizjj548t7JJuhhAzHe//F/Q++pkAAsyqTESePkj8tgTU2qM/tS4Aozip2HrShHzw9t1eh1I3KGfeYzewZAlWd7iRydKC+zRSzStRcx+sQ1Op2NUVmbPCLHW21QHfs12HQOCVHZSeWx9BEkVz3N1zFvXGueiZjISCn8=;
X-YMail-OSG: .OLyZDUVM1mlo2AtgJRqZApQJAEt4VPFV2FXVrKU2iRtOZLnKVEeLIgZmG0xkKHd9xT4_F.PfNU79JQuzg3fufS7w9vjZCy7GA--
X-Mailer: YahooMailRC/975.38 YahooMailWebService/0.7.185
Date: Wed, 7 May 2008 23:51:09 +0530 (IST)
From: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
Subject: [PATCH]: improved strnicmp in lib/string.c
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <116786.40929.qm@web94104.mail.in2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is somewhat improved version of strnicmp() function in lib/string.c. I have implemented binary
comparison  rather than linear one(which was in the older version). I am appending the patch bellow

--- 2.6.25-vanilla/lib/string.c    2008-04-17 08:19:44.000000000 +0530
+++ 2.6.25-hacked/lib/string.c    2008-05-07 23:31:57.000000000 +0530
@@ -1,24 +1,3 @@
-/*
- *  linux/lib/string.c
- *
- *  Copyright (C) 1991, 1992  Linus Torvalds
- */
-
-/*
- * stupid library routines.. The optimized versions should generally be found
- * as inline code in <asm-xx/string.h>
- *
- * These are buggy as well..
- *
- * * Fri Jun 25 1999, Ingo Oeser <ioe@informatik.tu-chemnitz.de>
- * -  Added strsep() which will replace strtok() soon (because strsep() is
- *    reentrant and should be faster). Use only strsep() in new code, please.
- *
- * * Sat Feb 09 2002, Jason Thomas <jason@topic.com.au>,
- *                    Matthew Hawkins <matt@mh.dropbear.id.au>
- * -  Kissed strtok() goodbye
- */
-
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
@@ -31,32 +10,43 @@
  * @s2: The other string
  * @len: the maximum number of characters to compare
  */
+/* This is somewhat faster
+ * method compared to the
+ * olderone (in case of a large string)
+ */
 int strnicmp(const char *s1, const char *s2, size_t len)
 {
-    /* Yes, Virginia, it had better be unsigned */
-    unsigned char c1, c2;
-
-    c1 = c2 = 0;
-    if (len) {
-        do {
-            c1 = *s1;
-            c2 = *s2;
-            s1++;
-            s2++;
-            if (!c1)
-                break;
-            if (!c2)
-                break;
-            if (c1 == c2)
-                continue;
-            c1 = tolower(c1);
-            c2 = tolower(c2);
-            if (c1 != c2)
+    /* Yes, i am keeping 'em unsigned too */
+    unsigned char c1, c2, c3, c4;
+    unsigned count = 0;
+    int flag = -1;
+
+    c1 = c2 = c3 = c4 = 0;
+
+    if(len > 0)
+    {
+        for(; count <= len/2; count++)
+        {
+            c1 = tolower(s1[count]);    // well, we
+            c2 = tolower(s2[count]);    // are ignoring
+            c3 = tolower(s1[len-count-1]);    // cases
+            c4 = tolower(s2[len-count-1]);    // thats why
+            
+            if(c1 == c2)
+            {
+                if(c3 != c4)
+                {
+                    flag = 1;
+                    break;
+                }
+            }
+            else
                 break;
-        } while (--len);
+            flag = 0;
+        }
     }
-    return (int)c1 - (int)c2;
-}
+    return flag;     // return 0 for matching and 
+}            // nonzero for mismatch
 EXPORT_SYMBOL(strnicmp);
 #endif



      Meet people who discuss and share your passions. Go to http://in.promos.yahoo.com/groups/bestofyahoo/


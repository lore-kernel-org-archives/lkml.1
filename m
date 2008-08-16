Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYHPKzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYHPKzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYHPKzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:55:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbYHPKzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:55:07 -0400
Subject: [PATCH] Fix header export of videodev2.h, ivtv.h, ivtvfb.h
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org, hverkuil@xs4all.nl
Content-Type: text/plain
Date: Sat, 16 Aug 2008 11:55:04 +0100
Message-Id: <1218884104.3184.215.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exported copy of videodev2.h contains this line:

	#define #include <sys/time.h>

This is because for some reason it defines __user for itself -- despite
the fact that we remove all instances of __user when exporting headers.
_All_ pointers in userspace are user pointers. Fix it by removing the
unnecessary '#define __user' from the file.

The new headers ivtv.h and ivtvfb.h would have the same problem... if
whoever put them there had actually remembered to add them to the Kbuild
file while he was at it. Fix those too, and export them as was
presumably intended.

Note that includes of <linux/compiler.h> are also stripped by the header
export process, so those don't need to be conditional.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 327f606..7d97067 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -250,6 +250,8 @@ unifdef-y += isdn.h
 unifdef-y += isdnif.h
 unifdef-y += isdn_divertif.h
 unifdef-y += isdn_ppp.h
+unifdef-y += ivtv.h
+unifdef-y += ivtvfb.h
 unifdef-y += joystick.h
 unifdef-y += kdev_t.h
 unifdef-y += kd.h
diff --git a/include/linux/ivtv.h b/include/linux/ivtv.h
index 794b8da..17ca64b 100644
--- a/include/linux/ivtv.h
+++ b/include/linux/ivtv.h
@@ -21,11 +21,7 @@
 #ifndef __LINUX_IVTV_H__
 #define __LINUX_IVTV_H__
 
-#ifdef __KERNEL__
-#include <linux/compiler.h> /* need __user */
-#else
-#define __user
-#endif
+#include <linux/compiler.h>
 #include <linux/types.h>
 
 /* ivtv knows several distinct output modes: MPEG streaming,
diff --git a/include/linux/ivtvfb.h b/include/linux/ivtvfb.h
index e980ba6..e20af47 100644
--- a/include/linux/ivtvfb.h
+++ b/include/linux/ivtvfb.h
@@ -21,11 +21,7 @@
 #ifndef __LINUX_IVTVFB_H__
 #define __LINUX_IVTVFB_H__
 
-#ifdef __KERNEL__
-#include <linux/compiler.h> /* need __user */
-#else
-#define __user
-#endif
+#include <linux/compiler.h>
 #include <linux/types.h>
 
 /* Framebuffer external API */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index e466bd5..e65a6be 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -55,13 +55,13 @@
  */
 #ifndef __LINUX_VIDEODEV2_H
 #define __LINUX_VIDEODEV2_H
+
 #ifdef __KERNEL__
 #include <linux/time.h>     /* need struct timeval */
-#include <linux/compiler.h> /* need __user */
 #else
-#define __user
 #include <sys/time.h>
 #endif
+#include <linux/compiler.h>
 #include <linux/ioctl.h>
 #include <linux/types.h>
 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




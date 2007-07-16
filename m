Return-Path: <linux-kernel-owner+w=401wt.eu-S1765622AbXGPPM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765622AbXGPPM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbXGPPMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:12:12 -0400
Received: from cpe-70-113-91-236.austin.res.rr.com ([70.113.91.236]:55100 "EHLO
	ericvh.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbXGPPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:12:11 -0400
X-Greylist: delayed 1473 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 11:12:11 EDT
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Meelis Roos <mroos@linux.ee>, Eric Van Hensbergren <ericvh@gmail.com>
Subject: [PATCH] 9p: fix debug compilation error
Date: Mon, 16 Jul 2007 09:47:49 -0500
Message-Id: <11845972692586-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.2.gfbe3d-dirty
In-Reply-To: <Pine.SOC.4.64.0707161432480.1471@math.ut.ee>
References: <Pine.SOC.4.64.0707161432480.1471@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>

With 9P but no 9P debug options, this error occurs:
  CC [M]  fs/9p/v9fs.o
fs/9p/v9fs.c: In function 'v9fs_parse_options':
fs/9p/v9fs.c:134: error: 'p9_debug_level' undeclared (first use in this function)

The following patch moves the definition of p9_debug_level out of #ifdef
and seems to fix the problem.

(Original patch took care of the extern definition in the includes, but
not the actual definition in mod.c - ericvh)

Signed-off-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Eric Van Hensbergren <ericvh@gmail.com>
---
 include/net/9p/9p.h |    4 ++--
 net/9p/mod.c        |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 88884d3..8fc3796 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -27,6 +27,8 @@
 #ifndef NET_9P_H
 #define NET_9P_H
 
+extern unsigned int p9_debug_level;
+
 #ifdef CONFIG_NET_9P_DEBUG
 
 #define P9_DEBUG_ERROR		(1<<0)
@@ -38,8 +40,6 @@
 #define P9_DEBUG_SLABS	      	(1<<7)
 #define P9_DEBUG_FCALL		(1<<8)
 
-extern unsigned int p9_debug_level;
-
 #define P9_DPRINTK(level, format, arg...) \
 do {  \
 	if ((p9_debug_level & level) == level) \
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 4f9e1d2..951bb1d 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -28,12 +28,10 @@
 #include <linux/moduleparam.h>
 #include <net/9p/9p.h>
 
-#ifdef CONFIG_NET_9P_DEBUG
 unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */
 EXPORT_SYMBOL(p9_debug_level);
 module_param_named(debug, p9_debug_level, uint, 0);
 MODULE_PARM_DESC(debug, "9P debugging level");
-#endif
 
 extern int p9_mux_global_init(void);
 extern void p9_mux_global_exit(void);
-- 
1.5.0.2.gfbe3d-dirty


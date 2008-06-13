Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYFMTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYFMTJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 15:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYFMTJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 15:09:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbYFMTJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 15:09:10 -0400
Date: Fri, 13 Jun 2008 15:08:07 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 8/8] dynamic debug - convert sound
Message-ID: <20080613190800.GI8813@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-convert sound to dynamic debug

Signed-off-by: Jason Baron <jbaron@redhat.com>

---

 include/sound/core.h |   14 ++++++++++----
 sound/core/misc.c    |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)


diff --git a/include/sound/core.h b/include/sound/core.h
index 4fc0235..956b867 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -364,7 +364,11 @@ void snd_verbose_printd(const char *file, int line, const char *format, ...)
 	printk(fmt ,##args)
 #endif
 
-#ifdef CONFIG_SND_DEBUG
+#if defined(CONFIG_SND_DEBUG) && !defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#define DEBUG 1
+#endif
+
+#if defined(CONFIG_SND_DEBUG) || defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 
 #define __ASTRING__(x) #x
 
@@ -376,11 +380,13 @@ void snd_verbose_printd(const char *file, int line, const char *format, ...)
  * Compiled only when Works like snd_printk() for debugging purpose.
  * Ignored when CONFIG_SND_DEBUG is not set.
  */
-#define snd_printd(fmt, args...) \
-	snd_verbose_printd(__FILE__, __LINE__, fmt ,##args)
+#define snd_printd(fmt, args...) do { \
+	if (dynamic_dbg_enabled(TYPE_BOOLEAN, 0, 0)) \
+		snd_verbose_printd(__FILE__, __LINE__, fmt, ##args); \
+	} while (0)
 #else
 #define snd_printd(fmt, args...) \
-	printk(fmt ,##args)
+	pr_debug(fmt, ##args)
 #endif
 /**
  * snd_assert - run-time assertion macro
diff --git a/sound/core/misc.c b/sound/core/misc.c
index 102d1c3..9f53c0a 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -55,7 +55,7 @@ void snd_verbose_printk(const char *file, int line, const char *format, ...)
 EXPORT_SYMBOL(snd_verbose_printk);
 #endif
 
-#if defined(CONFIG_SND_DEBUG) && defined(CONFIG_SND_VERBOSE_PRINTK)
+#if (defined(CONFIG_SND_DEBUG) || defined(CONFIG_DYNAMIC_PRINTK_DEBUG)) && defined(CONFIG_SND_VERBOSE_PRINTK)
 void snd_verbose_printd(const char *file, int line, const char *format, ...)
 {
 	va_list args;

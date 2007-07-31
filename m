Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXGaQWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXGaQWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbXGaQVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:21:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58378 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbXGaQVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:21:51 -0400
Date: Tue, 31 Jul 2007 22:04:10 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] Introduce strtol_check_range()
Message-ID: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Callers (especially "store" functions for sysfs or configfs attributes)
that want to convert an input string to a number may often also want to
check for simple input sanity or allowable range. strtol10_check_range()
of netconsole does this, so extract it out into lib/vsprintf.c, make it
generic w.r.t. base, and export it to the rest of the kernel and modules.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

[ On top of previously posted netconsole patches, and
  the just-posted "Introduce U16_MAX and U32_MAX" patch. ]

[ checkpatch.pl doesn't particularly like this patch, but I wanted to be
  consistent with the rest of lib/vsprintf.c and include/linux/kernel.h. ]

 drivers/net/netconsole.c |   46 ++++++++++++----------------------------------
 include/linux/kernel.h   |    1 +
 lib/vsprintf.c           |   30 ++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 47a8094..0992a16 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -242,34 +242,6 @@ static struct netconsole_target *to_target(struct config_item *item)
 }
 
 /*
- * Wrapper over simple_strtol (base 10) with sanity and range checking.
- * We return (signed) long only because we may want to return errors.
- * Do not use this to convert numbers that are allowed to be negative.
- */
-static long strtol10_check_range(const char *cp, long min, long max)
-{
-	long ret;
-	char *p = (char *) cp;
-
-	WARN_ON(min < 0);
-	WARN_ON(max < min);
-
-	ret = simple_strtol(p, &p, 10);
-
-	if (*p && (*p != '\n')) {
-		printk(KERN_ERR "netconsole: invalid input\n");
-		return -EINVAL;
-	}
-	if ((ret < min) || (ret > max)) {
-		printk(KERN_ERR "netconsole: input %ld must be between "
-				"%ld and %ld\n", ret, min, max);
-		return -EINVAL;
-	}
-
-	return ret;
-}
-
-/*
  * Attribute operations for netconsole_target.
  */
 
@@ -335,9 +307,11 @@ static ssize_t store_enabled(struct netconsole_target *nt,
 	int err;
 	long enabled;
 
-	enabled = strtol10_check_range(buf, 0, 1);
-	if (enabled < 0)
+	enabled = strtol_check_range(buf, 0, 1, 10);
+	if (enabled < 0) {
+		printk(KERN_ERR "netconsole: invalid input\n");
 		return enabled;
+	}
 
 	if (enabled) {	/* 1 */
 
@@ -398,9 +372,11 @@ static ssize_t store_local_port(struct netconsole_target *nt,
 		return -EINVAL;
 	}
 
-	local_port = strtol10_check_range(buf, 0, U16_MAX);
-	if (local_port < 0)
+	local_port = strtol_check_range(buf, 0, U16_MAX, 10);
+	if (local_port < 0) {
+		printk(KERN_ERR "netconsole: invalid input\n");
 		return local_port;
+	}
 
 	nt->np.local_port = local_port;
 
@@ -420,9 +396,11 @@ static ssize_t store_remote_port(struct netconsole_target *nt,
 		return -EINVAL;
 	}
 
-	remote_port = strtol10_check_range(buf, 0, U16_MAX);
-	if (remote_port < 0)
+	remote_port = strtol_check_range(buf, 0, U16_MAX, 10);
+	if (remote_port < 0) {
+		printk(KERN_ERR "netconsole: invalid input\n");
 		return remote_port;
+	}
 
 	nt->np.remote_port = remote_port;
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e9221de..ced5c1b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -121,6 +121,7 @@ extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
+extern long strtol_check_range(const char *,long,long,unsigned int);
 extern int sprintf(char * buf, const char * fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int vsprintf(char *buf, const char *, va_list)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6b6734d..7ce8736 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -126,6 +126,36 @@ long long simple_strtoll(const char *cp,char **endp,unsigned int base)
 	return simple_strtoull(cp,endp,base);
 }
 
+/**
+ * strtol_check_range - wrapper over simple_strtol with input and range checking
+ * @cp: The start of the string
+ * @min: Minimum value allowed
+ * @max: Maximum value allowed
+ * @base: The number base to use
+ *
+ * We return (signed) long only because we may want to return errors.
+ * Do not use this to convert numbers that are allowed to be negative.
+ */
+long strtol_check_range(const char *cp, long min, long max, unsigned int base)
+{
+	long ret;
+	char *p = (char *) cp;
+
+	WARN_ON(min < 0);
+	WARN_ON(max < min);
+
+	ret = simple_strtol(p, &p, base);
+
+	if (*p && (*p != '\n'))
+		return -EINVAL;
+	if ((ret < min) || (ret > max))
+		return -EINVAL;
+
+	return ret;
+}
+
+EXPORT_SYMBOL(strtol_check_range);
+
 static int skip_atoi(const char **s)
 {
 	int i=0;

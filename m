Return-Path: <linux-kernel-owner+w=401wt.eu-S1762324AbXENJdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324AbXENJdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXENJcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:32:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45163 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074AbXENJcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:32:50 -0400
Date: Mon, 14 May 2007 15:10:15 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  4/14] Add config options for union mount
Message-ID: <20070514094015.GF4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070514093722.GB4139@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Add config options for union mount

Introduces two new config options for union mount:

CONFIG_UNION_MOUNT - Enables union mount
CONFIG_UNION_MOUNT_DEBUG - Enables debugging support for union mount.

Also adds debugging routines.

FIXME: this needs some work. printk'ing isn't the right method for getting
good debugging output.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/Kconfig                  |   16 +++++++++
 include/linux/union_debug.h |   76 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -551,6 +551,22 @@ config INOTIFY_USER
 
 	  If unsure, say Y.
 
+config UNION_MOUNT
+       bool "Union mount support (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       ---help---
+         If you say Y here, you will be able to mount file systems as
+         union mount stacks. This is a VFS based implementation and
+         should work with all file systems. If unsure, say N.
+
+config UNION_MOUNT_DEBUG
+       bool "Union mount debugging output"
+       depends on UNION_MOUNT
+       ---help---
+         If you say Y here, the union mount debugging code will be
+         compiled in. You have activate the appropriate UNION_MOUNT_DEBUG
+         flags in <file:include/linux/union.h>, too.
+
 config QUOTA
 	bool "Quota support"
 	help
--- /dev/null
+++ b/include/linux/union_debug.h
@@ -0,0 +1,76 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright © 2004-2007 IBM Corporation
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef __LINUX_UNION_DEBUG_H
+#define __LINUX_UNION_DEBUG_H
+
+#ifdef __KERNEL__
+
+#ifdef CONFIG_UNION_MOUNT_DEBUG
+
+#include <linux/sched.h>
+
+#ifndef UNION_MOUNT_DEBUG
+#define UNION_MOUNT_DEBUG 0
+#endif	/* UNION_MOUNT_DEBUG */
+#ifndef UNION_MOUNT_DEBUG_DCACHE
+#define UNION_MOUNT_DEBUG_DCACHE 0
+#endif	/* UNION_MOUNT_DEBUG_DCACHE */
+#ifndef UNION_MOUNT_DEBUG_LOCK
+#define UNION_MOUNT_DEBUG_LOCK 0
+#endif	/* UNION_MOUNT_DEBUG_LOCK */
+#ifndef UNION_MOUNT_DEBUG_READDIR
+#define UNION_MOUNT_DEBUG_READDIR 0
+#endif	/* UNION_MOUNT_DEBUG_READDIR */
+
+/*
+ * The really excessive debugging output is triggered by
+ * the user id (7777) which is accessing the union stack
+ */
+#define UM_DEBUG(fmt, args...)						\
+do {									\
+	if (UNION_MOUNT_DEBUG)						\
+		printk(KERN_DEBUG "%s: " fmt, __FUNCTION__, ## args);	\
+} while (0)
+#define UM_DEBUG_UID(fmt, args...)					\
+do {									\
+	if (UNION_MOUNT_DEBUG && (current->uid == 7777))		\
+		printk(KERN_DEBUG "%s: " fmt, __FUNCTION__, ## args);	\
+} while (0)
+#define UM_DEBUG_DCACHE(fmt, args...)					\
+do {									\
+	if (UNION_MOUNT_DEBUG_DCACHE && (current->uid == 7777))		\
+		printk(KERN_DEBUG "%s: " fmt, __FUNCTION__, ## args);	\
+} while (0)
+#define UM_DEBUG_LOCK(fmt, args...)					\
+do {									\
+	if (UNION_MOUNT_DEBUG_LOCK && (current->uid == 7777))		\
+		printk(KERN_DEBUG "%s: " fmt, __FUNCTION__, ## args);	\
+} while (0)
+#define UM_DEBUG_READDIR(fmt, args...)					\
+do {									\
+	if (UNION_MOUNT_DEBUG_READDIR && (current->uid == 7777))	\
+		printk(KERN_DEBUG "%s: " fmt, __FUNCTION__, ## args);	\
+} while (0)
+
+#else	/* CONFIG_UNION_MOUNT_DEBUG */
+
+#define UM_DEBUG(fmt, args...) do { /* empty */ } while (0)
+#define UM_DEBUG_UID(fmt, args...) do { /* empty */ } while (0)
+#define UM_DEBUG_DCACHE(fmt, args...) do { /* empty */ } while (0)
+#define UM_DEBUG_LOCK(fmt, args...) do { /* empty */ } while (0)
+#define UM_DEBUG_READDIR(fmt, args...) do { /* empty */ } while (0)
+
+#endif	/* CONFIG_UNION_MOUNT_DEBUG */
+
+#endif	/* __KERNEL__ */
+#endif	/*  __LINUX_UNION_DEBUG_H */

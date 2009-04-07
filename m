Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbZDGPLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbZDGPLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZDGPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48840 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbZDGPHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:48 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [5/28] x86: MCE: Use extended sysattrs for the check_interval attribute.
Message-Id: <20090407150746.0291E1D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Cleanup

Instead of using own callbacks use the generic ones provided by
the sysdev later.

This finally allows to get rid of the ugly ACCESSOR macros. Should
also save some text size.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   38 +++++++++++++++---------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:15.000000000 +0200
@@ -921,26 +921,6 @@
 
 DEFINE_PER_CPU(struct sys_device, device_mce);
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu) __cpuinitdata;
-
-/* Why are there no generic functions for this? */
-#define ACCESSOR(name, var, start) \
-	static ssize_t show_ ## name(struct sys_device *s,		\
-				     struct sysdev_attribute *attr,	\
-				     char *buf) {			\
-		return sprintf(buf, "%lx\n", (unsigned long)var);	\
-	}								\
-	static ssize_t set_ ## name(struct sys_device *s,		\
-				    struct sysdev_attribute *attr,	\
-				    const char *buf, size_t siz) {	\
-		char *end;						\
-		unsigned long new = simple_strtoul(buf, &end, 0);	\
-		if (end == buf) return -EINVAL;				\
-		var = new;						\
-		start;							\
-		return end-buf;						\
-	}								\
-	static SYSDEV_ATTR(name, 0644, show_ ## name, set_ ## name);
-
 static struct sysdev_attribute *bank_attrs;
 
 static ssize_t show_bank(struct sys_device *s, struct sysdev_attribute *attr,
@@ -983,11 +963,25 @@
 	return len;
 }
 
+static ssize_t store_int_with_restart(struct sys_device *s,
+			      struct sysdev_attribute *attr,
+			      const char *buf, size_t size)
+{
+	ssize_t ret = sysdev_store_int(s, attr, buf, size);
+	mce_restart();
+	return ret;
+}
+
 static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
-ACCESSOR(check_interval,check_interval,mce_restart())
+static struct sysdev_ext_attribute attr_check_interval = {
+	_SYSDEV_ATTR(check_interval, 0644, sysdev_show_int,
+		     store_int_with_restart),
+	&check_interval
+};
+
 static struct sysdev_attribute *mce_attributes[] = {
-	&attr_tolerant.attr, &attr_check_interval, &attr_trigger,
+	&attr_tolerant.attr, &attr_check_interval.attr, &attr_trigger,
 	NULL
 };
 

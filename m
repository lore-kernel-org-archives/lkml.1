Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYIBL11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYIBL11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYIBL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:26:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYIBL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:26:39 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080902126.215915333@firstfloor.org>
In-Reply-To: <20080902126.215915333@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/3] MCE: Convert the mce code to use generic sysdev attributes.
Message-Id: <20080902112636.42F463E69FF@basil.firstfloor.org>
Date: Tue,  2 Sep 2008 13:26:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This avoids some code duplication by using more generic sysdev
infrastructure. Also no custom macros anymore.

Should be applied on top of the new x86/unify-mce patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -405,7 +405,7 @@ void mce_log_therm_throt_event(unsigned 
  * errors, poll 2x slower (up to check_interval seconds).
  */
 
-static int check_interval = 5 * 60; /* 5 minutes */
+static long check_interval = 5 * 60; /* 5 minutes */
 static int next_interval; /* in jiffies */
 static void mcheck_timer(struct work_struct *work);
 static DECLARE_DELAYED_WORK(mcheck_work, mcheck_timer);
@@ -839,25 +839,6 @@ static struct sysdev_class mce_sysclass 
 DEFINE_PER_CPU(struct sys_device, device_mce);
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu) __cpuinitdata;
 
-/* Why are there no generic functions for this? */
-#define ACCESSOR(name, var, start) \
-	static ssize_t show_ ## name(struct sys_device *s,		\
-				     struct sysdev_attribute *attr,	\
-				     char *buf) {			\
-		return sprintf(buf, "%Lx\n", (u64)var); 		\
-	}								\
-	static ssize_t set_ ## name(struct sys_device *s,		\
-				    struct sysdev_attribute *attr,	\
-				    const char *buf, size_t siz) {	\
-		u64 new;						\
-		int err = strict_strtoull(buf, 0, &new);		\
-		if (err) return err;					\
-		var = new;						\
-		start;							\
-		return strlen(buf);					\
-	}								\
-	static SYSDEV_ATTR(name, 0644, show_ ## name, set_ ## name);
-
 static struct sysdev_attribute *bank_attrs;
 
 static ssize_t show_bank(struct sys_device *s, struct sysdev_attribute *attr,
@@ -900,11 +881,22 @@ static ssize_t set_trigger(struct sys_de
 	return len;
 }
 
+static ssize_t interval_store(struct sys_device *s, struct sysdev_attribute *attr,
+			      const char *buf, size_t size)
+{
+	ssize_t ret = sysdev_store_ulong(s, attr, buf, size);
+	if (!ret)
+		mce_restart();
+	return ret;
+}
+
 static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
-ACCESSOR(check_interval,check_interval,mce_restart())
+static SYSDEV_EXT_ATTR(check_interval, 0644, check_interval,
+			sysdev_show_ulong, interval_store);
+
 static struct sysdev_attribute *mce_attributes[] = {
-	&attr_tolerant.attr, &attr_check_interval, &attr_trigger,
+	&attr_tolerant.attr, &attr_check_interval.attr, &attr_trigger,
 	NULL
 };
 

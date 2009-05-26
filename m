Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZEZXz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZEZXz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZEZXyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38586 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZEZXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:42 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/31] x86: MCE: Use extended sysattrs for the check_interval attribute.
Date: Wed, 27 May 2009 01:54:06 +0200
Message-Id: <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: Cleanup

Instead of using own callbacks use the generic ones provided by
the sysdev later.

This finally allows to get rid of the ugly ACCESSOR macros. Should
also save some text size.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   39 ++++++++++++++-----------------------
 1 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e1271ac..8a8af56 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1055,28 +1055,6 @@ DEFINE_PER_CPU(struct sys_device, device_mce);
 __cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
-/* Why are there no generic functions for this? */
-#define ACCESSOR(name, var, start) \
-	static ssize_t show_ ## name(struct sys_device *s,		\
-				     struct sysdev_attribute *attr,	\
-				     char *buf) {			\
-		return sprintf(buf, "%Lx\n", (u64)var);			\
-	}								\
-	static ssize_t set_ ## name(struct sys_device *s,		\
-				    struct sysdev_attribute *attr,	\
-				    const char *buf, size_t siz) {	\
-		char *end;						\
-		u64 new = simple_strtoull(buf, &end, 0);		\
-									\
-		if (end == buf)						\
-			return -EINVAL;					\
-		var = new;						\
-		start;							\
-									\
-		return end-buf;						\
-	}								\
-	static SYSDEV_ATTR(name, 0644, show_ ## name, set_ ## name);
-
 static struct sysdev_attribute *bank_attrs;
 
 static ssize_t show_bank(struct sys_device *s, struct sysdev_attribute *attr,
@@ -1127,13 +1105,26 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 	return len;
 }
 
+static ssize_t store_int_with_restart(struct sys_device *s,
+				      struct sysdev_attribute *attr,
+				      const char *buf, size_t size)
+{
+	ssize_t ret = sysdev_store_int(s, attr, buf, size);
+	mce_restart();
+	return ret;
+}
+
 static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
 
-ACCESSOR(check_interval, check_interval, mce_restart())
+static struct sysdev_ext_attribute attr_check_interval = {
+	_SYSDEV_ATTR(check_interval, 0644, sysdev_show_int,
+		     store_int_with_restart),
+	&check_interval
+};
 
 static struct sysdev_attribute *mce_attr[] = {
-	&attr_tolerant.attr, &attr_check_interval, &attr_trigger,
+	&attr_tolerant.attr, &attr_check_interval.attr, &attr_trigger,
 	NULL
 };
 
-- 
1.6.0.2


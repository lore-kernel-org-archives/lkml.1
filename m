Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZFOIVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZFOIVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZFOIVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:21:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47673 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZFOIVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:21:42 -0400
Message-ID: <4A360490.2030506@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:21:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/16] x86, mce: sysfs entries for new options
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs interface for admins who want to tweak these options without
rebooting the system.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   84 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e145229..6b465a6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1619,6 +1619,26 @@ static void mce_restart(void)
 	on_each_cpu(mce_cpu_restart, NULL, 1);
 }
 
+/* Toggle features for corrected errors */
+static void mce_disable_ce(void *all)
+{
+	if (!mce_available(&current_cpu_data))
+		return;
+	if (all)
+		del_timer_sync(&__get_cpu_var(mce_timer));
+	cmci_clear();
+}
+
+static void mce_enable_ce(void *all)
+{
+	if (!mce_available(&current_cpu_data))
+		return;
+	cmci_reenable();
+	cmci_recheck();
+	if (all)
+		mce_init_timer();
+}
+
 static struct sysdev_class mce_sysclass = {
 	.suspend	= mce_suspend,
 	.shutdown	= mce_shutdown,
@@ -1680,6 +1700,52 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 	return len;
 }
 
+static ssize_t set_ignore_ce(struct sys_device *s,
+			     struct sysdev_attribute *attr,
+			     const char *buf, size_t size)
+{
+	u64 new;
+
+	if (strict_strtoull(buf, 0, &new) < 0)
+		return -EINVAL;
+
+	if (mce_ignore_ce ^ !!new) {
+		if (new) {
+			/* disable ce features */
+			on_each_cpu(mce_disable_ce, (void *)1, 1);
+			mce_ignore_ce = 1;
+		} else {
+			/* enable ce features */
+			mce_ignore_ce = 0;
+			on_each_cpu(mce_enable_ce, (void *)1, 1);
+		}
+	}
+	return size;
+}
+
+static ssize_t set_cmci_disabled(struct sys_device *s,
+				 struct sysdev_attribute *attr,
+				 const char *buf, size_t size)
+{
+	u64 new;
+
+	if (strict_strtoull(buf, 0, &new) < 0)
+		return -EINVAL;
+
+	if (mce_cmci_disabled ^ !!new) {
+		if (new) {
+			/* disable cmci */
+			on_each_cpu(mce_disable_ce, NULL, 1);
+			mce_cmci_disabled = 1;
+		} else {
+			/* enable cmci */
+			mce_cmci_disabled = 0;
+			on_each_cpu(mce_enable_ce, NULL, 1);
+		}
+	}
+	return size;
+}
+
 static ssize_t store_int_with_restart(struct sys_device *s,
 				      struct sysdev_attribute *attr,
 				      const char *buf, size_t size)
@@ -1692,6 +1758,7 @@ static ssize_t store_int_with_restart(struct sys_device *s,
 static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
 static SYSDEV_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
+static SYSDEV_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
 
 static struct sysdev_ext_attribute attr_check_interval = {
 	_SYSDEV_ATTR(check_interval, 0644, sysdev_show_int,
@@ -1699,9 +1766,24 @@ static struct sysdev_ext_attribute attr_check_interval = {
 	&check_interval
 };
 
+static struct sysdev_ext_attribute attr_ignore_ce = {
+	_SYSDEV_ATTR(ignore_ce, 0644, sysdev_show_int, set_ignore_ce),
+	&mce_ignore_ce
+};
+
+static struct sysdev_ext_attribute attr_cmci_disabled = {
+	_SYSDEV_ATTR(ignore_ce, 0644, sysdev_show_int, set_cmci_disabled),
+	&mce_cmci_disabled
+};
+
 static struct sysdev_attribute *mce_attrs[] = {
-	&attr_tolerant.attr, &attr_check_interval.attr, &attr_trigger,
+	&attr_tolerant.attr,
+	&attr_check_interval.attr,
+	&attr_trigger,
 	&attr_monarch_timeout.attr,
+	&attr_dont_log_ce.attr,
+	&attr_ignore_ce.attr,
+	&attr_cmci_disabled.attr,
 	NULL
 };
 
-- 
1.6.3



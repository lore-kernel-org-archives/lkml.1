Return-Path: <linux-kernel-owner+w=401wt.eu-S1762635AbXGYUrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635AbXGYUrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXGYUq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:46:56 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:31445 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754523AbXGYUqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:46:55 -0400
Date: Wed, 25 Jul 2007 14:54:21 -0600
From: dougthompson@xmission.com
To: greg@kroah.com, ralf@linux-mips.org, egor@pasemi.com,
       dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/4] drivers edac fix reset edac_mc pollmsec
Message-ID: <46a7b87d.9iKovb4wybPFkLX6%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Doug Thompson <dougthompson@xmission.com>

This fixes a deadlock that could occur on a 'setup' and 'teardown'
sequence of the workq for a edac_mc control structure instance. A similiar
fix was previously implemented for the edac_device code.

In addition, the edac_mc device code there was missing code to
allow the workq period valu to be altered via sysfs control.

This patch adds that fix on the code, and allows for the changing
of the period value as well.

Cc:		Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 edac_mc.c       |   64 ++++++++++++++++++++++++++++++++++++--------------------
 edac_mc_sysfs.c |   19 +++++++++++++++-
 edac_module.h   |    2 +
 3 files changed, 62 insertions(+), 23 deletions(-)

Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_mc_sysfs.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_mc_sysfs.c
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_mc_sysfs.c
@@ -122,6 +122,23 @@ static ssize_t memctrl_int_store(void *p
 	return count;
 }
 
+/*
+ * mc poll_msec time value
+ */
+static ssize_t poll_msec_int_store(void *ptr, const char *buffer, size_t count)
+{
+	int *value = (int *)ptr;
+
+	if (isdigit(*buffer)) {
+		*value = simple_strtoul(buffer, NULL, 0);
+
+		/* notify edac_mc engine to reset the poll period */
+		edac_mc_reset_delay_period(*value);
+	}
+
+	return count;
+}
+
 
 /* EDAC sysfs CSROW data structures and methods
  */
@@ -704,7 +721,7 @@ MEMCTRL_ATTR(edac_mc_log_ce,
 	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
 
 MEMCTRL_ATTR(edac_mc_poll_msec,
-	S_IRUGO | S_IWUSR, memctrl_int_show, memctrl_int_store);
+	S_IRUGO | S_IWUSR, memctrl_int_show, poll_msec_int_store);
 
 /* Base Attributes of the memory ECC object */
 static struct memctrl_dev_attribute *memctrl_attr[] = {
Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_module.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_module.h
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_module.h
@@ -52,6 +52,8 @@ extern void edac_device_workq_setup(stru
 extern void edac_device_workq_teardown(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
 					   *edac_dev, unsigned long value);
+extern void edac_mc_reset_delay_period(int value);
+
 extern void *edac_align_ptr(void *ptr, unsigned size);
 
 /*
Index: linux-2.6.22-rc6-mm1/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/edac/edac_mc.c
+++ linux-2.6.22-rc6-mm1/drivers/edac/edac_mc.c
@@ -214,6 +214,13 @@ void edac_mc_free(struct mem_ctl_info *m
 }
 EXPORT_SYMBOL_GPL(edac_mc_free);
 
+
+/*
+ * find_mci_by_dev
+ *
+ *	scan list of controllers looking for the one that manages
+ *	the 'dev' device
+ */
 static struct mem_ctl_info *find_mci_by_dev(struct device *dev)
 {
 	struct mem_ctl_info *mci;
@@ -268,12 +275,6 @@ static void edac_mc_workq_function(struc
 	if (edac_mc_assert_error_check_and_clear() && (mci->edac_check != NULL))
 		mci->edac_check(mci);
 
-	/*
-	 * FIXME: temp place holder for PCI checks,
-	 * goes away when we break out PCI
-	 */
-	edac_pci_do_parity_check();
-
 	mutex_unlock(&mem_ctls_mutex);
 
 	/* Reschedule */
@@ -314,36 +315,55 @@ static void edac_mc_workq_teardown(struc
 {
 	int status;
 
-	/* if not running POLL, leave now */
-	if (mci->op_state == OP_RUNNING_POLL) {
-		status = cancel_delayed_work(&mci->work);
-		if (status == 0) {
-			debugf0("%s() not canceled, flush the queue\n",
-				__func__);
+	status = cancel_delayed_work(&mci->work);
+	if (status == 0) {
+		debugf0("%s() not canceled, flush the queue\n",
+			__func__);
 
-			/* workq instance might be running, wait for it */
-			flush_workqueue(edac_workqueue);
-		}
+		/* workq instance might be running, wait for it */
+		flush_workqueue(edac_workqueue);
 	}
 }
 
 /*
- * edac_reset_delay_period
+ * edac_mc_reset_delay_period(unsigned long value)
+ *
+ *	user space has updated our poll period value, need to
+ *	reset our workq delays
  */
-static void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long value)
+void edac_mc_reset_delay_period(int value)
 {
-	/* cancel the current workq request */
-	edac_mc_workq_teardown(mci);
+	struct mem_ctl_info *mci;
+	struct list_head *item;
+
+	mutex_lock(&mem_ctls_mutex);
+
+	/* scan the list and turn off all workq timers, doing so under lock
+	 */
+	list_for_each(item, &mc_devices) {
+		mci = list_entry(item, struct mem_ctl_info, link);
+
+		if (mci->op_state == OP_RUNNING_POLL)
+			cancel_delayed_work(&mci->work);
+	}
+
+	mutex_unlock(&mem_ctls_mutex);
 
-	/* lock the list of devices for the new setup */
+
+	/* re-walk the list, and reset the poll delay */
 	mutex_lock(&mem_ctls_mutex);
 
-	/* restart the workq request, with new delay value */
-	edac_mc_workq_setup(mci, value);
+	list_for_each(item, &mc_devices) {
+		mci = list_entry(item, struct mem_ctl_info, link);
+
+		edac_mc_workq_setup(mci, (unsigned long) value);
+	}
 
 	mutex_unlock(&mem_ctls_mutex);
 }
 
+
+
 /* Return 0 on success, 1 on failure.
  * Before calling this function, caller must
  * assign a unique value to mci->mc_idx.

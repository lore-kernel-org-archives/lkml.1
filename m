Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbXFCOqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbXFCOqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbXFCOmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:42:45 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:46841 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756728AbXFCOmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:42:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=OU7X/FlztqZSKx0iJ2o/3VurK/5xF5hkM/+iUS9k+cIVulgP9zzKL4gObfzAhFydYVvrGuI9ZONzjYc6RobAODZAcdQszJK/Eg09OOi6ZwZZHWMxwAOLJIuzY127XxFPOfFgeNVe25pblGNRs8acRZMBaT1HMM847jSft43qj48=;
X-YMail-OSG: 5LKIcM8VM1l3GF4hqJ7bJMS1FqgNT9CpoHcY5SSpRBcsSQWGEhCslxEaCk0FZo02VdZwep17KNGMUnFEXgqdtIAHIdnPUg3mM3VNn7JoAtuSE7ALqHQJLHei
Date: Sun, 3 Jun 2007 07:42:42 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 22/36] drivers edac cleanup workq ifdefs
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <806178.3977.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

The origin of this code comes from patches at sourceforge, that 
allow EDAC to be updated to various kernels. With kernel version 2.6.20
a
new workq system was installed, thus the patches needed to be modified
based on the kernel version. For submitting to the latest kernel.org
those #ifdefs are removed

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---

 edac_core.h   |   13 +------------
 edac_device.c |   11 -----------
 edac_mc.c     |   10 ----------
 edac_pci.c    |   10 ----------
 4 files changed, 1 insertion(+), 43 deletions(-)

Index: linux-2.6.22-rc1/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/edac_core.h
+++ linux-2.6.22-rc1/drivers/edac/edac_core.h
@@ -395,11 +395,8 @@ struct mem_ctl_info {
 	struct completion kobj_complete;
 
 	/* work struct for this MC */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	struct delayed_work work;
-#else
-	struct work_struct work;
-#endif
+
 	/* the internal state of this controller instance */
 	int op_state;
 };
@@ -530,11 +527,7 @@ struct edac_device_ctl_info {
 	/* the internal state of this controller instance */
 	int op_state;
 	/* work struct for this instance */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	struct delayed_work work;
-#else
-	struct work_struct work;
-#endif
 
 	/* pointer to edac polling checking routine:
 	 *      If NOT NULL: points to polling check routine
@@ -647,11 +640,7 @@ struct edac_pci_ctl_info {
 	/* the internal state of this controller instance */
 	int op_state;
 	/* work struct for this instance */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	struct delayed_work work;
-#else
-	struct work_struct work;
-#endif
 
 	/* pointer to edac polling checking routine:
 	 *      If NOT NULL: points to polling check routine
Index: linux-2.6.22-rc1/drivers/edac/edac_device.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/edac_device.c
+++ linux-2.6.22-rc1/drivers/edac/edac_device.c
@@ -332,17 +332,10 @@ EXPORT_SYMBOL(edac_device_find);
  * edac_device_workq_function
  *	performs the operation scheduled by a workq request
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 static void edac_device_workq_function(struct work_struct *work_req)
 {
 	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct edac_device_ctl_info *edac_dev =
to_edac_device_ctl_work(d_work);
-#else
-static void edac_device_workq_function(void *ptr)
-{
-	struct edac_device_ctl_info *edac_dev =
-	    (struct edac_device_ctl_info *)ptr;
-#endif
 
 	//debugf0("%s() here and running\n", __func__);
 	lock_device_list();
@@ -372,11 +365,7 @@ void edac_device_workq_setup(struct edac
 	edac_dev->poll_msec = msec;
 	edac_calc_delay(edac_dev);	/* Calc delay jiffies */
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	INIT_DELAYED_WORK(&edac_dev->work, edac_device_workq_function);
-#else
-	INIT_WORK(&edac_dev->work, edac_device_workq_function, edac_dev);
-#endif
 	queue_delayed_work(edac_workqueue, &edac_dev->work, edac_dev->delay);
 }
 
Index: linux-2.6.22-rc1/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/edac_mc.c
+++ linux-2.6.22-rc1/drivers/edac/edac_mc.c
@@ -235,16 +235,10 @@ static int edac_mc_assert_error_check_an
  * edac_mc_workq_function
  *	performs the operation scheduled by a workq request
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 static void edac_mc_workq_function(struct work_struct *work_req)
 {
 	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct mem_ctl_info *mci = to_edac_mem_ctl_work(d_work);
-#else
-static void edac_mc_workq_function(void *ptr)
-{
-	struct mem_ctl_info *mci = (struct mem_ctl_info *)ptr;
-#endif
 
 	mutex_lock(&mem_ctls_mutex);
 
@@ -274,11 +268,7 @@ void edac_mc_workq_setup(struct mem_ctl_
 {
 	debugf0("%s()\n", __func__);
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	INIT_DELAYED_WORK(&mci->work, edac_mc_workq_function);
-#else
-	INIT_WORK(&mci->work, edac_mc_workq_function, mci);
-#endif
 	queue_delayed_work(edac_workqueue, &mci->work,
msecs_to_jiffies(msec));
 }
 
Index: linux-2.6.22-rc1/drivers/edac/edac_pci.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/edac_pci.c
+++ linux-2.6.22-rc1/drivers/edac/edac_pci.c
@@ -214,16 +214,10 @@ EXPORT_SYMBOL_GPL(edac_pci_find);
  * edac_pci_workq_function()
  * 	performs the operation scheduled by a workq request
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 static void edac_pci_workq_function(struct work_struct *work_req)
 {
 	struct delayed_work *d_work = (struct delayed_work *)work_req;
 	struct edac_pci_ctl_info *pci = to_edac_pci_ctl_work(d_work);
-#else
-static void edac_pci_workq_function(void *ptr)
-{
-	struct edac_pci_ctl_info *pci = ptr;
-#endif
 
 	edac_lock_pci_list();
 
@@ -248,11 +242,7 @@ static void edac_pci_workq_setup(struct 
 {
 	debugf0("%s()\n", __func__);
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 	INIT_DELAYED_WORK(&pci->work, edac_pci_workq_function);
-#else
-	INIT_WORK(&pci->work, edac_pci_workq_function, pci);
-#endif
 	queue_delayed_work(edac_workqueue, &pci->work,
 			   msecs_to_jiffies(edac_pci_get_poll_msec()));
 }


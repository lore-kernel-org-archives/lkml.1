Return-Path: <linux-kernel-owner+w=401wt.eu-S1765598AbYCDQco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765598AbYCDQco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765446AbYCDQah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:37 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48603 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765416AbYCDQag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:36 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 02/11] memstick: add memstick_suspend/resume_host methods
Date: Wed,  5 Mar 2008 03:02:19 +1100
Message-Id: <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Bus driver may need to be informed that host is being suspended/resumed.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/memstick.c |   25 +++++++++++++++++++++++++
 drivers/memstick/host/tifm_ms.c  |    8 ++++----
 include/linux/memstick.h         |    2 ++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 5e0e960..3c97bac 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -561,6 +561,31 @@ void memstick_free_host(struct memstick_host *host)
 }
 EXPORT_SYMBOL(memstick_free_host);
 
+/**
+ * memstick_suspend_host - notify bus driver of host suspension
+ * @host - host to use
+ */
+void memstick_suspend_host(struct memstick_host *host)
+{
+	mutex_lock(&host->lock);
+	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
+	mutex_unlock(&host->lock);
+}
+EXPORT_SYMBOL(memstick_suspend_host);
+
+/**
+ * memstick_resume_host - notify bus driver of host resumption
+ * @host - host to use
+ */
+void memstick_resume_host(struct memstick_host *host)
+{
+	mutex_lock(&host->lock);
+	host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_ON);
+	mutex_unlock(&host->lock);
+	memstick_detect_change(host);
+}
+EXPORT_SYMBOL(memstick_resume_host);
+
 int memstick_register_driver(struct memstick_driver *drv)
 {
 	drv->driver.bus = &memstick_bus_type;
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 5b5bd61..8b1c102 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -627,17 +627,17 @@ static void tifm_ms_remove(struct tifm_dev *sock)
 
 static int tifm_ms_suspend(struct tifm_dev *sock, pm_message_t state)
 {
+	struct memstick_host *msh = tifm_get_drvdata(sock);
+
+	memstick_suspend_host(msh);
 	return 0;
 }
 
 static int tifm_ms_resume(struct tifm_dev *sock)
 {
 	struct memstick_host *msh = tifm_get_drvdata(sock);
-	struct tifm_ms *host = memstick_priv(msh);
-
-	tifm_ms_initialize_host(host);
-	memstick_detect_change(msh);
 
+	memstick_resume_host(msh);
 	return 0;
 }
 
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index c104e72..b7ee258 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -312,6 +312,8 @@ int memstick_add_host(struct memstick_host *host);
 void memstick_remove_host(struct memstick_host *host);
 void memstick_free_host(struct memstick_host *host);
 void memstick_detect_change(struct memstick_host *host);
+void memstick_suspend_host(struct memstick_host *host);
+void memstick_resume_host(struct memstick_host *host);
 
 void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
 			  struct scatterlist *sg);
-- 
1.5.3.6


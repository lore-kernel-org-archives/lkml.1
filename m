Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbYHZTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbYHZTCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbYHZTAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:00:22 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50645 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790AbYHZS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:59:52 -0400
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Len Brown <len.brown@intel.com>,
       Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 4/4] acpi: semaphore removal
Date: Tue, 26 Aug 2008 11:59:49 -0700
Message-Id: <1219777186-4787-4-git-send-email-dwalker@mvista.com>
X-Mailer: git-send-email 1.5.5.1.32.gba7d2
In-Reply-To: <1219777186-4787-3-git-send-email-dwalker@mvista.com>
References: <1219777186-4787-1-git-send-email-dwalker@mvista.com>
 <1219777186-4787-2-git-send-email-dwalker@mvista.com>
 <1219777186-4787-3-git-send-email-dwalker@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore usage in ACPI is more like completions. The ASL
functions getting implemented here are signals which follow a
"wait for", signaled, or reset format.

This implements the ACPI signaling methods with the Linux
completion API, instead of using semaphores.

Cc: linux-acpi@vger.kernel.org
Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 drivers/acpi/osl.c |   56 ++++++++++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e6f7337..63de45e 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -43,7 +43,7 @@
 #include <linux/ioport.h>
 #include <linux/list.h>
 #include <linux/jiffies.h>
-#include <linux/semaphore.h>
+#include <linux/completion.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -768,42 +768,44 @@ void acpi_os_delete_lock(acpi_spinlock handle)
 acpi_status
 acpi_os_create_semaphore(u32 max_units, u32 initial_units, acpi_handle * handle)
 {
-	struct semaphore *sem = NULL;
+	struct completion *comp = NULL;
 
-	sem = acpi_os_allocate(sizeof(struct semaphore));
-	if (!sem)
+	BUG_ON(initial_units);
+
+	comp = acpi_os_allocate(sizeof(struct completion));
+	if (!comp)
 		return AE_NO_MEMORY;
-	memset(sem, 0, sizeof(struct semaphore));
+	memset(comp, 0, sizeof(struct completion));
 
-	sema_init(sem, initial_units);
+	init_completion(comp);
 
-	*handle = (acpi_handle *) sem;
+	*handle = (acpi_handle *) comp;
 
-	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Creating semaphore[%p|%d].\n",
+	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Creating completion[%p|%d].\n",
 			  *handle, initial_units));
 
 	return AE_OK;
 }
 
 /*
- * TODO: A better way to delete semaphores?  Linux doesn't have a
- * 'delete_semaphore()' function -- may result in an invalid
+ * TODO: A better way to delete completions?  Linux doesn't have a
+ * 'delete_completions()' function -- may result in an invalid
  * pointer dereference for non-synchronized consumers.	Should
  * we at least check for blocked threads and signal/cancel them?
  */
 
 acpi_status acpi_os_delete_semaphore(acpi_handle handle)
 {
-	struct semaphore *sem = (struct semaphore *)handle;
+	struct completion *comp = (struct completion *)handle;
 
-	if (!sem)
+	if (!comp)
 		return AE_BAD_PARAMETER;
 
-	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Deleting semaphore[%p].\n", handle));
+	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Deleting completion[%p].\n", handle));
 
-	BUG_ON(!list_empty(&sem->wait_list));
-	kfree(sem);
-	sem = NULL;
+	BUG_ON(!completion_done(comp));
+	kfree(comp);
+	comp = NULL;
 
 	return AE_OK;
 }
@@ -814,17 +816,17 @@ acpi_status acpi_os_delete_semaphore(acpi_handle handle)
 acpi_status acpi_os_wait_semaphore(acpi_handle handle, u32 units, u16 timeout)
 {
 	acpi_status status = AE_OK;
-	struct semaphore *sem = (struct semaphore *)handle;
+	struct completion *comp = (struct completion *)handle;
 	long jiffies;
 	int ret = 0;
 
-	if (!sem || (units < 1))
+	if (!comp || (units < 1))
 		return AE_BAD_PARAMETER;
 
 	if (units > 1)
 		return AE_SUPPORT;
 
-	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Waiting for semaphore[%p|%d|%d]\n",
+	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Waiting for completion[%p|%d|%d]\n",
 			  handle, units, timeout));
 
 	if (timeout == ACPI_WAIT_FOREVER)
@@ -832,18 +834,18 @@ acpi_status acpi_os_wait_semaphore(acpi_handle handle, u32 units, u16 timeout)
 	else
 		jiffies = msecs_to_jiffies(timeout);
 	
-	ret = down_timeout(sem, jiffies);
+	ret = wait_for_completion_timeout(comp, jiffies);
 	if (ret)
 		status = AE_TIME;
 
 	if (ACPI_FAILURE(status)) {
 		ACPI_DEBUG_PRINT((ACPI_DB_MUTEX,
-				  "Failed to acquire semaphore[%p|%d|%d], %s",
+				  "Failed to acquire completion[%p|%d|%d], %s",
 				  handle, units, timeout,
 				  acpi_format_exception(status)));
 	} else {
 		ACPI_DEBUG_PRINT((ACPI_DB_MUTEX,
-				  "Acquired semaphore[%p|%d|%d]", handle,
+				  "Acquired completion[%p|%d|%d]", handle,
 				  units, timeout));
 	}
 
@@ -855,18 +857,18 @@ acpi_status acpi_os_wait_semaphore(acpi_handle handle, u32 units, u16 timeout)
  */
 acpi_status acpi_os_signal_semaphore(acpi_handle handle, u32 units)
 {
-	struct semaphore *sem = (struct semaphore *)handle;
+	struct completion *comp = (struct completion *)handle;
 
-	if (!sem || (units < 1))
+	if (!comp || (units < 1))
 		return AE_BAD_PARAMETER;
 
 	if (units > 1)
 		return AE_SUPPORT;
 
-	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Signaling semaphore[%p|%d]\n", handle,
-			  units));
+	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Signaling completion[%p|%d]\n",
+			 handle, units));
 
-	up(sem);
+	complete(comp);
 
 	return AE_OK;
 }
-- 
1.5.5.1.32.gba7d2


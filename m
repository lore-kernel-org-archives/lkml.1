Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbYHZTAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbYHZTAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbYHZS7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:59:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2184 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506AbYHZS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:59:52 -0400
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Len Brown <len.brown@intel.com>,
       Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 2/4] acpi: add real mutex function calls
Date: Tue, 26 Aug 2008 11:59:47 -0700
Message-Id: <1219777186-4787-2-git-send-email-dwalker@mvista.com>
X-Mailer: git-send-email 1.5.5.1.32.gba7d2
In-Reply-To: <1219777186-4787-1-git-send-email-dwalker@mvista.com>
References: <1219777186-4787-1-git-send-email-dwalker@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of re-using semaphores for the mutex operation, I've
added usage of the kernel mutex for the acpi os mutex
implementation.

Cc: linux-acpi@vger.kernel.org
Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 drivers/acpi/osl.c      |   93 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpiosxf.h |   11 +-----
 2 files changed, 95 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 235a138..e6f7337 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -871,6 +871,99 @@ acpi_status acpi_os_signal_semaphore(acpi_handle handle, u32 units)
 	return AE_OK;
 }
 
+acpi_status
+acpi_os_create_mutex(acpi_mutex *handle)
+{
+	struct mutex *mutex = NULL;
+
+	mutex = acpi_os_allocate(sizeof(struct mutex));
+	if (!mutex)
+		return AE_NO_MEMORY;
+	memset(mutex, 0, sizeof(struct mutex));
+
+	mutex_init(mutex);
+
+	*handle = (acpi_handle *) mutex;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Creating mutex[%p].\n",
+			  *handle));
+
+	return AE_OK;
+}
+
+acpi_status acpi_os_delete_mutex(acpi_mutex handle)
+{
+	struct mutex *mutex = (struct mutex *)handle;
+
+	if (!mutex)
+		return AE_BAD_PARAMETER;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Deleting mutex[%p].\n", handle));
+
+	BUG_ON(mutex_is_locked(mutex));
+	kfree(mutex);
+	mutex = NULL;
+
+	return AE_OK;
+}
+
+acpi_status acpi_os_acquire_mutex(acpi_mutex handle, u16 timeout)
+{
+	acpi_status status = AE_OK;
+	struct mutex *mutex = (struct mutex *)handle;
+	long jiffies;
+	int ret = 0;
+
+	if (!mutex)
+		return AE_BAD_PARAMETER;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Waiting for mutex[%p|%d]\n",
+			  handle, timeout));
+
+	if (timeout == ACPI_DO_NOT_WAIT) {
+		if (mutex_trylock(mutex))
+			return status;
+		else
+			return -ETIME;
+	}
+
+	if (timeout == ACPI_WAIT_FOREVER)
+		jiffies = MAX_SCHEDULE_TIMEOUT;
+	else
+		jiffies = msecs_to_jiffies(timeout);
+
+	ret = mutex_lock_timeout(mutex, jiffies);
+	if (ret == -ETIME)
+		status = AE_TIME;
+
+	if (ACPI_FAILURE(status)) {
+		ACPI_DEBUG_PRINT((ACPI_DB_MUTEX,
+				  "Failed to acquire mutex[%p|%d], %s",
+				  handle, timeout,
+				  acpi_format_exception(status)));
+	} else {
+		ACPI_DEBUG_PRINT((ACPI_DB_MUTEX,
+				  "Acquired mutex[%p|%d]", handle,
+				  timeout));
+	}
+
+	return status;
+}
+
+acpi_status acpi_os_release_mutex(acpi_mutex handle)
+{
+	struct mutex *mutex = (struct mutex *)handle;
+
+	if (!mutex)
+		return AE_BAD_PARAMETER;
+
+	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Signaling mutex[%p]\n", handle));
+
+	mutex_unlock(mutex);
+
+	return AE_OK;
+}
+
 #ifdef ACPI_FUTURE_USAGE
 u32 acpi_os_get_line(char *buffer)
 {
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 3f93a6b..9032ec3 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -125,18 +125,11 @@ acpi_status acpi_os_signal_semaphore(acpi_semaphore handle, u32 units);
  */
 acpi_status acpi_os_create_mutex(acpi_mutex * out_handle);
 
-void acpi_os_delete_mutex(acpi_mutex handle);
+acpi_status acpi_os_delete_mutex(acpi_mutex handle);
 
 acpi_status acpi_os_acquire_mutex(acpi_mutex handle, u16 timeout);
 
-void acpi_os_release_mutex(acpi_mutex handle);
-
-/* Temporary macros for Mutex* interfaces, map to existing semaphore xfaces */
-
-#define acpi_os_create_mutex(out_handle)    acpi_os_create_semaphore (1, 1, out_handle)
-#define acpi_os_delete_mutex(handle)        (void) acpi_os_delete_semaphore (handle)
-#define acpi_os_acquire_mutex(handle,time)  acpi_os_wait_semaphore (handle, 1, time)
-#define acpi_os_release_mutex(handle)       (void) acpi_os_signal_semaphore (handle, 1)
+acpi_status acpi_os_release_mutex(acpi_mutex handle);
 
 /*
  * Memory allocation and mapping
-- 
1.5.5.1.32.gba7d2



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZL0EUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZL0EUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 23:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZL0EUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 23:20:17 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:41256 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZL0EUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 23:20:16 -0500
Date: Sat, 26 Dec 2009 23:20:01 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -tip: origin tree boot crash
In-reply-to: <alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225102731.GA25513@elte.hu>
 <alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Dec 2009, Len Brown wrote:

> > [   28.643216] evbug.c: Connected device: input1 (Dell WMI hotkeys at wmi/input0)
> > [   28.650449] BUG: unable to handle kernel NULL pointer dereference at 00000014
> > [   28.654439] IP: [<c17f7f21>] wmi_install_notify_handler+0x31/0x70
> 
> Rather than reverting the broken patch that caused wmi to load,
> does applying this patch to deal with the broken error handling
> cause the oops to go away?

> Subject: [PATCH] Revert "wmi: Free the allocated acpi objects through wmi_get_event_data"
> 
> This reverts commit 3e9b988e4edf065d39c1343937f717319b1c1065.

These kfree's look correct, assuming we properly check
the return status.  So perhaps instead you can test
the patch below?

thanks,
-Len

>From 5caa3ab36da77d59017cff9b9d1e910862b489e7 Mon Sep 17 00:00:00 2001
Message-Id: <5caa3ab36da77d59017cff9b9d1e910862b489e7.1261887124.git.len.brown@intel.com>
In-Reply-To: <51b0f1c2b8c32ee44ff01ef74599a1f17e4fc565.1261887124.git.len.brown@intel.com>
References: <51b0f1c2b8c32ee44ff01ef74599a1f17e4fc565.1261887124.git.len.brown@intel.com>
From: Len Brown <len.brown@intel.com>
Date: Sat, 26 Dec 2009 23:02:24 -0500
Subject: [PATCH 3/3] dell-wmi, hp-wmi, msi-wmi: check wmi_get_event_data() return value
X-Patchwork-Hint: ignore

When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
the caller must kfree the returned buffer if AE_OK is returned.

The callers of wmi_get_event_data() pass ACPI_ALLOCATE_BUFFER,
and thus must check its return value before accessing
or kfree() on the buffer.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/platform/x86/dell-wmi.c |    7 ++++++-
 drivers/platform/x86/hp-wmi.c   |    7 ++++++-
 drivers/platform/x86/msi-wmi.c  |    7 ++++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 4c7e702..500af8c 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -202,8 +202,13 @@ static void dell_wmi_notify(u32 value, void *context)
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	static struct key_entry *key;
 	union acpi_object *obj;
+	acpi_status status;
 
-	wmi_get_event_data(value, &response);
+	status = wmi_get_event_data(value, &response);
+	if (status != AE_OK) {
+		printk(KERN_INFO "dell-wmi: bad event status 0x%x\n", status);
+		return;
+	}
 
 	obj = (union acpi_object *)response.pointer;
 
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 18bf741..5b648f0 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -338,8 +338,13 @@ static void hp_wmi_notify(u32 value, void *context)
 	static struct key_entry *key;
 	union acpi_object *obj;
 	int eventcode;
+	acpi_status status;
 
-	wmi_get_event_data(value, &response);
+	status = wmi_get_event_data(value, &response);
+	if (status != AE_OK) {
+		printk(KERN_INFO "hp-wmi: bad event status 0x%x\n", status);
+		return;
+	}
 
 	obj = (union acpi_object *)response.pointer;
 
diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index f746c67..f5f70d4 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -149,8 +149,13 @@ static void msi_wmi_notify(u32 value, void *context)
 	static struct key_entry *key;
 	union acpi_object *obj;
 	ktime_t cur;
+	acpi_status status;
 
-	wmi_get_event_data(value, &response);
+	status = wmi_get_event_data(value, &response);
+	if (status != AE_OK) {
+		printk(KERN_INFO DRV_PFX "bad event status 0x%x\n", status);
+		return;
+	}
 
 	obj = (union acpi_object *)response.pointer;
 
-- 
1.6.0.6


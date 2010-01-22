Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247Ab0AVTdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0AVTdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184Ab0AVTdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:33:38 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:37749 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab0AVTdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:33:36 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jan 2010 14:33:36 EST
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>
Subject: [PATCH 1/1] Staging: hv: Remove xen legacy code and check for
 Hyper-V
Thread-Topic: [PATCH 1/1] Staging: hv: Remove xen legacy code and check for
 Hyper-V
Thread-Index: AQHKmtrG/43JHj6W4UCwAFR737G0kJGh98zg
Date: Fri, 22 Jan 2010 19:17:50 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5620E878FE0@TK5EX14MBXC118.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Removed legacy XEN layer from hypervisor setup, and made sure only Hyper-V is
Is a valid hypervisor to run on.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>.
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
drivers/staging/hv/Hv.c |  205 +++++++++++++++++++----------------------------
drivers/staging/hv/Hv.h |   10 +--
2 files changed, 84 insertions(+), 131 deletions(-)

diff --git a/drivers/staging/hv/Hv.c b/drivers/staging/hv/Hv.c
index c2809f2..51149e6 100644
--- a/drivers/staging/hv/Hv.c
+++ b/drivers/staging/hv/Hv.c
@@ -208,50 +208,51 @@ int HvInit(void)
 	/* HvQueryHypervisorFeatures(maxLeaf); */
 
 	/*
-	 * Determine if we are running on xenlinux (ie x2v shim) or native
-	 * linux
+	 * We only support running on top of Hyper-V
 	 */
 	rdmsrl(HV_X64_MSR_GUEST_OS_ID, gHvContext.GuestId);
-	if (gHvContext.GuestId == 0) {
-		/* Write our OS info */
-		wrmsrl(HV_X64_MSR_GUEST_OS_ID, HV_LINUX_GUEST_ID);
-		gHvContext.GuestId = HV_LINUX_GUEST_ID;
+
+	if (gHvContext.GuestId != 0) {
+		DPRINT_ERR(VMBUS, "Unknown guest id (0x%llx)!!",
+				gHvContext.GuestId);
+		goto Cleanup;
 	}
 
+	/* Write our OS info */
+	wrmsrl(HV_X64_MSR_GUEST_OS_ID, HV_LINUX_GUEST_ID);
+	gHvContext.GuestId = HV_LINUX_GUEST_ID;
+
 	/* See if the hypercall page is already set */
 	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
-	if (gHvContext.GuestId == HV_LINUX_GUEST_ID) {
-		/* Allocate the hypercall page memory */
-		/* virtAddr = osd_PageAlloc(1); */
-		virtAddr = osd_VirtualAllocExec(PAGE_SIZE);
-
-		if (!virtAddr) {
-			DPRINT_ERR(VMBUS,
-				   "unable to allocate hypercall page!!");
-			goto Cleanup;
-		}
 
-		hypercallMsr.Enable = 1;
-		/* hypercallMsr.GuestPhysicalAddress =
-		 * 		virt_to_phys(virtAddr) >> PAGE_SHIFT; */
-		hypercallMsr.GuestPhysicalAddress = vmalloc_to_pfn(virtAddr);
-		wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+	/*
+	* Allocate the hypercall page memory
+	* virtAddr = osd_PageAlloc(1);
+	*/
+	virtAddr = osd_VirtualAllocExec(PAGE_SIZE);
 
-		/* Confirm that hypercall page did get setup. */
-		hypercallMsr.AsUINT64 = 0;
-		rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
-		if (!hypercallMsr.Enable) {
-			DPRINT_ERR(VMBUS, "unable to set hypercall page!!");
-			goto Cleanup;
-		}
+	if (!virtAddr) {
+		DPRINT_ERR(VMBUS,
+			   "unable to allocate hypercall page!!");
+		goto Cleanup;
+	}
 
-		gHvContext.HypercallPage = virtAddr;
-	} else {
-		DPRINT_ERR(VMBUS, "Unknown guest id (0x%llx)!!",
-				gHvContext.GuestId);
+	hypercallMsr.Enable = 1;
+
+	hypercallMsr.GuestPhysicalAddress = vmalloc_to_pfn(virtAddr);
+	wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+
+	/* Confirm that hypercall page did get setup. */
+	hypercallMsr.AsUINT64 = 0;
+	rdmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+
+	if (!hypercallMsr.Enable) {
+		DPRINT_ERR(VMBUS, "unable to set hypercall page!!");
 		goto Cleanup;
 	}
 
+	gHvContext.HypercallPage = virtAddr;
+
 	DPRINT_INFO(VMBUS, "Hypercall page VA=%p, PA=0x%0llx",
 		    gHvContext.HypercallPage,
 		    (u64)hypercallMsr.GuestPhysicalAddress << PAGE_SHIFT);
@@ -273,8 +274,6 @@ int HvInit(void)
 	gHvContext.SignalEventParam->FlagNumber = 0;
 	gHvContext.SignalEventParam->RsvdZ = 0;
 
-	/* DPRINT_DBG(VMBUS, "My id %llu", HvGetCurrentPartitionId()); */
-
 	DPRINT_EXIT(VMBUS);
 
 	return ret;
@@ -311,17 +310,14 @@ void HvCleanup(void)
 		kfree(gHvContext.SignalEventBuffer);
 	}
 
-	if (gHvContext.GuestId == HV_LINUX_GUEST_ID) {
-		if (gHvContext.HypercallPage) {
-			hypercallMsr.AsUINT64 = 0;
-			wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
-			vfree(gHvContext.HypercallPage);
-			gHvContext.HypercallPage = NULL;
-		}
+	if (gHvContext.HypercallPage) {
+		hypercallMsr.AsUINT64 = 0;
+		wrmsrl(HV_X64_MSR_HYPERCALL, hypercallMsr.AsUINT64);
+		vfree(gHvContext.HypercallPage);
+		gHvContext.HypercallPage = NULL;
 	}
 
 	DPRINT_EXIT(VMBUS);
-
 }
 
 /**
@@ -393,7 +389,7 @@ void HvSynicInit(void *irqarg)
 	union hv_synic_siefp siefp;
 	union hv_synic_sint sharedSint;
 	union hv_synic_scontrol sctrl;
-	u64 guestID;
+
 	u32 irqVector = *((u32 *)(irqarg));
 	int cpu = smp_processor_id();
 
@@ -409,71 +405,41 @@ void HvSynicInit(void *irqarg)
 
 	DPRINT_INFO(VMBUS, "SynIC version: %llx", version);
 
-	/* TODO: Handle SMP */
-	if (gHvContext.GuestId == HV_XENLINUX_GUEST_ID) {
-		DPRINT_INFO(VMBUS, "Skipping SIMP and SIEFP setup since "
-				"it is already set.");
-
-		rdmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
-		rdmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
-
-		DPRINT_DBG(VMBUS, "Simp: %llx, Sifep: %llx",
-			   simp.AsUINT64, siefp.AsUINT64);
-
-		/*
-		 * Determine if we are running on xenlinux (ie x2v shim) or
-		 * native linux
-		 */
-		rdmsrl(HV_X64_MSR_GUEST_OS_ID, guestID);
-		if (guestID == HV_LINUX_GUEST_ID) {
-			gHvContext.synICMessagePage[cpu] =
-				phys_to_virt(simp.BaseSimpGpa << PAGE_SHIFT);
-			gHvContext.synICEventPage[cpu] =
-				phys_to_virt(siefp.BaseSiefpGpa << PAGE_SHIFT);
-		} else {
-			DPRINT_ERR(VMBUS, "unknown guest id!!");
-			goto Cleanup;
-		}
-		DPRINT_DBG(VMBUS, "MAPPED: Simp: %p, Sifep: %p",
-			   gHvContext.synICMessagePage[cpu],
-			   gHvContext.synICEventPage[cpu]);
-	} else {
-		gHvContext.synICMessagePage[cpu] = (void *)get_zeroed_page(GFP_ATOMIC);
-		if (gHvContext.synICMessagePage[cpu] == NULL) {
-			DPRINT_ERR(VMBUS,
-				   "unable to allocate SYNIC message page!!");
-			goto Cleanup;
-		}
+	gHvContext.synICMessagePage[cpu] = (void *)get_zeroed_page(GFP_ATOMIC);
 
-		gHvContext.synICEventPage[cpu] = (void *)get_zeroed_page(GFP_ATOMIC);
-		if (gHvContext.synICEventPage[cpu] == NULL) {
-			DPRINT_ERR(VMBUS,
-				   "unable to allocate SYNIC event page!!");
-			goto Cleanup;
-		}
+	if (gHvContext.synICMessagePage[cpu] == NULL) {
+		DPRINT_ERR(VMBUS,
+			   "unable to allocate SYNIC message page!!");
+		goto Cleanup;
+	}
 
-		/* Setup the Synic's message page */
-		rdmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
-		simp.SimpEnabled = 1;
-		simp.BaseSimpGpa = virt_to_phys(gHvContext.synICMessagePage[cpu])
-					>> PAGE_SHIFT;
+	gHvContext.synICEventPage[cpu] = (void *)get_zeroed_page(GFP_ATOMIC);
 
-		DPRINT_DBG(VMBUS, "HV_X64_MSR_SIMP msr set to: %llx",
-				simp.AsUINT64);
+	if (gHvContext.synICEventPage[cpu] == NULL) {
+		DPRINT_ERR(VMBUS,
+			   "unable to allocate SYNIC event page!!");
+		goto Cleanup;
+	}
 
-		wrmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
+	/* Setup the Synic's message page */
+	rdmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
+	simp.SimpEnabled = 1;
+	simp.BaseSimpGpa = virt_to_phys(gHvContext.synICMessagePage[cpu])
+		>> PAGE_SHIFT;
 
-		/* Setup the Synic's event page */
-		rdmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
-		siefp.SiefpEnabled = 1;
-		siefp.BaseSiefpGpa = virt_to_phys(gHvContext.synICEventPage[cpu])
-					>> PAGE_SHIFT;
+	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIMP msr set to: %llx", simp.AsUINT64);
 
-		DPRINT_DBG(VMBUS, "HV_X64_MSR_SIEFP msr set to: %llx",
-				siefp.AsUINT64);
+	wrmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
 
-		wrmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
-	}
+	/* Setup the Synic's event page */
+	rdmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
+	siefp.SiefpEnabled = 1;
+	siefp.BaseSiefpGpa = virt_to_phys(gHvContext.synICEventPage[cpu])
+		>> PAGE_SHIFT;
+
+	DPRINT_DBG(VMBUS, "HV_X64_MSR_SIEFP msr set to: %llx", siefp.AsUINT64);
+
+	wrmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
 
 	/* Setup the interception SINT. */
 	/* wrmsrl((HV_X64_MSR_SINT0 + HV_SYNIC_INTERCEPTION_SINT_INDEX), */
@@ -505,13 +471,11 @@ void HvSynicInit(void *irqarg)
 	return;
 
 Cleanup:
-	if (gHvContext.GuestId == HV_LINUX_GUEST_ID) {
-		if (gHvContext.synICEventPage[cpu])
-			osd_PageFree(gHvContext.synICEventPage[cpu], 1);
+	if (gHvContext.synICEventPage[cpu])
+		osd_PageFree(gHvContext.synICEventPage[cpu], 1);
 
-		if (gHvContext.synICMessagePage[cpu])
-			osd_PageFree(gHvContext.synICMessagePage[cpu], 1);
-	}
+	if (gHvContext.synICMessagePage[cpu])
+		osd_PageFree(gHvContext.synICMessagePage[cpu], 1);
 
 	DPRINT_EXIT(VMBUS);
 	return;
@@ -542,27 +506,20 @@ void HvSynicCleanup(void *arg)
 	/* Disable the interrupt */
 	wrmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, sharedSint.AsUINT64);
 
-	/*
-	 * Disable and free the resources only if we are running as
-	 * native linux since in xenlinux, we are sharing the
-	 * resources with the x2v shim
-	 */
-	if (gHvContext.GuestId == HV_LINUX_GUEST_ID) {
-		rdmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
-		simp.SimpEnabled = 0;
-		simp.BaseSimpGpa = 0;
+	rdmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
+	simp.SimpEnabled = 0;
+	simp.BaseSimpGpa = 0;
 
-		wrmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
+	wrmsrl(HV_X64_MSR_SIMP, simp.AsUINT64);
 
-		rdmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
-		siefp.SiefpEnabled = 0;
-		siefp.BaseSiefpGpa = 0;
+	rdmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
+	siefp.SiefpEnabled = 0;
+	siefp.BaseSiefpGpa = 0;
 
-		wrmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
+	wrmsrl(HV_X64_MSR_SIEFP, siefp.AsUINT64);
 
-		osd_PageFree(gHvContext.synICMessagePage[cpu], 1);
-		osd_PageFree(gHvContext.synICEventPage[cpu], 1);
-	}
+	osd_PageFree(gHvContext.synICMessagePage[cpu], 1);
+	osd_PageFree(gHvContext.synICEventPage[cpu], 1);
 
 	DPRINT_EXIT(VMBUS);
 }
diff --git a/drivers/staging/hv/Hv.h b/drivers/staging/hv/Hv.h
index fce4b5c..41f5ebb 100644
--- a/drivers/staging/hv/Hv.h
+++ b/drivers/staging/hv/Hv.h
@@ -41,11 +41,6 @@ enum {
 
 #define HV_PRESENT_BIT			0x80000000
 
-#define HV_XENLINUX_GUEST_ID_LO		0x00000000
-#define HV_XENLINUX_GUEST_ID_HI		0x0B00B135
-#define HV_XENLINUX_GUEST_ID		(((u64)HV_XENLINUX_GUEST_ID_HI << 32) \
-					  | HV_XENLINUX_GUEST_ID_LO)
-
 #define HV_LINUX_GUEST_ID_LO		0x00000000
 #define HV_LINUX_GUEST_ID_HI		0xB16B00B5
 #define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI << 32) | \
@@ -102,8 +97,9 @@ struct hv_input_signal_event_buffer {
 };
 
 struct hv_context {
-	/* XenLinux or native Linux. If XenLinux, the hypercall and synic pages
-	 * has already been initialized */
+	/* We only support running on top of Hyper-V
+	* So at this point this really can only contain the Hyper-V ID
+	*/
 	u64 GuestId;
 
 	void *HypercallPage;

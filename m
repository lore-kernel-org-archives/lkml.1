Return-Path: <linux-kernel-owner+w=401wt.eu-S934123AbZDJQUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123AbZDJQUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764201AbZDJQUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:20:38 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52573 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294AbZDJQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:20:37 -0400
Message-ID: <49DF71CF.7070509@linux.vnet.ibm.com>
Date: Fri, 10 Apr 2009 09:20:31 -0700
From: jvrao <jvrao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
CC: Mike Anderson <andmike@linux.vnet.ibm.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       linux-driver@qlogic.com
Subject: Interrupts are being dropped under heavy IO on -rt .
Content-Type: multipart/mixed;
 boundary="------------050606060004070408080800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050606060004070408080800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Qlogic driver uses MSI-EDGE interrupts by default.
 
On -rt kernel under heavy IO load we observed that the driver missed 
interrupts occasionally.

Missing interrupts caused spurious mailbox timeouts and path failovers.

Suspecting MSI interrupts, we disabled MSI and forcing the driver to use 
APIC interrupts (Patch attached).

With this change, our IO tests ran for extended period of time without 
any issues.

It would be interesting to see if the MSI infrastructure itself has 
issues on realtime, or it is the combination of qla2xxx/MSI.

Right now we don't have any setup to test out MSI with other adapters. 
Hence, wondering if anyone faced similar issues.

Thanks,
JV


--------------050606060004070408080800
Content-Type: text/x-patch;
 name="qla_nomsi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="qla_nomsi.patch"

Index: linux-2.6.29.1/drivers/scsi/qla2xxx/qla_isr.c
===================================================================
--- linux-2.6.29.1.orig/drivers/scsi/qla2xxx/qla_isr.c
+++ linux-2.6.29.1/drivers/scsi/qla2xxx/qla_isr.c
@@ -1983,7 +1983,13 @@ qla2x00_request_irqs(struct qla_hw_data 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
 	    !IS_QLA8432(ha) && !IS_QLA8001(ha))
+#ifdef CONFIG_PREEMPT_RT
+		/* Observed IO timeouts with MSI iterrupts on -rt kernel. */
+		/* This code change forces the driver to use APIC interrupts. */
+		goto skip_msi;
+#else
 		goto skip_msix;
+#endif /* CONFIG_PREEMPT_RT */
 
 	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
 		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
Index: linux-2.6.29.1/drivers/scsi/qla2xxx/qla_version.h
===================================================================
--- linux-2.6.29.1.orig/drivers/scsi/qla2xxx/qla_version.h
+++ linux-2.6.29.1/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.00-k4"
+#define QLA2XXX_VERSION      "8.03.00-k4-rt1"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3

--------------050606060004070408080800--


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYDDM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYDDM21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYDDM2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:28:19 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:39955
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbYDDM2S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:28:18 -0400
Message-Id: <47F63B18.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 04 Apr 2008 13:28:40 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <len.brown@intel.com>
Cc: "linux-acpi" <linux-acpi@intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] adjust ACPI register handling
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_hw_low_level_{read,write}() have no need to accept a NULL reg
argument anymore (all callers use addresses of or derived from ACPI
globals), and it really should always have been considered an error
to call these functions in such a way.

Additionally acpi_hw_low_level_read() should initialize the value
read in all cases when it returns successfully.

Also use ACPI_GPE_REGISTER_WIDTH where possible rather than a plain
number.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/acpi/hardware/hwgpe.c  |   15 ++++++++-------
 drivers/acpi/hardware/hwregs.c |    6 +++---
 2 files changed, 11 insertions(+), 10 deletions(-)

--- linux-2.6.25-rc8/drivers/acpi/hardware/hwgpe.c	2007-04-26 05:08:32.000000000 +0200
+++ 2.6.25-rc8-acpi-hwregs/drivers/acpi/hardware/hwgpe.c	2008-04-03 10:59:59.000000000 +0200
@@ -84,7 +84,8 @@ acpi_hw_write_gpe_enable_reg(struct acpi
 
 	/* Write the entire GPE (runtime) enable register */
 
-	status = acpi_hw_low_level_write(8, gpe_register_info->enable_for_run,
+	status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH,
+					 gpe_register_info->enable_for_run,
 					 &gpe_register_info->enable_address);
 
 	return (status);
@@ -118,7 +119,7 @@ acpi_status acpi_hw_clear_gpe(struct acp
 	 * Write a one to the appropriate bit in the status register to
 	 * clear this GPE.
 	 */
-	status = acpi_hw_low_level_write(8, register_bit,
+	status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH, register_bit,
 					 &gpe_event_info->register_info->
 					 status_address);
 
@@ -181,7 +182,7 @@ acpi_hw_get_gpe_status(struct acpi_gpe_e
 	/* GPE currently active (status bit == 1)? */
 
 	status =
-	    acpi_hw_low_level_read(8, &in_byte,
+	    acpi_hw_low_level_read(ACPI_GPE_REGISTER_WIDTH, &in_byte,
 				   &gpe_register_info->status_address);
 	if (ACPI_FAILURE(status)) {
 		goto unlock_and_exit;
@@ -226,7 +227,7 @@ acpi_hw_disable_gpe_block(struct acpi_gp
 
 		/* Disable all GPEs in this register */
 
-		status = acpi_hw_low_level_write(8, 0x00,
+		status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH, 0x00,
 						 &gpe_block->register_info[i].
 						 enable_address);
 		if (ACPI_FAILURE(status)) {
@@ -263,7 +264,7 @@ acpi_hw_clear_gpe_block(struct acpi_gpe_
 
 		/* Clear status on all GPEs in this register */
 
-		status = acpi_hw_low_level_write(8, 0xFF,
+		status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH, 0xFF,
 						 &gpe_block->register_info[i].
 						 status_address);
 		if (ACPI_FAILURE(status)) {
@@ -307,7 +308,7 @@ acpi_hw_enable_runtime_gpe_block(struct 
 		/* Enable all "runtime" GPEs in this register */
 
 		status =
-		    acpi_hw_low_level_write(8,
+		    acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH,
 					    gpe_block->register_info[i].
 					    enable_for_run,
 					    &gpe_block->register_info[i].
@@ -350,7 +351,7 @@ acpi_hw_enable_wakeup_gpe_block(struct a
 
 		/* Enable all "wake" GPEs in this register */
 
-		status = acpi_hw_low_level_write(8,
+		status = acpi_hw_low_level_write(ACPI_GPE_REGISTER_WIDTH,
 						 gpe_block->register_info[i].
 						 enable_for_wake,
 						 &gpe_block->register_info[i].
--- linux-2.6.25-rc8/drivers/acpi/hardware/hwregs.c	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.25-rc8-acpi-hwregs/drivers/acpi/hardware/hwregs.c	2008-04-03 11:02:33.000000000 +0200
@@ -745,8 +745,9 @@ acpi_hw_low_level_read(u32 width, u32 * 
 	 * because the PM1A/B code must not fail if B isn't present.
 	 */
 	if (!reg) {
-		return (AE_OK);
+		return (AE_BAD_PARAMETER);
 	}
+	*value = 0;
 
 	/* Get a local copy of the address. Handles possible alignment issues */
 
@@ -754,7 +755,6 @@ acpi_hw_low_level_read(u32 width, u32 * 
 	if (!address) {
 		return (AE_OK);
 	}
-	*value = 0;
 
 	/*
 	 * Two address spaces supported: Memory or IO.
@@ -815,7 +815,7 @@ acpi_hw_low_level_write(u32 width, u32 v
 	 * because the PM1A/B code must not fail if B isn't present.
 	 */
 	if (!reg) {
-		return (AE_OK);
+		return (AE_BAD_PARAMETER);
 	}
 
 	/* Get a local copy of the address. Handles possible alignment issues */



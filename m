Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0BKN0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:26:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48263 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0BKN0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:26:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Thu, 11 Feb 2010 14:27:17 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <201001101431.38630.rjw@sisk.pl> <201002110156.54617.rjw@sisk.pl> <20100211020706.GA28372@us.ibm.com>
In-Reply-To: <20100211020706.GA28372@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002111427.17275.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010, Gary Hade wrote:
> On Thu, Feb 11, 2010 at 01:56:54AM +0100, Rafael J. Wysocki wrote:
> > On Thursday 11 February 2010, Rafael J. Wysocki wrote:
> > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > On Wed, Feb 10, 2010 at 11:58:00PM +0100, Rafael J. Wysocki wrote:
> > > > > On Wednesday 10 February 2010, Gary Hade wrote:
> > > ...
> > > > > > Yes, 6/9 also appeared to be the most likely suspect to me and
> > > > > > I was already doing what you asked except in the opposite order.
> > > > > > With 1/9 through 6/9 both the hot-add and hot-remove issues still
> > > > > > reproduced.  After removing 6/9 both issues disappeared.
> > > > > 
> > > > > Thanks for verifying, I've already started to look for bugs in it.
> > > > 
> > > > Thanks!
> > > > 
> > > > > 
> > > > > What's your kernel command line, BTW?
> > > > 
> > > > root=/dev/disk/by-id/scsi-35000c5000036ffcb-part7 ip=9.47.66.9:9.47.67.50:9.47.66.1:255.255.254.0 resume=/dev/disk/by-id/scsi-35000c50000370247-part3 crashkernel=256M-:128M console=tty0 console=ttyS0,115200 pci=use_crs pci=norom
> > > 
> > > Thanks.  We found a bug in the patch, but it would require you to use a
> > > specific command line switch to trigger, which you don't use.
> > > 
> > > I'll let you know if I have anything to test.
> > 
> > OK, please try the patch below on top of [1-6/9].
> 
> Sorry, it didn't help.  The hot-add and hot-remove behaviors
> still look the same.

Thanks for testing.

Well, this time I found another real bug, which is that we should add
gpe_block->block_base_number to the GPE index within the block in order to
compute the GPE number.  If there are GPE devices other than the FADT ones in
your system, that may explain the symptoms.

Please try the patch below (on top of [1-6/9]).  In case it doesn't help, please
look for "Failed to ebable GPE" messages in dmesg and let me know if there are
any.

Rafael

---
 drivers/acpi/acpica/evgpeblk.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-2.6/drivers/acpi/acpica/evgpeblk.c
@@ -258,7 +258,6 @@ acpi_ev_save_method_info(acpi_handle obj
 	u32 gpe_number;
 	char name[ACPI_NAME_SIZE + 1];
 	u8 type;
-	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(ev_save_method_info);
 
@@ -338,7 +337,7 @@ acpi_ev_save_method_info(acpi_handle obj
 	ACPI_DEBUG_PRINT((ACPI_DB_LOAD,
 			  "Registered GPE method %s as GPE number 0x%.2X\n",
 			  name, gpe_number));
-	return_ACPI_STATUS(status);
+	return_ACPI_STATUS(AE_OK);
 }
 
 /*******************************************************************************
@@ -1005,6 +1004,9 @@ acpi_ev_initialize_gpe_block(struct acpi
 					   ACPI_UINT32_MAX, ACPI_NS_WALK_UNLOCK,
 					   acpi_ev_match_prw_and_gpe, NULL,
 					   &gpe_info, NULL);
+		if (ACPI_FAILURE(status))
+			ACPI_ERROR((AE_INFO,
+					"Detection of wake GPEs failed\n"));
 	}
 
 	/*
@@ -1014,30 +1016,36 @@ acpi_ev_initialize_gpe_block(struct acpi
 	 */
 	wake_gpe_count = 0;
 	gpe_enabled_count = 0;
+	if (gpe_device == acpi_gbl_fadt_gpe_device)
+		gpe_device = NULL;
 
 	for (i = 0; i < gpe_block->register_count; i++) {
 		for (j = 0; j < 8; j++) {
-			int gpe_number = i * ACPI_GPE_REGISTER_WIDTH + j;
+			acpi_size gpe_index;
+			int gpe_number;
 
 			/* Get the info block for this particular GPE */
 
-			gpe_event_info = &gpe_block->event_info[(acpi_size)
-								gpe_number];
+			gpe_index = (acpi_size)i * ACPI_GPE_REGISTER_WIDTH + j;
+			gpe_event_info = &gpe_block->event_info[gpe_index];
 
 			if (gpe_event_info->flags & ACPI_GPE_CAN_WAKE) {
 				wake_gpe_count++;
-				continue;
+				if (acpi_gbl_leave_wake_gpes_disabled)
+					continue;
 			}
 
-			if (gpe_event_info->flags & ACPI_GPE_DISPATCH_METHOD) {
+			if (!(gpe_event_info->flags & ACPI_GPE_DISPATCH_METHOD))
+				continue;
+
+			gpe_number = gpe_index + gpe_block->block_base_number;
+			status = acpi_ref_runtime_gpe(gpe_device, gpe_number);
+			if (ACPI_FAILURE(status))
+				ACPI_ERROR((AE_INFO,
+						"Failed to enable GPE %02X\n",
+						gpe_number));
+			else
 				gpe_enabled_count++;
-				if (gpe_device == acpi_gbl_fadt_gpe_device)
-					status = acpi_ref_runtime_gpe(NULL,
-								      gpe_number);
-				else
-					status = acpi_ref_runtime_gpe(gpe_device,
-								      gpe_number);
-			}
 		}
 	}
 

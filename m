Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0BKA4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:56:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab0BKA4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:56:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Thu, 11 Feb 2010 01:56:54 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <201001101431.38630.rjw@sisk.pl> <20100210230438.GC17115@us.ibm.com> <201002110025.39316.rjw@sisk.pl>
In-Reply-To: <201002110025.39316.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002110156.54617.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 February 2010, Rafael J. Wysocki wrote:
> On Thursday 11 February 2010, Gary Hade wrote:
> > On Wed, Feb 10, 2010 at 11:58:00PM +0100, Rafael J. Wysocki wrote:
> > > On Wednesday 10 February 2010, Gary Hade wrote:
> ...
> > > > Yes, 6/9 also appeared to be the most likely suspect to me and
> > > > I was already doing what you asked except in the opposite order.
> > > > With 1/9 through 6/9 both the hot-add and hot-remove issues still
> > > > reproduced.  After removing 6/9 both issues disappeared.
> > > 
> > > Thanks for verifying, I've already started to look for bugs in it.
> > 
> > Thanks!
> > 
> > > 
> > > What's your kernel command line, BTW?
> > 
> > root=/dev/disk/by-id/scsi-35000c5000036ffcb-part7 ip=9.47.66.9:9.47.67.50:9.47.66.1:255.255.254.0 resume=/dev/disk/by-id/scsi-35000c50000370247-part3 crashkernel=256M-:128M console=tty0 console=ttyS0,115200 pci=use_crs pci=norom
> 
> Thanks.  We found a bug in the patch, but it would require you to use a
> specific command line switch to trigger, which you don't use.
> 
> I'll let you know if I have anything to test.

OK, please try the patch below on top of [1-6/9].

Rafael

---
 drivers/acpi/acpica/evgpeblk.c |    4 ++++
 drivers/acpi/acpica/evxface.c  |   14 ++++++++++++++
 2 files changed, 18 insertions(+)

Index: linux-2.6/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evxface.c
+++ linux-2.6/drivers/acpi/acpica/evxface.c
@@ -617,6 +617,13 @@ acpi_install_gpe_handler(acpi_handle gpe
 	handler->context = context;
 	handler->method_node = gpe_event_info->dispatch.method_node;
 
+	/* Disable the GPE before installing the handler */
+
+	status = acpi_ev_disable_gpe(gpe_event_info);
+	if (ACPI_FAILURE(status)) {
+		goto unlock_and_exit;
+	}
+
 	/* Install the handler */
 
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
@@ -709,6 +716,13 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 		return_ACPI_STATUS(status);
 	}
 
+	/* Disable the GPE before removing the handler */
+
+	status = acpi_ev_disable_gpe(gpe_event_info);
+	if (ACPI_FAILURE(status)) {
+		goto unlock_and_exit;
+	}
+
 	/* Remove the handler */
 
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
Index: linux-2.6/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-2.6/drivers/acpi/acpica/evgpeblk.c
@@ -335,6 +335,10 @@ acpi_ev_save_method_info(acpi_handle obj
 	gpe_event_info->dispatch.method_node =
 	    (struct acpi_namespace_node *)obj_handle;
 
+	/* Update enable mask, but don't enable the HW GPE as of yet */
+
+	status = acpi_ev_enable_gpe(gpe_event_info, FALSE);
+
 	ACPI_DEBUG_PRINT((ACPI_DB_LOAD,
 			  "Registered GPE method %s as GPE number 0x%.2X\n",
 			  name, gpe_number));

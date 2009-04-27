Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbZD0WYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbZD0WYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 18:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZD0WYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 18:24:23 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:7383 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbZD0WYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 18:24:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Date: Mon, 27 Apr 2009 16:24:15 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
References: <49ED22EC.2040204@kernel.org> <200904271439.37396.bjorn.helgaas@hp.com> <86802c440904271400q379da621ja808c96152c3fb8b@mail.gmail.com>
In-Reply-To: <86802c440904271400q379da621ja808c96152c3fb8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271624.17295.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009 03:00:16 pm Yinghai Lu wrote:
> On Mon, Apr 27, 2009 at 1:39 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >> other system may have broken _CRS.
> >
> > Do you have examples of problems here, or are you just worried that
> > there *may* be problems?
> one system with three chains... with pci=use_crs
> [    9.365669] pci_bus 0000:00: resource 0 io:  [0x00-0x3af]
> [    9.371065] pci_bus 0000:00: resource 1 io:  [0x3e0-0xcf7]
> [    9.376551] pci_bus 0000:00: resource 2 io:  [0x3b0-0x3bb]
> [    9.382028] pci_bus 0000:00: resource 3 io:  [0x3c0-0x3df]
> [    9.387513] pci_bus 0000:00: resource 4 io:  [0xd00-0xefff]
> [    9.393077] pci_bus 0000:00: resource 5 mem: [0x0a0000-0x0bffff]
> [    9.399084] pci_bus 0000:00: resource 6 mem: [0x0d0000-0x0dffff]
> [    9.405089] pci_bus 0000:00: resource 7 mem: [0xdd000000-0xdfffffff]
> [    9.505332] pci_bus 0000:40: resource 0 io:  [0x5000-0x8fff]
> [    9.510991] pci_bus 0000:40: resource 1 mem: [0xdb000000-0xdcffffff]
> [    9.553378] pci_bus 0000:80: resource 0 io:  [0x1000-0x4fff]
> [    9.559036] pci_bus 0000:80: resource 1 mem: [0xda000000-0xdaffffff]
> 
> without that: amd_bus.c will read that from pci conf space
> [    9.310965] pci_bus 0000:00: resource 0 io:  [0x9000-0xefff]
> [    9.316621] pci_bus 0000:00: resource 1 io:  [0x00-0xfff]
> [    9.322020] pci_bus 0000:00: resource 2 mem: [0xdd000000-0xdfffffff]
> [    9.328373] pci_bus 0000:00: resource 3 mem: [0x0a0000-0x0bffff]
> [    9.334378] pci_bus 0000:00: resource 4 mem: [0xc0000000-0xd9ffffff]
> [    9.340731] pci_bus 0000:00: resource 5 mem: [0xf0000000-0xffffffff]
> [    9.347084] pci_bus 0000:00: resource 6 mem: [0x840000000-0xfcffffffff]
> [    9.444440] pci_bus 0000:40: resource 0 io:  [0x5000-0x8fff]
> [    9.450099] pci_bus 0000:40: resource 1 io:  [0xf000-0xffff]
> [    9.455757] pci_bus 0000:40: resource 2 mem: [0xdb000000-0xdcffffff]
> [    9.498118] pci_bus 0000:80: resource 0 io:  [0x1000-0x4fff]
> [    9.503777] pci_bus 0000:80: resource 1 mem: [0xda000000-0xdaffffff]

It's interesting that many of the differences involve the legacy
VGA I/O ports in the 0x3b0-0x3df range.  My guess is that the AMD
chipset has special routing for those ranges.  If it didn't, it
would be difficult to support VGA devices under the other two
root bridges.  Maybe that VGA routing doesn't show up in the
bridge's PCI config space.  Can you tell from the ASL whether the
root bridge _SRS/_PRS/_CRS methods handle the VGA ranges specially?

One of the differences is that PCI config space shows a 64-bit region
(bus 0000:00 mem 0x840000000-0xfcffffffff) that doesn't show up in
the _CRS info.  But the _CRS parsing depends on acpi_resource_to_address64(),
which doesn't know about the ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64
descriptors added in ACPI 3.0.  So this difference could be a result
of that Linux bug.  It'd be interesting to see whether the test patch
below makes a difference.

The PCI config space region 0xf0000000-0xffffffff, also on bus 0000:00,
looks suspicious to me.  I thought that area contained a bunch of
BIOS-y things like reset vectors and local APICs.

Bjorn



diff --git a/drivers/acpi/acpica/rsxface.c b/drivers/acpi/acpica/rsxface.c
index 69a2aa5..dc2c5cb 100644
--- a/drivers/acpi/acpica/rsxface.c
+++ b/drivers/acpi/acpica/rsxface.c
@@ -62,8 +62,7 @@ ACPI_MODULE_NAME("rsxface")
 	ACPI_COPY_FIELD(out, in, minimum);                   \
 	ACPI_COPY_FIELD(out, in, maximum);                   \
 	ACPI_COPY_FIELD(out, in, translation_offset);        \
-	ACPI_COPY_FIELD(out, in, address_length);            \
-	ACPI_COPY_FIELD(out, in, resource_source);
+	ACPI_COPY_FIELD(out, in, address_length);
 /* Local prototypes */
 static acpi_status
 acpi_rs_match_vendor_resource(struct acpi_resource *resource, void *context);
@@ -328,6 +327,7 @@ acpi_resource_to_address64(struct acpi_resource *resource,
 {
 	struct acpi_resource_address16 *address16;
 	struct acpi_resource_address32 *address32;
+	struct acpi_resource_extended_address64 *address64;
 
 	if (!resource || !out) {
 		return (AE_BAD_PARAMETER);
@@ -356,6 +356,13 @@ acpi_resource_to_address64(struct acpi_resource *resource,
 			    sizeof(struct acpi_resource_address64));
 		break;
 
+	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
+
+		address64 = (struct acpi_resource_extended_address64 *)
+			&resource->data;
+		ACPI_COPY_ADDRESS(out, address64);
+		break;
+
 	default:
 		return (AE_BAD_PARAMETER);
 	}

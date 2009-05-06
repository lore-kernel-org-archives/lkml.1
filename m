Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbZEFWQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbZEFWQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761613AbZEFVzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:17 -0400
Received: from kroah.org ([198.145.64.141]:57411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761519AbZEFVzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:02 2009
Message-Id: <20090506214802.399677501@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 51/58] intel-iommu: Avoid panic() for DRHD at address zero.
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=intel-iommu-avoid-panic-for-drhd-at-address-zero.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

(cherry picked from commit e523b38e2f568af58baa13120a994cbf24e6dee0)

If the BIOS does something obviously stupid, like claiming that the
registers for the IOMMU are at physical address zero, then print a nasty
message and abort, rather than trying to set up the IOMMU and then later
panicking.

It's becoming more and more obvious that trusting this stuff to the BIOS
was a mistake.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/dmar.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -170,12 +170,21 @@ dmar_parse_one_drhd(struct acpi_dmar_hea
 	struct dmar_drhd_unit *dmaru;
 	int ret = 0;
 
+	drhd = (struct acpi_dmar_hardware_unit *)header;
+	if (!drhd->address) {
+		/* Promote an attitude of violence to a BIOS engineer today */
+		WARN(1, "Your BIOS is broken; DMAR reported at address zero!\n"
+		     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
+		     dmi_get_system_info(DMI_BIOS_VENDOR),
+		     dmi_get_system_info(DMI_BIOS_VERSION),
+		     dmi_get_system_info(DMI_PRODUCT_VERSION));
+		return -ENODEV;
+	}
 	dmaru = kzalloc(sizeof(*dmaru), GFP_KERNEL);
 	if (!dmaru)
 		return -ENOMEM;
 
 	dmaru->hdr = header;
-	drhd = (struct acpi_dmar_hardware_unit *)header;
 	dmaru->reg_base_addr = drhd->address;
 	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
 



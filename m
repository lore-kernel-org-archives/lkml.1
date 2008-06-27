Return-Path: <linux-kernel-owner+w=401wt.eu-S1764659AbYF0W7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764659AbYF0W7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761643AbYF0W6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:58:46 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:49061 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760074AbYF0W6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:44 -0400
Message-Id: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:56:51 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 00/28] PNP: convert fixed tables to lists, v4
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains all my PNP patches that are not yet in Linus'
tree, including both the "convert resource table to dynamic list" series
and the "convert resource options to unified dynamic list" series.

This fixes all checkpatch warnings except a "do not add new typedefs"
warning.  I kept the pnp_irq_mask_t typedef because I don't see a
better way to declare bitmaps in various places and pass around pointers
to them.

Len, I told you I was going to send incremental patches, but this is
a replacement instead.

Changes since v3:

    - Move IRQ test from pnpacpi_parse_irq_option() to
      pnpacpi_parse_ext_irq_option() (fixes "comparison is always true"
      warning noticed by David Howells)
    - Use pci_get_legacy_ide_irq(), not ATA_PRIMARY_IRQ()/ATA_SECONDARY_IRQ()
      (thanks to Bartlomiej Zolnierkiewicz)
    - Use snprintf() to make printks atomic
    - Fix checkpatch warnings (line length, "//" comments)

Here are the significant changes since the last posting:

    - When replacing pnp_resource_table, the PNPACPI resource encoders
      have to explicitly handle disabled resources; previously any
      unused slots in the table were implicitly disabled.  This should
      fix Jiri Slaby's oops on suspend/resume (though he hasn't tested
      this version).
      
      This change is in the patch titled "PNP: replace pnp_resource_table
      with dynamically allocated resources".
      
    - Added a new patch to keep disabled IRQ and DMA resources when parsing
      current config.  This fixes a bug in the current (2.6.25) PNPACPI
      code: consider a device with (mem, irq0, irq1, io), where irq0 is
      disabled.  If we drop irq0 when parsing the _CRS, we will mistakenly
      put irq1 in the irq0 slot when we encode resources for an _SRS call.

    - Added a new patch to avoid interrupts used by an IDE controller in
      compatibility mode.  https://bugzilla.novell.com/show_bug.cgi?id=375836

    - Added a new PNPACPI patch to support HP vendor-specific descriptors.
      This has long been supported by arch/ia64/kernel/acpi-ext.c, which
      provides an hp_acpi_csr_space() interface, but I think it's better
      and more generic to support it in PNPACPI.

Changes since v2 of "convert resource options to unified dynamic list":

    - fixed bisection problem in quirk_ad1815_mpu_resources()
    - fixed checkpatch warning in pnp_show_options()
      (pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch)
    - replaced pnp_independent_option() with literal 0
    - fixed coding style in pnp/manager.c
    - added EXPORT_SYMBOL(pnp_possible_config)
      (pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way-fix.patch)

Bjorn
-- 

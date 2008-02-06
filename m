Return-Path: <linux-kernel-owner+w=401wt.eu-S1763724AbYBGAKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763724AbYBGAKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764874AbYBFX5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:57:36 -0500
Received: from ns2.suse.de ([195.135.220.15]:60728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764854AbYBFX5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:57:34 -0500
Date: Wed, 6 Feb 2008 15:52:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch 34/73] ACPI: Not register gsi for PCI IDE controller in
	legacy mode
Message-ID: <20080206235255.GI13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-not-register-gsi-for-pci-ide-controller-in-legacy-mode.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

patch 96c2a8766bf4fe91abac863749c11637fabcc64f in mainline.

When PCI IDE controller works in legacy mode and no PRT entry is found
in ACPI PRT table, OSPM will neither read the irq number from the IDE
PCI configuration space nor call the function of acpi_register_gsi to
register gsi.

http://bugzilla.kernel.org/show_bug.cgi?id=5637

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/pci_irq.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -429,6 +429,15 @@ int acpi_pci_irq_enable(struct pci_dev *
 					  &polarity, &link,
 					  acpi_pci_allocate_irq);
 
+	if (irq < 0) {
+		/*
+		 * IDE legacy mode controller IRQs are magic. Why do compat
+		 * extensions always make such a nasty mess.
+		 */
+		if (dev->class >> 8 == PCI_CLASS_STORAGE_IDE &&
+				(dev->class & 0x05) == 0)
+			return 0;
+	}
 	/*
 	 * No IRQ known to the ACPI subsystem - maybe the BIOS / 
 	 * driver reported one, then use it. Exit in any case.

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbYG3Xfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbYG3Xfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759550AbYG3XfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:35:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:35629 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759108AbYG3XfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:35:17 -0400
Date: Wed, 30 Jul 2008 16:27:01 -0700
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
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jgarzik@redhat.com>,
       Alan Cox <alan@redhat.com>
Subject: [patch 09/29] pata_atiixp: Dont disable
Message-ID: <20080730232701.GJ30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pata_atiixp-don-t-disable.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Commit 05177f178efe1459d2d0ac05430027ba201889a4 upstream

pata_atiixp: Don't disable

A couple of distributions (Fedora, Ubuntu) were having weird problems with the
ATI IXP series PATA controllers being reported as simplex.  At the heart of
the problem is that both distros ignored the recommendations to load pata_acpi
and ata_generic *AFTER* specific host drivers.

The underlying cause however is that if you D3 and then D0 an ATI IXP it
helpfully throws away some configuration and won't let you rewrite it.

Add checks to ata_generic and pata_acpi to pin ATIIXP devices.  Possibly the
real answer here is to quirk them and pin them, but right now we can't do that
before they've been pcim_enable()'d by a driver.

I'm indebted to David Gero for this.  His bug report not only reported the
problem but identified the cause correctly and he had tested the right values
to prove what was going on

[If you backport this for 2.6.24 you will need to pull in the 2.6.25
removal of the bogus WARN_ON() in pcim_enagle]

Signed-off-by: Alan Cox <alan@redhat.com>
Tested-by: David Gero <davidg@havidave.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

---
 drivers/ata/ata_generic.c |    6 ++++++
 drivers/ata/pata_acpi.c   |    6 ++++++
 2 files changed, 12 insertions(+)

--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -193,6 +193,12 @@ static int ata_generic_init_one(struct p
 	if (dev->vendor == PCI_VENDOR_ID_AL)
 	    	ata_pci_clear_simplex(dev);
 
+	if (dev->vendor == PCI_VENDOR_ID_ATI) {
+		int rc = pcim_enable_device(dev);
+		if (rc < 0)
+			return rc;
+		pcim_pin_device(dev);
+	}
 	return ata_pci_init_one(dev, ppi);
 }
 
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -314,6 +314,12 @@ static int pacpi_init_one (struct pci_de
 		.port_ops	= &pacpi_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
+	if (pdev->vendor == PCI_VENDOR_ID_ATI) {
+		int rc = pcim_enable_device(pdev);
+		if (rc < 0)
+			return rc;
+		pcim_pin_device(pdev);
+	}
 	return ata_pci_init_one(pdev, ppi);
 }
 

-- 

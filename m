Return-Path: <linux-kernel-owner+w=401wt.eu-S1763399AbYGaAS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763399AbYGaAS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763272AbYGaARX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:17:23 -0400
Received: from mail.suse.de ([195.135.220.2]:39081 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763271AbYGaARW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:17:22 -0400
Date: Wed, 30 Jul 2008 16:59:08 -0700
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
       alan@lxorguk.ukuu.org.uk, Brice Goglin <brice@myri.com>
Subject: [patch 36/62] myri10ge: do not use mgp->max_intr_slots before
	loading the firmware
Message-ID: <20080730235908.GJ12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="myri10ge-do-not-use-mgp-max_intr_slots-before-loading-the-firmware.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Brice Goglin <brice@myri.com>

part of commit 0dcffac1a329be69bab0ac604bf7283737108e68 upstream
(the upstream multislice patch contains this fix within a large
 rework of the code since there is one rx_done ring per slice. The
 old allocating is replaced by a call to myri10ge_probe_slices())


Allocating the rx_done ring requires mgp->max_intr_slots to
be valid, which requires that we already loaded the firmware
we are going to use with this ring.
So move the allocating after myri10ge_load_firmware()
(but keep it before myri10ge_reset() which already needs the
 rx_done ring).

If fixedsa regression where loading the driver would not
appear to do anything. Regression introduced in 2.6.26-rc3 by
commit 014377a1df693ff30a9e8b69f0bbb0a38e601f75

Reported and patch tested by Lukas Hejtmanek at
http://lkml.org/lkml/2008/7/22/305
Reproduced and patch tested also by me.

Signed-off-by: Brice Goglin <brice@myri.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/myri10ge/myri10ge.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -3215,26 +3215,26 @@ static int myri10ge_probe(struct pci_dev
 	for (i = 0; i < ETH_ALEN; i++)
 		netdev->dev_addr[i] = mgp->mac_addr[i];
 
-	/* allocate rx done ring */
-	bytes = mgp->max_intr_slots * sizeof(*mgp->ss.rx_done.entry);
-	mgp->ss.rx_done.entry = dma_alloc_coherent(&pdev->dev, bytes,
-						&mgp->ss.rx_done.bus, GFP_KERNEL);
-	if (mgp->ss.rx_done.entry == NULL)
-		goto abort_with_ioremap;
-	memset(mgp->ss.rx_done.entry, 0, bytes);
-
 	myri10ge_select_firmware(mgp);
 
 	status = myri10ge_load_firmware(mgp);
 	if (status != 0) {
 		dev_err(&pdev->dev, "failed to load firmware\n");
-		goto abort_with_rx_done;
+		goto abort_with_ioremap;
 	}
 
+	/* allocate rx done ring */
+	bytes = mgp->max_intr_slots * sizeof(*mgp->ss.rx_done.entry);
+	mgp->ss.rx_done.entry = dma_alloc_coherent(&pdev->dev, bytes,
+						&mgp->ss.rx_done.bus, GFP_KERNEL);
+	if (mgp->ss.rx_done.entry == NULL)
+		goto abort_with_firmware;
+	memset(mgp->ss.rx_done.entry, 0, bytes);
+
 	status = myri10ge_reset(mgp);
 	if (status != 0) {
 		dev_err(&pdev->dev, "failed reset\n");
-		goto abort_with_firmware;
+		goto abort_with_rx_done;
 	}
 
 	pci_set_drvdata(pdev, mgp);
@@ -3260,7 +3260,7 @@ static int myri10ge_probe(struct pci_dev
 	 * is set to correct value if MSI is enabled */
 	status = myri10ge_request_irq(mgp);
 	if (status != 0)
-		goto abort_with_firmware;
+		goto abort_with_rx_done;
 	netdev->irq = pdev->irq;
 	myri10ge_free_irq(mgp);
 
@@ -3289,14 +3289,14 @@ static int myri10ge_probe(struct pci_dev
 abort_with_state:
 	pci_restore_state(pdev);
 
-abort_with_firmware:
-	myri10ge_dummy_rdma(mgp, 0);
-
 abort_with_rx_done:
 	bytes = mgp->max_intr_slots * sizeof(*mgp->ss.rx_done.entry);
 	dma_free_coherent(&pdev->dev, bytes,
 			  mgp->ss.rx_done.entry, mgp->ss.rx_done.bus);
 
+abort_with_firmware:
+	myri10ge_dummy_rdma(mgp, 0);
+
 abort_with_ioremap:
 	iounmap(mgp->sram);
 

-- 

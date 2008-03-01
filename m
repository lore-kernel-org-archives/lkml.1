Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbYCAQak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbYCAQak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763396AbYCAQ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:26:37 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:63619 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbYCAQ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:26:34 -0500
Date: Sat, 1 Mar 2008 11:26:33 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Karsten Keil <kkeil@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: [PATCH] hisax_fcpcipnp: move request_irq later in probe
Message-ID: <20080301162633.GA18883@phobos.i.cabal.ca>
References: <47C8972B.10602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C8972B.10602@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a quick glance at the code, we're getting the DEBUG_SHIRQ spurious
interrupt before we have the adapter template filled in. Real interrupts
appear to be turned on by fcpci*_init(), so move request_irq until just
before that.

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>

---
diff --git a/drivers/isdn/hisax/hisax_fcpcipnp.c b/drivers/isdn/hisax/hisax_fcpcipnp.c
index 7993e01..76043de 100644
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c
+++ b/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -725,23 +725,6 @@ static int __devinit fcpcipnp_setup(struct fritz_adapter *adapter)
 
 	switch (adapter->type) {
 	case AVM_FRITZ_PCIV2:
-		retval = request_irq(adapter->irq, fcpci2_irq, IRQF_SHARED,
-				     "fcpcipnp", adapter);
-		break;
-	case AVM_FRITZ_PCI:
-		retval = request_irq(adapter->irq, fcpci_irq, IRQF_SHARED,
-				     "fcpcipnp", adapter);
-		break;
-	case AVM_FRITZ_PNP:
-		retval = request_irq(adapter->irq, fcpci_irq, 0,
-				     "fcpcipnp", adapter);
-		break;
-	}
-	if (retval)
-		goto err_region;
-
-	switch (adapter->type) {
-	case AVM_FRITZ_PCIV2:
 	case AVM_FRITZ_PCI:
 		val = inl(adapter->io);
 		break;
@@ -796,6 +779,23 @@ static int __devinit fcpcipnp_setup(struct fritz_adapter *adapter)
 
 	switch (adapter->type) {
 	case AVM_FRITZ_PCIV2:
+		retval = request_irq(adapter->irq, fcpci2_irq, IRQF_SHARED,
+				     "fcpcipnp", adapter);
+		break;
+	case AVM_FRITZ_PCI:
+		retval = request_irq(adapter->irq, fcpci_irq, IRQF_SHARED,
+				     "fcpcipnp", adapter);
+		break;
+	case AVM_FRITZ_PNP:
+		retval = request_irq(adapter->irq, fcpci_irq, 0,
+				     "fcpcipnp", adapter);
+		break;
+	}
+	if (retval)
+		goto err_region;
+
+	switch (adapter->type) {
+	case AVM_FRITZ_PCIV2:
 		fcpci2_init(adapter);
 		isacsx_setup(&adapter->isac);
 		break;

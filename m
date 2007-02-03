Return-Path: <linux-kernel-owner+w=401wt.eu-S1946286AbXBCCnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946286AbXBCCnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946283AbXBCCmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:42:44 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53499 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946276AbXBCCml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:42:41 -0500
Message-Id: <20070203024522.492330000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:50 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "ethanhsiao@jmicron.com" <ethanhsiao@jmicron.com>,
       Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Andrew Morton <akpm@osdl.org>, Chuck Ebbert <cebbert@redhat.com>
Subject: [patch 46/59] jmicron: 40/80pin primary detection
Content-Disposition: inline; filename=jmicron-40-80pin-primary-detection.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: ethanhsiao@jmicron.com <ethanhsiao@jmicron.com>

jmicron module detects all JMB36x as JMB361 and PATA0 has wrong pin status
of XICBLID.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

cebbert@redhat.com: I folded in the warning fix (a51545ab25) because
otherwise it makes the tester think the patch caused the warning
that was already there.

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/ide/pci/jmicron.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- linux-2.6.19.2.orig/drivers/ide/pci/jmicron.c
+++ linux-2.6.19.2/drivers/ide/pci/jmicron.c
@@ -86,15 +86,16 @@ static int __devinit ata66_jmicron(ide_h
 	{
 	case PORT_PATA0:
 		if (control & (1 << 3))	/* 40/80 pin primary */
-			return 1;
-		return 0;
+			return 0;
+		return 1;
 	case PORT_PATA1:
 		if (control5 & (1 << 19))	/* 40/80 pin secondary */
 			return 0;
 		return 1;
 	case PORT_SATA:
-		return 1;
+		break;
 	}
+	return 1; /* Avoid bogus "control reaches end of non-void function" */
 }
 
 static void jmicron_tuneproc (ide_drive_t *drive, byte mode_wanted)
@@ -240,11 +241,11 @@ static int __devinit jmicron_init_one(st
 }
 
 static struct pci_device_id jmicron_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361), 0},
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363), 1},
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365), 2},
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366), 3},
-	{ PCI_DEVICE(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368), 4},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 2},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 3},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
 	{ 0, },
 };
 

--

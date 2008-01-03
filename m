Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYACV7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYACV7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYACV6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:58:34 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11152 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752638AbYACV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:58:30 -0500
Date: Thu, 03 Jan 2008 14:29:40 -0700
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/4] drivers-edac-pci-broken-parity-regression
Message-ID: <477d53c4.o3h/SVR7MjSDUKwy%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Bryan Boatright <b1@omega71.com>

Using the EDAC code in kernel.org kernel version 2.6.23.8 I am seeing the
following problem:

    In the kernel there is a pci device attribute located in sysfs that is
    checked by the EDAC PCI scanning code. If that attribute is set,
    PCI parity/error scannining is skipped for that device. The attribute
    is:

            broken_parity_status

    as is located in /sys/devices/pci<XXX>/0000:XX:YY.Z directorys for
    PCI devices.


I don't think this check was actually implemented.  I have a misbehaved card
that reports a parity error every 1000 ms:

Nov 25 07:28:43 beta kernel: EDAC PCI: Master Data Parity Error on 0000:05:01.0
Nov 25 07:28:44 beta kernel: EDAC PCI: Master Data Parity Error on 0000:05:01.0
Nov 25 07:28:45 beta kernel: EDAC PCI: Master Data Parity Error on 0000:05:01.0

Setting that card's broken_parity_status bit did not mask the error:

echo "1" > /sys/bus/pci/devices/0000:05:01.0/broken_parity_status


I looked through the EDAC code and did not readily see any reference to
broken_parity_status at all (which makes sense based on the behavior I am
seeing).  I applied the following patch as a proof-of-concept and now EDAC's
PCI parity error reporting behaves as documented:

bryan

Good regression find, bryan. It used to work. sigh.
I added more logic to your patch, for more coverage of the error.

Doug T

Signed-off-by:	Bryan Boatright <b1@omega71.com>
Signed-off-by:	Doug Thompson <dougthompson@xmisson.com>
---
 edac_pci_sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc6-mm1/drivers/edac/edac_pci_sysfs.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/drivers/edac/edac_pci_sysfs.c
+++ linux-2.6.24-rc6-mm1/drivers/edac/edac_pci_sysfs.c
@@ -558,8 +558,10 @@ static void edac_pci_dev_parity_test(str
 
 	debugf4("PCI STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
 
-	/* check the status reg for errors */
-	if (status) {
+	/* check the status reg for errors on boards NOT marked as broken
+	 * if broken, we cannot trust any of the status bits
+	 */
+	if (status && !dev->broken_parity_status) {
 		if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 			edac_printk(KERN_CRIT, EDAC_PCI,
 				"Signaled System Error on %s\n",
@@ -593,8 +595,10 @@ static void edac_pci_dev_parity_test(str
 
 		debugf4("PCI SEC_STATUS= 0x%04x %s\n", status, dev->dev.bus_id);
 
-		/* check the secondary status reg for errors */
-		if (status) {
+		/* check the secondary status reg for errors,
+		 * on NOT broken boards
+		 */
+		if (status && !dev->broken_parity_status) {
 			if (status & (PCI_STATUS_SIG_SYSTEM_ERROR)) {
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
 					"Signaled System Error on %s\n",

Return-Path: <linux-kernel-owner+w=401wt.eu-S1422830AbXCGRse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422830AbXCGRse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbXCGRO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:43030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422787AbXCGROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:46 -0500
Message-Id: <20070307171306.385694813@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Guilherme Salgado <gsalgado@gmail.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 033/101] UHCI: fix port resume problem
Content-Disposition: inline; filename=uhci-fix-port-resume-problem.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as863) fixes a problem encountered sometimes when resuming
a port on a UHCI controller.  The hardware may turn off the
Resume-Detect bit before turning off the Suspend bit, leading usbcore
to think that the port is still suspended and the resume has failed.
The patch makes uhci_finish_suspend() wait until both bits are safely
off.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/uhci-hub.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- linux-2.6.20.1.orig/drivers/usb/host/uhci-hub.c
+++ linux-2.6.20.1/drivers/usb/host/uhci-hub.c
@@ -33,6 +33,9 @@ static __u8 root_hub_hub_des[] =
 /* status change bits:  nonzero writes will clear */
 #define RWC_BITS	(USBPORTSC_OCC | USBPORTSC_PEC | USBPORTSC_CSC)
 
+/* suspend/resume bits: port suspended or port resuming */
+#define SUSPEND_BITS	(USBPORTSC_SUSP | USBPORTSC_RD)
+
 /* A port that either is connected or has a changed-bit set will prevent
  * us from AUTO_STOPPING.
  */
@@ -96,8 +99,8 @@ static void uhci_finish_suspend(struct u
 	int status;
 	int i;
 
-	if (inw(port_addr) & (USBPORTSC_SUSP | USBPORTSC_RD)) {
-		CLR_RH_PORTSTAT(USBPORTSC_SUSP | USBPORTSC_RD);
+	if (inw(port_addr) & SUSPEND_BITS) {
+		CLR_RH_PORTSTAT(SUSPEND_BITS);
 		if (test_bit(port, &uhci->resuming_ports))
 			set_bit(port, &uhci->port_c_suspend);
 
@@ -107,7 +110,7 @@ static void uhci_finish_suspend(struct u
 		 * Experiments show that some controllers take longer, so
 		 * we'll poll for completion. */
 		for (i = 0; i < 10; ++i) {
-			if (!(inw(port_addr) & USBPORTSC_RD))
+			if (!(inw(port_addr) & SUSPEND_BITS))
 				break;
 			udelay(1);
 		}
@@ -289,7 +292,7 @@ static int uhci_hub_control(struct usb_h
 			wPortStatus |= USB_PORT_STAT_CONNECTION;
 		if (status & USBPORTSC_PE) {
 			wPortStatus |= USB_PORT_STAT_ENABLE;
-			if (status & (USBPORTSC_SUSP | USBPORTSC_RD))
+			if (status & SUSPEND_BITS)
 				wPortStatus |= USB_PORT_STAT_SUSPEND;
 		}
 		if (status & USBPORTSC_OC)

--

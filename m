Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZCFLwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZCFLwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZCFLwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:52:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:31674 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbZCFLwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:52:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=mINezP0eIu+qKOfMPlw4KBmc1UdeGmDVoGX3dJ3wCKMZG1orM1Qn96tVzCNsFXcZcV
         B1PuI6FKH7+wGY7LVPBDpuUQ7yAHvoGtZMB7Ue5amjgXGXEbGQG8ZYsYSCboJptjLFJ1
         cel0QKDRZLLowIKW4HbUzov91aJcedbn44G9I=
Subject: usb/host/pci-quirks: Add option for setting handoff timeout for
 ehci
From: Martin Bammer <mrbm74@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 06 Mar 2009 12:52:35 +0100
Message-Id: <1236340355.16732.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When having a buggy BIOS which doesn't do ehci handoff correctly a 8s
boot delay is the result. This patch adds a kernel command line
parameter ehci_ho_to to be able to set an arbitrary timeout. On my
netbook I've set it to 50 which works without any problems. Maybe the
patch would be interesting for others?

--- a/drivers/usb/host/pci-quirks.c	2009-03-03 23:35:15.000000000 +0100
+++ b/drivers/usb/host/pci-quirks.c	2009-03-04 00:00:37.000000000 +0100
@@ -51,6 +51,7 @@
 #define EHCI_USBLEGCTLSTS	4		/* legacy control/status */
 #define EHCI_USBLEGCTLSTS_SOOE	(1 << 13)	/* SMI on ownership change */
 
+int ehci_ho_to = 5000;
 
 /*
  * Make sure the controller is completely inactive, unable to
@@ -209,6 +210,17 @@ static void __devinit quirk_usb_handoff_
 	iounmap(base);
 }
 
+int __init ehci_ho_to_setup(char *str)
+{
+	if (str != NULL && *str != '\0') {
+		ehci_ho_to = simple_strtol(str, NULL, 0);
+		if (ehci_ho_to < 10) ehci_ho_to = 10;
+	}
+	return 1;
+}
+
+__setup("ehci_ho_to=", ehci_ho_to_setup);
+
 static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
 {
 	int wait_time, delta;
@@ -271,7 +283,7 @@ static void __devinit quirk_usb_disable_
 			/* if boot firmware now owns EHCI, spin till
 			 * it hands it over.
 			 */
-			msec = 5000;
+			msec = ehci_ho_to;
 			while ((cap & EHCI_USBLEGSUP_BIOS) && (msec > 0)) {
 				tried_handoff = 1;
 				msleep(10);



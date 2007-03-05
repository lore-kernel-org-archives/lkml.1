Return-Path: <linux-kernel-owner+w=401wt.eu-S933592AbXCEV06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbXCEV06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933601AbXCEV06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:26:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:37238 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933592AbXCEV05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:26:57 -0500
X-Provags-ID: V01U2FsdGVkX1+Zlbof9lWZOeP1l26Qri4t6D1HhG3pD9XcJq14Al
	I+47ABqNirbPhr
From: Tobias Rupf <tobias.rupf@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: pci_set_power_state prints a lot of error messages, patch included
Date: Mon, 5 Mar 2007 22:27:12 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703052227.12864@trupf>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1. summary: ci_set_power_state prints a lot of error messages
2. description
KDE running with knemo enabled I get a lot of kprint error message if I switch 
with CTRL-ALT-F1 to a text console, whicht make the terminal nearly unusable.
The message is: 

[17179664.636000] pci_set_power_state(): 0000:00:0a.0: state=3, current 
state=5
[17179665.744000] pci_set_power_state(): 0000:00:0a.0: state=3, current 
state=5
[17179666.608000] pci_set_power_state(): 0000:00:0a.0: state=3, current 
state=5
....

The problem seem not to be KDE-specific as reported here for Gnome:
http://lists.debian.org/debian-user/2006/11/msg00906.html. As far as I have 
seen from some research on the Internet this problem does only occur with the 
below mentioned card an only if a network monitor program is activ.

relevant output of lspci -vvv:

00:0a.0 Ethernet controller: 3Com Corporation 3c905 100BaseTX [Boomerang]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (750ns min, 2000ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at dc00 [size=64]
        [virtual] Expansion ROM at 20000000 [disabled] [size=64K]

This card does not support any power saving features, but the driver seems to 
claim the card is in state d5 (does such sate exist at all?) 

3. Keywords:
pci_set_power_state, 3Com, Boomerang
4. kernel version
linux version 2.6.18.1-kanotix-1 (root@lisa) (gcc version 4.1.2 20060928 
(prerelease) (Ubuntu 4.1.1-13ubuntu5)) #1 SMP PREEMPT Thu Mar 1 19:34:45 CET 
2007
The problem still exists in kernel version 2.6.20, I don't know about 2.6.21.

5. output
pci_set_power_state(): 0000:00:0a.0: state=3, current state=5
.....
8.Fix / Patch
With the help of the Internet I have prepared a patch, which will check the 
capabilities of the device before doing any other stuff, even before printing 
the error message. This has solved the problem for me.
It will just change the order of some lines.

--- a/drivers/pci/pci.c	2006-09-20 05:42:06.000000000 +0200
+++ b/drivers/pci/pci.c	2007-02-11 09:54:00.000000000 +0100
@@ -303,17 +303,6 @@
 	if (state > PCI_D3hot)
 		state = PCI_D3hot;
 
-	/* Validate current state:
-	 * Can enter D0 from any state, but if we can only go deeper 
-	 * to sleep if we're already in a low power state
-	 */
-	if (state != PCI_D0 && dev->current_state > state) {
-		printk(KERN_ERR "%s(): %s: state=%d, current state=%d\n",
-			__FUNCTION__, pci_name(dev), state, dev->current_state);
-		return -EINVAL;
-	} else if (dev->current_state == state)
-		return 0;        /* we're already there */
-
 	/*
 	 * If the device or the parent bridge can't support PCI PM, ignore
 	 * the request if we're doing anything besides putting it into D0
@@ -337,6 +326,17 @@
 		return -EIO;
 	}
 
+	/* Validate current state:
+	 * Can enter D0 from any state, but if we can only go deeper 
+	 * to sleep if we're already in a low power state
+	 */
+	if (state != PCI_D0 && dev->current_state > state) {
+		printk(KERN_ERR "%s(): %s: state=%d, current state=%d\n",
+			__FUNCTION__, pci_name(dev), state, dev->current_state);
+		return -EINVAL;
+	} else if (dev->current_state == state)
+		return 0;        /* we're already there */
+
 	/* check if this device supports the desired state */
 	if (state == PCI_D1 && !(pmc & PCI_PM_CAP_D1))
 		return -EIO;



with kind regards

T. Rupf

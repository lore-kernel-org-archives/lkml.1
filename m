Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZBNPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZBNPMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 10:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbZBNPMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 10:12:10 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:56745 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZBNPMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 10:12:09 -0500
Date: Sat, 14 Feb 2009 16:12:00 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Subject: [PATCH 1/1] net: forcedeth:
	f55c21fd9a92a444e55ad1ca4e4732d56661bf2e caused wake-on-lan
	regression
Message-ID: <20090214151200.GA5496@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Ayaz Abdulla <aabdulla@nvidia.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>, Jeff Garzik <jeff@garzik.org>,
	Philipp Matthias Hahn <pmhahn@titan.lahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f55c21fd9a92a444e55ad1ca4e4732d56661bf2e, which was
introduced to fix the regression tracked at
http://bugzilla.kernel.org/show_bug.cgi?id=11358
causes the wake-on-lan mac to be reversed in the shutdown path.
Apparently the forcedeth situation is rather messy in that the mac
we need to writeback for a subsequent modprobe to work is exactly
the reverse of what is needed for proper wake-on-lan.

The following patch explains the situation in the comments and
makes the call to nv_restore_mac_addr() conditional (only called if
we are not really going for poweroff).

Tobias Diedrich wrote:
> Hmm, I had not tried WOL for some time.
> With 2.6.29-rc3 is see the following behaviour:
> 
> State            WOL Behaviour
> ------------------------------
> shutdown         reversed MAC
> disk/shutdown    reversed MAC
> disk/platform    OK
> 
> Apparently nv_restore_mac_addr() restores the MAC in the wrong order
> for WOL (at least for my PCI_DEVICE_ID_NVIDIA_NVENET_15).  platform
> works, because the MAC is not touched in the nv_suspend() path.
> 
> A possible fix might be to only call nv_restore_mac_addr() if
> system_state != SYSTEM_POWER_OFF.

With the following patch:
shutdown         OK
disk/shutdown    OK
disk/platform    OK
kexec            OK

Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Tested-by: Philipp Matthias Hahn <pmhahn@titan.lahn.de>

Index: linux-2.6.29-rc3/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.29-rc3.orig/drivers/net/forcedeth.c	2009-02-08 16:31:29.000000000 +0100
+++ linux-2.6.29-rc3/drivers/net/forcedeth.c	2009-02-08 16:39:58.000000000 +0100
@@ -6011,9 +6011,20 @@
 	if (netif_running(dev))
 		nv_close(dev);
 
-	nv_restore_mac_addr(pdev);
+	/*
+	 * Restore the MAC so a kernel started by kexec won't get confused.
+	 * If we really go for poweroff, we must not restore the MAC,
+	 * otherwise the MAC for WOL will be reversed at least on some boards.
+	 */
+	if (system_state != SYSTEM_POWER_OFF) {
+		nv_restore_mac_addr(pdev);
+	}
 
 	pci_disable_device(pdev);
+	/*
+	 * Apparently it is not possible to reinitialise from D3 hot,
+	 * only put the device into D3 if we really go for poweroff.
+	 */
 	if (system_state == SYSTEM_POWER_OFF) {
 		if (pci_enable_wake(pdev, PCI_D3cold, np->wolenabled))
 			pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。

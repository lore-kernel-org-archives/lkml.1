Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZBHQve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZBHQve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 11:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZBHQvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 11:51:25 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:41198 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZBHQvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 11:51:24 -0500
Date: Sun, 8 Feb 2009 17:52:17 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Jeff Garzik <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WOL with forcedeth broken since
	f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Message-ID: <20090208165217.GA3003@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090129063118.GA3586@pmhahn.de> <20090208151813.GA6941@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090208151813.GA6941@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Philipp Matthias Hahn wrote:
> > Somewhere between 2.6.26 and 2.6.27 WOL stopped working on my MS-7350
> > motherboard with an "nVidia Corporation MCP51 Ethernet Controller (rev a3)".
> > 	"etherwake 00:19:db:f2:e1:35" did not work
> > 	"etherwake 35:e1:f2:db:19:00" did work
> > Since I did a BIOS update during the same time window I (wrongly) put
> > the fault on the BIOS. (See /sys/class/dmi/id/modalias for yourself:
> > dmi:bvnAmericanMegatrendsInc.:bvrV1.7:bd07/29/2008:svnMSI:pnMS-7350:pvr1.0:rvnMSI:rnMS-7350:rvr1.0:cvnToBeFilledByO.E.M.:ct3:cvrToBeFilledByO.E.M.:
> > )
> 
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

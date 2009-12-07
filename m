Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbZLGAPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbZLGAPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbZLGAOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:35 -0500
Received: from kroah.org ([198.145.64.141]:34817 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934387AbZLGAOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:00 2009
Message-Id: <20091207000700.711075465@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: [115/119] PCI: Prevent AER driver from being loaded on non-root port PCIE devices
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=pci-prevent-aer-driver-from-being-loaded-on-non-root-port-pcie-devices.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit 30fc24b5cbc55f9e6c686e2710cc812419bddc0c upstream.

A bug was seen on boards using a PLX 8518 switch device which advertises
AER on each of it's transparent bridges. The AER driver was loaded for
each bridge and this driver tried to access the AER source ID register
whenever an interrupt occured on the shared PCI INTX lines. The source
ID register does not exist on non root port PCIE device's  which
advertise AER and trying to access this register causes a unsupported
request error on the bridge. Thus, when the next interrupt occurs,
another error is found and the non existent source ID register is
accessed again, and so it goes on.

The result is a spammed dmesg with unsupported request PCI express
errors on the bridge device that the AER driver is loaded against.

Reported-by: Malcolm Crossley <malcolm.crossley2@gefanuc.com>
Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Malcolm Crossley <malcolm.crossley2@gefanuc.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aer/aerdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -52,7 +52,7 @@ static struct pci_error_handlers aer_err
 
 static struct pcie_port_service_driver aerdriver = {
 	.name		= "aer",
-	.port_type	= PCIE_ANY_PORT,
+	.port_type	= PCIE_RC_PORT,
 	.service	= PCIE_PORT_SERVICE_AER,
 
 	.probe		= aer_probe,



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZBUEP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZBUEP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 23:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZBUEPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 23:15:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45222 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZBUEPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 23:15:49 -0500
To: jbarnes@virtuousgeek.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1ocx5ve8o.fsf@fess.ebiederm.org>
	<200902192247.46370.rjw@sisk.pl> <m13aeaxaw0.fsf@fess.ebiederm.org>
	<200902201153.52683.rjw@sisk.pl>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 20 Feb 2009 20:16:07 -0800
In-Reply-To: <200902201153.52683.rjw@sisk.pl> (Rafael J. Wysocki's message of "Fri\, 20 Feb 2009 11\:53\:52 +0100")
Message-ID: <m1r61s2znc.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, rjw@sisk.pl, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;jbarnes@virtuousgeek.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] pcie_portdriver: FIX: pcie_port_device_remove (take 2)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pcie_port_device_remove currently calls the remove method of port
drivers twice.  Ouch!

We are calling device_for_each_child multiple times for no apparent
reason.

So make it simple. Place put_device and device_unregister into
remove_iter, and throw out the rest.  Only call device_for_each_child
once.

The code is simpler and actually works!

Changelog:
v2 rebase against the linux-next tree so I don't conflict with Rafael's
   irq work, and remove the irq handling cleanups as Rafael's patch already
   made them.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---

 drivers/pci/pcie/portdrv_core.c |   23 +++--------------------
 1 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 3aea92a..569af00 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -456,16 +456,9 @@ int pcie_port_device_resume(struct pci_dev *dev)
 
 static int remove_iter(struct device *dev, void *data)
 {
-	struct pcie_port_service_driver *service_driver;
-
 	if (dev->bus == &pcie_port_bus_type) {
-		if (dev->driver) {
-			service_driver = to_service_driver(dev->driver);
-			if (service_driver->remove)
-				service_driver->remove(to_pcie_device(dev));
-		}
-		*(unsigned long*)data = (unsigned long)dev;
-		return 1;
+		put_device(dev);
+		device_unregister(dev);
 	}
 	return 0;
 }
@@ -480,18 +473,8 @@ static int remove_iter(struct device *dev, void *data)
 void pcie_port_device_remove(struct pci_dev *dev)
 {
 	struct pcie_port_data *port_data = pci_get_drvdata(dev);
-	int status;
-
-	do {
-		unsigned long device_addr;
 
-		status = device_for_each_child(&dev->dev, &device_addr, remove_iter);
-		if (status) {
-			struct device *device = (struct device*)device_addr;
-			put_device(device);
-			device_unregister(device);
-		}
-	} while (status);
+	device_for_each_child(&dev->dev, NULL, remove_iter);
 
 	switch (port_data->port_irq_mode) {
 	case PCIE_PORT_MSIX_MODE:
-- 
1.6.0.6


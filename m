Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYHQG0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYHQG0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 02:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYHQG0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 02:26:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:44805 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYHQG0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 02:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H+mgpv5FMdt4Yw0vN3hIEuCpuWcJ5G0XTz2IT3Fp0hRy/mp7mjOT8i2cJpcRhv+nwy
         dA3WLEf1PXwIYKexcToBfDT0ejL4ql8wAM5esWyNP7U2QRFae7UOVsUhvNxNzpRFrkx3
         fsq5K8IqRLphcu9AMMQefHw5ZRlwqqJDQZfqE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jeff Garzik <jgarzik@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] net: forcedeth use pci_choose_state instead of PCI_D3hot - v2
Date: Sat, 16 Aug 2008 23:25:33 -0700
Message-Id: <1218954333-12819-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after

| commit f735a2a1a4f2a0f5cd823ce323e82675990469e2
| Author: Tobias Diedrich <ranma+kernel@tdiedrich.de>
| Date:   Sun May 18 15:02:37 2008 +0200
|
|    [netdrvr] forcedeth: setup wake-on-lan before shutting down
|
|    When hibernating in 'shutdown' mode, after saving the image the suspend hook
|    is not called again.
|    However, if the device is in promiscous mode, wake-on-lan will not work.
|    This adds a shutdown hook to setup wake-on-lan before the final shutdown.
|
|    Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
|    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

my servers with nvidia mcp55 nic doesn't work with msi in second kernel by kexec

after remove pci_set_power_state(, PCI_D3hot) that nic/msi will work again.

check with e1000 is using pci_choose_state in _shutdown.

So change that pci_choose_state(pdev, ...), and it works.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/net/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/net/forcedeth.c
===================================================================
--- linux-2.6.orig/drivers/net/forcedeth.c
+++ linux-2.6/drivers/net/forcedeth.c
@@ -5988,7 +5988,7 @@ static void nv_shutdown(struct pci_dev *
 	pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
 	pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
 	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
+	pci_set_power_state(pdev, pci_choose_state(pdev, PMSG_SUSPEND));
 }
 #else
 #define nv_suspend NULL

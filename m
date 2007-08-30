Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXH3D2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXH3D2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbXH3D2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:28:13 -0400
Received: from mail.queued.net ([207.210.101.209]:1795 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbXH3D2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:28:12 -0400
Date: Wed, 29 Aug 2007 23:30:14 -0400
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: akpm@linux-foundation.org, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: [PATCH 3/5] ALSA: cs5535audio: update PCI device handling in
 suspend/resume
Message-Id: <20070829233014.6c885eb0.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Save the PCI state before disabling the device, and add some error checking.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 sound/pci/cs5535audio/cs5535audio_pm.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_pm.c b/sound/pci/cs5535audio/cs5535audio_pm.c
index 9a4e84a..838708f 100644
--- a/sound/pci/cs5535audio/cs5535audio_pm.c
+++ b/sound/pci/cs5535audio/cs5535audio_pm.c
@@ -74,8 +74,11 @@ int snd_cs5535audio_suspend(struct pci_dev *pci, pm_message_t state)
 	/* save important regs, then disable aclink in hw */
 	snd_cs5535audio_stop_hardware(cs5535au);
 
+	if (pci_save_state(pci)) {
+		printk(KERN_ERR "cs5535audio: pci_save_state failed!\n");
+		return -EIO;
+	}
 	pci_disable_device(pci);
-	pci_save_state(pci);
 	pci_set_power_state(pci, pci_choose_state(pci, state));
 	return 0;
 }
@@ -89,7 +92,12 @@ int snd_cs5535audio_resume(struct pci_dev *pci)
 	int i;
 
 	pci_set_power_state(pci, PCI_D0);
-	pci_restore_state(pci);
+	if (pci_restore_state(pci) < 0) {
+		printk(KERN_ERR "cs5535audio: pci_restore_state failed, "
+		       "disabling device\n");
+		snd_card_disconnect(card);
+		return -EIO;
+	}
 	if (pci_enable_device(pci) < 0) {
 		printk(KERN_ERR "cs5535audio: pci_enable_device failed, "
 		       "disabling device\n");

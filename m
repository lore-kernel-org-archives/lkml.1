Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbZHSJjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbZHSJjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZHSJjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:39:02 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:25819 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZHSJjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:39:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SXO5/gjvKexU8TfkxxI5R9v9XCwKnd8cSbm/xa6L4XDYWs++UrshAXw2/x+lG50ViJ
         59+hYmW3U1Aifq2aK46VkWehnXOBcejXzRi9m44ljh9bRlTQsGXbCowPZyg0zSkhI2ac
         9D9/CyoUB9m/sRBU8kUM/+g2chceGN6/qrwG4=
Message-ID: <4A8BC831.8050708@tuffmail.co.uk>
Date: Wed, 19 Aug 2009 10:38:57 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] eeepc-laptop: fix rfkill memory leak on unload
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill_unregister() should always be followed by rfkill_destroy()

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/eeepc-laptop.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 1c94860..36d613b 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -981,6 +981,7 @@ static void eeepc_rfkill_exit(void)
 	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
 	if (ehotk->wlan_rfkill) {
 		rfkill_unregister(ehotk->wlan_rfkill);
+		rfkill_destroy(ehotk->wlan_rfkill);
 		ehotk->wlan_rfkill = NULL;
 	}
 	/*
@@ -991,10 +992,14 @@ static void eeepc_rfkill_exit(void)
 	if (ehotk->hotplug_slot)
 		pci_hp_deregister(ehotk->hotplug_slot);
 
-	if (ehotk->bluetooth_rfkill)
+	if (ehotk->bluetooth_rfkill) {
 		rfkill_unregister(ehotk->bluetooth_rfkill);
-	if (ehotk->wwan3g_rfkill)
+		rfkill_destroy(ehotk->bluetooth_rfkill);
+	}
+	if (ehotk->wwan3g_rfkill) {
 		rfkill_unregister(ehotk->wwan3g_rfkill);
+		rfkill_destroy(ehotk->wwan3g_rfkill);
+	}
 }
 



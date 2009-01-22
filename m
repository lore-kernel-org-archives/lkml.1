Return-Path: <linux-kernel-owner+w=401wt.eu-S1760710AbZAVR5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbZAVR5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761699AbZAVR4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:56:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:3112 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761678AbZAVR4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:56:42 -0500
X-IronPort-AV: E=Sophos;i="4.37,307,1231131600"; 
   d="scan'208";a="36800697"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>, Milton Miller <miltonm@bga.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] HVC: do not request the irq twice.
Date: Thu, 22 Jan 2009 17:56:08 +0000
Message-Id: <1232646968-32671-1-git-send-email-Ian.Campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 22 Jan 2009 17:56:40.0829 (UTC) FILETIME=[C76C3AD0:01C97CBA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise:
  root@bogga:~# tty
  /dev/hvc0
  root@bogga:~# reboot


  Broadcast message from root@bogga (hvc0) (Thu Jan 22 17:51:20 2009):

  The system is going down for reboot NOW!
  INIT: Switching to runlevel: 6
  INIT: Sending processes the TERM signal
  hvc_open: request_irq failed with rc -16.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Milton Miller <miltonm@bga.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hvc_irq.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/hvc_irq.c b/drivers/char/hvc_irq.c
index 2623e17..8152a13 100644
--- a/drivers/char/hvc_irq.c
+++ b/drivers/char/hvc_irq.c
@@ -28,6 +28,10 @@ int notifier_add_irq(struct hvc_struct *hp, int irq)
 		hp->irq_requested = 0;
 		return 0;
 	}
+
+	if (hp->irq_requested)
+		return 0;
+
 	rc = request_irq(irq, hvc_handle_interrupt, IRQF_DISABLED,
 			   "hvc_console", hp);
 	if (!rc)
-- 
1.5.6.5


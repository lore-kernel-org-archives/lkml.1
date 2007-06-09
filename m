Return-Path: <linux-kernel-owner+w=401wt.eu-S1032607AbXFIAH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032607AbXFIAH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968173AbXFIAE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:04:58 -0400
Received: from mx1.suse.de ([195.135.220.2]:33942 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968606AbXFIAE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:04:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 9/9] OHCI: Fix machine check in ohci_hub_status_data
Date: Fri,  8 Jun 2007 17:03:54 -0700
Message-Id: <1181347501667-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <11813474933434-git-send-email-gregkh@suse.de>
References: <20070609000312.GA17574@kroah.com>
 <11813474343815-git-send-email-gregkh@suse.de>
 <1181347441440-git-send-email-gregkh@suse.de>
 <11813474492376-git-send-email-gregkh@suse.de>
 <118134746039-git-send-email-gregkh@suse.de>
 <11813474672336-git-send-email-gregkh@suse.de>
 <11813474771075-git-send-email-gregkh@suse.de>
 <11813474852263-git-send-email-gregkh@suse.de>
 <11813474933434-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as901) fixes an oversight in ohci-hcd.  The
hub_status_data routine must not try to access the controller's
memory-mapped registers if the controller is in a low-power state;
such attempts will cause a crash on some architectures (such as PPC).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/host/ohci-hub.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
index 216c9c9..bb9cc59 100644
--- a/drivers/usb/host/ohci-hub.c
+++ b/drivers/usb/host/ohci-hub.c
@@ -417,6 +417,8 @@ ohci_hub_status_data (struct usb_hcd *hcd, char *buf)
 	unsigned long	flags;
 
 	spin_lock_irqsave (&ohci->lock, flags);
+	if (!test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags))
+		goto done;
 
 	/* undocumented erratum seen on at least rev D */
 	if ((ohci->flags & OHCI_QUIRK_AMD756)
-- 
1.5.2.1


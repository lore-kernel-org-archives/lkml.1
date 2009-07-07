Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZGGOIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZGGOIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbZGGOIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:08:00 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:36590 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbZGGOH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:07:59 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Tue, 7 Jul 2009 16:08:10 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Michael S. Zick" <lkml@morethan.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <200907051720.45819.lkml@morethan.org> <alpine.LRH.2.00.0907071111210.27150@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0907071111210.27150@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071608.11050.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 7. Juli 2009 11:13:01 schrieb Jiri Kosina:
> [ adding linux-usb to CC ]
>
> On Sun, 5 Jul 2009, Michael S. Zick wrote:
> > Anyone with suggestions about this one?

Looks like we should test for presence before we switch off
autosuspend for khubd. Please test this diagnostic patch if this is
repeatable.

	Regards
		Oliver

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2af3b4f..c5b3929 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -371,11 +371,16 @@ static void kick_khubd(struct usb_hub *hub)
 {
 	unsigned long	flags;
 
-	/* Suppress autosuspend until khubd runs */
-	to_usb_interface(hub->intfdev)->pm_usage_cnt = 1;
+	if (!hub) {
+		BUG();
+		return;
+	}
 
 	spin_lock_irqsave(&hub_event_lock, flags);
 	if (!hub->disconnected && list_empty(&hub->event_list)) {
+		/* Suppress autosuspend until khubd runs */
+		to_usb_interface(hub->intfdev)->pm_usage_cnt = 1;
+
 		list_add_tail(&hub->event_list, &hub_event_list);
 		wake_up(&khubd_wait);
 	}
@@ -384,6 +389,11 @@ static void kick_khubd(struct usb_hub *hub)
 
 void usb_kick_khubd(struct usb_device *hdev)
 {
+	if (!hdev) {
+		BUG();
+		return;
+	}
+
 	/* FIXME: What if hdev isn't bound to the hub driver? */
 	kick_khubd(hdev_to_hub(hdev));
 }


Return-Path: <linux-kernel-owner+w=401wt.eu-S1763004AbYHEUOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763004AbYHEUOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbYHEUOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:14:09 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:8706 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbYHEUOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kUUGnSPgzomd3NCfwprA5H2KzZHn8UPtoLhjWG1/w99ZWQqoOP2N6NifGVwCGPEjW6
         lKZHsME5+gmVQr5M5U4TCEWOB4kz4nfHoMervirJaU3TrqDn7Lhq0SEaP4OjMGooFBWT
         4BEbNHixLosn9o/k+83EBHjkgwTWotavTCOWg=
Date: Tue, 5 Aug 2008 16:14:03 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Alfred E. Heggestad" <aeh@db.org>
Cc: Oliver Neukum <oliver@neukum.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset #2
Message-ID: <20080805201403.GA13557@anvil.corenet.prv>
References: <200806271424.50425.oliver@neukum.org> <200808041356.57928.oliver@neukum.org> <489767D3.6070408@db.org> <200808050008.48846.oliver@neukum.org> <4898A8C2.2080307@db.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4898A8C2.2080307@db.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 09:23:46PM +0200, Alfred E. Heggestad wrote:
> Aug  5 21:11:13 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
> Aug  5 21:11:13 io kernel: uhci_hcd 0000:00:1f.2: reserve dev 2 ep83-INT, period 32, phase 16, 14 us
>

Ok, so urb_irq is pending here...

> ;;;
> ;;; Press 'TAB' in shell to force Bell/Buzzer
> ;;;
>
> Aug  5 21:11:22 io kernel: cm109: cm109_toggle_buzzer_async: ctl_urb_pending=0 buzzer_pending=0
> Aug  5 21:11:22 io kernel: cm109: cm109_submit_buzz_toggle: buzzer_state=1
> Aug  5 21:11:22 io kernel: cm109: cm109_urb_ctl_callback: buzzer_pending=0, ctl_urb_pending=1
> Aug  5 21:11:22 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22     <--- note -EINVAL

And we trying to re-submit it.... How about the patch below?

Input: cm109 - fix issue with submitting urb_irq

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/cm109.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index d1ef394..a97f038 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -106,10 +106,11 @@ struct cm109_dev {
 	dma_addr_t ctl_req_dma;
 	struct urb *urb_ctl;
 	/*
-	 * The 2 bitfields below are protected by ctl_submit_lock.
+	 * The 3 bitfields below are protected by ctl_submit_lock.
 	 * They have to be separate since they are accessed from IRQ
 	 * context.
 	 */
+	unsigned irq_urb_pending:1;	/* irq_urb is in flight */
 	unsigned ctl_urb_pending:1;	/* ctl_urb is in flight */
 	unsigned buzzer_pending:1;	/* need to issue buzz command */
 	spinlock_t ctl_submit_lock;
@@ -332,6 +333,8 @@ static void cm109_urb_irq_callback(struct urb *urb)
 
 	spin_lock(&dev->ctl_submit_lock);
 
+	dev->irq_urb_pending = 0;
+
 	if (likely(!dev->shutting_down)) {
 
 		if (dev->buzzer_state)
@@ -380,7 +383,7 @@ static void cm109_urb_ctl_callback(struct urb *urb)
 			dev->buzzer_pending = 0;
 			dev->ctl_urb_pending = 1;
 			cm109_submit_buzz_toggle(dev);
-		} else {
+		} else if (likely(!dev->irq_urb_pending)) {
 			/* ask for key data */
 			error = usb_submit_urb(dev->urb_irq, GFP_ATOMIC);
 			if (error)



-- 
Dmitry

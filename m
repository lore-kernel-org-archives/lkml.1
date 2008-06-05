Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYFEMKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYFEMKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbYFEMK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:10:29 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37176 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYFEMK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:10:28 -0400
Date: Thu, 5 Jun 2008 13:09:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Olaf Hering <olaf@aepfle.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5 (G5 SATA broken)
In-Reply-To: <20080605112436.GA4533@aepfle.de>
Message-ID: <Pine.LNX.4.64.0806051255340.28792@blonde.site>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
 <20080605112436.GA4533@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, Olaf Hering wrote:
> On Wed, Jun 04, Linus Torvalds wrote:
> 
> > Another week, another batch of mostly pretty small fixes. Hopefully the 
> > regression list is shrinking, and we've fixed at least a couple of the 
> > oopses on Arjan's list.
> 
> SATA on a dualcore G5 is broken, it happend between
> c3b25b32e8bef526cca748e1ba023c6bdd705a99..53c8ba95402be65d412a806cda3430f0e72cd107
> 
> irq 18: nobody cared (try booting with the "irqpoll" option)
> Disabling IRQ #18
> 
> ctrl alt del on the USB keyboard does not trigger a reboot.
> Sometimes the cursor stops blinking, sometimes just nothing happens
> after ctrl alt del.
> 
> Does 53c8ba95402be65d412a806cda3430f0e72cd107 work for others on G5?

I've been bisecting that on Quad G5 (sata_svw): irq 18: nobody cared ...,
then later endless ata1.00: exception..., blah blah, ata1: EH complete.
It comes down to:

commit a57c1bade5a0ee5cd8b74502db9cbebb7f5780b2
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Thu May 29 22:10:58 2008 +0100
libata-sff: Fix oops reported in kerneloops.org for pnp devices with no ctl

And the patch I'm finding successful is below: I won't sign it off,
for all I know it's reverting part of what Alan is trying to achieve;
but I expect it'll help towards the right fix.

Hugh

--- 2.6.26-rc5/drivers/ata/libata-sff.c	2008-06-05 07:18:07.000000000 +0100
+++ linux/drivers/ata/libata-sff.c	2008-06-05 12:42:39.000000000 +0100
@@ -278,7 +278,7 @@ static u8 ata_sff_irq_status(struct ata_
 		    	return status;
 	}
 	/* Clear INTRQ latch */
-	status = ata_sff_check_status(ap);
+	status = ap->ops->sff_check_status(ap);
 	return status;
 }
 

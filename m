Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbXLWVKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbXLWVKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 16:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXLWVJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 16:09:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:49230 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbXLWVJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 16:09:58 -0500
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <alpine.LFD.0.9999.0712222058160.21557@woody.linux-foundation.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org>
	 <476D1D16.5090703@garzik.org>
	 <20071222064719.73fdd9a4@laptopd505.fenrus.org>
	 <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
	 <476DB95F.3090801@garzik.org>
	 <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
	 <476DDFEE.3010009@garzik.org>
	 <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org>
	 <476DE98F.2010009@garzik.org>
	 <alpine.LFD.0.9999.0712222058160.21557@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 08:09:10 +1100
Message-Id: <1198444150.6686.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 21:00 -0800, Linus Torvalds wrote:
> 
> On Sat, 22 Dec 2007, Jeff Garzik wrote:
> > 
> > But regardless of problems, enabling should be done globally, not per
> > device...
> 
> I'm ok with trying the "globally" idea, but it has to be "globally but 
> only if absolutely required".
> 
> And quite frankly, how do you tell whether it's absolutely required or 
> not?
> 
> I have an idea: the drivers that really need it will do a "please enable 
> MMCONFIG, because I will need it" thing?

What about this approach:

 - At boot, MMCONFIG is disabled, you perform the initial probe of all
devices.

 - During that probe, you set a flag if any device has capabilities that
extend beyond 0xff.

 - Once the main probe pass is done (before drivers are hooked up, which
on PCI is a separate phase), if that flag has been set, you print a fat
warning (on peecee's, which are our main concern, this will generally be
visible on vga console), that you're about to enable MMCONFIG for this
device and if the machine crashes, send a bug report and boot with
nommconfig. Then, for each of those devices, attempt to re-read the
config space header with MMCONFIG, and compare to what is supposed to be
there (+/- irrelevant status bits). If that fails, warn and keep
MMCONFIG disabled.

At this point, you can decide to either keep MMCONFIG on/off on a
per-device basis (if a device has capabilities in the ext space, use
MMCONFIG for it). In that case, your proposed API is useful to
force-enabling MMCONFIG for a given device if there are no such
capabilities but the driver wants to force-enable. That case should be
extremely rare if existing at all

Or you can decide to keep the enable/disable global (if a single device
fails, don't enable MMCONFIG globally).

Ben.



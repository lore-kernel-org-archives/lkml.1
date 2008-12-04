Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYLDWKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYLDWKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYLDWKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:10:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbYLDWKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:10:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Thu, 4 Dec 2008 23:09:11 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812030735230.3256@nehalem.linux-foundation.org> <200812041229.45443.elendil@planet.nl>
In-Reply-To: <200812041229.45443.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812042309.11540.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 4 of December 2008, Frans Pop wrote:
> On Wednesday 03 December 2008, Linus Torvalds wrote:
> > Well, I think that what _would_ be generally correct, and actually
> > pretty simple, is a rather different approach: just not sizing things
> > behind a transparent bridge AT ALL, since it really shouldn't matter.
> 
> I've given your patch a try and the few resumes from STR I've done were 
> all successful. That's not 100% conclusive yet, but a nice start.
> Some info from logs etc. below.

It doesn't help on my box, though.  I've got a failure to resume from
hibernation on the first attempt.

However, this one appears to work reliably for me (on top of vanilla current
mainline):

--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -350,6 +350,11 @@ static int pbus_size_mem(struct pci_bus 
 
 			if (r->parent || (r->flags & mask) != type)
 				continue;
+
+			if ((dev->class >> 8) == PCI_CLASS_BRIDGE_CARDBUS
+			    && bus->self->transparent)
+				continue;
+
 			r_size = resource_size(r);
 			/* For bridges size != alignment */
 			align = resource_alignment(r);

> > > Also, I would be happy to actually understand _why_ this happens.
> >
> > 100% agreed. I do _not_ see why it should ever matter how we set up a
> > PCI bridging window - whether prefetchable or not - on a bridge that
> > should be transparent. It sounds really odd. I'm wondering if there is
> > something we're missing here.
> 
> The theory that it is really a resume issue and not a device layout issue 
> sounds logical. Especially as everything always works correctly after a 
> normal boot.

Well, in fact I'm pretty sure this is the case.  By changing memory address
space layout we effectively change conditions during suspend-resume and
apparently we can choose one for which the failure condition doesn't trigger
(or, IOW, the probability of it is _so_ small that we just can't see it).

There seems to be a race of some kind or a missing delay or something similar.

Thanks,
Rafael

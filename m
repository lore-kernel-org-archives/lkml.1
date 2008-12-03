Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYLCPza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYLCPza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYLCPzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:55:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbYLCPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:55:20 -0500
Date: Wed, 3 Dec 2008 07:53:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812031220.36711.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812030735230.3256@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812030840.25539.rjw@sisk.pl> <200812030852.36437.rjw@sisk.pl> <200812031220.36711.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> 
> Then, voila!, I'm not able to reproduce the hibernation-resume failure.
> 
> This appears to mean that:
> (1) The sizes of the allocations and the locations of devices in the memory
>     address space don't matter here.
> (2) The presence and size of the prefetchable memory window don't matter here.
> (3) What matters is the presence of non-prefetchable memory window on the
>     supposedly transparent bridge.  Namely, if the window is there, resume from
>     hibernation occasionally fails (again, the size of the window and the
>     location of it in the memory address space doesn't seem to matter).

That is indeed rather odd, and very interesting. 

> So, apparently, on this box (and I guess on Frans' too) we could avoid the
> problem if we didn't allocate the non-prefetchable memory window in
> pci_bus_size_cardbus(), but I guess that wouldn't be generally correct.

Well, I think that what _would_ be generally correct, and actually pretty 
simple, is a rather different approach: just not sizing things behind a 
transparent bridge AT ALL, since it really shouldn't matter.

So if the appended patch fixes things for you, I think this might 
potentially be the right approach.

NOTE NOTE NOTE! This patch is entirely untested, as usual. I didn't check 
that this is necessarily the correct place to test for this, but it 
does make sense. IOW, it _feels_ like the rigth thing. However, even if it 
fixes things for you, I think we're too late in the 2.6.28 cycle to really 
apply this.

So it really does make sense to consider a root bridge and a transparent 
one to be equivalent here, since in both cases any bridge windows should 
be irrelevant. Which is why I think this patch is interesting.

> Also, I would be happy to actually understand _why_ this happens.

100% agreed. I do _not_ see why it should ever matter how we set up a PCI 
bridging window - whether prefetchable or not - on a bridge that should be 
transparent. It sounds really odd. I'm wondering if there is something 
we're missing here.

But apart from the existence of the bridging window, the only thing that 
it seems to affect is really just a minor layour issue. So it does seem 
like it matters. Odd.

			Linus

---
 drivers/pci/setup-bus.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index ea979f2..586451c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -467,8 +467,12 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
 		}
 	}
 
-	/* The root bus? */
-	if (!bus->self)
+	/*
+	 * We don't need to allocate PCI bridging windows
+	 * for a root bus (everything bridged) or for a
+	 * transparent one.
+	 */
+	if (!bus->self || bus->self->transparent)
 		return;
 
 	switch (bus->self->class >> 8) {

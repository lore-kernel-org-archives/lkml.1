Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbYCZXXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbYCZXXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYCZXWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:22:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:57121 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYCZXWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:22:51 -0400
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
In-Reply-To: <20080326224702.46b4d582@core>
References: <20080325201125.GD15330@elte.hu>
	 <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de>
	 <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
	 <20080326101450.GA9060@jurassic.park.msu.ru>
	 <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
	 <20080326203012.GB6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
	 <20080326205828.GA15225@jurassic.park.msu.ru>
	 <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
	 <1206568675.6926.7.camel@pasglop>
	 <alpine.LFD.1.00.0803261524560.2775@woody.linux-foundation.org>
	 <20080326224702.46b4d582@core>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 10:17:41 +1100
Message-Id: <1206573461.6926.43.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 22:47 +0000, Alan Cox wrote:
> > I dunno. I'm not going to do anything in this area before 2.6.25 is out 
> > because this *does* make me a bit nervous, but if somebody wants to think 
> > about this and perhaps write patches for testing, that would be good.
> 
> One way to kill off some of the assumptions and gunge would be to add
> pci_resource_assigned(resource) [or indeed just resource_assigned()].
> Iomap has similar problems - we have no portable defined "not mapped" at
> the moment, although we use NULL technically mmio maps of 0 end up at 0
> in the implementation today.

There is IORESOURCE_UNSET... We could use that. I use it to some extent
on powerpc but x86 doesn't. Though I remember spotting a code path in
setup-res.c will not clear it when actually assigning the resource to a
bus. I can't remember if that hits in practice tho. I have a patch
anyway :-)

----
[PATCH] pci: Make pci_assign_resource always clear IORESOURCE_UNSET

For bus resources pci_assign_resrouce() needs to also clear
IORESOURCE_UNSET. (For device resources, it's handled by
pci_update_resource).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-merge/drivers/pci/setup-res.c
===================================================================
--- linux-merge.orig/drivers/pci/setup-res.c	2007-12-13 13:06:27.000000000 +1100
+++ linux-merge/drivers/pci/setup-res.c	2007-12-13 13:06:50.000000000 +1100
@@ -167,7 +167,8 @@ int pci_assign_resource(struct pci_dev *
 			(unsigned long long)res->start, pci_name(dev));
 	} else if (resno < PCI_BRIDGE_RESOURCES) {
 		pci_update_resource(dev, res, resno);
-	}
+	} else
+		res->flags &= ~IORESOURCE_UNSET;
 
 	return ret;
 }



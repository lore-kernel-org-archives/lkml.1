Return-Path: <linux-kernel-owner+w=401wt.eu-S964793AbZHEQ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbZHEQ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934648AbZHEQ1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:27:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934612AbZHEQ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:27:11 -0400
Date: Wed, 5 Aug 2009 09:25:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Manuel Lauss <mano@roarinelk.homelinux.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <20090805155102.GA31646@roarinelk.homelinux.net>
Message-ID: <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain>
 <20090805155102.GA31646@roarinelk.homelinux.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 5 Aug 2009, Manuel Lauss wrote:
> 
> On Tue, Aug 04, 2009 at 04:04:16PM -0700, Linus Torvalds wrote:
> > 
> > So I _think_ that you actually are getting the same layout as with 2.6.30, 
> > but with a warning that didn't exist in 2.6.30. Can you verify?
> 
> You're absolutely correct: /proc/iomem on 2.6.30 and 31-rc5+ are identical,
> the only difference being 2.6.30 not complaining about any collisions.

Ok.

So this is not a regression per se.

The warning looks a bit annoying, but in fact I believe that the warning 
is correct, and is showing us a real problem. Well, not "problem" exactly, 
but an issue.

I think that what is happening is that pci_find_parent_resource() may be 
in fact finding another parent resource than the one we strictly want (the 
pre-existing one).

And I think it's brought on by the fact that this is a ROM resource.

I bet that what is happening is:

 - the PCI bridge has a _prefetchable_ bus resource window at

	ff600000-ff6fffff : PCI Bus 0000:02

 - the PCI bridge is a transparent bridge

 - the BIOS has set up the ROM (BAR 6) at 

	ff680000-ff69ffff : 0000:02:03.0

 - We have for some reason marked the ROM as being non-prefetchable.

and what happens is:

 - pci_find_parent_resource() refuses to use the ff600000-ff6fffff PCI 
   bridge resource, because it is marked IORESOURCE_PREFETCH, and the ROM 
   resource is not so marked.

 - But because it's a transparent bridge, once we've iterated over the 
   bridge window resources, we have a couple of resources that point back 
   to the parent of the bridge - the PCI root resources. 

   So now pci_find_parent_resource() will return that instead

 - request_resource() will (correctly) notice that the root resource 
   already has other resources at that address (the PCI brige window!) and 
   will refuse to insert it - leading us to re-allocating the 
   BIOS-provided resource later (to the non-prefetchable bus window)

 - but when we for a short while (incorrectly) used 'insert_resource()' in 
   pci_claim_resource(), it would recurse back into the prefetchable 
   window, and everything would work - because a ROM resource is actually 
   perfectly happy to be in a prefetchable window.

So I think I understand the behavior on your box, and the warning was 
actually correct and useful - our PCI layer is being stupid. We should 
mark ROM resources as being prefetchable.

Hmm.. We do seem to _try_ do exactly that in pci_read_bases(). I wonder 
what I'm missing, and where that bit is then cleared. Or whether we're 
doing that ROM BAR probe somewhere else too..

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758354AbZFPX4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbZFPX4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 19:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZFPX4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 19:56:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845AbZFPX4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 19:56:14 -0400
Date: Tue, 16 Jun 2009 16:56:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Patterson <andrew.patterson@hp.com>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <1245195498.8234.236.camel@bluto.andrew>
Message-ID: <alpine.LFD.2.01.0906161640250.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>  <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>  <1245192703.8234.226.camel@bluto.andrew>  <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain>
 <1245195498.8234.236.camel@bluto.andrew>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Andrew Patterson wrote:
> > 
> > Well, find_resource() found room for a resource. So it returns it. The 
> > point is, your patch returns another - equally valid one.
> 
> I am confused.  The existing code will return a conflict and bomb out.

My point is, there are two answers - returning the conflicting resource, 
or trying to recurse into it. Both are "valid", in the sense that both 
have real semantics.

But the reason I don't like your patch is that I think the _deeper_ 
problem is the fact that the resource tree isn't set up right in the first 
place.

It looks to me like your patch works around the bug (by trying to find 
that "other possible case"), while my disagreement with that patch is that 
we should never need to care about these kinds of "you can try to find 
ambiguous cases" in the first place.

> > We've had those kinds of situations before. The thread you point to is an 
> > exact case of this. My point is that I'd rather try to _avoid_ any 
> > ambiguous cases, and try to solve it properly at a higher PCI level, where 
> > the ambiguity doesn't exist any more (because we'd explicitly take the 
> > actual bus topology into account).
> > So your patch may fix a bug, but I'm pretty sure I've seen a patch from 
> > Ivan that should _also_ fix it, and that I would expect to do it not by 
> > just tweaking a fundamentally ambiguous case.
> 
> OK. I would be happy to test Ivan's patch.

I just looked at our PCI bus resource allocation code, and afaik it does 
everything right even as-is. Which is why I now wonder if that incorrectly 
nested bus resource was perhaps set up by the PCI hotplug code (which I do 
not know, and didn't look at). 

I may also be confused, and not have found the right place that actually 
inserts the resource. Afaik, bus resources get allocated through

	pbus_assign_resources_sorted ->
	  pci_assign_resource ->
	    pci_bus_alloc_resource ->
	      allocate_resource

and that "pci_bus_alloc_resource()" thing only allocates within the parent 
bus, so it _should_ nest correctly.

It would be interesting to see where that resource actually gets 
allocated. I'm clearly missing something, since clearly your resources do 
_not_ nest correctly.

			Linus

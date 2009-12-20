Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZLUAFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZLUAFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 19:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZLUAFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 19:05:34 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13812 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZLUAFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 19:05:33 -0500
Subject: Re: [PATCH 2/12] pci: add pci_bridge_release_unused_res and
	pci_bus_release_unused_bridge_res -v2
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ingo Molnar <mingo@elte.hu>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>
References: <4B2BE9DD.3040504@kernel.org> <4B2BEC1B.9090104@kernel.org>
	 <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 20 Dec 2009 16:59:40 -0700
Message-Id: <1261353580.26429.57.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 13:24 -0800, Linus Torvalds wrote:
> 
> On Fri, 18 Dec 2009, Yinghai Lu wrote:
> > 
> > so later we could use it to release small resource before pci assign unassign res
> 
> However, I think this one is wrong.
> 
> > +static void release_child_resources(struct resource *r)
> > +{
> > +	struct resource *p;
> > +	resource_size_t size;
> > +
> > +	p = r->child;
> > +	while (p) {
> > +		release_child_resources(p);
> > +		release_resource(p);
> 
> So not only is this releasing resources that aren't necessarily PCI 
> devices, it's releasing the whole tree - regardless of how they were 
> allocated and initialized. ...

Help me fill in my mental picture of these resources ...  This function
just takes a struct resource, so it doesn't know whether it's a PCI,
ACPI, or other resource.  But in Yinghai's usage, I think we do know
that we're starting with a PCI resource.  In that case, is it possible
that some child is a non-PCI resource?

The picture in my mind is that once we are downstream of a PCI host
bridge, all child resources must be PCI, and they must all conform to
the forwarding rules for PCI bridges and so on.  I know there are PCI
devices with BARs at non-standard places, so Linux wouldn't know about
those resources (and that worries me a bit when we're talking about
reprogramming a bridge window that might be upstream of such a device).
But if Linux *did* learn about those non-standard resources via a quirk
or something, I would still think of those as PCI resources, not ACPI or
something else.

Anyway, I'd like to correct my mental picture if it's mistaken.

Bjorn



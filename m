Return-Path: <linux-kernel-owner+w=401wt.eu-S932826AbZLRVZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbZLRVZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZLRVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:25:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbZLRVZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:25:34 -0500
Date: Fri, 18 Dec 2009 13:24:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/12] pci: add pci_bridge_release_unused_res and
 pci_bus_release_unused_bridge_res -v2
In-Reply-To: <4B2BEC1B.9090104@kernel.org>
Message-ID: <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>
References: <4B2BE9DD.3040504@kernel.org> <4B2BEC1B.9090104@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Yinghai Lu wrote:
> 
> so later we could use it to release small resource before pci assign unassign res

However, I think this one is wrong.

> +static void release_child_resources(struct resource *r)
> +{
> +	struct resource *p;
> +	resource_size_t size;
> +
> +	p = r->child;
> +	while (p) {
> +		release_child_resources(p);
> +		release_resource(p);

So not only is this releasing resources that aren't necessarily PCI 
devices, it's releasing the whole tree - regardless of how they were 
allocated and initialized. That makes me nervous to begin with. It's in 
the wrong file.

But the locking is crap too!

You need to hold the resource lock for the whole operation - you can't 
just walk the resource tree and release them.

And once you do that, then using "release_resrouce()" is the wrong thing, 
since it turns into just "__release_resource()" and you notice that that 
walks the chain looking for them - which makes it pointless to have 
_another_ outer loop that walks the chain to release them!

So you'd need to

 - move this to kernel/resource.c

 - do it all under 'write_lock(&resource_lock);'

 - stop the silly double list loop, and just do it as a single loop that 
   does

	p = old->parent->child;
	old->parent = NULL;
	while (p) {
		struct resource *tmp = p;
		p = p->sibling;

		.. do whatever you do to free tmp ..
	}

   and it's much simpler, more efficient, has the rigth locking, and is in 
   the right place.

That said, it's still unclear if you can ever do this! Why would the PCI 
layer be allowed to release ACPI resources int he tree, for example?

So I can see fixing the _implementation_ issues I have like above, but I'd 
still be nervous about the whole concept of the patch..

		Linus

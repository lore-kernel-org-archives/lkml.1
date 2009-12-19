Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZLSAlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZLSAlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbZLSAlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:41:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792AbZLSAlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:41:45 -0500
Date: Fri, 18 Dec 2009 16:40:43 -0800 (PST)
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
In-Reply-To: <4B2C1DA9.4030907@kernel.org>
Message-ID: <alpine.LFD.2.00.0912181635170.3712@localhost.localdomain>
References: <4B2BE9DD.3040504@kernel.org> <4B2BEC1B.9090104@kernel.org> <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain> <4B2C1DA9.4030907@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Yinghai Lu wrote:
> 
> ok, please check attached is right or not
>  
> +static void __release_child_resources(struct resource *r)
> +{
> +	struct resource *tmp, *p;
> +	resource_size_t size;
> +
> +	p = r->child;
> +	r->child = NULL;
> +	while (p) {
> +		tmp = p;
> +		p = p->sibling;
> +
> +		tmp->parent = NULL;
> +		tmp->sibling = NULL;
> +		__release_child_resources(tmp);
> +
> +		printk(KERN_DEBUG "release child resource %pR\n", tmp);
> +		/* need to restore size, and keep flags */
> +		size = resource_size(tmp);
> +		tmp->start = 0;
> +		tmp->end = size - 1;
> +	}
> +}

Ok, this looks mostly right. I do worry about the alignment information: 
you lose that thing for any resource that had IORESOURCE_STARTALIGN set 
when you do this thing. That's pretty fundamental to the whole resource 
code, I suspect we should just finally add a 'alignment' field to the 
resource struct, so that alignment doesn't get lost when a resource is 
allocated.

(Do a "git grep IORESOURCE_.*ALIGN" to see the kind of stuff I'm talking 
about, and look at he PCI 'setup-bus.c' code that sets that STARTALIGN 
thing).

So a preliminary ack on the resource.c parts. The rest I'm still a bit 
dubious about, and the whole "we've lost alignment on the resources" is 
probably indicative of how none of the resource code has ever really been 
designed for this kind of "tear down and build back up again" behavior.

				Linus

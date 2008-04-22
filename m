Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYDVEFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYDVEFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 00:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYDVEFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 00:05:05 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:41577 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYDVEFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:05:04 -0400
Date: Mon, 21 Apr 2008 22:05:02 -0600
From: Alex Chiang <achiang@hp.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
       linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
Message-ID: <20080422040502.GB1788@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
	linux-kernel@vger.kernel.org, matthew@wil.cx
References: <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop> <20080407234255.GA22514@ldl.fc.hp.com> <20080416031712.GB3333@ldl.fc.hp.com> <1208331916.6958.270.camel@pasglop> <20080416171127.GA18290@ldl.fc.hp.com> <20080416130343.a82702f0.akpm@linux-foundation.org> <1208384185.6958.304.camel@pasglop> <20080419063807.GB12987@ldl.fc.hp.com> <1208588626.6958.446.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208588626.6958.446.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> 
> On Sat, 2008-04-19 at 00:38 -0600, Alex Chiang wrote:
> > So I'm not sure how much we can use of your slot infrastructure, I'll
> > have
> > > to look, I suspect it can cover some cases but not all of them.
> > 
> > *poke*
> > 
> > Any update on this?
> > 
> > Anything I can do to help?
> 
> Not yet no. I've looked a bit, but ran out of time, I'll look more this
> week-end or next week. I'm also trying to figure out who in IBM is
> responsible for that hotplug stuff so they can get involved too.
> 
> BTW. How would you do if the answer was we simply can't declare hotplug
> "slots" ? ie. if I end up finding out (which is what I think will
> happen) that there is simply no way for us to know in advance any
> concept of "slot" with a devfn for hotplug ?

Hm, I may be getting lost in the twisty maze of pseries, but I
guess I don't really understand this statement.

Today, before calling rpaphp_register_slot, we first call
rpaphp_enable_slot. rpaphp_enable_slot makes a call to
pcibios_find_pci_bus which must succeed before we ever try to
register the slot.

So if there is a pci_bus, then it must have a ->self, which means
it has a ->devfn. Right?

Are you saying that it is not accurate to use this
pci_bus->self->devfn to keep track of slots?

> Basically, when doing hotplug, the hypervisor sends us new bits of
> device-tree with things potentially ranging from host bridges, P2P
> bridges to devices, but I'm not certain at this stage we can know in
> advance where they'll hook up (in fact, for PHBs, we can't for sure) and
> thus even if we end up supporting hotplug of actual slots, we don't even
> know in advance the devfn where devices will appear. It's all hidden
> from us by the hypervisor.
> 
> How would that fit in your infrastructure ? Can we just disable usage of
> your slots abstraction in our case ?

I suppose you could just pass in 0 as slot_nr/devfn. That is what
my fixup patch did if it couldn't find a pci_bus->self. The
result would be that for a given pci_bus, you would only see the
first "slot" with this 0 slot_nr appear in sysfs, and it would
have whatever name originally associated with your dn.

I think if I were to understand more about this issue, we could
figure out a better solution...

thanks,

/ac


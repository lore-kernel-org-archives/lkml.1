Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbXKUJnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbXKUJnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 04:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbXKUJnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 04:43:25 -0500
Received: from ns2.suse.de ([195.135.220.15]:53473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbXKUJnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 04:43:23 -0500
Subject: Re: [PATCH 3/3] PNP cleanups - Version 2 - Pass struct pnp_dev to
	pnp_clean_resource_table for cleanup reasons
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>
In-Reply-To: <4743EE5E.4070301@keyaccess.nl>
References: <1195581124.23700.262.camel@queen.suse.de>
	 <20071120180007.1ebe11a2@the-village.bc.nu>	<4743372A.6030400@keyaccess.nl>
	 <20071120221812.47fb5645@the-village.bc.nu> <4743EE5E.4070301@keyaccess.nl>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 21 Nov 2007 10:43:21 +0100
Message-Id: <1195638201.23700.285.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 09:37 +0100, Rene Herman wrote:
> On 20-11-07 23:18, Alan Cox wrote:
> 
> >>> Again I don't see the point of this change. A routine for cleaning up
> >>> resource tables expects logically to be passed a resource table to clean
> >>> up not some device it may be attached to.
> 
> >> He needs to pass the pnp_dev to later be able to replace the:
> >>
> >> 	for (idx = 0; idx < PNP_MAX_PORT; idx++)
> >>
> >> loops with:
> >>
> >> 	for (idx = 0; pnp_port(dev, idx); idx++)
> > 
> > I can see why he does it, but that doesn't answer the problem that the
> > code is messing up the sensible interface.
> 
> Not much of an interface. Note that pnp_clean_resource_table is an internal 
> helper function in drivers/pnp/manager.c, unexported and with a mere three 
> call sites that each call it as pnp_clean_resource_table(&dev->res). A small 
> internal helper like this need really not be an argument.
> 
> >> in a later patch when he introduces dynamic resource tables -- pnp-acpi can 
> >> (and does) now sometimes require more resources than the current pnp limits 
> >> allow but simply upping the limits uncoditionally wastes too much space in 
> >> the resource tables. He therefore aims to krealloc() the arrays as required.
> > 
> > That bit is fine, but put the count in the resource structure. Then you
> > can pass a resource around as a meaningful self contained object. That
> > means you can pass them, ref count them and whatever else is needed.
> 
> I suppose you mean put the count inside the resource _table_ structure? It 
> is a count of resource structures after all. Inside the table is where he 
> did in fact propose it would go (dev->res.allocated_ports) but logically a 
> pnp_dev and its pnp_resource_table are one and the same; "res" is embedded 
> in the pnp_dev. That is, the resources are tied to the device, with struct 
> pnp_resource_table being no more than a handy container to group them under 
> a single name.
Putting the count into struct resource does not make sense.

> Only the pnp_resource_change export (that is, the pnp_init_resource_table 
> and pnp_manual_config_dev exports) give a pnp_resource_table struct slightly 
> more of a life of its own but those are only used by the ALSA ISAPnP drivers 
> in what I as stated before personally consider a bad layering violation and 
> would be more than happy to fix after which they can just go -- they have no 
> possible uses _other_ than layering violations.
> 
> See the existing pnp design as well; all the resource stuff does the same 
> thing in taking a pnp_dev and then returning from dev->res:
> 
> #define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
> #define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)
> 
> and so on. From a consistency standpoint making his new setup use this same 
> paradigm makes sense to me therefore.
The idea is to not rely on the exact pnp resource table structure and
abstracting this to macros. If krealloc approach works,
dev->res.port_resource[i].start would even still work, if not, it's
easier to alter the pnp resource table and the macros internally.

> > (Remember if you krealloc a pnp resource you have to know *nobody* is 
> > using the existing resource pointer at that moment, so you will need 
> > locks attached to the resource as well - or RCU later)
> 
> Yes, I dont know how he intends to deal with this (nor, in fact, just how 
> dynamic things are supposed to end up to begin with) so over to Thomas.
Krealloc should only get used at early pnp init time, when the BIOS
structures are parsed. The devices shouldn't be active then...
A bit of a problem, as said, could be the sysfs interfaces, there it
must be insured krealloc is not used anymore.

> >>> I don't see why pnp_dma() and pnp_irq() should change either. It just 
> >>> causes noise and breaks driver code. I don't see where it needs to change
> >>> to make internal pnp changes work ?
> >> As he explained in his 0/3, his pnp_port() would look like:
> > 
> > You don't need to change the names - just the code. 
> > 
> > Lets split the problems I have with it into three areas
> > 
> > 1.	Changes the interface to drivers but for no apparent reason in
> > part.
> 
> Really. Only pnp_irq -> pnp_irq_start (or _no if really need be) and same 
> for dma. Not exactly a high-invasiveness thing.
Ok, I think I see the main problem: Externally built drivers would
break.
I can try with a "do not alter exported interfaces if it could be
avoided" approach.

I'd add these then:
#define pnp_port_ptr(dev,bar)
#define pnp_dma_ptr(dev,bar)
...

I will come back in some days...

    Thomas


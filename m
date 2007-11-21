Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbXKUImz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbXKUImz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbXKUImq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:42:46 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:53563 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbXKUImp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:42:45 -0500
Message-ID: <4743EE5E.4070301@keyaccess.nl>
Date: Wed, 21 Nov 2007 09:37:50 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: trenn@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>
Subject: Re: [PATCH 3/3] PNP cleanups - Version 2 - Pass struct pnp_dev to
   pnp_clean_resource_table for cleanup reasons
References: <1195581124.23700.262.camel@queen.suse.de>	<20071120180007.1ebe11a2@the-village.bc.nu>	<4743372A.6030400@keyaccess.nl> <20071120221812.47fb5645@the-village.bc.nu>
In-Reply-To: <20071120221812.47fb5645@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-11-07 23:18, Alan Cox wrote:

>>> Again I don't see the point of this change. A routine for cleaning up
>>> resource tables expects logically to be passed a resource table to clean
>>> up not some device it may be attached to.

>> He needs to pass the pnp_dev to later be able to replace the:
>>
>> 	for (idx = 0; idx < PNP_MAX_PORT; idx++)
>>
>> loops with:
>>
>> 	for (idx = 0; pnp_port(dev, idx); idx++)
> 
> I can see why he does it, but that doesn't answer the problem that the
> code is messing up the sensible interface.

Not much of an interface. Note that pnp_clean_resource_table is an internal 
helper function in drivers/pnp/manager.c, unexported and with a mere three 
call sites that each call it as pnp_clean_resource_table(&dev->res). A small 
internal helper like this need really not be an argument.

>> in a later patch when he introduces dynamic resource tables -- pnp-acpi can 
>> (and does) now sometimes require more resources than the current pnp limits 
>> allow but simply upping the limits uncoditionally wastes too much space in 
>> the resource tables. He therefore aims to krealloc() the arrays as required.
> 
> That bit is fine, but put the count in the resource structure. Then you
> can pass a resource around as a meaningful self contained object. That
> means you can pass them, ref count them and whatever else is needed.

I suppose you mean put the count inside the resource _table_ structure? It 
is a count of resource structures after all. Inside the table is where he 
did in fact propose it would go (dev->res.allocated_ports) but logically a 
pnp_dev and its pnp_resource_table are one and the same; "res" is embedded 
in the pnp_dev. That is, the resources are tied to the device, with struct 
pnp_resource_table being no more than a handy container to group them under 
a single name.

Only the pnp_resource_change export (that is, the pnp_init_resource_table 
and pnp_manual_config_dev exports) give a pnp_resource_table struct slightly 
more of a life of its own but those are only used by the ALSA ISAPnP drivers 
in what I as stated before personally consider a bad layering violation and 
would be more than happy to fix after which they can just go -- they have no 
possible uses _other_ than layering violations.

See the existing pnp design as well; all the resource stuff does the same 
thing in taking a pnp_dev and then returning from dev->res:

#define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
#define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)

and so on. From a consistency standpoint making his new setup use this same 
paradigm makes sense to me therefore.

> (Remember if you krealloc a pnp resource you have to know *nobody* is 
> using the existing resource pointer at that moment, so you will need 
> locks attached to the resource as well - or RCU later)

Yes, I dont know how he intends to deal with this (nor, in fact, just how 
dynamic things are supposed to end up to begin with) so over to Thomas.

>>> I don't see why pnp_dma() and pnp_irq() should change either. It just 
>>> causes noise and breaks driver code. I don't see where it needs to change
>>> to make internal pnp changes work ?
>> As he explained in his 0/3, his pnp_port() would look like:
> 
> You don't need to change the names - just the code. 
> 
> Lets split the problems I have with it into three areas
> 
> 1.	Changes the interface to drivers but for no apparent reason in
> part.

Really. Only pnp_irq -> pnp_irq_start (or _no if really need be) and same 
for dma. Not exactly a high-invasiveness thing.

> 2.	Hides a lot of stuff in macros so we get peculiar un C like
> assignments that hide the actual functionality. I want to *see* what is
> going on when I touch the code not hide it, at least within the pnp layer

Yes, not hugely fond of the lvalue thing either. Andrew commented that he 
found if to be okay-ish from a consistency standpoint. <shrug>

Quite frankly, I've had enough email to PnP maintainer(s) disappear into 
blackholes now that I'm happy already to see some action. If I'm right that 
I should consider Bjorn Helgaas the PnP maintainer now, I'd vote he gets a 
say here. Without the magic assignments I guess you'd need helper functions 
for them.

> 3.	Object lifetime and internal completeness - dev->res should
> point to everything that is neccessary to manage the resource set. It
> should be updatable in a consistent locked manner. That matters the
> moment you do any dynamic reassignment of resources affecting a live
> object, it matters the moment you want to do things like work with
> resources cleanly without the device structure.

As to the latter bit, I'm not sure there's any point in the "without the 
device structure" bit. As argued above, the resources are fully tied to the 
device.

As to the locking, I suppose we could use a more fully complete patchset to 
judge whether or not these preparations are good but it _looks_ like Thomas 
is trying for a fairly minimally invasive route here which in itself seems 
to coincide with your wishes.

> Now I would suggest that #2 and #3 actually matter right now. We can
> argue about whether its called a wombat or banana and rename them any day
> of the week.
> 
> 
> What I would thus like to see is a patch set which
> 
> 1.	Switches to krealloc resources internally and moves the
> resource count sizes into the resource object but without hiding internal
> detail in magic macros (macros for device side are good internal bad
> generally). Nothing dynamic after setup *yet*
> 
> 2.	Update any driver specific assumptions about resource walking

Rene.


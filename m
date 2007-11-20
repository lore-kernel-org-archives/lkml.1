Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbXKTTrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbXKTTrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbXKTTrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:47:05 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:54917 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXKTTrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:47:03 -0500
Message-ID: <4743372A.6030400@keyaccess.nl>
Date: Tue, 20 Nov 2007 20:36:11 +0100
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
References: <1195581124.23700.262.camel@queen.suse.de> <20071120180007.1ebe11a2@the-village.bc.nu>
In-Reply-To: <20071120180007.1ebe11a2@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-11-07 19:00, Alan Cox wrote:

> On Tue, 20 Nov 2007 18:52:04 +0100
> Thomas Renninger <trenn@suse.de> wrote:
> 
>> Pass struct pnp_dev to pnp_clean_resource_table for cleanup reasons
> 
> Again I don't see the point of this change. A routine for cleaning up
> resource tables expects logically to be passed a resource table to clean
> up not some device it may be attached to.

He needs to pass the pnp_dev to later be able to replace the:

	for (idx = 0; idx < PNP_MAX_PORT; idx++)

loops with:

	for (idx = 0; pnp_port(dev, idx); idx++)

in a later patch when he introduces dynamic resource tables -- pnp-acpi can 
(and does) now sometimes require more resources than the current pnp limits 
allow but simply upping the limits uncoditionally wastes too much space in 
the resource tables. He therefore aims to krealloc() the arrays as required.

> Perhaps if you could explain where you are trying to end up, it would 
> help understand what you are trying to do.
> 
> I don't see why pnp_dma() and pnp_irq() should change either. It just 
> causes noise and breaks driver code. I don't see where it needs to change
> to make internal pnp changes work ?

As he explained in his 0/3, his pnp_port() would look like:

#define pnp_port(dev,bar)      ((dev)->res.allocated_ports > (bar) \
	? (&(dev)->res.port_resource[(bar)]) : NULL)

If the above replacement was the only use for the macros, he could as well do:

	for (idx = 0; idx < dev->res.allocated_ports; idx++)

but given that he'll need to get at the resource more generally, the simple 
pnp_port(), pnp_irq(), pnp_dma() and pnp_mem() names sound best. It would 
ofcourse be possible to call them something like pnp_port_addr() as well but 
given that he only needs to get rid of pnp_irq() and pnp_dma() to have these 
better names available, I'd say go for it.

pnp_{irq,dma}_no(), or pnp_{irq,dma}_start() as he originally proposed and 
which has consistency both with the existing pnp_{port,mem}_start() and the 
struct resource name as its plus should be fine and he then frees up the 
better names for the new use which should make for better readable code at 
the end of things.

My vote's with pnp_irq_start(). As said, consistent both with the port and 
mem variants and the struct resource usage and name.

Rene.


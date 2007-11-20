Return-Path: <linux-kernel-owner+w=401wt.eu-S1762440AbXKTWUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762440AbXKTWUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbXKTWUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:20:23 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35490 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756938AbXKTWUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:20:21 -0500
Date: Tue, 20 Nov 2007 22:18:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: trenn@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>
Subject: Re: [PATCH 3/3] PNP cleanups - Version 2 - Pass struct pnp_dev to 
  pnp_clean_resource_table for cleanup reasons
Message-ID: <20071120221812.47fb5645@the-village.bc.nu>
In-Reply-To: <4743372A.6030400@keyaccess.nl>
References: <1195581124.23700.262.camel@queen.suse.de>
	<20071120180007.1ebe11a2@the-village.bc.nu>
	<4743372A.6030400@keyaccess.nl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Again I don't see the point of this change. A routine for cleaning up
> > resource tables expects logically to be passed a resource table to clean
> > up not some device it may be attached to.
> 
> He needs to pass the pnp_dev to later be able to replace the:
> 
> 	for (idx = 0; idx < PNP_MAX_PORT; idx++)
> 
> loops with:
> 
> 	for (idx = 0; pnp_port(dev, idx); idx++)

I can see why he does it, but that doesn't answer the problem that the
code is messing up the sensible interface.

> in a later patch when he introduces dynamic resource tables -- pnp-acpi can 
> (and does) now sometimes require more resources than the current pnp limits 
> allow but simply upping the limits uncoditionally wastes too much space in 
> the resource tables. He therefore aims to krealloc() the arrays as required.

That bit is fine, but put the count in the resource structure. Then you
can pass a resource around as a meaningful self contained object. That
means you can pass them, ref count them and whatever else is needed.

(Remember if you krealloc a pnp resource you have to know *nobody* is
using the existing resource pointer at that moment, so you will need
locks attached to the resource as well - or RCU later)

> > I don't see why pnp_dma() and pnp_irq() should change either. It just 
> > causes noise and breaks driver code. I don't see where it needs to change
> > to make internal pnp changes work ?
> 
> As he explained in his 0/3, his pnp_port() would look like:

You don't need to change the names - just the code. 

Lets split the problems I have with it into three areas

1.	Changes the interface to drivers but for no apparent reason in
part.

2.	Hides a lot of stuff in macros so we get peculiar un C like
assignments that hide the actual functionality. I want to *see* what is
going on when I touch the code not hide it, at least within the pnp layer

3.	Object lifetime and internal completeness - dev->res should
point to everything that is neccessary to manage the resource set. It
should be updatable in a consistent locked manner. That matters the
moment you do any dynamic reassignment of resources affecting a live
object, it matters the moment you want to do things like work with
resources cleanly without the device structure.

Now I would suggest that #2 and #3 actually matter right now. We can
argue about whether its called a wombat or banana and rename them any day
of the week.


What I would thus like to see is a patch set which

1.	Switches to krealloc resources internally and moves the
resource count sizes into the resource object but without hiding internal
detail in magic macros (macros for device side are good internal bad
generally). Nothing dynamic after setup *yet*

2.	Update any driver specific assumptions about resource walking


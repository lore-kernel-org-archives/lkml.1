Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYGSU1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYGSU1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 16:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYGSU1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 16:27:13 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1873 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752960AbYGSU1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 16:27:12 -0400
Date: Sat, 19 Jul 2008 16:27:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Re  [patch 2/3] fastboot: turn the USB hostcontroller initcalls
 into async initcalls
In-Reply-To: <20080719083942.2daa2959@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0807191618380.6459-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008, Arjan van de Ven wrote:

> On Sat, 19 Jul 2008 11:25:29 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > On 18 July, 2008, Arjan van de Ven wrote:
> > 
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Subject: [PATCH] fastboot: turn the USB hostcontroller initcalls
> > > into async initcalls
> > > 
> > > the USB host controller init calls take a long time, mostly due to a
> > > "minimally 100 msec" delay *per port* during initialization.
> > > These are prime candidates for going in parallel to everything else.
> > > 
> > > The USB device ordering is not affected by this due to the
> > > serialized-within-eachother property of async initcalls.
> > 
> > 
> > Where is this "minimally 100 msec" per-port delay you refer to?  
> > Offhand I can't recall any such delays in the init routines.
> > 
> 
> it's here (in drivers/usb/core/hub.c::hub_power_on):
> 
>                                 "non-switchable hub\n");
>         for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
>                 set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);
> 
>         /* Wait at least 100 msec for power to become stable */
>         msleep(max(pgood_delay, (unsigned) 100));
> }
> 
> at least my eeepc901 hits that like 6 or 7 times
> (because if I shorten the 100 the boot goes a ton faster.. but that's
> obviously just a bad hack)

That isn't a *per-port* delay.  It's a single delay used concurrently
for all the ports in the root hub; the msleep call occurs outside the 
"for" loop.

Maybe you meant 100 ms *per controller*.  I agree, it's best for these 
delays to occur in parallel.  Now if only we could do the same with 
suspend and resume...

Alan Stern


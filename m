Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZBCDsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZBCDsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZBCDsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:48:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbZBCDsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:48:09 -0500
Date: Mon, 2 Feb 2009 19:47:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233631820.16867.27.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902021941120.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <200902030045.19416.rjw@sisk.pl>  <alpine.LFD.2.00.0902021551050.3247@localhost.localdomain>  <200902030115.32659.rjw@sisk.pl>  <alpine.LFD.2.00.0902021622350.3247@localhost.localdomain> 
 <1233623525.18767.151.camel@pasglop>  <alpine.LFD.2.00.0902021729510.3247@localhost.localdomain>  <1233625606.18767.157.camel@pasglop> <1233631820.16867.27.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> On Tue, 2009-02-03 at 12:46 +1100, Benjamin Herrenschmidt wrote:
> >
> > Radeons don't do much with config space... the worst we may miss I
> > suppose is subsystem vendor/device... Maybe I'll add something to
> > explicitely save and restore it or X might get upset. I'll have a look.
> 
> Actually, subsystem stuff is below 0x40 so it should be fine too.

The things above 0x40 tend to be:

 - capabilities (values and next-pointers)

   The PCI layer will save a random couple of these (read: the ones it 
   cares about)

 - random non-architected values specific to that chip. And sometimes 
   these are important. Like ISA interrupt routing information for cardbus 
   controllers. Or timing values set up by the BIOS.

but in 99% of all cases the stuff isn't really anything special, or is 
just fine at its cold-reset default values. But I could in theory see that 
some graphics card could hide things like DRAM timings in there, that get 
initialized on POST, but not (obviously) on a STR cycle.

So it could go either way. Totally unimportant or hugely important. Most 
cards don't seem to care, and saving just the low 64 bytes seems to work 
for almost all drivers.

			Linus

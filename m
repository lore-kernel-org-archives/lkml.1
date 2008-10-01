Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYJAPQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYJAPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 11:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYJAPQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 11:16:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbYJAPQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:16:16 -0400
Date: Wed, 1 Oct 2008 08:14:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grant Grundler <grundler@parisc-linux.org>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in
 quirk_system_pci_resources()
In-Reply-To: <20081001061328.GD7348@colo.lackof.org>
Message-ID: <alpine.LFD.2.00.0810010800510.11040@nehalem.linux-foundation.org>
References: <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org> <48E24C6F.3030903@keyaccess.nl>
 <alpine.LFD.2.00.0809300904530.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301001280.3389@nehalem.linux-foundation.org> <alpine.LFD.2.00.0809301015210.4651@nehalem.linux-foundation.org> <20080930193819.GA29860@elte.hu>
 <alpine.LFD.2.00.0809301244290.3262@nehalem.linux-foundation.org> <20081001061328.GD7348@colo.lackof.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Oct 2008, Grant Grundler wrote:
> > 
> > And then we can create a separate set of these dependency points, so that 
> > X and Y don't have to know about each other, they just have to have some 
> > knowledge about some common synchronization point - one that exists 
> > regardless of whether X or Y are even compiled in!
> 
> We already do this today. :)
> Definitions are in include/linux/init.h.

Absolutely. 

The problem with the current <linux/init.h> isn't that it doesn't work - 
it's worked pretty well for a long time - it's that we continually tend to 
hit the limits of the few fixed points.

I would just extend on that notion a bit, and also make the markers a bit 
more dynamic. Instead of having just 7-8 levels of initcalls, and a very 
fixed naming that is a bit misleading, I'd like to extend it to maybe 50 
levels, and the levels would be named by the subsystems and then just have 
one single place that orders them.

The old 7 levels (plus the "pure" one) would still exist, so it wouldn't 
need to be a flag-day event.

For example: why would you use "fs_initcall()" for the PnP init? The 
reason is simple: it's not a filesystem init, but it's the one that comes 
after the subsys init and before the actual low-leveld drivers. We used to 
initialize the core filesystem data (VFS) at that stage (we still do, 
although most of the actual filesystems are actually just done using the 
default module-init much later), which explains the naming, but the 
problem is that

 (a) we want to order things at a finer granularity than that
 (b) we want to have a better and more descriptive naming

but the basic notion of having a fixed ordering certainly isn't wrong (and 
I already argued against any _dynamic_ one).

> Point A would be "early" ("run before initialing SMP")
> The rest could use better definitions and AFAICT aren't that much better
> than being named "Point B".

It would be *much* better to give them symbolic names (easy enough - we 
just turn them into sections that are symbolic anyway), and then have a 
list of ordering for those symbolic names.

So they sure as hell would be much better than being named "Point B". We 
could get rid of

	subsys_initcall(pci_init)

and instead do

	initcall(pci_init, "pci");
	..
	initcall(pnp_init, "pnp");

and then just list the levels for the linker scripts in one place. So that 
we wouldn't really have to worry about link ordering: if the link ordering 
is wrong, we just add a new initcall level and insert it in the right 
place, and then we can look at the ordering and see it explicitly in one 
place instead of looking at the makefiles and checking the order we add 
object files to the list in!

		Linus

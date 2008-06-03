Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYFCQ6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYFCQ6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYFCQ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:58:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:26796 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbYFCQ6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:58:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,584,1204531200"; 
   d="scan'208";a="335544638"
Date: Tue, 3 Jun 2008 09:49:03 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080603094903.280775ae@appleyard>
In-Reply-To: <48443E3F.8050306@garzik.org>
References: <20080508161008.59361de5@appleyard>
	<20080527030854.GC7515@mit.edu>
	<20080527143202.4bab5bf0@appleyard>
	<20080527225926.GE6843@mit.edu>
	<20080527163251.04054a74@appleyard>
	<20080531080015.GG5405@ucw.cz>
	<4842F5A8.9020708@garzik.org>
	<20080602080440.25fc663c@core>
	<4843A4A7.3020809@garzik.org>
	<4843EF88.2040606@rtr.ca>
	<48441AA6.8080704@garzik.org>
	<20080602100019.3d2d2522@appleyard>
	<484431AB.7010005@garzik.org>
	<20080602104753.3f24087d@appleyard>
	<484438BF.7070303@garzik.org>
	<20080602111644.54738d57@appleyard>
	<48443E3F.8050306@garzik.org>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008 14:38:55 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Kristen Carlson Accardi wrote:
> > On Mon, 02 Jun 2008 14:15:27 -0400
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> Kristen Carlson Accardi wrote:
> >>> Here you can see that it would be very easy for another driver
> >>> to just add code to set the NO_HOTPLUG flag and then this code
> >>> will work for them as well, since we power off the phy using
> >>> DET which is specified by SATA.
> >>> here's that code:
> >> Agreed.  The main discussion in this sub-thread is more about user 
> >> interface.  The user interface in this case, a module option, is 
> >> specific to AHCI.
> >>
> >> Surely you can see how it is a bit silly to force each driver writer to 
> >> create the same user interface in each driver, to support a generic concept.
> >>
> >> 	Jeff
> >>
> >>
> > Not all drivers will need a user interface to turn off hotplug
> > I would think.  At any rate - I would think it'd be better to let
> > driver writers decide how they want their drivers to behave wrt
> > hotplug and power instead of forcing a generic policy on everyone.
> > 
> > This patch would provide users of AHCI controllers a way to save
> > power now, while you work on the grand scheme for polling/turning on off
> > hotplug via sysfs.  It's an interim solution that impacts nobody but
> > ahci users and is can be easily integrated into whatever solution you
> > eventually work out.
> 
> It's a one-off driver-specific interface that will have to be supported 
> even after the same feature is available via libata core...  that's not 
> the path to scalable, sustainable engineering.

Jeff - I think you are misunderstanding what the module parameter 
is doing.  It is not a substitute for the sysfs interface that you
proposed.  You would not want to get rid of it ever.  What it does
is set the default of the AHCI driver to favor the BIOS settings
for which ports are hotpluggable.  the parameter is there to allow
users to override the BIOS settings at module load time.  Once you
get your sysfs interface in, you would then be able to override
the default at run time.  

> 
> I know user interfaces are annoying because you have to think about 
> chips other than your own, but that's life.  Other hardware vendors have 
> to do it too.

User interfaces are annoying because it takes 2 maintainers to agree
on them, that is all.  Surely you remember how long it took AN to
get in?  It was about 9 months.  This patch can go in now while we
spend 9 months deciding how to do the ultimate sysfs interface.

> 
> Letting each driver have a different user interface is /unfriendly/ to 
> both developers users.  It's easiest for Intel kernel developers, but 
> that is not our target audience :)
> 
> The biggest power savings for the largest amount of users can be had if 
> you take a moment and figure out what's best for Linux, rather than what 
> is best for Intel.
> 
> Because you can be damned sure SATA users with non-AHCI chips want this 
> power savings too...  let's not put roadblocks to that in place in the 
> beginning (by adding one-off interfaces).

As I've been trying to explain to you.  a) this isn't a one off interface.
b) this patch doesn't prevent you at all from adding a generic interface
later.  Perhaps you have a non-technical reason for not wanting this
patch, but I'd like to make sure there's nothing here that you are
just not understanding or something that I can fix.  I obviously can't
fix your idea that I only care about Intel chips, not matter how utterly
wrong and not supported by the facts that is.


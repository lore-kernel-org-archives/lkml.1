Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYHSV1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYHSV1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYHSV1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:27:23 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:16850 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYHSV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:27:22 -0400
Date: Tue, 19 Aug 2008 15:26:30 -0600
From: Alex Chiang <achiang@hp.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH 04/13] PCI: acpiphp: remove 'name' parameter
Message-ID: <20080819212630.GF18842@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Rolf Eike Beer <eike-kernel@sf-tec.de>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	kaneshige.kenji@jp.fujitsu.com
References: <20080816235504.5461.20733.stgit@blender.achiang> <200808171059.50802.eike-kernel@sf-tec.de> <20080819183908.GD18842@ldl.fc.hp.com> <200808192301.56532.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808192301.56532.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rolf Eike Beer <eike-kernel@sf-tec.de>:
> Alex Chiang wrote:
> > * Rolf Eike Beer <eike-kernel@sf-tec.de>:
> > > Alex Chiang wrote:
> > > >
> > > > +static inline const char *slot_name(struct slot *slot)
> > > > +{
> > > > +	return hotplug_slot_name(slot->hotplug_slot);
> > > > +}
> > > > +
> > > >  /*
> > > >   * struct acpiphp_bridge - PCI bridge information
> > > >   *
> > >
> > > I don't see a point in this function. Why not call hotplug_slot_name()
> > > directly?
> >
> > You're correct that we don't exactly need it in acpiphp. However,
> > it is a useful helper function for some of the other drivers, and
> > I thought it would be better to keep consistency if possible.
> 
> I looked into all other patches and the function is the same in every one.

For example, in shpchp, I use slot_name() in both shpchp_core.c
and in shpchp_ctrl.c. This is the case for a few other drivers
too.

Based on that reasoning, I felt a little consistency across
drivers was warranted. Besides, the generated code should be the
same.

> > > >  	acpiphp_slot->slot = slot;
> > > > -	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
> > > > +	memset(name, 0, SLOT_NAME_SIZE);
> > > > +	snprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
> > >
> > > The memset() is not needed at all. And the sizeof is IMHO a good idea
> > > anyway as it allows to get rid of the define.
> >
> > Hm, don't need a memset? I won't have garbage on the stack?
> > </n00b>
> 
> Yes, you have garbage on the stack. But snprintf() does not care what is in 
> the buffer before it starts and the result is 0-terminated afterwards.

Ok, you're right. For some reason, I was thinking that there were
versions of snprintf() that did not NULL-terminate in the event
of truncation, but I checked the kernel implementation, and it
does NULL terminate in either case.

Besides, it looks like I should be using scnprintf() instead. So
I'll rework the patches.
 
> > On the other hand, keeping the #define is important, because
> > again, that's the established convention of the PCI hotplug
> > drivers.
> 
> I would not bet on this. It has been there and copied around
> from one driver to the other. If we can get rid of those I
> guess noone would be upset. And you introduced at least two of
> them ;) Jesse? 

The #define exists in the original pcihp_skeleton.c example.

This is perhaps the 2nd or 3rd time I've swept through the
PCI hotplug drivers for cleanups, and for me, I really prefer
some sort of consistency, otherwise I go insane trying to keep
track of the differences.

But I will defer to Jesse's opinion.

Thanks,

/ac


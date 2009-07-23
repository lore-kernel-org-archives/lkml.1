Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZGWQOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZGWQOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZGWQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:14:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbZGWQOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:14:07 -0400
Date: Thu, 23 Jul 2009 09:12:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.31-rc4: strange change in iomem allocation
In-Reply-To: <200907231653.48933.elendil@planet.nl>
Message-ID: <alpine.LFD.2.01.0907230905360.21520@localhost.localdomain>
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain> <200907231614.23570.elendil@planet.nl> <200907231653.48933.elendil@planet.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jul 2009, Frans Pop wrote:

> On Thursday 23 July 2009, Frans Pop wrote:
> > I'm seeing the following change in dmesg between -rc3 and -rc4:
> > -system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
> > +system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
> >
> > There is nothing in the earlier part of dmesg that would explain this
> > change.
> >
> > The change is also visible in /proc/iomem:
> >  fec00000-fec00fff : IOAPIC 0
> >    fec00000-fec00fff : reserved
> > -    fec00000-fec000ff : pnp 00:0c
> >
> > I somewhat suspect 857fdc53a0a90c3ba7fcf5b1fb4c7a62ae03cf82:
> >     x86/pci: insert ioapic resource before assigning unassigned resources
> 
> Reverting that commit did indeed restore the old situation.

Don't worry about the new warning. 

It is in fact _normal_ to see a number of warnings about PnP resources 
"could not be reserved", because there are a number of sources of 
resources that we trust more than the PnP stuff, so we make the IO 
reservations based on those other sources of information. And then the PnP 
layer comes along, and can't reserve things any more because they are 
already reserved.

So the only thing that changed is that now we moved the APIC reservation 
earlier, exactly because we trust our knowledge of the hardware "more" 
than some other things.

You can google for "could not be reserved" (quotes needed to make it get 
anything relevant, of course), and you'll see a lot of dmesg's. The 
warning is interesting in the sense that _if_ there are any PCI resource 
issues, it hints about the fact that we got resource information from 
different places and they overlapped, so I wouldn't want to remove it.

So think of it this way: the difference between "has been reserved" and 
"could not be reserved" is _not_ a "good" vs "bad" situation. They are 
both purely informational. They're not good-or-bad, they are information 
we leave around in case bad things happen later.

		Linus

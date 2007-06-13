Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXFMTNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXFMTNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXFMTNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:13:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41260 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbXFMTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:13:39 -0400
Subject: Re: [kvm-devel] kvm + IOMMU
From: Gregory Haskins <ghaskins@novell.com>
To: David Brown <dmlb2000@gmail.com>
Cc: kvm-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <9c21eeae0706131152y64b02e6fs4d120fcc3a5343fe@mail.gmail.com>
References: <9c21eeae0706131027i21d97e16k7aedf54134c727b8@mail.gmail.com>
	 <1181759552.16287.23.camel@ghaskins-t60p.haskins.net>
	 <9c21eeae0706131152y64b02e6fs4d120fcc3a5343fe@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 15:12:40 -0400
Message-Id: <1181761960.16287.34.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 11:52 -0700, David Brown wrote:
> > Hi David,
> >   I am not an expert here, but I don't believe it would work without
> > changes to KVM.  My understanding is that you use an IOMMU in this
> > fashion if you want to direct-map a device into a guest for devices that
> > do not have a local IOMMU-like functionality built in already.  For
> > instance, perhaps you want to assign an off-the-shelf ethernet NIC to a
> > guest.  The IOMMU would serve to translate between GPA and system based
> > DMA addresses.  However, the hypervisor would really need to be involved
> > in the setup of this mapping on the IOMMU in the first place.
> 
> Okay its understandable that the initial setup of the mapping between
> virtual and actual would be done by some OS (most-likely host).
> However isn't the actual mapping when the guest starts and requests
> devices supposed to be handled by hardware? I would think performance
> wouldn't scale very well if the host OS had to maintain mappings and
> translate addresses every time a guest requests access to a mapped
> device.

Sorry, I didn't word that very well.  The hypervisor would have to do
the initial setup, and possibly any bookkeeping updates as the state of
the MMU mappings change over time (if applicable).  But this is
"slow-path" type stuff.  Once the mappings are in place, memory accesses
are handled by the hardware at full speed.

This is akin to how an OS sets up the regular MMU, but then the task
runs at full speed directly on the memory until something like a fault
occurs.  Essentially, IOMMUs perform translation for the peripheral
busses "in" to memory, as a regular MMU performs translation "out".
Someone has to be behind the wheel configuring the translation tables.
However, once they are setup, accesses to memory within the configured
regions happen without software interaction.

> 
> > KVM (currently) virtualizes/emulates all components in the logical
> > "system" presented to the guest.  It doesn't yet support the notion of
> > direct-mapping a physical component.  I doubt you will have to wait too
> > long for someone to add this feature, however :)  It's just not there
> > today (to my knowledge, anyway)
> 
> That's good to hear. :)
> 
> > But to answer your question, when configured up like this the IO
> > subsystem in question should perform pretty close to native (at least in
> > theory).
> 
> Hopefully you mean that the hardware is handling the mapping so that
> the host OS won't have to take the burden of mapping a bunch of
> addresses all the time.

That's correct.

> 
> Thanks,
> - David Brown


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbYFCVJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbYFCVJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYFCVJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:09:26 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59887 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbYFCVJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:09:25 -0400
Subject: Re: [PATCH 2/3] [2.6.26] ehea: Add dependency to Kconfig
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Hannes Hering <hannes.hering@linux.vnet.ibm.com>, jeff@garzik.org,
       tklein@de.ibm.com, themann@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       ossthema@de.ibm.com
In-Reply-To: <20080603204908.GB7475@localdomain>
References: <200805071443.20192.hannes.hering@linux.vnet.ibm.com>
	 <20080528164405.GA4836@localdomain>
	 <200806031007.40162.hannes.hering@linux.vnet.ibm.com>
	 <20080603204908.GB7475@localdomain>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 14:08:55 -0700
Message-Id: <1212527335.23656.2.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 15:49 -0500, Nathan Lynch wrote:
> Hannes Hering wrote:
> > 
> > On Wednesday 28 May 2008 18:44:05 Nathan Lynch wrote:
> > > 
> > > Hannes Hering wrote:
> > > > The new ehea memory hot plug implementation depends on MEMORY_HOTPLUG.
> > > > 
> > > > Signed-off-by: Hannes Hering <hering2@de.ibm.com>
> > > > ---
> > > > 
> > > > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > > > index f90a86b..181cd86 100644
> > > > --- a/drivers/net/Kconfig
> > > > +++ b/drivers/net/Kconfig
> > > > @@ -2440,7 +2440,7 @@ config CHELSIO_T3
> > > >  
> > > >  config EHEA
> > > >  	tristate "eHEA Ethernet support"
> > > > -	depends on IBMEBUS && INET && SPARSEMEM
> > > > +	depends on IBMEBUS && INET && SPARSEMEM && MEMORY_HOTPLUG
> > > >  	select INET_LRO
> > > >  	---help---
> > > >  	  This driver supports the IBM pSeries eHEA ethernet adapter.
> > > 
> > > I disagree with this change.
> > > 
> > > It makes it impossible to build the ehea driver without memory hotplug
> > > enabled.  Presumably, this commit was intended to work around a build
> > > break of this sort (with EHEA=m and MEMORY_HOTPLUG=n):
> > > 
> > > drivers/net/ehea/ehea_qmr.c: In function 'ehea_create_busmap':
> > > drivers/net/ehea/ehea_qmr.c:635: error: implicit declaration of function 'walk_memory_resource'
> > > 
> > > (some indication of this should have been in the commit message, btw)
> > > 
> > > I think this was the wrong way to fix the issue.  EHEA=m and
> > > MEMORY_HOTPLUG=n is a valid configuration for machines I test.
> > > 
> > > Any thoughts on the following, which makes walk_memory_resource()
> > > available regardless of MEMORY_HOTPLUG's setting?  I've tested it on a
> > > JS22 (Power6 blade).
> >
> > I agree that the ehea cannot be built without MEMORY_HOTPLUG. The
> > problem is the fact that the ppc walk_memory_resource declaration is
> > in the scope of MEMORY_HOTPLUG. At the moment I don't have complete
> > overview if the move of the code as you propose in your patch has
> > any side effects. We probably need to talk to Badari who provided
> > the walk_memory_resource code. We can also just throw it onto one of
> > our boxes to see what happens. ;)
> 
> I would certainly appreciate any additional testing.

I think we can make walk_memory_resource() for ppc64 available
outside of MEMORY_HOTPLUG. It doesn't require any MEMORY_HOTPLUG
functionality to work correctly. Its a generic enough interface.
Only reason I placed it under MEMORY_HOTPLUG is to have parity
with the arch-independent version + we needed for eHEA driver whic
needs MEMORY_HOTPLUG.

> You wrote the ehea code that uses walk_memory_resource, so I was
> hoping you could speak to whether ehea needs that interface when
> CONFIG_MEMORY_HOTPLUG=n.  Or maybe there should be a no-op version of
> walk_memory_resource for that case?  And what about the
> arch-independent version in kernel/resource.c?  Badari?


I would leave the arch-independent version alone - since its not
exported and there are no users for it.

> It would be nice to get this resolved for 2.6.26 -- this new
> dependency causes working 2.6.25 configs to effectively fail (by
> deselecting CONFIG_EHEA during make oldconfig).

Thanks,
Badari


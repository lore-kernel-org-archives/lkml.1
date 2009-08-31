Return-Path: <linux-kernel-owner+w=401wt.eu-S1752167AbZHaWff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbZHaWff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 18:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZHaWfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 18:35:34 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:41325 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbZHaWfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 18:35:33 -0400
Subject: RE: [PATCH] SCSI driver for VMware's virtual HBA.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Dmitry Torokhov <dtor@vmware.com>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "robert.w.love@intel.com" <robert.w.love@intel.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>,
       Maxime Austruy <maustruy@vmware.com>,
       Bhavesh Davda <bhavesh@vmware.com>
In-Reply-To: <412A05BA40734D4887DBC67661F433080FF71D90@EXMAIL.ad.emulex.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com>
	 <412A05BA40734D4887DBC67661F433080FF71D16@EXMAIL.ad.emulex.com>
	 <1251498656.25584.7.camel@ank32.eng.vmware.com>
	 <412A05BA40734D4887DBC67661F433080FF71D90@EXMAIL.ad.emulex.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 31 Aug 2009 15:35:36 -0700
Message-Id: <1251758136.16169.74.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chetan,

> > 
> > On Fri, 2009-08-28 at 14:18 -0700, Chetan.Loke@Emulex.Com wrote:
> > > Alok,
> > >
> > >
> > > > +static int __devinit pvscsi_allocate_rings(struct pvscsi_adapter
> > > > *adapter)
> > > > +{
> > > > +	adapter->rings_state = pci_alloc_consistent(adapter->dev, PAGE_SIZE,
> > > > +						    &adapter->ringStatePA);
> > > > +	adapter->req_ring = pci_alloc_consistent(adapter->dev,
> > > > +						 adapter->req_pages * PAGE_SIZE,
> > > > +						 &adapter->reqRingPA);
> > > > +	adapter->cmp_ring = pci_alloc_consistent(adapter->dev,
> > > > +						 adapter->cmp_pages * PAGE_SIZE,
> > > > +						 &adapter->cmpRingPA);
> 
> 
> > >
> > > I understand the emulation etc. But I see that this function isn't
> > > allocating multiple rings right? Didn't see any performance benefits?
> > >
> > 
> > The function is allocating multiple rings, actually 2 of them for the
> > IO path, request and completion rings (req_ring, cmp_ring).
> > 
> > Let me know if you were asking something else.
> > 
> 
> I was using 'Ring' loosely.
> So, Ring == [req_path,cmpl_path]
> Example - R0[req-path,cmpl-path]
> 
> But the code doesn't allocate R0,R1,...,RN.
> 
> Existing code - 
> 
>       --------
> 	Ring-0
> 	--------
> 	  Req 
> 	   +
> 	   |
>  	   +
>         Cmpl     
> 
> 
> Why not multiple rings as shown below - 
> 
>       --------	--------
> 	Ring-0	Ring-M
> 	--------	--------
> 	  Req 	  Req
> 	   +		   +
> 	   |		   |
>  	   +		   +
>         Cmpl     	  Cmpl
> 
> 
> 
> Creating multiple rings @ the guest level buys nothing in terms of
> performance? 

We implement single (pair of) rings in the hypervisor too. And haven't
seen that as a bottleneck in our experiments, yet. And IMO it only makes
sense to support that once their are devices which support multiple
request queues out their.

It would be interesting to understand your view point on this as well.
Have you seen any interesting performance data with multiple rings
support, in the emulation software that you are aware of ?  

> This is also related to how the hypervisor will schedule the
> world-interrupts. If 'a' pv-driver has multiple interrupt lines
> enabled then will the interrupts/ISR's get routed on different PCPU's
> for a vmworld? Or is there a limitation?

Right now since we support a single completion ring only one vector will
be used to deliver intr's. 
Though its important to note that pvscsi does support MSI-X and hence
can support enabling multiple vectors once the need arises.

Thanks,
Alok
> 
> 
> Chetan
> 


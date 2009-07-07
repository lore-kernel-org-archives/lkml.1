Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZGGNWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZGGNWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZGGNW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:22:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50588 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650AbZGGNWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:22:25 -0400
Date: Tue, 7 Jul 2009 16:21:36 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [KVM PATCH v9 2/2] KVM: add iosignalfd support
Message-ID: <20090707132136.GB7578@redhat.com>
References: <20090706202742.14222.65548.stgit@dev.haskins.net> <20090706203321.14222.67866.stgit@dev.haskins.net> <20090707112024.GA3647@redhat.com> <4A53372E.6090509@redhat.com> <20090707122250.GC3647@redhat.com> <4A533F45.90609@redhat.com> <20090707125148.GE3647@redhat.com> <4A53460B.8090401@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A53460B.8090401@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 08:56:43AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > On Tue, Jul 07, 2009 at 03:27:49PM +0300, Avi Kivity wrote:
> >   
> >> On 07/07/2009 03:22 PM, Michael S. Tsirkin wrote:
> >>     
> >>> On Tue, Jul 07, 2009 at 02:53:18PM +0300, Avi Kivity wrote:
> >>>    
> >>>       
> >>>>>> +		/* address-range must be precise for a hit */
> >>>>>>
> >>>>>>          
> >>>>>>             
> >>>>> So there's apparently no way to specify that
> >>>>> you want 1,2, or 4 byte writes at address X?
> >>>>>
> >>>>>        
> >>>>>           
> >>>> Why would you want that?
> >>>>      
> >>>>         
> >>> Donnu. Why would anyone want to catch 8 byte writes at all?
> >>>    
> >>>       
> >> One of the natural write sizes.
> >>
> >>     
> >>> Seriously, why add artificial limitations?
> >>> IMO, addr=0,len=1 and addr=0,len=2 should not conflict.
> >>>
> >>>    
> >>>       
> >> They should not conflict, but a two byte write need not hit a one byte  
> >> registration.
> >>     
> >
> > Yes. That's exactly what I'm saying. I think it should be possible to
> > create 2 fds:
> >
> > addr = 0
> > len = 1
> > addr = 0
> > len = 2
> > and at most one will ever trigger.
> >
> > But current code will not let you create the second one.
> >
> >   
> Note that this was by design to keep the code simple since we don't have
> a (known) use case for overlap.  At the very least, you have to address
> how data subsets are handled.  But do we really need that functionality?
> 
> -Greg
> 

Hey, forget about overlap. Overlap does not exist as a concept.  You now
spend a lot of effort to detect it. Kill all that code, and just do
this on assignment:

list_for_each(...)
	if (rhs->add == lhs->addr && rhs->len == lhs->len &&
	    (rhs->wildcard || lhs->wildcard || rhs->data == lhs->data))
		return -EEXIST;

-- 
MST

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZHQOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZHQOlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZHQOlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:41:14 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:44082 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbZHQOlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:41:13 -0400
Date: Mon, 17 Aug 2009 20:10:58 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Li, Shaohua" <shaohua.li@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090817144058.GA5126@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090812195753.GA14649@in.ibm.com> <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain> <20090813045931.GB14649@in.ibm.com> <20090814113021.GL32418@elf.ucw.cz> <20090816182629.GA31027@in.ibm.com> <20090816194441.GA22626@balbir.in.ibm.com> <1250459602.8648.35.camel@laptop> <20090817062418.GB31027@in.ibm.com> <1250493357.5241.1656.camel@twins> <20090817075815.GB11049@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817075815.GB11049@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 01:28:15PM +0530, Dipankar Sarma wrote:
> On Mon, Aug 17, 2009 at 09:15:57AM +0200, Peter Zijlstra wrote:
> > On Mon, 2009-08-17 at 11:54 +0530, Dipankar Sarma wrote:
> > > For most parts, we do. The guest kernel doesn't manage the offline
> > > CPU state. That is typically done by the hypervisor. However, offline
> > > operation as defined now always result in a VM resize in some hypervisor
> > > systems (like pseries) - it would be convenient to have a non-resize
> > > offline operation which lets the guest cede the cpu to hypervisor
> > > with the hint that the VM shouldn't be resized and the guest needs the guarantee
> > > to get the cpu back any time. The hypervisor can do whatever it wants
> > > with the ceded CPU including putting it in a low power state, but
> > > not change the physical cpu shares of the VM. The pseries hypervisor,
> > > for example, clearly distinguishes between the two - "rtas-stop-self" call
> > > to resize VM vs. H_CEDE hypercall with a hint. What I am suggesting
> > > is that we allow this with an extension to existing interfaces because it 
> > > makes sense to allow sort of "hibernation" of the cpus without changing any
> > > configuration of the VMs.
> > 
> > >From my POV the thing you call cede is the only sane thing to do for a
> > guest. Let the hypervisor management interface deal with resizing guests
> > if and when that's needed.
> 
> That is more or less how it currently works - atleast for pseries hypervisor. 
> The current "offline" operation with "rtas-stop-self" call I mentioned
> earlier is initiated by the hypervisor management interfaces/tool in
> pseries system. This wakes up a guest system tool that echoes "1"
> to the offline file resulting in the configuration change.

Should have said - echoes "0" to the online file. 

You don't necessarily need this in the guest Linux as long as there is
a way for hypervisor tools to internally move Linux tasks/interrupts
from a vcpu - async event handled by the kernel, for example.
But I think it is too late for that - the interface has long been
exported.


> The OS involvement is necessary to evacuate tasks/interrupts
> from the released CPU. We don't really want to initiate this from guests.
> 
> > Thing is, you don't want a guest to be able to influence the amount of
> > cpu shares attributed to it. You want that in explicit control of
> > whomever manages the hypervisor.
> 
> Agreed. But given a fixed cpu share by the hypervisor management tools,
> we would like to be able to cede cpus to hypervisor leaving the hypervisor
> configuration intact. This, we don't have at the moment and want to just
> extend the current interface for this.
> 
> Thanks
> Dipankar
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbZHQGYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbZHQGYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 02:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZHQGYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 02:24:35 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36440 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZHQGYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 02:24:35 -0400
Date: Mon, 17 Aug 2009 11:54:18 +0530
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
Message-ID: <20090817062418.GB31027@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20090810081941.GA18649@elf.ucw.cz> <1249950137.11545.38184.camel@localhost.localdomain> <20090812115806.GK24339@elf.ucw.cz> <20090812195753.GA14649@in.ibm.com> <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain> <20090813045931.GB14649@in.ibm.com> <20090814113021.GL32418@elf.ucw.cz> <20090816182629.GA31027@in.ibm.com> <20090816194441.GA22626@balbir.in.ibm.com> <1250459602.8648.35.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250459602.8648.35.camel@laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 11:53:22PM +0200, Peter Zijlstra wrote:
> On Mon, 2009-08-17 at 01:14 +0530, Balbir Singh wrote:
> > Agreed, I've tried to come with a little ASCII art to depict your
> > scenairos graphically
> > 
> > 
> >         +--------+ don't need (offline)
> >         |  OS    +----------->+------------+
> >         +--+-----+            | hypervisor +-----> Reuse CPU
> >            |                  |            |       for something
> >            |                  |            |       else
> >            |                  |            |   (visible to users)
> >            |                  |            |    as resource changed
> >            |                  +----------- +
> >            V (needed, but can cede)
> >        +------------+
> >        | hypervisor | Don't reuse CPU
> >        |            |  (CPU ceded)
> >        |            | give back to OS
> >        +------------+ when needed.
> >                         (Not visible to
> >                         users as so resource
> >                         binding changed)
> 
> I still don't get it... _why_ should this be exposed in the guest
> kernel? Why not let the hypervisor manage a guest's offline cpus in a
> way it sees fit?

For most parts, we do. The guest kernel doesn't manage the offline
CPU state. That is typically done by the hypervisor. However, offline
operation as defined now always result in a VM resize in some hypervisor
systems (like pseries) - it would be convenient to have a non-resize
offline operation which lets the guest cede the cpu to hypervisor
with the hint that the VM shouldn't be resized and the guest needs the guarantee
to get the cpu back any time. The hypervisor can do whatever it wants
with the ceded CPU including putting it in a low power state, but
not change the physical cpu shares of the VM. The pseries hypervisor,
for example, clearly distinguishes between the two - "rtas-stop-self" call
to resize VM vs. H_CEDE hypercall with a hint. What I am suggesting
is that we allow this with an extension to existing interfaces because it 
makes sense to allow sort of "hibernation" of the cpus without changing any
configuration of the VMs.

Thanks
Dipankar

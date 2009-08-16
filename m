Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZHPV5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZHPV5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZHPV5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:57:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:48086 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbZHPV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:57:22 -0400
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Pavel Machek <pavel@ucw.cz>,
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
In-Reply-To: <20090816194441.GA22626@balbir.in.ibm.com>
References: <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl>
	 <20090810081941.GA18649@elf.ucw.cz>
	 <1249950137.11545.38184.camel@localhost.localdomain>
	 <20090812115806.GK24339@elf.ucw.cz> <20090812195753.GA14649@in.ibm.com>
	 <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain>
	 <20090813045931.GB14649@in.ibm.com> <20090814113021.GL32418@elf.ucw.cz>
	 <20090816182629.GA31027@in.ibm.com>
	 <20090816194441.GA22626@balbir.in.ibm.com>
Content-Type: text/plain
Date: Sun, 16 Aug 2009 23:53:22 +0200
Message-Id: <1250459602.8648.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 01:14 +0530, Balbir Singh wrote:
> * Dipankar Sarma <dipankar@in.ibm.com> [2009-08-16 23:56:29]:
> 
> > On Fri, Aug 14, 2009 at 01:30:21PM +0200, Pavel Machek wrote:
> > > > 
> > > > It depends on the hypervisor implementation. On pseries (powerpc)
> > > > hypervisor, for example, they are different. By offlining a vcpu
> > > > (and in turn shutting a cpu), you will actually create a configuration
> > > > change in the VM that is visible to other systems management tools
> > > > which may not be what the system administrator wanted. Ideally,
> > > > we would like to distinguish between these two states.
> > > > 
> > > > Hope that suffices as an example.
> > > 
> > > So... you have something like "physically pulling out hotplug cpu" on
> > > powerpc.
> > 
> > If any system can do physical unplug, then it should do "offline"
> > with configuration changes reflected in the hypervisor and
> > other system configuration software.
> > 
> > > But maybe it is useful to take already offline cpus (from linux side),
> > > and make that visible to hypervisor, too.
> > > 
> > > So maybe something like "echo 1 > /sys/devices/system/cpu/cpu1/unplug"
> > > would be more useful for hypervisor case?
> > 
> > On pseries, we do an RTAS call ("stop-cpu") which effectively permantently
> > de-allocates it from the VM hands over the control to hypervisor. The
> > hypervisors may do whatever it wants including allocating it to
> > another VM. Once gone, the original VM may not get it back depending
> > on the situation.
> > 
> > The point I am making is that we may not always want to *release*
> > the CPU to hypervisor and induce a configuration change. That needs
> > to be reflected by extending the existing user interface - hence
> > the proposal for - /sys/devices/system/cpu/cpu<#>/state and
> > /sys/devices/system/cpu/cpu<#>/available_states. It allows
> > ceding to hypervisor without de-allocating. It is a minor
> > extension of the existing interface keeping backwards compatibility
> > and platforms can allow what make sense.
> >
> 
> 
> Agreed, I've tried to come with a little ASCII art to depict your
> scenairos graphically
> 
> 
>         +--------+ don't need (offline)
>         |  OS    +----------->+------------+
>         +--+-----+            | hypervisor +-----> Reuse CPU
>            |                  |            |       for something
>            |                  |            |       else
>            |                  |            |   (visible to users)
>            |                  |            |    as resource changed
>            |                  +----------- +
>            V (needed, but can cede)
>        +------------+
>        | hypervisor | Don't reuse CPU
>        |            |  (CPU ceded)
>        |            | give back to OS
>        +------------+ when needed.
>                         (Not visible to
>                         users as so resource
>                         binding changed)

I still don't get it... _why_ should this be exposed in the guest
kernel? Why not let the hypervisor manage a guest's offline cpus in a
way it sees fit?




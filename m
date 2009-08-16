Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZHPTov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZHPTov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZHPTou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:44:50 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:34063 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbZHPTot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:44:49 -0400
Date: Mon, 17 Aug 2009 01:14:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Li, Shaohua" <shaohua.li@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
Message-ID: <20090816194441.GA22626@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl> <20090810081941.GA18649@elf.ucw.cz> <1249950137.11545.38184.camel@localhost.localdomain> <20090812115806.GK24339@elf.ucw.cz> <20090812195753.GA14649@in.ibm.com> <alpine.LFD.2.00.0908122036580.22946@localhost.localdomain> <20090813045931.GB14649@in.ibm.com> <20090814113021.GL32418@elf.ucw.cz> <20090816182629.GA31027@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090816182629.GA31027@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dipankar Sarma <dipankar@in.ibm.com> [2009-08-16 23:56:29]:

> On Fri, Aug 14, 2009 at 01:30:21PM +0200, Pavel Machek wrote:
> > > 
> > > It depends on the hypervisor implementation. On pseries (powerpc)
> > > hypervisor, for example, they are different. By offlining a vcpu
> > > (and in turn shutting a cpu), you will actually create a configuration
> > > change in the VM that is visible to other systems management tools
> > > which may not be what the system administrator wanted. Ideally,
> > > we would like to distinguish between these two states.
> > > 
> > > Hope that suffices as an example.
> > 
> > So... you have something like "physically pulling out hotplug cpu" on
> > powerpc.
> 
> If any system can do physical unplug, then it should do "offline"
> with configuration changes reflected in the hypervisor and
> other system configuration software.
> 
> > But maybe it is useful to take already offline cpus (from linux side),
> > and make that visible to hypervisor, too.
> > 
> > So maybe something like "echo 1 > /sys/devices/system/cpu/cpu1/unplug"
> > would be more useful for hypervisor case?
> 
> On pseries, we do an RTAS call ("stop-cpu") which effectively permantently
> de-allocates it from the VM hands over the control to hypervisor. The
> hypervisors may do whatever it wants including allocating it to
> another VM. Once gone, the original VM may not get it back depending
> on the situation.
> 
> The point I am making is that we may not always want to *release*
> the CPU to hypervisor and induce a configuration change. That needs
> to be reflected by extending the existing user interface - hence
> the proposal for - /sys/devices/system/cpu/cpu<#>/state and
> /sys/devices/system/cpu/cpu<#>/available_states. It allows
> ceding to hypervisor without de-allocating. It is a minor
> extension of the existing interface keeping backwards compatibility
> and platforms can allow what make sense.
>


Agreed, I've tried to come with a little ASCII art to depict your
scenairos graphically


        +--------+ don't need (offline)
        |  OS    +----------->+------------+
        +--+-----+            | hypervisor +-----> Reuse CPU
           |                  |            |       for something
           |                  |            |       else
           |                  |            |   (visible to users)
           |                  |            |    as resource changed
           |                  +----------- +
           V (needed, but can cede)
       +------------+
       | hypervisor | Don't reuse CPU
       |            |  (CPU ceded)
       |            | give back to OS
       +------------+ when needed.
                        (Not visible to
                        users as so resource
                        binding changed)



-- 
	Balbir

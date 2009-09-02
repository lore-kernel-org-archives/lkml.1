Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZIBUCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZIBUCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 16:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZIBUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 16:02:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46149 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZIBUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 16:02:21 -0400
Date: Wed, 2 Sep 2009 22:02:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2 0/2] cpu: pseries: Offline state framework.
Message-ID: <20090902200214.GA1918@ucw.cz>
References: <20090828095741.10641.32053.stgit@sofia.in.ibm.com> <1251869611.7547.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251869611.7547.38.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-02 07:33:31, Peter Zijlstra wrote:
> On Fri, 2009-08-28 at 15:30 +0530, Gautham R Shenoy wrote:
> > Hi,
> > 
> > This is the version 2 of the patch series to provide a cpu-offline framework
> > that enables the administrators choose the state the offline CPU must be put
> > into when multiple such states are exposed by the underlying architecture.
> > 
> > Version 1 of the Patch can be found here:
> > http://lkml.org/lkml/2009/8/6/236
> > 
> > The patch-series exposes the following sysfs tunables to
> > allow the system-adminstrator to choose the state of a CPU:
> > 
> > To query the available hotplug states, one needs to read the sysfs tunable:
> > 	/sys/devices/system/cpu/cpu<number>/available_hotplug_states
> > To query or set the current state, on needs to read/write the sysfs tunable:
> > 	/sys/devices/system/cpu/cpu<number>/current_states
> > 
> > The patchset ensures that the writes to the "current_state" sysfs file are
> > serialized against the writes to the "online" file.
> > 
> > This patchset also contains the offline state driver implemented for
> > pSeries. For pSeries, we define three available_hotplug_states. They are:
> > 
> > 	online: The processor is online.
> > 
> > 	deallocate: This is the the default behaviour when the cpu is offlined
> > 	even in the absense of this driver. The CPU would call make an
> > 	rtas_stop_self() call and hand over the CPU back to the resource pool,
> > 	thereby effectively deallocating that vCPU from the LPAR.
> > 	NOTE: This would result in a configuration change to the LPAR
> > 	which is visible to the outside world.
> > 
> > 	deactivate: This cedes the vCPU to the hypervisor which
> > 	in turn can put the vCPU time to the best use.
> > 	NOTE: This option DOES NOT result in a configuration change
> > 	and the vCPU would be still entitled to the LPAR to which it earlier
> > 	belong to.
> > 
> > Awaiting your feedback.
> 
> I'm still thinking this is a bad idea.
> 
> The OS should only know about online/offline.
> 
> Use the hypervisor interface to deal with the cpu once its offline.
> 
> That is, I think this interface you propose is a layering violation.

Agreed. Plus having interface like 'go to this state during offliine'
then 'go offline' is strange/stupid. For hypervisor case, you might
want to change 'state' of cpu that is already offline.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

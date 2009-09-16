Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZIPHtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZIPHtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZIPHtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:49:13 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:63946 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZIPHtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:49:13 -0400
Date: Wed, 16 Sep 2009 09:48:49 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v3 0/3] cpu: pseries: Cpu offline states framework
Message-ID: <20090916074848.GB4870@osiris.boeblingen.de.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
 <1253016701.5506.73.camel@laptop>
 <20090915145834.GG4846@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915145834.GG4846@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 08:28:34PM +0530, Balbir Singh wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-09-15 14:11:41]:
> 
> > On Tue, 2009-09-15 at 17:36 +0530, Gautham R Shenoy wrote:
> > > This patchset contains the offline state driver implemented for
> > > pSeries. For pSeries, we define three available_hotplug_states. They are:
> > > 
> > >         online: The processor is online.
> > > 
> > >         offline: This is the the default behaviour when the cpu is offlined
> > >         even in the absense of this driver. The CPU would call make an
> > >         rtas_stop_self() call and hand over the CPU back to the resource pool,
> > >         thereby effectively deallocating that vCPU from the LPAR.
> > >         NOTE: This would result in a configuration change to the LPAR
> > >         which is visible to the outside world.
> > > 
> > >         inactive: This cedes the vCPU to the hypervisor with a cede latency
> > >         specifier value 2.
> > >         NOTE: This option does not result in a configuration change
> > >         and the vCPU would be still entitled to the LPAR to which it earlier
> > >         belong to.
> > > 
> > > Any feedback on the patchset will be immensely valuable.
> > 
> > I still think its a layering violation... its the hypervisor manager
> > that should be bothered in what state an off-lined cpu is in. 
> >
> 
> From a design standpoint where we stand today is
> 
> 1. A cede indicates that the CPU is no longer needed and can be
> reassigned (remember we do dedicated CPU partitions in power)
> 2. What this patch is trying to do is to say "We don't need the
> CPU, but please don't reassign, put it to sleep"

FWIW, this sounds exactly like the same we have already on s390.
But back then I didn't consider adding a common code infrastructure
would make sense :)

Besides the "online" attribute we have an additional "configure"
attribute to which can only be written if the cpu is offline.
Writing a "0" to it would mean that you currently won't need the cpu
anymore and the hypervisor is free to reassign the cpu to a different
LPAR.
Writing a "1" to it means you want to use it. If there are enough
resources you will get it. If not.. bad luck.

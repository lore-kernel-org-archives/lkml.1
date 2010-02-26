Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966360Ab0BZWVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 17:21:36 -0500
Received: from trinity.develer.com ([83.149.158.210]:36135 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966086Ab0BZWVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 17:21:35 -0500
Date: Fri, 26 Feb 2010 23:21:21 +0100
From: Andrea Righi <arighi@develer.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
Message-ID: <20100226222121.GA4999@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <1266765525-30890-3-git-send-email-arighi@develer.com>
 <20100223212943.GF11930@redhat.com>
 <20100225151211.GC3964@linux>
 <20100226214811.GB7498@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226214811.GB7498@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 04:48:11PM -0500, Vivek Goyal wrote:
> On Thu, Feb 25, 2010 at 04:12:11PM +0100, Andrea Righi wrote:
> > On Tue, Feb 23, 2010 at 04:29:43PM -0500, Vivek Goyal wrote:
> > > On Sun, Feb 21, 2010 at 04:18:45PM +0100, Andrea Righi wrote:
> > > 
> > > [..]
> > > > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > > > index 0b19943..c9ff1cd 100644
> > > > --- a/mm/page-writeback.c
> > > > +++ b/mm/page-writeback.c
> > > > @@ -137,10 +137,11 @@ static struct prop_descriptor vm_dirties;
> > > >   */
> > > >  static int calc_period_shift(void)
> > > >  {
> > > > -	unsigned long dirty_total;
> > > > +	unsigned long dirty_total, dirty_bytes;
> > > >  
> > > > -	if (vm_dirty_bytes)
> > > > -		dirty_total = vm_dirty_bytes / PAGE_SIZE;
> > > > +	dirty_bytes = mem_cgroup_dirty_bytes();
> > > > +	if (dirty_bytes)
> > > > +		dirty_total = dirty_bytes / PAGE_SIZE;
> > > >  	else
> > > >  		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
> > > >  				100;
> > > 
> > > Ok, I don't understand this so I better ask. Can you explain a bit how memory
> > > cgroup dirty ratio is going to play with per BDI dirty proportion thing.
> > > 
> > > Currently we seem to be calculating per BDI proportion (based on recently
> > > completed events), of system wide dirty ratio and decide whether a process
> > > should be throttled or not.
> > > 
> > > Because throttling decision is also based on BDI and its proportion, how
> > > are we going to fit it with mem cgroup? Is it going to be BDI proportion
> > > of dirty memory with-in memory cgroup (and not system wide)?
> > 
> > IMHO we need to calculate the BDI dirty threshold as a function of the
> > cgroup's dirty memory, and keep BDI statistics system wide.
> > 
> > So, if a task is generating some writes, the threshold to start itself
> > the writeback will be calculated as a function of the cgroup's dirty
> > memory. If the BDI dirty memory is greater than this threshold, the task
> > must start to writeback dirty pages until it reaches the expected dirty
> > limit.
> > 
> 
> Ok, so calculate dirty per cgroup and calculate BDI's proportion from
> cgroup dirty? So will you be keeping track of vm_completion events per
> cgroup or will rely on existing system wide and per BDI completion events
> to calculate BDI proportion?
> 
> BDI proportion are more of an indication of device speed and faster device
> gets higher share of dirty, so may be we don't have to keep track of
> completion events per cgroup and can rely on system wide completion events
> for calculating the proportion of a BDI.
> 
> > OK, in this way a cgroup with a small dirty limit may be forced to
> > writeback a lot of pages dirtied by other cgroups on the same device.
> > But this is always related to the fact that tasks are forced to
> > writeback dirty inodes randomly, and not the inodes they've actually
> > dirtied.
> 
> So we are left with following two issues.
> 
> - Should we rely on global BDI stats for BDI_RECLAIMABLE and BDI_WRITEBACK
>   or we need to make these per cgroup to determine actually how many pages
>   have been dirtied by a cgroup and force writeouts accordingly?
> 
> - Once we decide to throttle a cgroup, it should write its inodes and
>   should not be serialized behind other cgroup's inodes.  

We could try to save who made the inode dirty
(inode->cgroup_that_made_inode_dirty) so that during the active
writeback each cgroup can be forced to write only its own inodes.

-Andrea

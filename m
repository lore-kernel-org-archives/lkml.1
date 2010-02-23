Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0BWT4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:56:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab0BWT4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:56:47 -0500
Date: Tue, 23 Feb 2010 14:56:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
Message-ID: <20100223195606.GD11930@redhat.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-3-git-send-email-arighi@develer.com> <20100222165215.GA3096@redhat.com> <20100223094040.GC1882@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223094040.GC1882@linux>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 10:40:40AM +0100, Andrea Righi wrote:
> On Mon, Feb 22, 2010 at 11:52:15AM -0500, Vivek Goyal wrote:
> > >  unsigned long determine_dirtyable_memory(void)
> > >  {
> > > -	unsigned long x;
> > > -
> > > -	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
> > > -
> > > +	unsigned long memcg_memory, memory;
> > > +
> > > +	memory = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
> > > +	memcg_memory = mem_cgroup_page_state(MEMCG_NR_FREE_PAGES);
> > > +	if (memcg_memory > 0) {
> > 
> > it could be just 
> > 
> > 	if (memcg_memory) {
> 
> Agreed.
> 
> > 	}
> > 
> > > +		memcg_memory +=
> > > +			mem_cgroup_page_state(MEMCG_NR_RECLAIMABLE_PAGES);
> > > +		if (memcg_memory < memory)
> > > +			return memcg_memory;
> > > +	}
> > >  	if (!vm_highmem_is_dirtyable)
> > > -		x -= highmem_dirtyable_memory(x);
> > > +		memory -= highmem_dirtyable_memory(memory);
> > >  
> > 
> > If vm_highmem_is_dirtyable=0, In that case, we can still return with
> > "memcg_memory" which can be more than "memory".  IOW, highmem is not
> > dirtyable system wide but still we can potetially return back saying
> > for this cgroup we can dirty more pages which can potenailly be acutally
> > be more that system wide allowed?
> > 
> > Because you have modified dirtyable_memory() and made it per cgroup, I
> > think it automatically takes care of the cases of per cgroup dirty ratio,
> > I mentioned in my previous mail. So we will use system wide dirty ratio
> > to calculate the allowed dirty pages in this cgroup (dirty_ratio *
> > available_memory()) and if this cgroup wrote too many pages start
> > writeout? 
> 
> OK, if I've understood well, you're proposing to use per-cgroup
> dirty_ratio interface and do something like:

I think we can use system wide dirty_ratio for per cgroup (instead of
providing configurable dirty_ratio for each cgroup where each memory
cgroup can have different dirty ratio. Can't think of a use case
immediately).
> 
> unsigned long determine_dirtyable_memory(void)
> {
> 	unsigned long memcg_memory, memory;
> 
> 	memory = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
> 	if (!vm_highmem_is_dirtyable)
> 		memory -= highmem_dirtyable_memory(memory);
> 
> 	memcg_memory = mem_cgroup_page_state(MEMCG_NR_FREE_PAGES);
> 	if (!memcg_memory)
> 		return memory + 1;      /* Ensure that we never return 0 */
> 	memcg_memory += mem_cgroup_page_state(MEMCG_NR_RECLAIMABLE_PAGES);
> 	if (!vm_highmem_is_dirtyable)
> 		 memcg_memory -= highmem_dirtyable_memory(memory) *
> 					mem_cgroup_dirty_ratio() / 100;
> 	if (memcg_memory < memory)
> 		return memcg_memory;
> }
> 

This one is tricky and I don't have good answers. I have concerns though.

- While calculating system wide dirtyable memory, we rely on actual memory
  available. (NR_FREE_PAGES + reclaimable_pages). In case of per memory
  cgroup available free pages, we are relying on not necessarily on
  actually available dirtyable memory but based on a user configurable
  limit (LIMIT - USAGE = cgroup_dirtyable_memory).

  This is good as long as total sum of limits of all cgroups is not more
  than available memory. But if somebody sets the "limit" to a high value,
  we will allow lots of write from that cgroup without being throttled.

  So if memory cgroups were not configured right so that limit total
  represents the actual memory in system, then we might end up having lot
  more dirty pages in the system.

- Subtracting high memory pages from dirtyable memory is tricky. Because
  how to account it in per cgroup calculation. May be we can just do
  following.

	calculate_memcg_memory;
	memory = memory - highmem_dirtyable_memory();
	if (memcg_memory < memory)
		return memcg_memory;

 Not sure. This is very crude and leaves the scope of more pages being
 dirty than otherwise would have been. Ideas?

Vivek

> 
> > 
> > > -	return x + 1;	/* Ensure that we never return 0 */
> > > +	return memory + 1;	/* Ensure that we never return 0 */
> > >  }
> > >  
> > >  void
> > > @@ -421,12 +428,13 @@ get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
> > >  		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
> > >  {
> > >  	unsigned long background;
> > > -	unsigned long dirty;
> > > +	unsigned long dirty, dirty_bytes;
> > >  	unsigned long available_memory = determine_dirtyable_memory();
> > >  	struct task_struct *tsk;
> > >  
> > > -	if (vm_dirty_bytes)
> > > -		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
> > > +	dirty_bytes = mem_cgroup_dirty_bytes();
> > > +	if (dirty_bytes)
> > > +		dirty = DIV_ROUND_UP(dirty_bytes, PAGE_SIZE);
> > >  	else {
> > >  		int dirty_ratio;
> > >  
> > > @@ -505,9 +513,17 @@ static void balance_dirty_pages(struct address_space *mapping,
> > >  		get_dirty_limits(&background_thresh, &dirty_thresh,
> > >  				&bdi_thresh, bdi);
> > >  
> > > -		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> > > +		nr_reclaimable = mem_cgroup_page_state(MEMCG_NR_FILE_DIRTY);
> > > +		if (nr_reclaimable == 0) {
> > > +			nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> > >  					global_page_state(NR_UNSTABLE_NFS);
> > > -		nr_writeback = global_page_state(NR_WRITEBACK);
> > > +			nr_writeback = global_page_state(NR_WRITEBACK);
> > > +		} else {
> > > +			nr_reclaimable +=
> > > +				mem_cgroup_page_state(MEMCG_NR_UNSTABLE_NFS);
> > > +			nr_writeback =
> > > +				mem_cgroup_page_state(MEMCG_NR_WRITEBACK);
> > > +		}
> > >  
> > >  		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
> > >  		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> > > @@ -660,6 +676,8 @@ void throttle_vm_writeout(gfp_t gfp_mask)
> > >  	unsigned long dirty_thresh;
> > >  
> > >          for ( ; ; ) {
> > > +		unsigned long dirty;
> > > +
> > >  		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
> > >  
> > >                  /*
> > > @@ -668,10 +686,15 @@ void throttle_vm_writeout(gfp_t gfp_mask)
> > >                   */
> > >                  dirty_thresh += dirty_thresh / 10;      /* wheeee... */
> > >  
> > > -                if (global_page_state(NR_UNSTABLE_NFS) +
> > > -			global_page_state(NR_WRITEBACK) <= dirty_thresh)
> > > -                        	break;
> > > -                congestion_wait(BLK_RW_ASYNC, HZ/10);
> > > +		dirty = mem_cgroup_page_state(MEMCG_NR_WRITEBACK);
> > > +		if (dirty < 0)
> > 
> > dirty is unsigned long. Will above condition be ever true? 
> > 
> > Are you expecting that NR_WRITEBACK can go negative?
> 
> No, this is a bug, indeed. The right check is just "if (dirty)".
> 
> Thanks!
> -Andrea

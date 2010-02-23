Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0BWJp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:45:28 -0500
Received: from trinity.develer.com ([83.149.158.210]:48710 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0BWJp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:45:26 -0500
Date: Tue, 23 Feb 2010 10:45:23 +0100
From: Andrea Righi <arighi@develer.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: dirty pages instrumentation
Message-ID: <20100223094523.GD1882@linux>
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <1266765525-30890-3-git-send-email-arighi@develer.com>
 <20100222165215.GA3096@redhat.com>
 <20100223094040.GC1882@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223094040.GC1882@linux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 10:40:40AM +0100, Andrea Righi wrote:
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

ok, this is wrong:

> 	if (memcg_memory < memory)
> 		return memcg_memory;
> }

	return min(memcg_memory, memory);

-Andrea

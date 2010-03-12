Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0CLDIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 22:08:38 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47999 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0CLDIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 22:08:37 -0500
Subject: Re: Nick's vfs-scalability patches ported to 2.6.33-rt
From: john stultz <johnstul@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
In-Reply-To: <20100310090142.GA9529@infradead.org>
References: <1267163608.2002.9.camel@work-vm> <20100226060109.GH9738@laptop>
	 <1267659090.4317.67.camel@localhost.localdomain>
	 <20100304033312.GO8653@laptop>
	 <1267675511.4317.78.camel@localhost.localdomain>
	 <1268189462.3339.12.camel@localhost.localdomain>
	 <20100310090142.GA9529@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 19:08:32 -0800
Message-ID: <1268363312.3475.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-10 at 04:01 -0500, Christoph Hellwig wrote:
> On Tue, Mar 09, 2010 at 06:51:02PM -0800, john stultz wrote:
> > So this all means that with Nick's patch set, we're no longer getting
> > bogged down in the vfs (at least at 8-way) at all. All the contention is
> > in the actual filesystem (ext2 in group_adjust_blocks, and ext3 in the
> > journal and block allocation code).
> 
> Can you check if you're running into any fs scaling limit with xfs?


Here's the charts from some limited testing:
http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/xfs-dbench.png

They're not great.  And compared to ext3, the results are basically
flat.
http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/ext3-dbench.png

Now, I've not done any real xfs work before, so if there is any tuning
needed for dbench, please let me know.

The odd bit is that perf doesn't show huge overheads in the xfs runs.
The spinlock contention is supposedly under 5%. So I'm not sure whats
causing the numbers to be so bad.

Clipped perf log below.

thanks
-john

    11.06%       dbench  [kernel]                    [k] copy_user_generic_strin

     4.82%       dbench  [kernel]                    [k] __lock_acquire
                |          
                |--94.74%-- lock_acquire
                |          |          
                |          |--38.89%-- rt_spin_lock
                |          |          |          
                |          |          |--28.57%-- _slab_irq_disable
                |          |          |          |          
                |          |          |          |--50.00%-- kmem_cache_alloc
                |          |          |          |          kmem_zone_alloc
                |          |          |          |          xfs_buf_get
                |          |          |          |          xfs_buf_read
                |          |          |          |          xfs_trans_read_buf
                |          |          |          |          xfs_btree_read_buf_b
                |          |          |          |          xfs_btree_lookup_get
                |          |          |          |          xfs_btree_lookup
                |          |          |          |          xfs_alloc_lookup_eq
                |          |          |          |          xfs_alloc_fixup_tree
                |          |          |          |          xfs_alloc_ag_vextent
                |          |          |          |          xfs_alloc_ag_vextent
                |          |          |          |          xfs_alloc_vextent
                |          |          |          |          xfs_ialloc_ag_alloc
                |          |          |          |          xfs_dialloc
                |          |          |          |          xfs_ialloc
                |          |          |          |          xfs_dir_ialloc
                |          |          |          |          xfs_create
                |          |          |          |          xfs_vn_mknod
                |          |          |          |          xfs_vn_mkdir
                |          |          |          |          vfs_mkdir
                |          |          |          |          sys_mkdirat
                |          |          |          |          sys_mkdir
                |          |          |          |          system_call_fastpath
                |          |          |          |          __GI___mkdir
                |          |          |          |          
                |          |          |           --50.00%-- kmem_cache_free
                |          |          |                     xfs_buf_get
                |          |          |                     xfs_buf_read
                |          |          |                     xfs_trans_read_buf
                |          |          |                     xfs_btree_read_buf_b
                |          |          |                     xfs_btree_lookup_get
                |          |          |                     xfs_btree_lookup
                |          |          |                     xfs_dialloc
                |          |          |                     xfs_ialloc
                |          |          |                     xfs_dir_ialloc
                |          |          |                     xfs_create
                |          |          |                     xfs_vn_mknod
                |          |          |                     xfs_vn_mkdir
                |          |          |                     vfs_mkdir
                |          |          |                     sys_mkdirat
                |          |          |                     sys_mkdir
                |          |          |                     system_call_fastpath
                |          |          |                     __GI___mkdir
                |          |          |          
                |          |          |--14.29%-- dput
                |          |          |          path_put
                |          |          |          link_path_walk
                |          |          |          path_walk
                |          |          |          do_path_lookup
                |          |          |          user_path_at
                |          |          |          vfs_fstatat
                |          |          |          vfs_stat
                |          |          |          sys_newstat
                |          |          |          system_call_fastpath
                |          |          |          _xstat
                |          |          |          
                |          |          |--14.29%-- add_to_page_cache_locked
                |          |          |          add_to_page_cache_lru
                |          |          |          grab_cache_page_write_begin
                |          |          |          block_write_begin
                |          |          |          xfs_vm_write_begin
                |          |          |          generic_file_buffered_write
                |          |          |          xfs_write
                |          |          |          xfs_file_aio_write
                |          |          |          do_sync_write
                |          |          |          vfs_write
                |          |          |          sys_pwrite64
                |          |          |          system_call_fastpath
                |          |          |          __GI_pwrite
:



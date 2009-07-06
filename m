Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbZGFVRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbZGFVRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 17:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZGFVQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 17:16:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:19832 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbZGFVQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 17:16:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,358,1243839600"; 
   d="scan'208";a="530580913"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Eric.Moore@lsi.com" <Eric.Moore@lsi.com>,
       "DL-MPTFusionLinux@lsi.com" <DL-MPTFusionLinux@lsi.com>
Date: Mon, 6 Jul 2009 14:16:38 -0700
Subject: RE: >10% performance degradation since 2.6.18
Thread-Topic: >10% performance degradation since 2.6.18
Thread-Index: Acn8CsZ1K60vvuoCQSu40/yHxccwuQCcLg/w
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E800357E120E6@azsmsx501.amr.corp.intel.com>
References: <20090703025607.GK5480@parisc-linux.org>
 <87skhdaaub.fsf@basil.nowhere.org>
In-Reply-To: <87skhdaaub.fsf@basil.nowhere.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to answer Andi's questions below

>-----Original Message-----
>From: Andi Kleen [mailto:andi@firstfloor.org]
>Sent: Friday, July 03, 2009 11:19 AM
>To: Matthew Wilcox
>Cc: linux-kernel@vger.kernel.org; Styner, Douglas W; Ma, Chinang; Prickett,
>Terry O; Wilcox, Matthew R; Eric.Moore@lsi.com; DL-MPTFusionLinux@lsi.com
>Subject: Re: >10% performance degradation since 2.6.18
>
>
>Matthew Wilcox <matthew@wil.cx> writes:
>>
>> ======oprofile CPU_CLK_UNHALTED for top 30 functions
>> Cycles% 2.6.18-92.el5-op           Cycles% 2.6.30
>> 70.1409 <database>                 67.0207 <database>
>> 1.3556 mpt_interrupt               1.7029 mpt_interrupt
>
>It's strange that mpt_interrupt is that more costly in 2.6.30
>than in 2.6.18. I diffed 2.6.30's drivers/message/fusion/mptbase.c
>to a rhel 5.3s and they seem to be about the same.
>
>So why does it cost 0.5% more in 2.6.30?
>
>[adding MPT maintainers]
>
>> 1.1622 __blockdev_direct_IO        1.1443 kmem_cache_alloc
>
>It would be interesting to find out why kmem_cache_alloc
>is that more expensive. Either it is called more or the allocator
>is slower. Any chance of a callgraph profile run so we
>can see the callers?
>

We will try collecting the oprofile callgraph data.

>(you would need to rebuild the kernel with frame pointers)
>
>An interesting would be to simply count them on both kernels, e.g. with a
>simple systemtap script (see script at end of mail)
>
>> 0.8246 kmem_cache_free             0.8801 kmem_cache_free
>> 0.7108 schedule                    0.7774 __blockdev_direct_IO
>> 0.6733 scsi_request_fn             0.7031 scsi_request_fn
>> 0.6114 kmem_cache_alloc            0.5317 __schedule
>> 0.4207 follow_hugetlb_page         0.3922 task_rq_lock
>> 0.4062 list_del                    0.3629 sd_prep_fn
>> 0.3400 __switch_to                 0.3504 list_del
>
>A callgraph for the list_del/list_dels would be interesting.
>Presumably that's cache misses, maybe we can do something
>here with some strategic prefetches or more batching.
>
>> 0.3339 generic_make_request        0.3382 __sigsetjmp
>
>__sigsetjmp is in glibc, isn't it?

Yes, __sigsetjmp from glibc

>
>> 0.3204 memmove                     0.3270 __switch_to
>> 0.3088 __sigsetjmp                 0.3257 generic_make_request
>> 0.2848 get_request                 0.3116 kfree
>> 0.2804 lock_timer_base             0.2895 memmove
>
>memmove? Is that glibc or the kernel? (it would be good if that
>was marked in the listing)

Memmove is from glibc. I will filter out all user space libraries in the future report 

>
>Back when I wrote the x86-64 string functions I didn't consider memmove
>too performance critical. So the x86-64 kernel memmove is actually
>not very optimized, especially the backwards case is very dumb
>and copies byte by byte.
>
>If it's that there might be some low hanging fruit here,
>on the other hand it's not a lot of CPU time. The systemtap
>script at the end measures this also.
>
>A callgraph for it would be useful if it's kernel.
>
>> 0.2572 __end_that_request_first    0.2402 aio_complete
>> 0.2567 fget_light                  0.2382 mptscsih_qcmd
>> 0.2531 submit_page_section         0.2342 fget
>> 0.2428 mempool_alloc               0.2277 gup_huge_pmd
>> 0.2428 __generic_file_aio_read     0.2264 submit_page_section
>> 0.2368 touch_atime                 0.2204 touch_atime
>
>Did you not run with noatime? If it runs with noatime and touch_atime
>still takes that many cycles something must be wrong.
>

Did not try noatime option yet. Will try it next time.

>Ah it might be the lock in mnt_want_write(). How about the
>appended dumb (untested) patch to first check for all the noatime
>cases before taking the lock? Even without noatime, but standard
>relatime that will hopefully eliminate the locking cost
>in most cases.
>
>> 0.2270 __aio_get_req               0.2165 __list_add
>> 0.2223 mptscsih_qcmd               0.2063 scsi_dispatch_cmd
>> 0.2198 init_request_from_bio       0.2040 lock_timer_base
>> 0.2191 fget                        0.2036 irq_entries_start
>> 0.2141 device_not_available        0.2036 plist_del
>
>That plist_del is new. calltrace?

Not sure who use this. It is part of vmlinux

>
>> 0.2125 try_to_wake_up              0.2004 elv_queue_empty
>> 0.2065 mptscsih_io_done            0.2004 get_user_pages_fast
>> 0.2059 math_state_restore          0.1997 copy_user_generic_string
>> 0.2035 __errno_location            0.1925 kref_get
>> 0.2022 find_vma                    0.1905 scsi_finish_command
>> 0.1967 _setjmp                     0.1888 aio_rw_vect_retry
>> 0.1966 kref_get                    0.1882 __errno_location
>
>That's not kernel, but it's weird that __errno_location is that
>costly. AFAIK it should be a simple thread local data lookup
>
>> 0.1952 memset                      0.1849 scsi_device_unbusy
>> 0.1924 __list_add                  0.1846 pick_next_highest_task_rt
>> 0.1917 copy_user_generic           0.1826 memset_c
>> 0.1907 acpi_os_read_port           0.1819 _setjmp
>> 0.1842 elv_queue_empty             0.1816 ipc_lock
>
>So it looks like ipc_lock needs so more scalability work.
>
 Ipc_lock is not too high in cycles in this case. We can reduce the semaphore array size to try lower the contention.

>> 0.1809 scsi_dispatch_cmd           0.1809 mod_timer
>> 0.1808 sd_init_command             0.1800 noop_queue_empty
>> 0.1789 swiotlb_unmap_sg            0.1796 scsi_softirq_done
>> 0.1766 rw_verify_area              0.1757 scsi_run_queue
>> -----------------------------------
>
>---
>
>Systemtap script to measure some interesting metrics. Run
>with stap script.stp and then ctrl-c to get data out.
>
>---

Will try collect this data.

>
>global kmem_cache_alloc
>global kmem_cache_free
>
>probe kernel.function("kmem_cache_alloc") {
>	kmem_cache_alloc++
>
>}
>
>probe kernel.function("kmem_cache_free") {
>	kmem_cache_free++
>}
>
>global memmove_total, memmove_backwards
>
>probe kernel.function("memmove") {
>	memmove_total++
>	if (ulong_arg(1) < ulong_arg(2)) {
>		memmove_backwards++
>	}
>}
>
>probe end {
>	printf("%u kmem_cache_allocs\n", kmem_cache_alloc)
>	printf("%u kmem_cache_frees\n", kmem_cache_free)
>	printf("%u memmoves, %u backwards\n", memmove_total,
>memmove_backwards);
>}
>
>
>---
>
>Only do mnt_want_write after all other options to avoid atime update are
>exhausted
>
>mnt_want_write takes a lock and can be fairly expensive. So do it as late
>as possible.
>
>Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
>---
> fs/inode.c |   20 ++++++++++----------
> 1 file changed, 10 insertions(+), 10 deletions(-)
>
>Index: linux-2.6.30-ak/fs/inode.c
>===================================================================
>--- linux-2.6.30-ak.orig/fs/inode.c
>+++ linux-2.6.30-ak/fs/inode.c
>@@ -1361,31 +1361,31 @@ void touch_atime(struct vfsmount *mnt, s
> 	struct inode *inode = dentry->d_inode;
> 	struct timespec now;
>
>-	if (mnt_want_write(mnt))
>-		return;
> 	if (inode->i_flags & S_NOATIME)
>-		goto out;
>+		return;
> 	if (IS_NOATIME(inode))
>-		goto out;
>+		return;
> 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
>-		goto out;
>+		return;
>
> 	if (mnt->mnt_flags & MNT_NOATIME)
>-		goto out;
>+		return;
> 	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
>-		goto out;
>+		return;
>
> 	now = current_fs_time(inode->i_sb);
>
> 	if (!relatime_need_update(mnt, inode, now))
>-		goto out;
>+		return;
>
> 	if (timespec_equal(&inode->i_atime, &now))
>-		goto out;
>+		return;
>+
>+	if (mnt_want_write(mnt))
>+		return;
>
> 	inode->i_atime = now;
> 	mark_inode_dirty_sync(inode);
>-out:
> 	mnt_drop_write(mnt);
> }
> EXPORT_SYMBOL(touch_atime);
>
>
>--
>ak@linux.intel.com -- Speaking for myself only.

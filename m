Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbZJHMhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbZJHMhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbZJHMhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:37:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841AbZJHMhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:37:01 -0400
Date: Thu, 8 Oct 2009 14:36:22 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091008123622.GA30316@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 07:56:33AM -0700, Linus Torvalds wrote:
> On Wed, 7 Oct 2009, Nick Piggin wrote:
> > 
> > OK, I have a really basic patch that does store-free path walking
> > (except on the final element).
> 
> Yay!
> 
> > dbench is pretty nasty still because it seems to do a lot of stupid 
> > things like reading from /proc/mounts all the time.
> 
> You should largely forget about dbench, it can certainly be a useful 
> benchmark, but at the same time it's certainly not a _meaningful_ one.
> There are better things to try.

OK, here's one you might find interesting. It is a cached git diff
workload in a linux kernel tree. I actually ran it in a loop 100
times in order to get some reasonable sample sizes, then I ran
parallel and serial configs (PreloadIndex = true/false). Compared
plain kernel with all vfs patches to now.

2.6.32-rc3 serial
5.35user 7.12system 0:12.47elapsed 100%CPU

2.6.32-rc3 parallel
5.79user 17.69system 0:09.41elapsed 249%CPU

vfs serial
5.30user 5.62system 0:10.92elapsed 100%CPU

vfs parallel
4.86user 0.68system 0:06.82elapsed 81%CPU

(I don't know what happened with CPU accounting on the last one, but
elapsed time was accurate).

The profiles are interesting. It's pretty verbose but I've included
just the backtraces for the locking functions.

serial
plain
# Samples: 288849
#
# Overhead         Command                     Shared Object
# ........  ..............  ................................
#
    55.46%             git  [kernel]
                |
                |--36.52%-- __d_lookup
                |--9.57%-- __link_path_walk
                |--6.26%-- _atomic_dec_and_lock
                |          |
                |          |--39.42%-- dput
                |          |          |
                |          |          |--53.66%-- path_put
                |          |          |          |
                |          |          |          |--90.91%-- vfs_fstatat
                |          |          |          |          vfs_lstat
                |          |          |          |          sys_newlstat
                |          |          |          |          system_call_fastpath
                |          |          |          |
                |          |          |           --9.09%-- path_walk
                |          |          |                     do_path_lookup
                |          |          |                     user_path_at
                |          |          |                     vfs_fstatat
                |          |          |                     vfs_lstat
                |          |          |                     sys_newlstat
                |          |          |                     system_call_fastpath
                |          |          |
                |          |           --46.34%-- __link_path_walk
                |          |                     path_walk
                |          |                     do_path_lookup
                |          |                     user_path_at
                |          |                     vfs_fstatat
                |          |                     vfs_lstat
                |          |                     sys_newlstat
                |          |                     system_call_fastpath
                |          |
                |          |--31.73%-- path_put
                |          |          |
                |          |          |--57.58%-- vfs_fstatat
                |          |          |          vfs_lstat
                |          |          |          sys_newlstat
                |          |          |          system_call_fastpath
                |          |          |
                |          |           --42.42%-- path_walk
                |          |                     do_path_lookup
                |          |                     user_path_at
                |          |                     vfs_fstatat
                |          |                     vfs_lstat
                |          |                     sys_newlstat
                |          |                     system_call_fastpath
                |          |
                |          |--21.15%-- __link_path_walk
                |          |          path_walk
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |           --7.69%-- mntput_no_expire
                |                     path_put
                |                     |
                |                     |--50.00%-- vfs_fstatat
                |                     |          vfs_lstat
                |                     |          sys_newlstat
                |                     |          system_call_fastpath
                |                     |
                |                      --50.00%-- path_walk
                |                                do_path_lookup
                |                                user_path_at
                |                                vfs_fstatat
                |                                vfs_lstat
                |                                sys_newlstat
                |                                system_call_fastpath
                |
                |--5.78%-- strncpy_from_user
                |--5.60%-- _spin_unlock
                |          |
                |          |--88.17%-- dput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--4.30%-- path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--3.23%-- do_lookup
                |          |          __link_path_walk
                |          |          path_walk
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--2.15%-- handle_mm_fault
                |          |          do_page_fault
                |          |          page_fault
                |          |
                |           --2.15%-- __d_lookup
                |                     do_lookup
                |                     __link_path_walk
                |                     path_walk
                |                     do_path_lookup
                |                     user_path_at
                |                     vfs_fstatat
                |                     vfs_lstat
                |                     sys_newlstat
                |                     system_call_fastpath
                |
                |--5.17%-- generic_fillattr
                |--2.95%-- acl_permission_check
                |--1.87%-- groups_search
                |--1.81%-- kmem_cache_free
                |--1.68%-- system_call
                |--1.62%-- clear_page_c
                |--1.56%-- do_lookup
                |--1.44%-- _spin_lock
                |          |
                |          |--58.33%-- __d_lookup
                |          |          do_lookup
                |          |          __link_path_walk
                |          |          path_walk
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |
                |          |--20.83%-- dput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |
                |          |--16.67%-- do_lookup
                |          |          __link_path_walk
                |          |          path_walk
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |
                |           --4.17%-- copy_process
                |                     do_fork
                |                     sys_clone
                |                     stub_clone
                |                     __libc_fork
                |                     0x494a5d
                |
                |--1.38%-- dput
                |--1.38%-- mntput_no_expire
                |--1.32%-- cp_new_stat
                |--1.26%-- path_walk
                |--1.20%-- sysret_check
                |--1.08%-- kmem_cache_alloc
                |--0.96%-- __follow_mount
                |--0.96%-- copy_user_generic_string
                |--0.66%-- in_group_p
                |--0.54%-- page_fault
                 --7.40%-- [...]

So serial case still has significant time in locking. 13% of all kernel
cycles.

vfs
amples: 254207
#
# Overhead         Command                     Shared Object
# ........  ..............  ................................
#
    53.15%             git  [kernel]
                |
                |--37.47%-- __d_lookup_rcu
                |--15.63%-- link_path_walk_rcu
                |--6.70%-- strncpy_from_user
                |--5.65%-- generic_fillattr
                |--3.49%-- _spin_lock
                |          |
                |          |--66.00%-- dput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--14.00%-- mntput_no_expire
                |          |          mntput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--6.00%-- link_path_walk_rcu
                |          |          do_path_lookup
                |          |          |
                |          |          |--66.67%-- user_path_at
                |          |          |          vfs_fstatat
                |          |          |          vfs_lstat
                |          |          |          sys_newlstat
                |          |          |          system_call_fastpath
                |          |          |
                |          |           --33.33%-- do_filp_open
                |          |                     do_sys_open
                |          |                     sys_open
                |          |                     system_call_fastpath
                |          |
                |          |--4.00%-- path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--4.00%-- do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--2.00%-- anon_vma_link
                |          |          dup_mm
                |          |          copy_process
                |          |          do_fork
                |          |          sys_clone
                |          |          stub_clone
                |          |          __libc_fork
                |          |
                |          |--2.00%-- do_page_fault
                |          |          page_fault
                |          |
                |           --2.00%-- vfsmount_read_lock
                |                     mntput_no_expire
                |                     mntput
                |                     path_put
                |                     vfs_fstatat
                |                     vfs_lstat
                |                     sys_newlstat
                |                     system_call_fastpath
                |
                |--2.44%-- kmem_cache_free
                |--1.95%-- system_call
                |--1.88%-- groups_search
                |--1.81%-- do_path_lookup
                |--1.54%-- cp_new_stat
                |--1.33%-- clear_page_c
                |--1.33%-- kmem_cache_alloc
                |--1.12%-- mntput_no_expire
                |--1.05%-- do_lookup_rcu
                |--0.98%-- dput
                |--0.91%-- page_fault
                |--0.91%-- copy_user_generic_string
                |--0.77%-- sysret_check
                |--0.77%-- in_group_p
                |--0.77%-- getname
                |--0.70%-- _spin_unlock
                |          |
                |          |--30.00%-- mntput_no_expire
                |          |          mntput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |
                |          |--20.00%-- link_path_walk_rcu
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |
                |          |--10.00%-- handle_mm_fault
                |          |          do_page_fault
                |          |          page_fault
                |          |          0x45f62a
                |          |
                |          |--10.00%-- vfsmount_read_unlock
                |          |          mntput_no_expire
                |          |          mntput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |
                |          |--10.00%-- dput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |
                |          |--10.00%-- path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |
                |           --10.00%-- do_path_lookup
                |                     user_path_at
                |                     vfs_fstatat
                |                     vfs_lstat
                |                     sys_newlstat
                |                     system_call_fastpath
                |                     __lxstat
                |
                |--0.63%-- path_put
                |--0.56%-- copy_page_c
                |--0.56%-- user_path_at
                 --9.07%-- [...]

Locking goes to about 4%. Signifciantly coming from dput of the final
dentry element which is basically impossible to avoid, so we're much
closer to optimal.

The parallel case is interesting too.
plain
# Samples: 635836
#
# Overhead         Command                     Shared Object
# ........  ..............  ................................
#
    76.39%             git  [kernel]
                |
                |--32.26%-- _atomic_dec_and_lock
                |          |
                |          |--60.44%-- dput
                |          |          |
                |          |          |--51.15%-- path_put
                |          |          |          |
                |          |          |          |--94.91%-- path_walk
                |          |          |          |          do_path_lookup
                |          |          |          |          user_path_at
                |          |          |          |          vfs_fstatat
                |          |          |          |          vfs_lstat
                |          |          |          |          sys_newlstat
                |          |          |          |          system_call_fastpath
                |          |          |          |
                |          |          |           --5.09%-- vfs_fstatat
                |          |          |                     vfs_lstat
                |          |          |                     sys_newlstat
                |          |          |                     system_call_fastpath
                |          |          |
                |          |           --48.85%-- __link_path_walk
                |          |                     path_walk
                |          |                     do_path_lookup
                |          |                     user_path_at
                |          |                     vfs_fstatat
                |          |                     vfs_lstat
                |          |                     sys_newlstat
                |          |                     system_call_fastpath
                |          |
                |          |--14.04%-- mntput_no_expire
                |          |          path_put
                |          |          |
                |          |          |--51.29%-- path_walk
                |          |          |          do_path_lookup
                |          |          |          user_path_at
                |          |          |          vfs_fstatat
                |          |          |          vfs_lstat
                |          |          |          sys_newlstat
                |          |          |          system_call_fastpath
                |          |          |
                |          |           --48.71%-- vfs_fstatat
                |          |                     vfs_lstat
                |          |                     sys_newlstat
                |          |                     system_call_fastpath
                |          |
                |          |--13.01%-- path_put
                |          |          |
                |          |          |--95.81%-- path_walk
                |          |          |          do_path_lookup
                |          |          |          user_path_at
                |          |          |          vfs_fstatat
                |          |          |          vfs_lstat
                |          |          |          sys_newlstat
                |          |          |          system_call_fastpath
                |          |          |
                |          |           --4.19%-- vfs_fstatat
                |          |                     vfs_lstat
                |          |                     sys_newlstat
                |          |                     system_call_fastpath
                |          |
                |           --12.52%-- __link_path_walk
                |                     path_walk
                |                     do_path_lookup
                |                     user_path_at
                |                     vfs_fstatat
                |                     vfs_lstat
                |                     sys_newlstat
                |                     system_call_fastpath
                |
                |--13.23%-- path_walk
                |--12.94%-- __d_lookup
                |--7.81%-- do_path_lookup
                |--7.53%-- path_init
                |--3.84%-- __link_path_walk
                |--2.36%-- acl_permission_check
                |--2.15%-- _spin_lock
                |          |
                |          |--42.73%-- _atomic_dec_and_lock
                |          |          dput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--39.09%-- __d_lookup
                |          |          do_lookup
                |          |          __link_path_walk
                |          |          path_walk
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--9.09%-- do_lookup
                |          |          __link_path_walk
                |          |          path_walk
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--8.18%-- dput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |           --0.91%-- system_call_fastpath
                |                     0x7fb0fcf23257
                |                     0x7fb0fcf158bd
                |
                |--2.01%-- generic_fillattr
                |--1.76%-- _spin_unlock
                |          |
                |          |--85.56%-- dput
                |          |          path_put
                |          |          |
                |          |          |--98.70%-- vfs_fstatat
                |          |          |          vfs_lstat
                |          |          |          sys_newlstat
                |          |          |          system_call_fastpath
                |          |          |
                |          |           --1.30%-- __link_path_walk
                |          |                     path_walk
                |          |                     do_path_lookup
                |          |                     do_filp_open
                |          |                     do_sys_open
                |          |                     sys_open
                |          |                     system_call_fastpath
                |          |
                |          |--5.56%-- __d_lookup
                |          |          do_lookup
                |          |          __link_path_walk
                |          |          path_walk
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--4.44%-- path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--2.22%-- do_lookup
                |          |          __link_path_walk
                |          |          path_walk
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--1.11%-- handle_mm_fault
                |          |          do_page_fault
                |          |          page_fault
                |          |
                |           --1.11%-- update_process_times
                |                     tick_sched_timer
                |                     __run_hrtimer
                |                     hrtimer_interrupt
                |                     smp_apic_timer_interrupt
                |                     apic_timer_interrupt
                |
                |--1.62%-- _read_unlock
                |          |
                |          |--75.90%-- path_init
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |           --24.10%-- do_path_lookup
                |                     user_path_at
                |                     vfs_fstatat
                |                     vfs_lstat
                |                     sys_newlstat
                |                     system_call_fastpath
                |
                |--1.29%-- strncpy_from_user
                |--1.17%-- path_put
                |--1.01%-- dput
                |--0.62%-- kmem_cache_free
                |--0.60%-- do_lookup
                |--0.59%-- clear_page_c

We can see it is really starting to choke on atomic_dec_and_lock. I
don't know how many tasks you spawn off in git here, but it looks
like this is nearing the absolute limit of scalbility.

vfs

amples: 273522
#
# Overhead         Command                     Shared Object
# ........  ..............  ................................
#
    48.24%             git  [kernel]
                |
                |--32.37%-- __d_lookup_rcu
                |--14.14%-- link_path_walk_rcu
                |--7.57%-- _read_unlock
                |          |
                |          |--96.46%-- path_init_rcu
                |          |          do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |           --3.54%-- do_path_lookup
                |                     user_path_at
                |                     vfs_fstatat
                |                     vfs_lstat
                |                     sys_newlstat
                |                     system_call_fastpath
                |
                |--7.04%-- generic_fillattr
                |--5.50%-- strncpy_from_user
                |--2.68%-- kmem_cache_free
                |--2.55%-- _spin_lock
                |          |
                |          |--81.58%-- dput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--5.26%-- do_path_lookup
                |          |          user_path_at
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |
                |          |--5.26%-- try_to_wake_up
                |          |          |
                |          |          |--50.00%-- wake_up_state
                |          |          |          wake_futex
                |          |          |          futex_wake
                |          |          |          do_futex
                |          |          |          sys_futex
                |          |          |          mm_release
                |          |          |          exit_mm
                |          |          |          do_exit
                |          |          |          sys_exit
                |          |          |          system_call_fastpath
                |          |          |          start_thread
                |          |          |
                |          |           --50.00%-- wake_up_process
                |          |                     __up_write
                |          |                     up_write
                |          |                     sys_mmap
                |          |                     system_call_fastpath
                |          |                     mmap64
                |          |
                |          |--5.26%-- vfsmount_read_lock
                |          |          mntput_no_expire
                |          |          mntput
                |          |          path_put
                |          |          vfs_fstatat
                |          |          vfs_lstat
                |          |          sys_newlstat
                |          |          system_call_fastpath
                |          |          __lxstat
                |          |          |
                |          |          |--50.00%-- 0x7f7640b9e2c0
                |          |          |          0x4ab3b1fc
                |          |          |
                |          |           --50.00%-- 0x7f7640bb4e78
                |          |                     0x4a803476
                |          |
                |           --2.63%-- path_put
                |                     vfs_fstatat
                |                     vfs_lstat
                |                     sys_newlstat
                |                     system_call_fastpath
                |                     __lxstat
                |                     0x7f7640d7f488
                |                     0x4a8034a4
                |
                |--2.48%-- clear_page_c
                |--1.61%-- system_call
                |--1.47%-- copy_user_generic_string
                |--1.41%-- cp_new_stat
                |--1.41%-- groups_search
                |--1.21%-- do_lookup_rcu
                |--0.94%-- kmem_cache_alloc
                |--0.94%-- do_path_lookup
                |--0.87%-- in_group_p
                |--0.80%-- page_fault
                |--0.80%-- sysret_check
                |--0.74%-- dput
                |--0.67%-- getname
                |--0.67%-- user_path_at
                |--0.67%-- mntput_no_expire
                |--0.60%-- unmap_vmas
                |--0.54%-- _spin_unlock
                |--0.54%-- vfs_fstatat
                |--0.54%-- path_init_rcu
                 --9.25%-- [...]

This one is interesting. spin_lock/spin_unlock remains very low, however
read_unlock pops up. This would be... fs->lock. You're using threads
then (rather than processes)?

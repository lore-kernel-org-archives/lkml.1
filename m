Return-Path: <linux-kernel-owner+w=401wt.eu-S1764352AbXHFTET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764352AbXHFTET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXHFTEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:04:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:54530 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753049AbXHFTEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:04:04 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX1+MZ7BC/0iMW6pYFR3CSnfmPo/WMy7+MOHC2Ber1Y
	6lBUctXW1Fp3kf
Message-ID: <46B77EB5.7070205@gmx.net>
Date: Mon, 06 Aug 2007 22:04:05 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net>	<200708051903.12414.jimis@gmx.net>	<20070805182811.a8992126.akpm@linux-foundation.org>	<46B72E2E.5040906@gmx.net> <20070806103317.5688d6df.akpm@linux-foundation.org>
In-Reply-To: <20070806103317.5688d6df.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------070803040600070201000807"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070803040600070201000807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Mon, 06 Aug 2007 16:20:30 +0200 Dimitrios Apostolou <jimis@gmx.net> wrote:
> 
>> Andrew Morton wrote:
>>> On Sun, 5 Aug 2007 19:03:12 +0300 Dimitrios Apostolou <jimis@gmx.net> wrote:
>>>
>>>> was my report so complicated?
>>> We're bad.
>>>
>>> Seems that your context switch rate when running two instances of
>>> badblocks against two different disks went batshit insane.  It doesn't
>>> happen here.
>>>
>>> Please capture the `vmstat 1' output while running the problematic
>>> workload.
>>>
>>> The oom-killing could have been unrelated to the CPU load problem.  iirc
>>> badblocks uses a lot of memory, so it might have been genuine.  Keep an eye
>>> on the /proc/meminfo output and send the kernel dmesg output from the
>>> oom-killing event.
>> Please see the attached files. Unfortunately I don't see any useful info 
>> in them:
>> 	*_before: before running any badblocks process
>> 	*_while: while running badblocks process, but without any cron job 
>> having kicked in
>> 	*_bad: 5 minutes later that some cron jobs kicked in
>>
>> About the OOM killer, indeed I believe that it is unrelated. It started 
>> killing after about 2 days, that hundreds of processes were stuck as 
>> running and taking up memory, so I suppose the 256 MB RAM were truly 
>> filled. I just mentioned it because its behaviour is completely 
>> non-helpful. It doesn't touch the badblocks process, it rarely touches 
>> the stuck as running cron jobs, but it kills other irrelevant processes. 
>> If you still want the killing logs, tell me and I'll search for them.
> 
> ah.  Your context-switch rate during the dual-badblocks run is not high at
> all.
> 
> I suspect I was fooled by the oprofile output, which showed tremendous
> amounts of load in schedule() and switch_to().  The percentages which
> opreport shows are the percentage of non-halted CPU time.  So if you have a
> function in the kernel which is using 1% of the total CPU, and the CPU is
> halted for 95% of the time, it appears that the function is taking 20% of
> CPU!
> 
> The fix for that is to boot with the "idle=poll" boot parameter, to make
> the CPU spin when it has nothing else to do.

I'm attaching the new oprofile output. I can't see any difference 
however. :-s


Dimitris



--------------070803040600070201000807
Content-Type: text/plain;
 name="bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bad.txt"

Mon Aug  6 21:46:59 EEST 2007
+ opcontrol --vmlinux=/usr/src/linux-2.6.22-ARCH/vmlinux
+ opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
+ sleep 5
+ opcontrol --shutdown
Stopping profiling.
Killing daemon.
+ echo

+ echo

+ echo

+ opreport
CPU: PIII, speed 798.025 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
     7917 57.2658 vmlinux
     2204 15.9421 libc-2.6.so
      958  6.9295 libpython2.5.so.1.0
      815  5.8951 ide_core
      773  5.5913 perl
      242  1.7505 ld-2.6.so
      216  1.5624 mpop
      204  1.4756 bash
      121  0.8752 libgnutls.so.13.3.0
       64  0.4629 badblocks
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       48 75.0000 badblocks
	       10 15.6250 anon (tgid:4338 range:0xb7f6c000-0xb7f6d000)
	        6  9.3750 anon (tgid:4339 range:0xb7f64000-0xb7f65000)
       46  0.3327 ISO8859-1.so
       37  0.2676 ext3
       34  0.2459 imap-login
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	       31 91.1765 imap-login
	        1  2.9412 anon (tgid:3989 range:0xb7f80000-0xb7f81000)
	        1  2.9412 anon (tgid:3990 range:0xb7f72000-0xb7f73000)
	        1  2.9412 anon (tgid:4332 range:0xb7fd6000-0xb7fd7000)
       33  0.2387 libext2fs.so.2.4
       24  0.1736 jbd
       24  0.1736 libpthread-2.6.so
       21  0.1519 gawk
       15  0.1085 oprofile
       13  0.0940 libcrypto.so.0.9.8
       12  0.0868 ide_disk
       11  0.0796 skge
        7  0.0506 sshd
        6  0.0434 dovecot-auth
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        5 83.3333 dovecot-auth
	        1 16.6667 anon (tgid:3971 range:0xb7f8c000-0xb7f8d000)
        4  0.0289 libnetsnmp.so.15.0.0
        4  0.0289 libnetsnmpmibs.so.15.0.0
        4  0.0289 imap
        4  0.0289 dovecot
        3  0.0217 grep
        3  0.0217 reiserfs
        3  0.0217 locale-archive
        1  0.0072 libdl-2.6.so
        1  0.0072 init
        1  0.0072 screen-4.0.3
+ echo

+ echo

+ echo

+ opreport -l /usr/src/linux-2.6.22-ARCH/vmlinux
CPU: PIII, speed 798.025 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
2477     31.2871  __switch_to
1625     20.5255  schedule
246       3.1072  mask_and_ack_8259A
222       2.8041  __blockdev_direct_IO
147       1.8568  follow_page
107       1.3515  put_page
106       1.3389  do_wp_page
91        1.1494  native_load_tls
88        1.1115  __bio_add_page
80        1.0105  delay_tsc
63        0.7958  __handle_mm_fault
50        0.6316  submit_page_section
49        0.6189  get_page_from_freelist
48        0.6063  dio_bio_add_page
45        0.5684  dequeue_task
41        0.5179  get_user_pages
40        0.5052  bio_alloc_bioset
39        0.4926  enable_8259A_irq
38        0.4800  dio_send_cur_page
38        0.4800  page_address
38        0.4800  sysenter_past_esp
37        0.4673  dio_get_page
37        0.4673  find_get_page
36        0.4547  bio_add_page
36        0.4547  kmem_cache_alloc
36        0.4547  unmap_vmas
35        0.4421  kmem_cache_free
34        0.4295  blk_rq_map_sg
33        0.4168  blk_recount_segments
32        0.4042  do_page_fault
31        0.3916  generic_file_direct_write
30        0.3789  __generic_file_aio_write_nolock
30        0.3789  vm_normal_page
28        0.3537  __link_path_walk
28        0.3537  __mutex_lock_slowpath
26        0.3284  irq_entries_start
25        0.3158  filemap_nopage
25        0.3158  vfs_write
23        0.2905  find_vma
22        0.2779  __d_lookup
22        0.2779  dio_bio_complete
22        0.2779  mark_page_accessed
21        0.2653  add_timer_randomness
21        0.2653  max_block
21        0.2653  page_fault
19        0.2400  restore_all
18        0.2274  __add_entropy_words
18        0.2274  preempt_schedule
17        0.2147  __copy_to_user_ll
17        0.2147  __generic_unplug_device
17        0.2147  do_sys_poll
17        0.2147  fget_light
17        0.2147  math_state_restore
16        0.2021  __mod_timer
16        0.2021  generic_file_direct_IO
16        0.2021  preempt_schedule_irq
15        0.1895  block_llseek
15        0.1895  do_sync_write
14        0.1768  current_fs_time
14        0.1768  do_generic_mapping_read
14        0.1768  mempool_free
14        0.1768  native_flush_tlb_single
14        0.1768  radix_tree_lookup
14        0.1768  rw_verify_area
13        0.1642  __alloc_pages
13        0.1642  __make_request
13        0.1642  _spin_lock_irqsave
13        0.1642  cond_resched
12        0.1516  cfq_completed_request
12        0.1516  strnlen_user
11        0.1389  __mutex_unlock_slowpath
11        0.1389  do_lookup
11        0.1389  generic_make_request
11        0.1389  get_request
11        0.1389  restore_nocheck
10        0.1263  blkdev_direct_IO
10        0.1263  load_elf_binary
10        0.1263  unix_poll
9         0.1137  cfq_insert_request
9         0.1137  cfq_set_request
9         0.1137  copy_page_range
9         0.1137  do_mmap_pgoff
9         0.1137  elv_insert
9         0.1137  generic_file_aio_write_nolock
9         0.1137  generic_permission
9         0.1137  recalc_task_prio
8         0.1010  blkdev_get_blocks
8         0.1010  cache_reap
8         0.1010  dio_new_bio
8         0.1010  file_update_time
8         0.1010  sys_llseek
8         0.1010  vsnprintf
7         0.0884  bio_put
7         0.0884  blk_backing_dev_unplug
7         0.0884  cfq_dispatch_requests
7         0.0884  copy_process
7         0.0884  device_not_available
7         0.0884  disk_round_stats
7         0.0884  elv_queue_empty
7         0.0884  free_block
7         0.0884  generic_unplug_device
7         0.0884  hrtimer_interrupt
7         0.0884  kmap_atomic_prot
7         0.0884  mutex_remove_waiter
7         0.0884  need_resched
7         0.0884  page_remove_rmap
7         0.0884  permission
6         0.0758  __blk_put_request
6         0.0758  __copy_from_user_ll
6         0.0758  __copy_user_intel
6         0.0758  __end_that_request_first
6         0.0758  __find_get_block_slow
6         0.0758  bio_init
6         0.0758  blk_remove_plug
6         0.0758  cfq_may_queue
6         0.0758  dio_cleanup
6         0.0758  dio_complete
6         0.0758  dput
6         0.0758  getname
6         0.0758  inotify_inode_queue_event
6         0.0758  kfree
6         0.0758  memcpy
6         0.0758  mempool_alloc
6         0.0758  path_walk
6         0.0758  rb_erase
6         0.0758  read_tsc
6         0.0758  task_rq_lock
6         0.0758  try_to_wake_up
6         0.0758  vfs_llseek
5         0.0632  __const_udelay
5         0.0632  __fput
5         0.0632  blk_plug_device
5         0.0632  cfq_remove_request
5         0.0632  copy_strings
5         0.0632  current_io_context
5         0.0632  debug_mutex_add_waiter
5         0.0632  dnotify_parent
5         0.0632  do_IRQ
5         0.0632  do_filp_open
5         0.0632  do_path_lookup
5         0.0632  drain_array
5         0.0632  elv_rqhash_add
5         0.0632  free_poll_entry
5         0.0632  generic_segment_checks
5         0.0632  handle_level_irq
5         0.0632  idle_cpu
5         0.0632  init_request_from_bio
5         0.0632  io_schedule
5         0.0632  ip_append_data
5         0.0632  note_interrupt
5         0.0632  proc_sys_lookup_table_one
5         0.0632  sched_clock
5         0.0632  sys_write
5         0.0632  up_read
4         0.0505  __dentry_open
4         0.0505  __freed_request
4         0.0505  __pagevec_lru_add_active
4         0.0505  _atomic_dec_and_lock
4         0.0505  bdev_read_only
4         0.0505  cfq_queue_empty
4         0.0505  copy_to_user
4         0.0505  debug_mutex_free_waiter
4         0.0505  do_munmap
4         0.0505  do_sync_read
4         0.0505  do_wait
4         0.0505  dummy_inode_permission
4         0.0505  elv_completed_request
4         0.0505  end_that_request_last
4         0.0505  filemap_write_and_wait
4         0.0505  find_extend_vma
4         0.0505  find_vma_prev
4         0.0505  generic_file_aio_read
4         0.0505  get_empty_filp
4         0.0505  get_request_wait
4         0.0505  hweight32
4         0.0505  internal_add_timer
4         0.0505  irq_exit
4         0.0505  native_read_tsc
4         0.0505  number
4         0.0505  poll_freewait
4         0.0505  proc_lookup
4         0.0505  setup_arg_pages
4         0.0505  should_remove_suid
4         0.0505  sock_poll
4         0.0505  submit_bio
4         0.0505  tick_sched_timer
4         0.0505  unmap_region
4         0.0505  vma_adjust
3         0.0379  __atomic_notifier_call_chain
3         0.0379  __do_page_cache_readahead
3         0.0379  __elv_add_request
3         0.0379  __find_get_block
3         0.0379  __mark_inode_dirty
3         0.0379  __pte_alloc
3         0.0379  anon_vma_prepare
3         0.0379  anon_vma_unlink
3         0.0379  bio_endio
3         0.0379  bit_waitqueue
3         0.0379  call_rcu
3         0.0379  cfq_init_prio_data
3         0.0379  cfq_put_queue
3         0.0379  cfq_service_tree_add
3         0.0379  clear_bdi_congested
3         0.0379  common_interrupt
3         0.0379  credit_entropy_store
3         0.0379  deactivate_task
3         0.0379  debug_mutex_lock_common
3         0.0379  debug_mutex_unlock
3         0.0379  del_timer
3         0.0379  down_read_trylock
3         0.0379  dummy_inode_getattr
3         0.0379  elv_dispatch_sort
3         0.0379  elv_may_queue
3         0.0379  elv_put_request
3         0.0379  elv_set_request
3         0.0379  enqueue_task
3         0.0379  error_code
3         0.0379  flush_old_exec
3         0.0379  free_hot_cold_page
3         0.0379  generic_fillattr
3         0.0379  kmem_cache_zalloc
3         0.0379  link_path_walk
3         0.0379  lock_timer_base
3         0.0379  locks_remove_flock
3         0.0379  may_expand_vm
3         0.0379  native_load_esp0
3         0.0379  open_namei
3         0.0379  path_lookup_open
3         0.0379  pipe_poll
3         0.0379  proc_flush_task
3         0.0379  release_vm86_irqs
3         0.0379  remove_vma
3         0.0379  rq_init
3         0.0379  sock_alloc_send_skb
3         0.0379  strncpy_from_user
3         0.0379  sys_mmap2
3         0.0379  sys_mprotect
3         0.0379  touch_atime
3         0.0379  vfs_read
3         0.0379  vm_acct_memory
3         0.0379  vm_stat_account
3         0.0379  vma_link
2         0.0253  I_BDEV
2         0.0253  __dec_zone_state
2         0.0253  __group_complete_signal
2         0.0253  __inc_zone_state
2         0.0253  __mutex_lock_interruptible_slowpath
2         0.0253  __path_lookup_intent_open
2         0.0253  __pollwait
2         0.0253  __rb_rotate_right
2         0.0253  __vm_enough_memory
2         0.0253  __vma_link_rb
2         0.0253  __wake_up
2         0.0253  __wake_up_bit
2         0.0253  alloc_inode
2         0.0253  anon_vma_ctor
2         0.0253  bio_alloc
2         0.0253  bio_free
2         0.0253  bio_fs_destructor
2         0.0253  bio_get_nr_vecs
2         0.0253  bio_phys_segments
2         0.0253  blk_queue_bounce
2         0.0253  cache_alloc_refill
2         0.0253  check_pgt_cache
2         0.0253  debug_mutex_set_owner
2         0.0253  dio_bio_end_io
2         0.0253  dio_zero_block
2         0.0253  do_notify_parent
2         0.0253  do_notify_resume
2         0.0253  do_sys_open
2         0.0253  down_read
2         0.0253  dst_alloc
2         0.0253  effective_prio
2         0.0253  elv_dequeue_request
2         0.0253  elv_next_request
2         0.0253  file_free_rcu
2         0.0253  file_read_actor
2         0.0253  filp_close
2         0.0253  find_next_bit
2         0.0253  find_next_zero_bit
2         0.0253  find_vma_prepare
2         0.0253  flush_tlb_mm
2         0.0253  flush_tlb_page
2         0.0253  generic_file_mmap
2         0.0253  get_index
2         0.0253  get_unused_fd
2         0.0253  getnstimeofday
2         0.0253  handle_IRQ_event
2         0.0253  icmp_push_reply
2         0.0253  icmp_send
2         0.0253  kill_fasync
2         0.0253  kunmap_atomic
2         0.0253  lru_cache_add_active
2         0.0253  mntput_no_expire
2         0.0253  native_read_cr0
2         0.0253  notifier_call_chain
2         0.0253  ordered_bio_endio
2         0.0253  page_cache_readahead
2         0.0253  percpu_counter_mod
2         0.0253  poll_initwait
2         0.0253  profile_munmap
2         0.0253  put_filp
2         0.0253  put_io_context
2         0.0253  quicklist_trim
2         0.0253  radix_tree_gang_lookup_tag
2         0.0253  rb_insert_color
2         0.0253  remove_suid
2         0.0253  resume_userspace
2         0.0253  sched_balance_self
2         0.0253  seq_printf
2         0.0253  smp_apic_timer_interrupt
2         0.0253  sys_brk
2         0.0253  sys_fstat64
2         0.0253  sys_read
2         0.0253  sys_rt_sigaction
2         0.0253  sys_stat64
2         0.0253  system_call
2         0.0253  vma_merge
2         0.0253  work_notifysig
2         0.0253  zone_watermark_ok
1         0.0126  __activate_task
1         0.0126  __alloc_skb
1         0.0126  __blocking_notifier_call_chain
1         0.0126  __bread
1         0.0126  __delay
1         0.0126  __do_softirq
1         0.0126  __follow_mount
1         0.0126  __iget
1         0.0126  __ip_select_ident
1         0.0126  __put_user_4
1         0.0126  __rb_rotate_left
1         0.0126  __rcu_process_callbacks
1         0.0126  __rmqueue
1         0.0126  __sigqueue_alloc
1         0.0126  __sigqueue_free
1         0.0126  __sk_dst_check
1         0.0126  __tasklet_schedule
1         0.0126  __tcp_ack_snd_check
1         0.0126  __tcp_push_pending_frames
1         0.0126  __user_walk_fd
1         0.0126  __vma_link
1         0.0126  _read_lock_irqsave
1         0.0126  account_system_time
1         0.0126  account_user_time
1         0.0126  add_disk_randomness
1         0.0126  add_wait_queue
1         0.0126  all_vm_events
1         0.0126  alloc_buffer_head
1         0.0126  alloc_pid
1         0.0126  anon_pipe_buf_release
1         0.0126  anon_vma_link
1         0.0126  arch_setup_additional_pages
1         0.0126  bio_hw_segments
1         0.0126  blk_do_ordered
1         0.0126  blk_start_queueing
1         0.0126  blockable_page_cache_readahead
1         0.0126  blocking_notifier_call_chain
1         0.0126  bmap
1         0.0126  can_vma_merge_after
1         0.0126  cfq_add_rq_rb
1         0.0126  cfq_choose_req
1         0.0126  cfq_cic_rb_lookup
1         0.0126  cfq_rb_erase
1         0.0126  check_userspace
1         0.0126  copy_semundo
1         0.0126  core_sys_select
1         0.0126  cp_new_stat64
1         0.0126  csum_partial_copy_generic
1         0.0126  d_alloc
1         0.0126  dec_zone_page_state
1         0.0126  dequeue_signal
1         0.0126  devinet_ioctl
1         0.0126  do_fork
1         0.0126  do_group_exit
1         0.0126  do_sigaction
1         0.0126  drive_stat_acct
1         0.0126  dummy_capable
1         0.0126  dummy_file_alloc_security
1         0.0126  dummy_task_kill
1         0.0126  dummy_vm_enough_memory
1         0.0126  dup_fd
1         0.0126  elv_rb_add
1         0.0126  end_that_request_first
1         0.0126  exit_itimers
1         0.0126  fasync_helper
1         0.0126  fget
1         0.0126  file_kill
1         0.0126  file_move
1         0.0126  file_ra_state_init
1         0.0126  flush_sigqueue
1         0.0126  fn_hash_lookup
1         0.0126  fput
1         0.0126  free_page_and_swap_cache
1         0.0126  free_pgtables
1         0.0126  get_futex_key
1         0.0126  get_io_context
1         0.0126  get_task_mm
1         0.0126  hrtimer_try_to_cancel
1         0.0126  icmp_glue_bits
1         0.0126  ifind_fast
1         0.0126  inotify_dentry_parent_queue_event
1         0.0126  invalidate_inode_buffers
1         0.0126  ip_route_input
1         0.0126  irq_enter
1         0.0126  local_bh_enable_ip
1         0.0126  may_open
1         0.0126  mempool_alloc_slab
1         0.0126  mempool_free_slab
1         0.0126  n_tty_receive_buf
1         0.0126  native_apic_write
1         0.0126  native_set_pte_at
1         0.0126  open_exec
1         0.0126  opost
1         0.0126  page_add_file_rmap
1         0.0126  pipe_release
1         0.0126  pipe_write
1         0.0126  prio_tree_insert
1         0.0126  prio_tree_remove
1         0.0126  proc_sys_lookup_table
1         0.0126  profile_tick
1         0.0126  pty_chars_in_buffer
1         0.0126  put_tty_queue
1         0.0126  rb_first
1         0.0126  recalc_sigpending_tsk
1         0.0126  release_open_intent
1         0.0126  release_task
1         0.0126  restore_sigcontext
1         0.0126  ret_from_exception
1         0.0126  ret_from_intr
1         0.0126  scheduler_tick
1         0.0126  search_binary_handler
1         0.0126  secure_ip_id
1         0.0126  show_stat
1         0.0126  sigprocmask
1         0.0126  snprintf
1         0.0126  sock_fasync
1         0.0126  softlockup_tick
1         0.0126  special_mapping_nopage
1         0.0126  split_vma
1         0.0126  sys_access
1         0.0126  sys_clone
1         0.0126  sys_execve
1         0.0126  sys_futex
1         0.0126  sys_open
1         0.0126  sys_rt_sigprocmask
1         0.0126  syscall_exit
1         0.0126  sysctl_head_next
1         0.0126  task_running_tick
1         0.0126  tcp_poll
1         0.0126  tcp_rcv_space_adjust
1         0.0126  tcp_recvmsg
1         0.0126  tcp_transmit_skb
1         0.0126  test_set_page_writeback
1         0.0126  tick_do_update_jiffies64
1         0.0126  tick_program_event
1         0.0126  timespec_trunc
1         0.0126  try_to_del_timer_sync
1         0.0126  tty_ioctl
1         0.0126  tty_ldisc_ref_wait
1         0.0126  udp_flush_pending_frames
1         0.0126  unuse_table
1         0.0126  update_process_times
1         0.0126  update_wall_time
1         0.0126  vfs_stat_fd
1         0.0126  vma_prio_tree_remove
1         0.0126  wake_up_inode
1         0.0126  wake_up_new_task
1         0.0126  wake_up_process
1         0.0126  write_cache_pages

--------------070803040600070201000807
Content-Type: text/plain;
 name="idle.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="idle.txt"

Mon Aug  6 21:38:04 EEST 2007
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
Daemon started.
Profiler running.
Stopping profiling.
Killing daemon.



CPU: PIII, speed 798.025 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
CPU_CLK_UNHALT...|
  samples|      %|
------------------
    40131 97.6495 vmlinux
      318  0.7738 libc-2.6.so
      168  0.4088 oprofiled
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	      167 99.4048 oprofiled
	        1  0.5952 anon (tgid:4159 range:0xb7f55000-0xb7f56000)
      162  0.3942 bash
      133  0.3236 ld-2.6.so
       51  0.1241 oprofile
       49  0.1192 ISO8859-1.so
       33  0.0803 ext3
       20  0.0487 jbd
        5  0.0122 locale-archive
        4  0.0097 gawk
        4  0.0097 imap-login
        3  0.0073 grep
        3  0.0073 reiserfs
        2  0.0049 cat
        2  0.0049 libcrypto.so.0.9.8
        2  0.0049 dovecot-auth
        1  0.0024 ide_core
        1  0.0024 ide_disk
        1  0.0024 libncurses.so.5.6
        1  0.0024 which
        1  0.0024 libnetsnmp.so.15.0.0
        1  0.0024 libnetsnmpmibs.so.15.0.0
        1  0.0024 dovecot
	CPU_CLK_UNHALT...|
	  samples|      %|
	------------------
	        1 100.000 anon (tgid:3968 range:0xb7fa7000-0xb7fa8000)



CPU: PIII, speed 798.025 MHz (estimated)
Counted CPU_CLK_UNHALTED events (clocks processor is not halted) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
39019    97.2291  cpu_idle
263       0.6554  poll_idle
131       0.3264  quicklist_trim
92        0.2292  do_wp_page
50        0.1246  check_pgt_cache
44        0.1096  __handle_mm_fault
37        0.0922  get_page_from_freelist
31        0.0772  page_fault
21        0.0523  unmap_vmas
15        0.0374  __copy_to_user_ll
13        0.0324  filemap_nopage
12        0.0299  radix_tree_lookup
11        0.0274  copy_process
10        0.0249  __link_path_walk
10        0.0249  sysenter_past_esp
9         0.0224  do_page_fault
9         0.0224  find_get_page
8         0.0199  kmem_cache_free
6         0.0150  __d_lookup
6         0.0150  __find_get_block
6         0.0150  page_address
5         0.0125  _atomic_dec_and_lock
5         0.0125  do_mmap_pgoff
5         0.0125  free_hot_cold_page
5         0.0125  kmem_cache_alloc
5         0.0125  load_elf_binary
5         0.0125  strnlen_user
4         0.0100  __wake_up_bit
4         0.0100  copy_page_range
4         0.0100  d_alloc
4         0.0100  error_code
4         0.0100  find_vma
4         0.0100  flush_tlb_mm
4         0.0100  inode_init_once
4         0.0100  kmap_atomic_prot
4         0.0100  put_page
4         0.0100  restore_nocheck
4         0.0100  schedule
4         0.0100  vm_normal_page
3         0.0075  __follow_mount
3         0.0075  __mutex_lock_slowpath
3         0.0075  __rmqueue
3         0.0075  anon_vma_unlink
3         0.0075  ktime_get_ts
3         0.0075  mark_page_accessed
3         0.0075  memcpy
3         0.0075  prio_tree_insert
3         0.0075  strncpy_from_user
3         0.0075  sys_close
2         0.0050  __atomic_notifier_call_chain
2         0.0050  __find_get_block_slow
2         0.0050  __lookup_mnt
2         0.0050  __mutex_unlock_slowpath
2         0.0050  __rb_rotate_left
2         0.0050  __rcu_process_callbacks
2         0.0050  __switch_to
2         0.0050  anon_vma_prepare
2         0.0050  cache_alloc_refill
2         0.0050  debug_mutex_add_waiter
2         0.0050  do_path_lookup
2         0.0050  dup_fd
2         0.0050  generic_fillattr
2         0.0050  generic_make_request
2         0.0050  get_task_mm
2         0.0050  get_unused_fd
2         0.0050  getnstimeofday
2         0.0050  hrtimer_interrupt
2         0.0050  hweight32
2         0.0050  inotify_dentry_parent_queue_event
2         0.0050  link_path_walk
2         0.0050  mask_and_ack_8259A
2         0.0050  may_open
2         0.0050  path_walk
2         0.0050  pgd_alloc
2         0.0050  preempt_schedule
2         0.0050  proc_lookup
2         0.0050  tick_nohz_restart_sched_tick
2         0.0050  unlink_file_vma
2         0.0050  vm_stat_account
2         0.0050  vma_merge
2         0.0050  zone_watermark_ok
1         0.0025  __alloc_pages
1         0.0025  __alloc_skb
1         0.0025  __copy_from_user_ll
1         0.0025  __copy_user_intel
1         0.0025  __dentry_open
1         0.0025  __do_softirq
1         0.0025  __end_that_request_first
1         0.0025  __fput
1         0.0025  __free_pages
1         0.0025  __getblk
1         0.0025  __inc_zone_state
1         0.0025  __kmalloc
1         0.0025  __pagevec_lru_add
1         0.0025  __pte_alloc
1         0.0025  __put_task_struct
1         0.0025  __tasklet_schedule
1         0.0025  __vm_enough_memory
1         0.0025  __vma_link_rb
1         0.0025  _read_lock_irqsave
1         0.0025  _spin_lock_irqsave
1         0.0025  account_user_time
1         0.0025  alloc_buffer_head
1         0.0025  alloc_inode
1         0.0025  apic_timer_interrupt
1         0.0025  arch_get_unmapped_area_topdown
1         0.0025  arch_pick_mmap_layout
1         0.0025  attach_pid
1         0.0025  bio_init
1         0.0025  block_read_full_page
1         0.0025  cache_reap
1         0.0025  call_rcu
1         0.0025  can_share_swap_page
1         0.0025  cfq_set_request
1         0.0025  check_userspace
1         0.0025  cleanup_timers
1         0.0025  clockevents_program_event
1         0.0025  clocksource_get_next
1         0.0025  compute_creds
1         0.0025  copy_from_user
1         0.0025  copy_strings
1         0.0025  create_read_pipe
1         0.0025  current_fs_time
1         0.0025  current_io_context
1         0.0025  d_instantiate
1         0.0025  d_splice_alias
1         0.0025  debug_mutex_unlock
1         0.0025  delayed_put_task_struct
1         0.0025  dnotify_flush
1         0.0025  dnotify_parent
1         0.0025  do_exit
1         0.0025  do_fcntl
1         0.0025  do_lookup
1         0.0025  do_munmap
1         0.0025  do_notify_resume
1         0.0025  do_softirq
1         0.0025  do_sys_open
1         0.0025  do_wait
1         0.0025  down_read_trylock
1         0.0025  down_write
1         0.0025  dput
1         0.0025  dummy_inode_getattr
1         0.0025  eligible_child
1         0.0025  elv_dispatch_sort
1         0.0025  end_buffer_write_sync
1         0.0025  enqueue_hrtimer
1         0.0025  exit_mmap
1         0.0025  fget
1         0.0025  fget_light
1         0.0025  file_read_actor
1         0.0025  filp_close
1         0.0025  find_busiest_group
1         0.0025  find_lock_page
1         0.0025  find_next_zero_bit
1         0.0025  find_or_create_page
1         0.0025  find_vma_prev
1         0.0025  flush_old_exec
1         0.0025  flush_sigqueue
1         0.0025  flush_tlb_page
1         0.0025  fput
1         0.0025  free_block
1         0.0025  free_page_and_swap_cache
1         0.0025  free_pgtables
1         0.0025  free_poll_entry
1         0.0025  generic_file_mmap
1         0.0025  generic_segment_checks
1         0.0025  get_empty_filp
1         0.0025  get_next_timer_interrupt
1         0.0025  getname
1         0.0025  inode_change_ok
1         0.0025  internal_add_timer
1         0.0025  invalidate_inode_buffers
1         0.0025  kill_fasync
1         0.0025  kmap
1         0.0025  kmem_cache_zalloc
1         0.0025  ktime_get
1         0.0025  kunmap_atomic
1         0.0025  ll_back_merge_fn
1         0.0025  lookup_hash
1         0.0025  lookup_mnt
1         0.0025  lru_cache_add_active
1         0.0025  mempool_free_slab
1         0.0025  mm_alloc
1         0.0025  mm_release
1         0.0025  mmput
1         0.0025  mntput_no_expire
1         0.0025  native_set_pte_at
1         0.0025  number
1         0.0025  page_add_file_rmap
1         0.0025  page_add_new_anon_rmap
1         0.0025  page_remove_rmap
1         0.0025  page_waitqueue
1         0.0025  path_release
1         0.0025  peer_avl_rebalance
1         0.0025  percpu_counter_mod
1         0.0025  permission
1         0.0025  pipe_write
1         0.0025  prio_tree_replace
1         0.0025  proc_flush_task
1         0.0025  proc_pid_lookup
1         0.0025  radix_tree_tag_set
1         0.0025  rb_insert_color
1         0.0025  remove_vma
1         0.0025  restore_all
1         0.0025  rm_from_queue_full
1         0.0025  rw_verify_area
1         0.0025  sched_balance_self
1         0.0025  set_bh_page
1         0.0025  set_normalized_timespec
1         0.0025  set_task_comm
1         0.0025  setup_sigcontext
1         0.0025  show_stat
1         0.0025  sync_page
1         0.0025  sys_dup2
1         0.0025  sys_faccessat
1         0.0025  sys_ftruncate
1         0.0025  sys_read
1         0.0025  sys_rt_sigprocmask
1         0.0025  sys_select
1         0.0025  task_rq_lock
1         0.0025  task_running_tick
1         0.0025  tcp_poll
1         0.0025  tick_do_update_jiffies64
1         0.0025  tick_nohz_stop_sched_tick
1         0.0025  try_to_wake_up
1         0.0025  unix_poll
1         0.0025  unlock_buffer
1         0.0025  up_read
1         0.0025  update_wall_time
1         0.0025  vfs_getattr
1         0.0025  vfs_permission
1         0.0025  vfs_read
1         0.0025  vm_acct_memory
1         0.0025  vsnprintf
1         0.0025  wake_up_inode
1         0.0025  wake_up_new_task
1         0.0025  work_notifysig

--------------070803040600070201000807
Content-Type: text/plain;
 name="vmstat_bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmstat_bad.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 4  2      0 161676   9716  55700    0    0   248  2020   50  131  5  4 84  7
 4  2      0 161668   9716  55704    0    0     0 16000  253  504 80 20  0  0
 3  2      0 161668   9716  55704    0    0     0 16000  249  522 66 34  0  0
 3  2      0 161608   9716  55704    0    0     0 15936  251  508 80 20  0  0
 3  2      0 161548   9716  55704    0    0     0 15936  249  523 73 28  0  0
 4  2      0 161488   9716  55704    0    0     0 15936  250  517 84 16  0  0
 3  2      0 161488   9724  55704    0    0     0 15876  252  469 57 43  0  0
 4  2      0 161428   9724  55704    0    0     0 15872  253  504 60 40  0  0
 3  2      0 161428   9724  55704    0    0     0 15936  248  500 24 76  0  0
 4  2      0 161428   9740  55704    0    0     0 15840  258  475 52 48  0  0

--------------070803040600070201000807--

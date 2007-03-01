Return-Path: <linux-kernel-owner+w=401wt.eu-S965277AbXCAP1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277AbXCAP1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXCAP1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:27:34 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33165 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965277AbXCAP1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:27:32 -0500
Date: Thu, 1 Mar 2007 18:23:23 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301152323.GA8217@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <200703011228.01144.dada1@cosmosbay.com> <20070301114731.GA20773@2ka.mipt.ru> <200703011412.51256.dada1@cosmosbay.com> <20070301144350.GA12684@2ka.mipt.ru> <20070301144717.GA24079@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20070301144717.GA24079@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 18:24:05 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline

On Thu, Mar 01, 2007 at 03:47:17PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > CPU: AMD64 processors, speed 2210.08 MHz (estimated)
> > Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit mask of 0x00 (No unit mask) count 100000
> > samples  %        symbol name
> > 195750   67.3097  cpu_idle
> > 14111     4.8521  enter_idle
> > 4979      1.7121  IRQ0x51_interrupt
> > 4765      1.6385  tcp_v4_rcv
> 
> the pretty much only meaningful way to measure this is to:
> 
> - start a really long 'ab' testrun. Something like "ab -c 8000 -t 600".
> - let the system get into 'steady state': i.e. CPU load at 100%
> - reset the oprofile counters, then start an oprofile run for 60 
>   seconds.
> - stop the oprofile run.
> - stop the test.
> 
> this way there wont be that many 'cpu_idle' entries in your profiles, 
> and the profiles between the two event delivery mechanisms will be 
> directly comparable.

They are there, since ab runs only 50k requests.
If I change it to something noticebly more than 50/80k, ab crashes:
# ab -c8000 -t 600 -n800000000 http://192.168.0.48/
This is ApacheBench, Version 2.0.40-dev <$Revision: 1.146 $> apache-2.0
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Copyright 2006 The Apache Software Foundation, http://www.apache.org/

Benchmarking 192.168.0.48 (be patient)
Segmentation fault

Are there any other tool suitable for such loads?
I only tested httperf (which is worse, since it uses poll/select) and
'ab'.

Btw, host machine runs 100% too, so it is possible that client side is
broken (too).

> > In that tests I got epoll perf about 4400 req/s, kevent was about 
> > 5300.
> 
> So we are now up to epoll being 83% of kevent's performance - while the 
> noise of numbers seen today alone is around 100% ... Could you update 
> the files two URLs that you posted before, with the code that you used 
> for the above numbers:

And in a couple of moments I resent profile with 6100 r/s, and now
attached with 6300.

>    http://tservice.net.ru/~s0mbre/archive/kevent/evserver_epoll.c
>    http://tservice.net.ru/~s0mbre/archive/kevent/evserver_kevent.c

Plus http://tservice.net.ru/~s0mbre/archive/kevent/evserver_common.c
which contains common request handling function

> thanks,
> 
> 	Ingo

-- 
	Evgeniy Polyakov

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=koi8-r
Content-Disposition: attachment; filename="profile.kevent"

CPU: AMD64 processors, speed 2210.08 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
168753   65.1189  cpu_idle
12451     4.8046  enter_idle
4814      1.8576  tcp_v4_rcv
3980      1.5358  IRQ0x51_interrupt
3142      1.2124  tcp_ack
2738      1.0565  kmem_cache_free
2346      0.9053  kfree
2341      0.9034  memset_c
1927      0.7436  csum_partial_copy_generic
1723      0.6649  ip_route_input
1650      0.6367  dev_queue_xmit
1452      0.5603  ip_output
1416      0.5464  handle_IRQ_event
1335      0.5152  ip_rcv
1326      0.5117  tcp_rcv_state_process
1069      0.4125  schedule
960       0.3704  __do_softirq
943       0.3639  tcp_sendmsg
915       0.3531  ip_queue_xmit
907       0.3500  tcp_v4_do_rcv
897       0.3461  fget
894       0.3450  system_call
890       0.3434  csum_partial
877       0.3384  tcp_transmit_skb
845       0.3261  netif_receive_skb
822       0.3172  ip_local_deliver
812       0.3133  kmem_cache_alloc
788       0.3041  local_bh_enable
773       0.2983  __alloc_skb
771       0.2975  kfree_skbmem
764       0.2948  __d_lookup
757       0.2921  __tcp_push_pending_frames
734       0.2832  pfifo_fast_enqueue
720       0.2778  copy_user_generic_string
627       0.2419  net_rx_action
603       0.2327  pfifo_fast_dequeue
586       0.2261  ret_from_intr
562       0.2169  __link_path_walk
561       0.2165  sock_wfree
549       0.2118  __fput
547       0.2111  __kfree_skb
543       0.2095  get_unused_fd
534       0.2061  number
527       0.2034  sysret_check
516       0.1991  preempt_schedule
508       0.1960  skb_clone
496       0.1914  tcp_parse_options
487       0.1879  _atomic_dec_and_lock
470       0.1814  tcp_poll
469       0.1810  __ip_route_output_key
466       0.1798  rt_hash_code
464       0.1790  tcp_recvmsg
421       0.1625  dput
420       0.1621  tcp_rcv_established
412       0.1590  __tcp_select_window
407       0.1571  exit_idle
394       0.1520  rb_erase
381       0.1470  sys_close
375       0.1447  __mod_timer
365       0.1408  d_alloc
363       0.1401  mask_and_ack_8259A
335       0.1293  lock_timer_base
315       0.1216  cache_alloc_refill
307       0.1185  ret_from_sys_call
300       0.1158  do_path_lookup
299       0.1154  eth_type_trans
298       0.1150  find_next_zero_bit
294       0.1134  tcp_data_queue
286       0.1104  dentry_iput
285       0.1100  ip_append_data
263       0.1015  thread_return
257       0.0992  __dentry_open
255       0.0984  sock_recvmsg
255       0.0984  tcp_rtt_estimator
252       0.0972  sys_fcntl
250       0.0965  tcp_current_mss
248       0.0957  sk_stream_mem_schedule
240       0.0926  call_softirq
233       0.0899  sys_recvfrom
229       0.0884  cache_grow
221       0.0853  vsnprintf
215       0.0830  tcp_send_fin
214       0.0826  do_generic_mapping_read
213       0.0822  call_rcu
213       0.0822  common_interrupt
203       0.0783  do_lookup
196       0.0756  inotify_dentry_parent_queue_event
191       0.0737  memcpy_c
188       0.0725  filp_close
180       0.0695  release_sock
180       0.0695  sock_def_readable
178       0.0687  get_page_from_freelist
177       0.0683  do_sys_open
174       0.0671  restore_args
172       0.0664  strncpy_from_user
167       0.0644  fget_light
162       0.0625  clear_inode
161       0.0621  link_path_walk
159       0.0614  generic_drop_inode
157       0.0606  get_empty_filp
156       0.0602  __skb_checksum_complete
153       0.0590  del_timer
152       0.0587  update_send_head
151       0.0583  percpu_counter_mod
150       0.0579  current_fs_time
150       0.0579  schedule_timeout
150       0.0579  skb_checksum
149       0.0575  fd_install
145       0.0560  sock_close
143       0.0552  try_to_wake_up
142       0.0548  generic_permission
135       0.0521  __put_unused_fd
133       0.0513  new_inode
132       0.0509  half_md4_transform
131       0.0506  alloc_inode
130       0.0502  bictcp_cong_avoid
130       0.0502  memcmp
127       0.0490  tcp_init_tso_segs
126       0.0486  tcp_sync_mss
125       0.0482  __do_page_cache_readahead
125       0.0482  find_get_page
123       0.0475  lookup_mnt
117       0.0451  rb_insert_color
114       0.0440  tcp_v4_send_check
112       0.0432  mod_timer
109       0.0421  page_cache_readahead
101       0.0390  __path_lookup_intent_open
100       0.0386  __wake_up_bit
100       0.0386  may_open
100       0.0386  tcp_snd_test
97        0.0374  tcp_check_space
96        0.0370  expand_files
96        0.0370  skb_copy_datagram_iovec
95        0.0367  getname
95        0.0367  igrab
94        0.0363  open_namei
93        0.0359  groups_search
92        0.0355  dnotify_flush
91        0.0351  locks_remove_posix
91        0.0351  memmove
90        0.0347  sk_reset_timer
89        0.0343  tcp_send_ack
88        0.0340  copy_page_c
88        0.0340  tcp_select_initial_window
87        0.0336  sock_common_recvmsg
85        0.0328  sock_release
83        0.0320  IRQ0x20_interrupt
83        0.0320  file_free_rcu
80        0.0309  rw_verify_area
79        0.0305  d_instantiate
79        0.0305  permission
79        0.0305  put_page
77        0.0297  cond_resched
77        0.0297  get_task_mm
77        0.0297  touch_atime
75        0.0289  __follow_mount
75        0.0289  inotify_inode_queue_event
74        0.0286  file_move
73        0.0282  copy_to_user
71        0.0274  tcp_v4_tw_remember_stamp
69        0.0266  wake_up_inode
65        0.0251  prepare_to_wait
65        0.0251  sockfd_lookup
65        0.0251  tcp_event_data_recv
64        0.0247  file_kill
64        0.0247  fput
62        0.0239  __handle_mm_fault
62        0.0239  tcp_setsockopt
61        0.0235  sock_sendmsg
60        0.0232  __wake_up
59        0.0228  page_fault
57        0.0220  locks_remove_flock
54        0.0208  sk_stream_rfree
54        0.0208  sprintf
53        0.0205  inet_sendmsg
53        0.0205  retint_kernel
51        0.0197  iret_label
51        0.0197  tcp_cwnd_validate
49        0.0189  tcp_rcv_space_adjust
48        0.0185  inode_init_once
48        0.0185  mutex_unlock
45        0.0174  finish_wait
45        0.0174  mntput_no_expire
44        0.0170  __delay
44        0.0170  __tcp_ack_snd_check
43        0.0166  inet_sock_destruct
42        0.0162  try_to_del_timer_sync
41        0.0158  free_hot_cold_page
41        0.0158  memset
40        0.0154  __rb_rotate_left
40        0.0154  init_once
40        0.0154  sys_open
40        0.0154  tcp_unhash
39        0.0150  generic_file_open
39        0.0150  tcp_cong_avoid
38        0.0147  __lookup_mnt
38        0.0147  bit_waitqueue
36        0.0139  clear_page_c
36        0.0139  iput
33        0.0127  in_group_p
33        0.0127  inet_sk_rebuild_header
33        0.0127  sock_fasync
33        0.0127  tcp_init_cwnd
32        0.0123  memcpy_toiovec
32        0.0123  sk_stop_timer
32        0.0123  unmap_vmas
31        0.0120  blockable_page_cache_readahead
30        0.0116  _spin_lock_bh
30        0.0116  inet_getname
29        0.0112  __put_user_8
28        0.0108  copy_from_user
27        0.0104  do_filp_open
26        0.0100  tcp_v4_destroy_sock
25        0.0096  __alloc_pages
24        0.0093  apic_timer_interrupt
24        0.0093  do_page_fault
24        0.0093  file_ra_state_init
24        0.0093  hrtimer_run_queues
24        0.0093  vfs_permission
23        0.0089  tcp_slow_start
23        0.0089  zone_watermark_ok
22        0.0085  mutex_lock
21        0.0081  destroy_inode
21        0.0081  init_timer
21        0.0081  invalidate_inode_buffers
21        0.0081  sk_alloc
19        0.0073  exit_intr
16        0.0062  copy_page_range
15        0.0058  find_vma
14        0.0054  retint_swapgs
14        0.0054  wake_up_bit
13        0.0050  __down_read
12        0.0046  do_wp_page
12        0.0046  mark_page_accessed
11        0.0042  __get_user_4
11        0.0042  __tcp_checksum_complete_user
10        0.0039  vm_normal_page
9         0.0035  __up_read
8         0.0031  rcu_start_batch
8         0.0031  retint_restore_args
8         0.0031  timespec_trunc
7         0.0027  __find_get_block
7         0.0027  error_exit
7         0.0027  flush_tlb_page
6         0.0023  _write_lock_bh
6         0.0023  copy_process
6         0.0023  free_hot_page
6         0.0023  inode_has_buffers
6         0.0023  kmem_flagcheck
6         0.0023  retint_check
5         0.0019  __rb_rotate_right
5         0.0019  del_timer_sync
5         0.0019  nameidata_to_filp
4         0.0015  __down_read_trylock
4         0.0015  __getblk
4         0.0015  __mutex_init
4         0.0015  __set_page_dirty_nobuffers
4         0.0015  _read_lock_irqsave
4         0.0015  do_mmap_pgoff
4         0.0015  error_sti
4         0.0015  free_pgd_range
4         0.0015  load_elf_binary
4         0.0015  mmput
3         0.0012  __iget
3         0.0012  _spin_lock_irqsave
3         0.0012  bio_endio
3         0.0012  copy_strings
3         0.0012  cpuset_update_task_memory_state
3         0.0012  d_lookup
3         0.0012  exit_itimers
3         0.0012  filemap_nopage
3         0.0012  find_vma_prepare
3         0.0012  free_pages
3         0.0012  generic_fillattr
3         0.0012  generic_make_request
3         0.0012  memcpy
3         0.0012  prio_tree_insert
3         0.0012  put_unused_fd
3         0.0012  run_local_timers
3         0.0012  unmap_region
3         0.0012  vma_prio_tree_remove
2        7.7e-04  __clear_user
2        7.7e-04  __find_get_block_slow
2        7.7e-04  __strnlen_user
2        7.7e-04  __vm_enough_memory
2        7.7e-04  add_to_page_cache
2        7.7e-04  add_wait_queue
2        7.7e-04  alloc_pages_current
2        7.7e-04  anon_vma_prepare
2        7.7e-04  dnotify_parent
2        7.7e-04  do_exit
2        7.7e-04  do_munmap
2        7.7e-04  do_select
2        7.7e-04  dup_fd
2        7.7e-04  exit_mmap
2        7.7e-04  find_mergeable_anon_vma
2        7.7e-04  free_pgtables
2        7.7e-04  lru_cache_add_active
2        7.7e-04  mempool_free
2        7.7e-04  page_add_file_rmap
2        7.7e-04  page_remove_rmap
2        7.7e-04  page_waitqueue
2        7.7e-04  path_release
2        7.7e-04  prio_tree_replace
2        7.7e-04  pty_chars_in_buffer
2        7.7e-04  remove_vma
2        7.7e-04  retint_with_reschedule
2        7.7e-04  run_workqueue
2        7.7e-04  seq_puts
2        7.7e-04  split_vma
2        7.7e-04  sys_mmap
2        7.7e-04  sys_mprotect
2        7.7e-04  sys_rt_sigprocmask
2        7.7e-04  truncate_inode_pages_range
2        7.7e-04  vfs_lstat_fd
2        7.7e-04  vm_acct_memory
2        7.7e-04  vma_adjust
2        7.7e-04  vma_link
1        3.9e-04  __block_prepare_write
1        3.9e-04  __bread
1        3.9e-04  __d_path
1        3.9e-04  __down_write
1        3.9e-04  __down_write_nested
1        3.9e-04  __end_that_request_first
1        3.9e-04  __free_pages
1        3.9e-04  __generic_file_aio_write_nolock
1        3.9e-04  __make_request
1        3.9e-04  __page_set_anon_rmap
1        3.9e-04  __pagevec_lru_add_active
1        3.9e-04  __put_user_4
1        3.9e-04  __remove_shared_vm_struct
1        3.9e-04  __up_write
1        3.9e-04  __vma_link_rb
1        3.9e-04  _read_lock_bh
1        3.9e-04  activate_page
1        3.9e-04  anon_vma_unlink
1        3.9e-04  block_write_full_page
1        3.9e-04  cap_bprm_apply_creds
1        3.9e-04  cap_vm_enough_memory
1        3.9e-04  clear_page_dirty_for_io
1        3.9e-04  cond_resched_lock
1        3.9e-04  cp_new_stat
1        3.9e-04  create_empty_buffers
1        3.9e-04  dentry_unhash
1        3.9e-04  do_brk
1        3.9e-04  do_mpage_readpage
1        3.9e-04  do_mremap
1        3.9e-04  do_sigaction
1        3.9e-04  do_wait
1        3.9e-04  drop_buffers
1        3.9e-04  eligible_child
1        3.9e-04  exit_sem
1        3.9e-04  file_read_actor
1        3.9e-04  filldir64
1        3.9e-04  flush_signal_handlers
1        3.9e-04  generic_block_bmap
1        3.9e-04  generic_file_llseek
1        3.9e-04  generic_file_mmap
1        3.9e-04  get_index
1        3.9e-04  get_signal_to_deliver
1        3.9e-04  get_stack
1        3.9e-04  get_unmapped_area
1        3.9e-04  get_vma_policy
1        3.9e-04  init_request_from_bio
1        3.9e-04  inode_setattr
1        3.9e-04  is_bad_inode
1        3.9e-04  kref_put
1        3.9e-04  lru_add_drain
1        3.9e-04  may_delete
1        3.9e-04  mm_release
1        3.9e-04  n_tty_ioctl
1        3.9e-04  nr_blockdev_pages
1        3.9e-04  page_add_new_anon_rmap
1        3.9e-04  pipe_poll
1        3.9e-04  preempt_schedule_irq
1        3.9e-04  proc_lookup
1        3.9e-04  ptregscall_common
1        3.9e-04  put_files_struct
1        3.9e-04  radix_tree_tag_clear
1        3.9e-04  rb_prev
1        3.9e-04  recalc_bh_state
1        3.9e-04  release_pages
1        3.9e-04  sched_exec
1        3.9e-04  sched_fork
1        3.9e-04  seq_escape
1        3.9e-04  set_close_on_exec
1        3.9e-04  set_fs_pwd
1        3.9e-04  set_personality_64bit
1        3.9e-04  shrink_dcache_parent
1        3.9e-04  sock_map_fd
1        3.9e-04  strchr
1        3.9e-04  submit_bio
1        3.9e-04  sys_dup2
1        3.9e-04  sys_faccessat
1        3.9e-04  sys_munmap
1        3.9e-04  sys_rt_sigaction
1        3.9e-04  tty_write
1        3.9e-04  unlink_file_vma
1        3.9e-04  unlock_page
1        3.9e-04  vfs_read
1        3.9e-04  vfs_readdir
1        3.9e-04  vma_merge
1        3.9e-04  vma_prio_tree_insert
1        3.9e-04  wake_up_new_task
1        3.9e-04  writeback_inodes
1        3.9e-04  zonelist_policy

--k1lZvvs/B4yU6o8G--

Return-Path: <linux-kernel-owner+w=401wt.eu-S933707AbYEHVq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707AbYEHVq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbYEHVqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:46:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760689AbYEHVqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:46:15 -0400
Date: Thu, 8 May 2008 23:45:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix
	AIM7 40% regression with 2.6.26-rc1)
Message-ID: <20080508214557.GA13311@elte.hu>
References: <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org> <20080508201956.GA2547@elte.hu> <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > I suspect some more performance could be won in this particular 
> > workload by getting rid of the BKL dependency altogether.
> 
> Did somebody have any trace on which BKL taker it is? It apparently 
> wasn't file locking. Was it the tty layer?

yeah, i captured a trace of all the down()s that happen in the workload, 
using ftrace/sched_switch + stacktrace + a tracepoint in down(). Here's 
the semaphore activities in the trace:

# grep lock_kernel /debug/tracing/trace | cut -d: -f2- | sort | \
                                          uniq -c | sort -n | cut -d= -f1-4

      9  down <= lock_kernel <= proc_lookup_de <= proc_lookup <
     12  down <= lock_kernel <= de_put <= proc_delete_inode <
     14  down <= lock_kernel <= proc_lookup_de <= proc_lookup <
     19  down <= lock_kernel <= vfs_ioctl <= do_vfs_ioctl <
     58  down <= lock_kernel <= tty_release <= __fput <
     62  down <= lock_kernel <= chrdev_open <= __dentry_open <
     70  down <= lock_kernel <= sys_fcntl <= system_call_after_swapgs <
   2512  down <= lock_kernel <= opost <= write_chan <
   2574  down <= lock_kernel <= write_chan <= tty_write <

note that this is running the fixed semaphore code, so contended 
semaphores are really rare in the trace. The histogram above includes 
all calls to down().

here's the full trace file (from a single CPU, on a dual-core box 
running aim7):

   http://redhat.com/~mingo/misc/aim7-ftrace.txt

some other interesting stats. Top 5 wakeups sources:

 # grep wake_up aim7-ftrace.txt  | cut -d: -f2- | sort | uniq -c | 
                                   sort -n | cut -d= -f1-6 | tail -5
  [...]
    340  default_wake_function <= __wake_up_common <= __wake_up_sync <= unix_write_space <= sock_wfree <= skb_release_all <
    411  default_wake_function <= autoremove_wake_function <= __wake_up_common <= __wake_up_sync <= pipe_read <= do_sync_read <
    924  default_wake_function <= autoremove_wake_function <= __wake_up_common <= __wake_up_sync <= pipe_write <= do_sync_write <
   1301  default_wake_function <= __wake_up_common <= __wake_up <= n_tty_receive_buf <= pty_write <= write_chan <
   2065  wake_up_state <= prepare_signal <= send_signal <= __group_send_sig_info <= group_send_sig_info <= __kill_pgrp_info <

top 10 scheduling points:

# grep -w schedule aim7-ftrace.txt  | cut -d: -f2- | sort |
                            uniq -c | sort -n | cut -d= -f1-4 | tail -10
  [...]
    465  schedule <= __cond_resched <= _cond_resched <= shrink_active_list <
    582  schedule <= cpu_idle <= start_secondary <=  <
    929  schedule <= pipe_wait <= pipe_read <= do_sync_read <
    990  schedule <= __cond_resched <= _cond_resched <= shrink_page_list <
   1034  schedule <= io_schedule <= get_request_wait <= __make_request <
   1140  schedule <= worker_thread <= kthread <= child_rip <
   1512  schedule <= retint_careful <=  <= 0 <
   1571  schedule <= __cond_resched <= _cond_resched <= shrink_active_list <
   2034  schedule <= schedule_timeout <= do_select <= core_sys_select <
   2355  schedule <= sysret_careful <=  <= 0 <

as visible from the trace, this is a CONFIG_PREEMPT_NONE kernel, so most 
of the preemptions get triggered by wakeups and get executed from the 
return-from-syscall need_resched check. But there's a fair amount of 
select() related sleeping as well, and a fair amount of 
IRQ-hits-userspace driven preemptions as well.

a rather hectic workload, with a surprisingly large amount of TTY 
related activity.

and here's a few seconds worth of NMI driven readprofile output:

  1131 page_fault                                70.6875
  1181 find_lock_page                             8.2014
  1302 __isolate_lru_page                        12.8911
  1344 copy_page_c                               84.0000
  1588 page_lock_anon_vma                        34.5217
  1616 ext3fs_dirhash                             3.4753
  1683 ext3_htree_store_dirent                    6.8975
  1976 str2hashbuf                               12.7484
  1992 copy_user_generic_string                  31.1250
  2362 do_unlinkat                                6.5069
  2969 try_to_unmap                               2.0791
  3031 will_become_orphaned_pgrp                 24.4435
  4009 __copy_user_nocache                       12.3735
  4627 congestion_wait                           34.0221
  6624 clear_page_c                             414.0000
 18711 try_to_unmap_one                          30.8254
 34447 page_referenced                          140.0285
 38669 do_filp_open                              17.7789
166569 page_referenced_one                      886.0053
213361 *unknown*
216021 sync_page                                3375.3281
391888 page_check_address                       1414.7581
962212 total                                      0.3039

system overhead is consistently 20% during this test.

the page_check_address() overhead is surprising - tons of rmap 
contention? about 10% wall-clock overhead in that function alone - and 
this is just on a dual-core box!

Below is the instruction level profile of that function. The second 
column is the # of profile hits. The spin_lock() overhead is clearly 
visible.

	Ingo

                         ___----- # of profile hits
                        v
ffffffff80286244:     3478 <page_check_address>:
ffffffff80286244:     3478 	55                   	push   %rbp
ffffffff80286245:     1092 	48 89 d0             	mov    %rdx,%rax
ffffffff80286248:        0 	48 c1 e8 27          	shr    $0x27,%rax
ffffffff8028624c:        0 	48 89 e5             	mov    %rsp,%rbp
ffffffff8028624f:      717 	41 57                	push   %r15
ffffffff80286251:        1 	25 ff 01 00 00       	and    $0x1ff,%eax
ffffffff80286256:        0 	49 89 cf             	mov    %rcx,%r15
ffffffff80286259:     1354 	41 56                	push   %r14
ffffffff8028625b:        0 	49 89 fe             	mov    %rdi,%r14
ffffffff8028625e:        0 	48 89 d7             	mov    %rdx,%rdi
ffffffff80286261:     1507 	41 55                	push   %r13
ffffffff80286263:        0 	41 54                	push   %r12
ffffffff80286265:        0 	53                   	push   %rbx
ffffffff80286266:     1763 	48 83 ec 08          	sub    $0x8,%rsp
ffffffff8028626a:        0 	48 8b 56 48          	mov    0x48(%rsi),%rdx
ffffffff8028626e:        4 	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
ffffffff80286272:     3174 	f6 c2 01             	test   $0x1,%dl
ffffffff80286275:        0 	0f 84 cc 00 00 00    	je     ffffffff80286347 <page_check_address+0x103>
ffffffff8028627b:        0 	48 89 f8             	mov    %rdi,%rax
ffffffff8028627e:    64468 	48 be 00 f0 ff ff ff 	mov    $0x3ffffffff000,%rsi
ffffffff80286285:        0 	3f 00 00 
ffffffff80286288:        1 	48 b9 00 00 00 00 00 	mov    $0xffff810000000000,%rcx
ffffffff8028628f:        0 	81 ff ff 
ffffffff80286292:     4686 	48 c1 e8 1b          	shr    $0x1b,%rax
ffffffff80286296:        0 	48 21 f2             	and    %rsi,%rdx
ffffffff80286299:        0 	25 f8 0f 00 00       	and    $0xff8,%eax
ffffffff8028629e:     7468 	48 01 d0             	add    %rdx,%rax
ffffffff802862a1:        0 	48 8b 14 08          	mov    (%rax,%rcx,1),%rdx
ffffffff802862a5:       11 	f6 c2 01             	test   $0x1,%dl
ffffffff802862a8:     4409 	0f 84 99 00 00 00    	je     ffffffff80286347 <page_check_address+0x103>
ffffffff802862ae:        0 	48 89 f8             	mov    %rdi,%rax
ffffffff802862b1:        0 	48 21 f2             	and    %rsi,%rdx
ffffffff802862b4:     1467 	48 c1 e8 12          	shr    $0x12,%rax
ffffffff802862b8:        0 	25 f8 0f 00 00       	and    $0xff8,%eax
ffffffff802862bd:        0 	48 01 d0             	add    %rdx,%rax
ffffffff802862c0:      944 	48 8b 14 08          	mov    (%rax,%rcx,1),%rdx
ffffffff802862c4:       17 	f6 c2 01             	test   $0x1,%dl
ffffffff802862c7:        1 	74 7e                	je     ffffffff80286347 <page_check_address+0x103>
ffffffff802862c9:      927 	48 89 d0             	mov    %rdx,%rax
ffffffff802862cc:       77 	48 c1 ef 09          	shr    $0x9,%rdi
ffffffff802862d0:        3 	48 21 f0             	and    %rsi,%rax
ffffffff802862d3:     1238 	81 e7 f8 0f 00 00    	and    $0xff8,%edi
ffffffff802862d9:        1 	48 01 c8             	add    %rcx,%rax
ffffffff802862dc:        0 	4c 8d 24 38          	lea    (%rax,%rdi,1),%r12
ffffffff802862e0:      792 	41 f6 04 24 81       	testb  $0x81,(%r12)
ffffffff802862e5:       25 	74 60                	je     ffffffff80286347 <page_check_address+0x103>
ffffffff802862e7:   118074 	48 c1 ea 0c          	shr    $0xc,%rdx
ffffffff802862eb:    41187 	48 b8 00 00 00 00 00 	mov    $0xffffe20000000000,%rax
ffffffff802862f2:        0 	e2 ff ff 
ffffffff802862f5:      182 	48 6b d2 38          	imul   $0x38,%rdx,%rdx
ffffffff802862f9:    25998 	48 8d 1c 02          	lea    (%rdx,%rax,1),%rbx
ffffffff802862fd:        0 	4c 8d 6b 10          	lea    0x10(%rbx),%r13
ffffffff80286301:        0 	4c 89 ef             	mov    %r13,%rdi
ffffffff80286304:    80598 	e8 4b 17 28 00       	callq  ffffffff80507a54 <_spin_lock>
ffffffff80286309:    36022 	49 8b 0c 24          	mov    (%r12),%rcx
ffffffff8028630d:     1623 	f6 c1 81             	test   $0x81,%cl
ffffffff80286310:        5 	74 32                	je     ffffffff80286344 <page_check_address+0x100>
ffffffff80286312:       16 	48 b8 00 00 00 00 00 	mov    $0x1e0000000000,%rax
ffffffff80286319:        0 	1e 00 00 
ffffffff8028631c:      359 	48 ba b7 6d db b6 6d 	mov    $0x6db6db6db6db6db7,%rdx
ffffffff80286323:        0 	db b6 6d 
ffffffff80286326:       12 	48 c1 e1 12          	shl    $0x12,%rcx
ffffffff8028632a:        0 	49 8d 04 06          	lea    (%r14,%rax,1),%rax
ffffffff8028632e:      492 	48 c1 e9 1e          	shr    $0x1e,%rcx
ffffffff80286332:       23 	48 c1 f8 03          	sar    $0x3,%rax
ffffffff80286336:        0 	48 0f af c2          	imul   %rdx,%rax
ffffffff8028633a:     1390 	48 39 c8             	cmp    %rcx,%rax
ffffffff8028633d:        0 	75 05                	jne    ffffffff80286344 <page_check_address+0x100>
ffffffff8028633f:        0 	4d 89 2f             	mov    %r13,(%r15)
ffffffff80286342:      165 	eb 06                	jmp    ffffffff8028634a <page_check_address+0x106>
ffffffff80286344:        0 	fe 43 10             	incb   0x10(%rbx)
ffffffff80286347:    11886 	45 31 e4             	xor    %r12d,%r12d
ffffffff8028634a:    17451 	5a                   	pop    %rdx
ffffffff8028634b:    14507 	5b                   	pop    %rbx
ffffffff8028634c:       42 	4c 89 e0             	mov    %r12,%rax
ffffffff8028634f:     1736 	41 5c                	pop    %r12
ffffffff80286351:       40 	41 5d                	pop    %r13
ffffffff80286353:     1727 	41 5e                	pop    %r14
ffffffff80286355:     1420 	41 5f                	pop    %r15
ffffffff80286357:       44 	c9                   	leaveq 
ffffffff80286358:     1685 	c3                   	retq   

gcc-4.2.3, the config is at:

  http://redhat.com/~mingo/misc/config-Thu_May__8_22_23_21_CEST_2008


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0BDTky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:40:54 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36895 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734Ab0BDTku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:40:50 -0500
Date: Thu, 4 Feb 2010 20:40:47 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
	improvements
Message-ID: <20100204194047.GE5733@kernel.dk>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <20100203102540.GQ5733@kernel.dk> <20100203205009.GB5068@nowhere>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <20100203205009.GB5068@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 03 2010, Frederic Weisbecker wrote:
> Ok, thanks a lot, the fact you can test on a 64 threads box is critically
> helpful.
> 
> I also wonder what happens after this patch applied:
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 98fd360..254b3d4 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -3094,7 +3094,8 @@ static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
>         if (event->parent)
>                 event = event->parent;
>  
> -       return task_pid_nr_ns(p, event->ns);
> +       return p->pid;
>  }
> 
> In my box it has increased the speed from 2x this patchset.

Doesn't seem to change anything, same runtime for a ls.

> I wonder if the tool becomes usable for you with that.
> Otherwise, it means we have other things to fix, and
> the result of:
> 
> 	perf record -g -f perf lock record sleep 6
> 	perf report
> 
> would be very nice to have.

root@nehalem:/dev/shm # perf record -g -f perf lock record sleep 6
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 446.208 MB perf.data (~19495127 samples) ]
[ perf record: Woken up 9 times to write data ]
[ perf record: Captured and wrote 1.135 MB perf.data (~49609 samples) ]

It's huuuge. Thankfully the output isn't so big, I've attached it.

-- 
Jens Axboe


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="perf-lock-report.txt"

# Samples: 6012215
#
# Overhead          Command                                        Shared Object  Symbol
# ........  ...............  ...................................................  ......
#
    51.54%             perf  libpthread-2.7.so                                    [.] __write_nocancel
    19.36%             init  [kernel.kallsyms]                                    [k] acpi_idle_enter_bm
    11.30%             init                                                    0  [k] 0000000000000000
     4.05%          swapper  [kernel.kallsyms]                                    [k] acpi_idle_enter_c1
     3.56%             perf  [kernel.kallsyms]                                    [k] ftrace_profile_lock_acquire
     3.11%          swapper                                                    0  [k] 0000000000000000
     2.70%          swapper  [kernel.kallsyms]                                    [k] acpi_idle_enter_bm
     1.45%             init  [kernel.kallsyms]                                    [k] __do_softirq
     0.48%          swapper  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.37%             perf  libc-2.7.so                                          [.] __GI_mmap
     0.25%             perf  libc-2.7.so                                          [.] __GI___open
     0.15%             perf  libc-2.7.so                                          [.] __getdents64
     0.11%             perf  perf                                                 [.] __cmd_record
     0.10%             perf  libc-2.7.so                                          [.] __GI___libc_read
     0.09%             perf  libc-2.7.so                                          [.] __munmap
     0.08%             perf  libc-2.7.so                                          [.] syscall
     0.07%             perf  libc-2.7.so                                          [.] __GI_close
     0.07%             perf  libc-2.7.so                                          [.] __GI___poll
     0.07%             perf  [kernel.kallsyms]                                    [k] ftrace_profile_lock_release
     0.06%             java  libpthread-2.7.so                                    [.] pthread_cond_timedwait@@GLIBC_2.3.2
     0.05%          swapper  [kernel.kallsyms]                                    [k] cpuidle_idle_call
     0.05%             perf  libc-2.7.so                                          [.] __GI_ioctl
     0.04%        scsi_eh_1  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.03%             perf  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irq
     0.03%          swapper  [kernel.kallsyms]                                    [k] cpu_idle
     0.03%             perf  [kernel.kallsyms]                                    [k] __do_softirq
     0.03%             perf  [kernel.kallsyms]                                    [k] lock_acquired
     0.03%             perf  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.03%             perf  libc-2.7.so                                          [.] __GI___fxstat64
     0.03%            sleep  libc-2.7.so                                          [.] __execve
     0.03%  wrapper-linux-x  libpthread-2.7.so                                    [.] 0x0000000000cfec
     0.02%             init  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.02%             perf  [kernel.kallsyms]                                    [k] __mutex_unlock_slowpath
     0.02%          swapper  [kernel.kallsyms]                                    [k] __do_softirq
     0.02%         postgres  libc-2.7.so                                          [.] __libc_select
     0.01%  hald-addon-stor  libc-2.7.so                                          [.] __GI_ioctl
     0.01%  hald-addon-stor  libc-2.7.so                                          [.] __GI___open
     0.01%             perf  [kernel.kallsyms]                                    [k] clear_page_c
     0.01%             init  [kernel.kallsyms]                                    [k] acpi_idle_enter_c1
     0.01%  wrapper-linux-x  libpthread-2.7.so                                    [.] __libc_recv
     0.01%  wrapper-linux-x  libpthread-2.7.so                                    [.] __waitpid
     0.01%            sleep  libc-2.7.so                                          [.] __GI__exit
     0.01%             perf  [kernel.kallsyms]                                    [k] mutex_lock_nested
     0.01%          swapper  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irq
     0.01%             perf  libpthread-2.7.so                                    [.] fcntl
     0.01%             java  libpthread-2.7.so                                    [.] __lll_unlock_wake
     0.01%             perf  [kernel.kallsyms]                                    [k] lock_acquire
     0.01%        scsi_eh_1  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.01%             perf  libpthread-2.7.so                                    [.] __read
     0.01%             perf  perf                                                 [.] create_counter
     0.01%             perf  [kernel.kallsyms]                                    [k] copy_user_generic_string
     0.01%        events/38  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.01%         events/4  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.01%        events/36  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.01%             perf  [kernel.kallsyms]                                    [k] lock_release
     0.01%             perf  [kernel.kallsyms]                                    [k] generic_exec_single
     0.01%  wrapper-linux-x  libpthread-2.7.so                                    [.] __read
     0.01%         events/6  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.01%         events/7  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.01%         events/0  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/52  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%             ntpd  libc-2.7.so                                          [.] __libc_select
     0.00%  hald-addon-stor  libc-2.7.so                                          [.] __GI_close
     0.00%        events/18  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%            sleep  ld-2.7.so                                            [.] __mmap
     0.00%             perf  [kernel.kallsyms]                                    [k] get_page_from_freelist
     0.00%        events/31  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/10  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%            sleep  ld-2.7.so                                            [.] _dl_relocate_object
     0.00%        events/39  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/17  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/32  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/37  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/16  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/12  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/57  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%         events/2  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/51  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/28  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%         events/9  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%         events/8  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/63  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/62  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/61  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/60  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/59  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/58  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/56  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/55  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/54  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/53  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%         events/5  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/43  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/42  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/41  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/40  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/35  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/34  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/33  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/30  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%         events/3  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/29  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/27  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/26  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/25  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/24  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/23  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/22  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/21  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/20  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/19  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/15  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/14  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/13  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/11  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%         events/1  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%          swapper  [kernel.kallsyms]                                    [k] net_rx_action
     0.00%        events/44  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%       mpt_poll_3  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%       mpt_poll_1  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%           mysqld  libc-2.7.so                                          [.] __libc_select
     0.00%        events/49  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%             perf  [kernel.kallsyms]                                    [k] do_page_fault
     0.00%        events/50  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/48  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/47  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/46  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%        events/45  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%             perf  [kernel.kallsyms]                                    [k] iov_iter_fault_in_readable
     0.00%             perf  [kernel.kallsyms]                                    [k] shmem_getpage
     0.00%        flush-8:0  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%         postgres  libc-2.7.so                                          [.] __getppid
     0.00%       mpt_poll_2  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%       mpt_poll_0  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%             java  libc-2.7.so                                          [.] __GI___poll
     0.00%             perf  [vdso]                                               [.] 0x00000000000638
     0.00%            sleep  ld-2.7.so                                            [.] __libc_open
     0.00%             perf  [kernel.kallsyms]                                    [k] __wake_up_bit
     0.00%             perf  [kernel.kallsyms]                                    [k] __alloc_pages_nodemask
     0.00%             perf                                     ffffffffff600167  [.] 0xffffffffff600167
     0.00%             java  libpthread-2.7.so                                    [.] __libc_recv
     0.00%  wrapper-linux-x  libpthread-2.7.so                                    [.] __libc_send
     0.00%            sleep  ld-2.7.so                                            [.] access
     0.00%         events/0  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irq
     0.00%            sleep  libc-2.7.so                                          [.] _nl_intern_locale_data
     0.00%             java  libpthread-2.7.so                                    [.] __libc_send
     0.00%          swapper  [kernel.kallsyms]                                    [k] clockevents_notify
     0.00%            sleep  ld-2.7.so                                            [.] _dl_map_object_from_fd
     0.00%  hald-addon-stor  libc-2.7.so                                          [.] __GI___poll
     0.00%            sleep  ld-2.7.so                                            [.] strcmp
     0.00%       mpt_poll_1  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.00%             init  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irq
     0.00%             perf  [kernel.kallsyms]                                    [k] put_page
     0.00%             perf  [kernel.kallsyms]                                    [k] do_raw_spin_trylock
     0.00%             java  libjvm.so                                            [.] 0x0000000052d47e
     0.00%         events/0  [kernel.kallsyms]                                    [k] drain_array
     0.00%          swapper  [kernel.kallsyms]                                    [k] lapic_timer_state_broadcast
     0.00%          swapper  [kernel.kallsyms]                                    [k] ftrace_profile_lock_acquire
     0.00%            sleep  ld-2.7.so                                            [.] __mprotect
     0.00%             ntpd  libc-2.7.so                                          [.] __sendto_nocancel
     0.00%            sleep  ld-2.7.so                                            [.] check_match.8369
     0.00%            sleep  ld-2.7.so                                            [.] dl_main
     0.00%            sleep  ld-2.7.so                                            [.] _dl_setup_hash
     0.00%            sleep  libc-2.7.so                                          [.] __GI___open
     0.00%            sleep  ld-2.7.so                                            [.] memset
     0.00%          swapper  [kernel.kallsyms]                                    [k] _raw_spin_lock_irqsave
     0.00%            sleep  libc-2.7.so                                          [.] _int_malloc
     0.00%       kblockd/22  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%            sleep  ld-2.7.so                                            [.] _dl_cache_libcmp
     0.00%            sleep  ld-2.7.so                                            [.] _dl_load_cache_lookup
     0.00%         postgres  libc-2.7.so                                          [.] __GI___poll
     0.00%             ntpd  libc-2.7.so                                          [.] __GI___open
     0.00%          swapper  [kernel.kallsyms]                                    [k] schedule
     0.00%            sleep  ld-2.7.so                                            [.] _dl_new_object
     0.00%        scsi_eh_1  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irq
     0.00%            sleep  libc-2.7.so                                          [.] __libc_pthread_init
     0.00%             perf  [kernel.kallsyms]                                    [k] system_call
     0.00%             perf  [kernel.kallsyms]                                    [k] unlock_page
     0.00%            sleep  sleep                                                [.] 0x00000000001110
     0.00%            sleep  libc-2.7.so                                          [.] _nl_load_locale_from_archive
     0.00%            sleep  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.00%             ntpd  libc-2.7.so                                          [.] _xstat
     0.00%            sleep  ld-2.7.so                                            [.] _dl_start
     0.00%             perf  [kernel.kallsyms]                                    [k] ftrace_perf_buf_prepare
     0.00%             perf  [kernel.kallsyms]                                    [k] should_remove_suid
     0.00%             perf  [kernel.kallsyms]                                    [k] find_get_page
     0.00%             perf  [kernel.kallsyms]                                    [k] find_lock_page
     0.00%             perf  [kernel.kallsyms]                                    [k] __generic_file_aio_write
     0.00%             perf  [kernel.kallsyms]                                    [k] generic_file_aio_write
     0.00%             perf  [kernel.kallsyms]                                    [k] balance_dirty_pages_ratelimited_nr
     0.00%             perf  [kernel.kallsyms]                                    [k] next_zones_zonelist
     0.00%             perf  [kernel.kallsyms]                                    [k] cache_grow
     0.00%             perf  [kernel.kallsyms]                                    [k] sys_write
     0.00%             perf  [kernel.kallsyms]                                    [k] file_update_time
     0.00%             perf  [kernel.kallsyms]                                    [k] __fsnotify_parent
     0.00%             perf  [kernel.kallsyms]                                    [k] cap_vm_enough_memory
     0.00%             perf  [kernel.kallsyms]                                    [k] _raw_spin_lock_irq
     0.00%             ntpd  libc-2.7.so                                          [.] __recvmsg
     0.00%            sleep  libc-2.7.so                                          [.] _nl_normalize_codeset
     0.00%            sleep  libc-2.7.so                                          [.] ____strtod_l_internal
     0.00%            sleep  libc-2.7.so                                          [.] __GI_strlen
     0.00%            sleep  ld-2.7.so                                            [.] do_lookup_x
     0.00%            sleep  libpthread-2.7.so                                    [.] __pthread_initialize_minimal
     0.00%            sleep  libc-2.7.so                                          [.] _init
     0.00%       mpt_poll_3  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.00%          swapper  [kernel.kallsyms]                                    [k] kmem_cache_free
     0.00%        scsi_eh_1  [kernel.kallsyms]                                    [k] ata_dev_next
     0.00%             init  libc-2.7.so                                          [.] _xstat
     0.00%             perf  libpthread-2.7.so                                    [.] __libc_lseek
     0.00%            sleep  libc-2.7.so                                          [.] __nanosleep_nocancel
     0.00%     migration/37  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%      bdi-default  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%             init  [kernel.kallsyms]                                    [k] ftrace_profile_lock_acquire
     0.00%        scsi_eh_1  [kernel.kallsyms]                                    [k] ahci_stop_engine
     0.00%             perf  perf                                                 [.] __dsos__findnew
     0.00%          swapper  [kernel.kallsyms]                                    [k] lock_acquire
     0.00%            sleep  libc-2.7.so                                          [.] __GI_mmap
     0.00%            sleep  ld-2.7.so                                            [.] _dl_init_paths
     0.00%            sleep  ld-2.7.so                                            [.] munmap
     0.00%       mpt_poll_0  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.00%         events/0  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.00%            sleep  libc-2.7.so                                          [.] str_to_mpn
     0.00%            sleep  libc-2.7.so                                          [.] ptmalloc_init
     0.00%            sleep  libc-2.7.so                                          [.] index
     0.00%            sleep  libc-2.7.so                                          [.] __GI_strcmp
     0.00%            sleep  libc-2.7.so                                          [.] __strchrnul
     0.00%            sleep  libc-2.7.so                                          [.] sysconf
     0.00%            sleep  ld-2.7.so                                            [.] _dl_lookup_symbol_x
     0.00%            sleep  ld-2.7.so                                            [.] _dl_map_object_deps
     0.00%            sleep  ld-2.7.so                                            [.] match_symbol
     0.00%            sleep  ld-2.7.so                                            [.] _dl_sysdep_start
     0.00%            sleep  ld-2.7.so                                            [.] strlen
     0.00%             perf  perf                                                 [.] perf_header__write
     0.00%             perf  libc-2.7.so                                          [.] _itoa_word
     0.00%             perf  [kernel.kallsyms]                                    [k] add_to_page_cache_lru
     0.00%             java                                             f4558044  [.] 0x000000f4558044
     0.00%            sleep  ld-2.7.so                                            [.] _start
     0.00%  wrapper-linux-x  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irqrestore
     0.00%            sleep  libc-2.7.so                                          [.] __brk
     0.00%            sleep  libc-2.7.so                                          [.] __GI___register_atfork
     0.00%            sleep  ld-2.7.so                                            [.] __brk
     0.00%             ntpd  ntpd                                                 [.] 0x00000000026cd0
     0.00%             ntpd  libc-2.7.so                                          [.] __restore_rt
     0.00%           mysqld  mysqld                                               [.] srv_lock_timeout_and_monitor_thread
     0.00%       kblockd/18  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%             init  libc-2.7.so                                          [.] __libc_select
     0.00%            sleep  ld-2.7.so                                            [.] __GI___fxstat
     0.00%            sleep  libpthread-2.7.so                                    [.] __read
     0.00%            sleep  libpthread-2.7.so                                    [.] __libc_sigaction
     0.00%       mpt_poll_0  [kernel.kallsyms]                                    [k] _raw_spin_unlock_irq
     0.00%            sleep  libc-2.7.so                                          [.] __GI___fxstat64
     0.00%            sleep  ld-2.7.so                                            [.] _dl_next_tls_modid
     0.00%            sleep  libc-2.7.so                                          [.] __GI___getrlimit
     0.00%             perf  perf                                                 [.] event__synthesize_kernel_mmap
     0.00%             perf  perf                                                 [.] event__synthesize_comm
     0.00%             perf  libc-2.7.so                                          [.] __GI_vfprintf
     0.00%             perf  libc-2.7.so                                          [.] _IO_getline_info_internal
     0.00%            sleep  librt-2.7.so                                         [.] call_gmon_start
     0.00%            sleep  librt-2.7.so                                         [.] __GI_clock_gettime
     0.00%            sleep  librt-2.7.so                                         [.] __do_global_ctors_aux
     0.00%            sleep  libpthread-2.7.so                                    [.] pthread_mutex_lock
     0.00%            sleep  libpthread-2.7.so                                    [.] __pthread_mutex_unlock
     0.00%            sleep  libpthread-2.7.so                                    [.] __pthread_rwlock_wrlock_internal
     0.00%            sleep  libpthread-2.7.so                                    [.] __pthread_cleanup_push_defer
     0.00%            sleep  libpthread-2.7.so                                    [.] __do_global_ctors_aux
     0.00%            sleep  libc-2.7.so                                          [.] __GI_setlocale
     0.00%            sleep  libc-2.7.so                                          [.] _nl_find_locale
     0.00%            sleep  libc-2.7.so                                          [.] _nl_postload_ctype
     0.00%            sleep  libc-2.7.so                                          [.] __bindtextdomain
     0.00%            sleep  libc-2.7.so                                          [.] __textdomain
     0.00%            sleep  libc-2.7.so                                          [.] _setjmp
     0.00%            sleep  libc-2.7.so                                          [.] __GI_bsearch
     0.00%            sleep  libc-2.7.so                                          [.] __GI_getenv
     0.00%            sleep  libc-2.7.so                                          [.] __cxa_atexit_internal
     0.00%            sleep  libc-2.7.so                                          [.] __GI_strtod_l
     0.00%            sleep  libc-2.7.so                                          [.] __mpn_lshift
     0.00%            sleep  libc-2.7.so                                          [.] __mpn_construct_double
     0.00%            sleep  libc-2.7.so                                          [.] __new_fclose
     0.00%            sleep  libc-2.7.so                                          [.] __fpending
     0.00%            sleep  libc-2.7.so                                          [.] _IO_file_close_internal
     0.00%            sleep  libc-2.7.so                                          [.] _IO_un_link
     0.00%            sleep  libc-2.7.so                                          [.] _IO_unsave_markers_internal
     0.00%            sleep  libc-2.7.so                                          [.] _IO_cleanup
     0.00%            sleep  libc-2.7.so                                          [.] __GI___libc_malloc
     0.00%            sleep  libc-2.7.so                                          [.] __default_morecore
     0.00%            sleep  libc-2.7.so                                          [.] __GI_strrchr
     0.00%            sleep  libc-2.7.so                                          [.] __GI_mempcpy
     0.00%            sleep  libc-2.7.so                                          [.] memcpy
     0.00%            sleep  libc-2.7.so                                          [.] intel_02_known_compare
     0.00%            sleep  libc-2.7.so                                          [.] init_cacheinfo
     0.00%            sleep  libc-2.7.so                                          [.] __GI_nanosleep
     0.00%            sleep  libc-2.7.so                                          [.] _getopt_internal_r
     0.00%            sleep  libc-2.7.so                                          [.] getopt_long
     0.00%            sleep  libc-2.7.so                                          [.] __GI___getpagesize
     0.00%            sleep  libc-2.7.so                                          [.] __init_misc
     0.00%            sleep  libc-2.7.so                                          [.] _dl_addr
     0.00%            sleep  libc-2.7.so                                          [.] __libc_dl_error_tsd
     0.00%            sleep  ld-2.7.so                                            [.] local_strdup
     0.00%            sleep  ld-2.7.so                                            [.] open_verify
     0.00%            sleep  ld-2.7.so                                            [.] _dl_debug_initialize
     0.00%            sleep  ld-2.7.so                                            [.] _dl_name_match_p
     0.00%            sleep  ld-2.7.so                                            [.] _dl_determine_tlsoffset
     0.00%            sleep  ld-2.7.so                                            [.] _dl_runtime_resolve
     0.00%            sleep  ld-2.7.so                                            [.] index
     0.00%            sleep  ld-2.7.so                                            [.] __libc_close
     0.00%             init  [kernel.kallsyms]                                    [k] find_busiest_group
     0.00%            sleep  libc-2.7.so                                          [.] __new_exitfn
     0.00%            sleep  ld-2.7.so                                            [.] _dl_allocate_tls_storage
     0.00%            sleep  ld-2.7.so                                            [.] memcpy
     0.00%             perf  libc-2.7.so                                          [.] _int_malloc
     0.00%          swapper  [kernel.kallsyms]                                    [k] find_next_bit
     0.00%        scsi_eh_1  [kernel.kallsyms]                                    [k] ioread32
     0.00%        scsi_eh_1  [kernel.kallsyms]                                    [k] scsi_device_put
     0.00%      sync_supers  [kernel.kallsyms]                                    [k] kernel_thread_helper
     0.00%             perf  perf                                                 [.] sig_handler
     0.00%            sleep  libc-2.7.so                                          [.] __GI_close
     0.00%            sleep  ld-2.7.so                                            [.] __read
     0.00%             init  [kernel.kallsyms]                                    [k] ftrace_profile_lock_release
     0.00%             perf  libc-2.7.so                                          [.] __restore_rt
     0.00%             init  [kernel.kallsyms]                                    [k] run_rebalance_domains
     0.00%             init  [kernel.kallsyms]                                    [k] run_timer_softirq
     0.00%             init  [kernel.kallsyms]                                    [k] hrtimer_run_pending
     0.00%             init  [kernel.kallsyms]                                    [k] lock_release
     0.00%             init  [kernel.kallsyms]                                    [k] check_for_new_grace_period
     0.00%             init  [kernel.kallsyms]                                    [k] __rcu_process_callbacks
     0.00%             init  [kernel.kallsyms]                                    [k] find_next_bit
     0.00%             init  [kernel.kallsyms]                                    [k] hweight64
     0.00%             init  [kernel.kallsyms]                                    [k] lapic_timer_state_broadcast
     0.00%             init  libc-2.7.so                                          [.] __GI___fxstat64
     0.00%          swapper  [kernel.kallsyms]                                    [k] blk_iopoll_softirq
     0.00%          swapper  [kernel.kallsyms]                                    [k] 0000000000000000
     0.00%     ksoftirqd/36  [kernel.kallsyms]                                    [k] kernel_thread_helper
#
# (For a higher level overview, try: perf report --sort comm,dso)
#

--neYutvxvOLaeuPCA--

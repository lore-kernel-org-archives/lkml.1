Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbZBKNvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbZBKNvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZBKNvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:51:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41165 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZBKNu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:50:58 -0500
Date: Wed, 11 Feb 2009 11:50:32 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Packable data structures found by pahole
Message-ID: <20090211135032.GI12820@ghostprotocols.net>
References: <20090209190406.GA11005@ghostprotocols.net> <20090211122236.GC16535@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211122236.GC16535@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 11, 2009 at 01:22:36PM +0100, Ingo Molnar escreveu:
> Is there anything packable in core kernel structures like task struct?

I still haven't added an heuristic to avoid reporting members with
explicit __alignment attributes, as these are not encoded in DWARF. I'll
work on that soon, but till then we can use this as an starting point.

struct name, current size, --reorganized size, savings

$ pahole --packable ../build/blkftrace/vmlinux | sort -k4 -nr
vc_data                      432   176 256
   is this exported to userspace?

rcu_ctrlblk                  128    64  64
   has ____cacheline_internodealigned_in_smp

timex                        208   152  56
   syscall interface

hh_cache                     128    72  56
   has ____cacheline_aligned_in_smp

cpu_workqueue_struct         128    72  56
   is ____cacheline_aligned

rchan_buf                    256   216  40
   is ____cacheline_aligned

tty_struct                  1328  1296  32
   this one doesn't have any annotation, looks ripe for --reorganize

task_struct                 6008  5976  32

   Printing this one here, the rest of the possibly packable data
structures are after it:

struct task_struct {
	volatile long int          state;                /*     0     8 */
	void *                     stack;                /*     8     8 */
	atomic_t                   usage;                /*    16     4 */
	unsigned int               flags;                /*    20     4 */
	unsigned int               ptrace;               /*    24     4 */
	int                        lock_depth;           /*    28     4 */
	int                        prio;                 /*    32     4 */
	int                        static_prio;          /*    36     4 */
	int                        normal_prio;          /*    40     4 */
	unsigned int               rt_priority;          /*    44     4 */
	const struct sched_class  * sched_class;         /*    48     8 */
	struct sched_entity        se;                   /*    56   368 */
	/* --- cacheline 6 boundary (384 bytes) was 40 bytes ago --- */
	struct sched_rt_entity     rt;                   /*   424    64 */
	/* --- cacheline 7 boundary (448 bytes) was 40 bytes ago --- */
	unsigned char              fpu_counter;          /*   488     1 */
	s8                         oomkilladj;           /*   489     1 */

	/* XXX 2 bytes hole, try to pack */

	unsigned int               btrace_seq;           /*   492     4 */
	unsigned int               policy;               /*   496     4 */

	/* XXX 4 bytes hole, try to pack */

	cpumask_t                  cpus_allowed;         /*   504     8 */
	/* --- cacheline 8 boundary (512 bytes) --- */
	struct sched_info          sched_info;           /*   512    40 */

	/* XXX last struct has 4 bytes of padding */

	struct list_head           tasks;                /*   552    16 */
	struct plist_node          pushable_tasks;       /*   568    40 */
	/* --- cacheline 9 boundary (576 bytes) was 32 bytes ago --- */
	struct mm_struct *         mm;                   /*   608     8 */
	struct mm_struct *         active_mm;            /*   616     8 */
	struct linux_binfmt *      binfmt;               /*   624     8 */
	int                        exit_state;           /*   632     4 */
	int                        exit_code;            /*   636     4 */
	/* --- cacheline 10 boundary (640 bytes) --- */
	int                        exit_signal;          /*   640     4 */
	int                        pdeath_signal;        /*   644     4 */
	unsigned int               personality;          /*   648     4 */
	unsigned int               did_exec:1;           /*   652:31  4 */

	/* XXX 31 bits hole, try to pack */

	pid_t                      pid;                  /*   656     4 */
	pid_t                      tgid;                 /*   660     4 */
	long unsigned int          stack_canary;         /*   664     8 */
	struct task_struct *       real_parent;          /*   672     8 */
	struct task_struct *       parent;               /*   680     8 */
	struct list_head           children;             /*   688    16 */
	/* --- cacheline 11 boundary (704 bytes) --- */
	struct list_head           sibling;              /*   704    16 */
	struct task_struct *       group_leader;         /*   720     8 */
	struct list_head           ptraced;              /*   728    16 */
	struct list_head           ptrace_entry;         /*   744    16 */
	struct bts_tracer *        bts;                  /*   760     8 */
	/* --- cacheline 12 boundary (768 bytes) --- */
	void *                     bts_buffer;           /*   768     8 */
	size_t                     bts_size;             /*   776     8 */
	struct pid_link            pids[3];              /*   784    72 */
	/* --- cacheline 13 boundary (832 bytes) was 24 bytes ago --- */
	struct list_head           thread_group;         /*   856    16 */
	struct completion *        vfork_done;           /*   872     8 */
	int *                      set_child_tid;        /*   880     8 */
	int *                      clear_child_tid;      /*   888     8 */
	/* --- cacheline 14 boundary (896 bytes) --- */
	cputime_t                  utime;                /*   896     8 */
	cputime_t                  stime;                /*   904     8 */
	cputime_t                  utimescaled;          /*   912     8 */
	cputime_t                  stimescaled;          /*   920     8 */
	cputime_t                  gtime;                /*   928     8 */
	cputime_t                  prev_utime;           /*   936     8 */
	cputime_t                  prev_stime;           /*   944     8 */
	long unsigned int          nvcsw;                /*   952     8 */
	/* --- cacheline 15 boundary (960 bytes) --- */
	long unsigned int          nivcsw;               /*   960     8 */
	struct timespec            start_time;           /*   968    16 */
	struct timespec            real_start_time;      /*   984    16 */
	long unsigned int          min_flt;              /*  1000     8 */
	long unsigned int          maj_flt;              /*  1008     8 */
	struct task_cputime        cputime_expires;      /*  1016    24 */
	/* --- cacheline 16 boundary (1024 bytes) was 16 bytes ago --- */
	struct list_head           cpu_timers[3];        /*  1040    48 */
	/* --- cacheline 17 boundary (1088 bytes) --- */
	const struct cred  *       real_cred;            /*  1088     8 */
	const struct cred  *       cred;                 /*  1096     8 */
	struct mutex               cred_exec_mutex;      /*  1104    32 */
	char                       comm[16];             /*  1136    16 */
	/* --- cacheline 18 boundary (1152 bytes) --- */
	int                        link_count;           /*  1152     4 */
	int                        total_link_count;     /*  1156     4 */
	struct sysv_sem            sysvsem;              /*  1160     8 */
	long unsigned int          last_switch_count;    /*  1168     8 */
	struct thread_struct       thread;               /*  1176   208 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 21 boundary (1344 bytes) was 40 bytes ago --- */
	struct fs_struct *         fs;                   /*  1384     8 */
	struct files_struct *      files;                /*  1392     8 */
	struct nsproxy *           nsproxy;              /*  1400     8 */
	/* --- cacheline 22 boundary (1408 bytes) --- */
	struct signal_struct *     signal;               /*  1408     8 */
	struct sighand_struct *    sighand;              /*  1416     8 */
	sigset_t                   blocked;              /*  1424     8 */
	sigset_t                   real_blocked;         /*  1432     8 */
	sigset_t                   saved_sigmask;        /*  1440     8 */
	struct sigpending          pending;              /*  1448    24 */
	/* --- cacheline 23 boundary (1472 bytes) --- */
	long unsigned int          sas_ss_sp;            /*  1472     8 */
	size_t                     sas_ss_size;          /*  1480     8 */
	int                        (*notifier)(void *);  /*  1488     8 */
	void *                     notifier_data;        /*  1496     8 */
	sigset_t *                 notifier_mask;        /*  1504     8 */
	struct audit_context *     audit_context;        /*  1512     8 */
	uid_t                      loginuid;             /*  1520     4 */
	unsigned int               sessionid;            /*  1524     4 */
	seccomp_t                  seccomp;              /*  1528     4 */
	u32                        parent_exec_id;       /*  1532     4 */
	/* --- cacheline 24 boundary (1536 bytes) --- */
	u32                        self_exec_id;         /*  1536     4 */
	spinlock_t                 alloc_lock;           /*  1540     4 */
	spinlock_t                 pi_lock;              /*  1544     4 */

	/* XXX 4 bytes hole, try to pack */

	struct plist_head          pi_waiters;           /*  1552    32 */
	struct rt_mutex_waiter *   pi_blocked_on;        /*  1584     8 */
	unsigned int               irq_events;           /*  1592     4 */
	int                        hardirqs_enabled;     /*  1596     4 */
	/* --- cacheline 25 boundary (1600 bytes) --- */
	long unsigned int          hardirq_enable_ip;    /*  1600     8 */
	unsigned int               hardirq_enable_event; /*  1608     4 */

	/* XXX 4 bytes hole, try to pack */

	long unsigned int          hardirq_disable_ip;   /*  1616     8 */
	unsigned int               hardirq_disable_event; /*  1624     4 */
	int                        softirqs_enabled;     /*  1628     4 */
	long unsigned int          softirq_disable_ip;   /*  1632     8 */
	unsigned int               softirq_disable_event; /*  1640     4 */

	/* XXX 4 bytes hole, try to pack */

	long unsigned int          softirq_enable_ip;    /*  1648     8 */
	unsigned int               softirq_enable_event; /*  1656     4 */
	int                        hardirq_context;      /*  1660     4 */
	/* --- cacheline 26 boundary (1664 bytes) --- */
	int                        softirq_context;      /*  1664     4 */

	/* XXX 4 bytes hole, try to pack */

	void *                     journal_info;         /*  1672     8 */
	struct bio *               bio_list;             /*  1680     8 */
	struct bio * *             bio_tail;             /*  1688     8 */
	struct reclaim_state *     reclaim_state;        /*  1696     8 */
	struct backing_dev_info *  backing_dev_info;     /*  1704     8 */
	struct io_context *        io_context;           /*  1712     8 */
	long unsigned int          ptrace_message;       /*  1720     8 */
	/* --- cacheline 27 boundary (1728 bytes) --- */
	siginfo_t *                last_siginfo;         /*  1728     8 */
	struct task_io_accounting  ioac;                 /*  1736    56 */
	/* --- cacheline 28 boundary (1792 bytes) --- */
	u64                        acct_rss_mem1;        /*  1792     8 */
	u64                        acct_vm_mem1;         /*  1800     8 */
	cputime_t                  acct_timexpd;         /*  1808     8 */
	nodemask_t                 mems_allowed;         /*  1816    64 */
	/* --- cacheline 29 boundary (1856 bytes) was 24 bytes ago --- */
	int                        cpuset_mems_generation; /*  1880     4 */
	int                        cpuset_mem_spread_rotor; /*  1884     4 */
	struct css_set *           cgroups;              /*  1888     8 */
	struct list_head           cg_list;              /*  1896    16 */
	struct robust_list_head *  robust_list;          /*  1912     8 */
	/* --- cacheline 30 boundary (1920 bytes) --- */
	struct compat_robust_list_head * compat_robust_list; /*  1920     8 */
	struct list_head           pi_state_list;        /*  1928    16 */
	struct futex_pi_state *    pi_state_cache;       /*  1944     8 */
	struct perf_counter_context perf_counter_ctx;    /*  1952    80 */
	/* --- cacheline 31 boundary (1984 bytes) was 48 bytes ago --- */
	struct mempolicy *         mempolicy;            /*  2032     8 */
	short int                  il_next;              /*  2040     2 */

	/* XXX 2 bytes hole, try to pack */

	atomic_t                   fs_excl;              /*  2044     4 */
	/* --- cacheline 32 boundary (2048 bytes) --- */
	struct rcu_head            rcu;                  /*  2048    16 */
	struct pipe_inode_info *   splice_pipe;          /*  2064     8 */
	struct task_delay_info *   delays;               /*  2072     8 */
	struct prop_local_single   dirties;              /*  2080    24 */
	int                        latency_record_count; /*  2104     4 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 33 boundary (2112 bytes) --- */
	struct latency_record      latency_record[32];   /*  2112  3840 */
	/* --- cacheline 93 boundary (5952 bytes) --- */
	long unsigned int          timer_slack_ns;       /*  5952     8 */
	long unsigned int          default_timer_slack_ns; /*  5960     8 */
	struct list_head *         scm_work_list;        /*  5968     8 */
	int                        curr_ret_stack;       /*  5976     4 */

	/* XXX 4 bytes hole, try to pack */

	struct ftrace_ret_stack *  ret_stack;            /*  5984     8 */
	atomic_t                   trace_overrun;        /*  5992     4 */
	atomic_t                   tracing_graph_pause;  /*  5996     4 */
	long unsigned int          trace;                /*  6000     8 */

	/* size: 6008, cachelines: 94, members: 148 */
	/* sum members: 5976, holes: 9, sum holes: 32 */
	/* bit holes: 1, sum bit holes: 31 bits */
	/* paddings: 2, sum paddings: 8 */
	/* last cacheline: 56 bytes */
};	/* definitions: 742 */

If we ask pahole to reorganize it it would do these steps:

$ pahole -C task_struct --reorganize --show_reorg_steps kernel/sched.o|grep ^\/
/* Demoting bitfield ('did_exec' ... 'did_exec') from 'unsigned int' to
 * 'unsigned char' */

/* Moving bitfield('did_exec' ... 'did_exec') from after 'personality'
 * to after 'oomkilladj' */

/* Moving 'personality' from after 'pdeath_signal' to after 'policy' */

/* Moving 'hardirq_enable_event' from after 'hardirq_enable_ip' to after
 * 'pi_lock' */

/* Moving 'softirq_context' from after 'hardirq_context' to after
 * 'softirq_disable_event' */

/* Moving 'curr_ret_stack' from after 'scm_work_list' to after
 * 'latency_record_count' */

And the new stats would be:

	/* size: 5976, cachelines: 94, members: 148 */
	/* sum members: 5973, holes: 2, sum holes: 3 */
	/* bit holes: 1, sum bit holes: 7 bits */
	/* paddings: 2, sum paddings: 8 */
	/* last cacheline: 24 bytes */
};   /* saved 32 bytes! */

It would still have these holes/paddings:

	<SNIP>

	s8                    oomkilladj;           /*   489     1 */
	unsigned char         did_exec:1;           /*   490: 7  1 */

	/* XXX 7 bits hole, try to pack */
	/* XXX 1 byte hole, try to pack */

	unsigned int               btrace_seq;      /*   492     4 */

	<SNIP>

	/* --- cacheline 8 boundary (512 bytes) --- */
	struct sched_info     sched_info;           /*   512    40 */

	/* XXX last struct has 4 bytes of padding */

	struct list_head      tasks;                /*   552    16 */

	<SNIP>

	long unsigned int     last_switch_count;    /*  1160     8 */
	struct thread_struct  thread;               /*  1168   208 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 21 boundary (1344 bytes) was 32 bytes ago --- */

	<SNIP>

	/* --- cacheline 31 boundary (1984 bytes) was 24 bytes ago --- */
	struct mempolicy *    mempolicy;            /*  2008     8 */
	short int             il_next;              /*  2016     2 */

	/* XXX 2 bytes hole, try to pack */

	atomic_t              fs_excl;              /*  2020     4 */

	<SNIP>

I put the pahole vmlinux output on
http://fedorapeople.org/~acme/pahole/vmlinux.pahole.c

zone                        1536  1512  24
super_block                  768   744  24
Scsi_Host                   1384  1360  24
scsi_device                 1312  1288  24
rq                          2456  2432  24
request_queue               2272  2248  24
net_device                  1600  1576  24
cp_private                  1344  1320  24
clocksource                  192   168  24
ata_port                   11184 11160  24
taskstats                    328   312  16
sock                         544   528  16
rtl8139_private              448   432  16
rtentry                      120   104  16
pci_dev                     1624  1608  16
packet_sock                  760   744  16
mtd_info                     352   336  16
mousedev                     784   768  16
module                       512   496  16
mm_struct                    808   792  16
loop_device                  400   384  16
journal_s                    568   552  16
gendisk                      720   704  16
floppy_drive_params          128   112  16
files_struct                 704   688  16
dio                          856   840  16
block_device                 248   232  16
audit_context               1968  1952  16
xfrm_state                   632   624   8
writeback_control             64    56   8
vt_spawn_console              24    16   8
vmap_block_queue              48    40   8
vfsmount                     224   216   8
user_struct                   96    88   8
unix_skb_parms                32    24   8
unity_map_entry               48    40   8
uart_port                    200   192   8
tty_ldisc_ops                144   136   8
tty_bufhead                  152   144   8
tty_audit_buf                 72    64   8
transaction_s                168   160   8
tick_sched                   248   240   8
thread_struct                208   200   8
sysfs_dirent                  80    72   8
sk_buff                      192   184   8
signal_struct                944   936   8
sighand_struct              2088  2080   8
sg_io_hdr                     88    80   8
serio                        704   696   8
semid_ds                      88    80   8
scsi_target                  616   608   8
scsi_pointer                  64    56   8
scm_cookie                    40    32   8
rt_rq                       1760  1752   8
rtc_device                   744   736   8
root_domain                 1704  1696   8
ring_buffer_per_cpu          112   104   8
ring_buffer                   72    64   8
request                      368   360   8
rchan                        376   368   8
psmouse_protocol              48    40   8
proto                        336   328   8
protection_domain             48    40   8
prop_local_percpu             64    56   8
proc_dir_entry               160   152   8
power_supply                 112   104   8
pnp_card                     632   624   8
platform_device              520   512   8
pid_namespace               2112  2104   8
pglist_data                80576 80568   8
perf_counter_context          80    72   8
perf_counter                4408  4400   8
pci_root_info                 40    32   8
old_serial_port               40    32   8
net                          592   584   8
neigh_table                  472   464   8
neighbour                    240   232   8
ncp_mount_data_v4             80    72   8
mtd_oob_ops                   64    56   8
msghdr                        56    48   8
mnt_namespace                 64    56   8
ml_device                    888   880   8
loop_info                    168   160   8
kprobe                       128   120   8
kparam_array                  48    40   8
kmem_cache                  4352  4344   8
irq_desc                     192   184   8
ip_sf_list                    40    32   8
ip_mc_list                   168   160   8
ipc_namespace                296   288   8
input_dev                   2352  2344   8
inode                        560   552   8
inet_timewait_death_row      568   560   8
inet6_ifaddr                 184   176   8
in_device                    376   368   8
i387_soft_struct             136   128   8
hrtimer_cpu_base             160   152   8
hid_field                    112   104   8
hid_device                  7144  7136   8
gen_estimator                112   104   8
fs_quota_stat                 80    72   8
floppy_write_errors           40    32   8
floppy_fdc_state              40    32   8
flock                         32    24   8
fb_info                      712   704   8
ext3_sb_info                 440   432   8
ext3_inode_info              768   760   8
dquot                        232   224   8
cpuinfo_x86                  192   184   8
clock_event_device           128   120   8
cdrom_generic_command         64    56   8
cache_detail                 224   216   8
bsg_device                   160   152   8
bsg_class_device              48    40   8
blk_user_trace_setup          72    64   8
blk_trace                     96    88   8
blkcipher_walk               112   104   8
audit_watch                   72    64   8
atkbd                       1488  1480   8
ata_queued_cmd               224   216   8
ata_host                      72    64   8
ata_device                  1168  1160   8
as_io_context                104    96   8
amd_iommu                    120   112   8
agp_kern_info                 80    72   8
agp_bridge_data              200   192   8
acpi_thermal                1472  1464   8
acpi_pscope_state             56    48   8
acpi_prt_entry                48    40   8
acpi_processor_power        2112  2104   8
acpi_processor_performance   112   104   8
acpi_processor_cx            136   128   8
acpi_blacklist_item           56    48   8
tty_port                     136   132   4
scsi_host_cmd_pool            48    44   4
rtentry32                     84    80   4
msqid_ds                     104   100   4
inotify_watch                 64    60   4
in6_rtmsg                     80    76   4
fown_struct                   32    28   4
fib_iter_state                56    52   4
entropy_store                 56    52   4
compat_ncp_mount_data         56    52   4
compat_loop_info             140   136   4
compat_floppy_fdc_state       32    28   4
compat_floppy_drive_params    88    84   4
agp_allocate                  24    20   4
acpi_parse_obj_named          72    68   4
fb_monspecs                  144   141   3

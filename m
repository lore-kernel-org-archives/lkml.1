Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbXDCM26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbXDCM26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXDCM26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:28:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:60590 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbXDCM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent:x-url:organization:sender;
        b=uMXS9UP4e+tjl9rVOMtGXlM3rYVaD21Tako3i/3N1qDwg6URM9L+1625YLGEaOMzWiVjGfAID+jjaQoKr5/kVDen/pZBb6aBXEorumCQQO87aajYMvWRUR25ll0hG7MCW7QdtE0pABqvGd+MbzucOFFKP5xeB7w9LHl6aobyxxE=
Date: Tue, 3 Apr 2007 09:28:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] Reorganizing structs to save space
Message-ID: <20070403122848.GA14224@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

       I implemented a struct reorganizer in pahole, one of the tools in
the dwarves suite I've been working on, it does several things to reduce
the size of structs:

1. demotes bitfields to a base type that is enough for the sum of the
   members.
2. combines bitfields by moving members
3. combines alignment holes by moving members

	There are some problems related to explicit
____cacheline_aligned{_in_smp} not being respected in some cases, as there
is no information in the DWARF tags about these gcc attributes it just tries
some heuristics to avoid it, I'll be trying using the DW_AT_decl_{file,line}
DWARF attributes in the future to look at the source code and parse these
attributes, taking it into account when doing the reorganization.

         Of course this only matters for non exported to userspace ABI structs :-)

         But even with this current shortcoming the results are interesting,
below we have a list of structs in a recent x86_64 SMP kernel build, produced
with the following command:

[acme@filo pahole]$ pahole --packable --executable examples/vmlinux-x86_64

          After this list we can look at one of the reorganizations, as an
example, and at the end of this message there is a link for the verbose
output of --reorganize, using another option, --show_reorg_steps, where all
the steps performed are show with a comment just before the new state of
the structure.

          The biggest "savings" come from structs where there are alignment
constraints, where I really need to use DW_AT_decl{file,line} to take this
into account, keeping the constraints and using the space just before it to
move other members, keeping the original intent while using the holes to
reduce the struct size.

                            orig   new
struct name                 size  size savings
----------------------------------------------
net_device                  1664  1448 216
module                     16960 16848 112
hh_cache                     192    80 112
zone                        2752  2672  80
softnet_data                1792  1728  64
rcu_ctrlblk                  128    64  64
inet_hashinfo                384   320  64
entropy_store                128    64  64
task_struct                 1856  1800  56
rchan_buf                    256   208  48
hwif_s                      3392  3352  40
tty_struct                  1312  1280  32
mddev_s                      672   640  32
usbhid_device               6400  6376  24
request_queue               1496  1472  24
device                       680   656  24
usb_sg_request               104    88  16
usb_device                  1568  1552  16
thread_struct                688   672  16
super_block                  616   600  16
rtentry                      120   104  16
pcmcia_socket               1424  1408  16
mm_struct                    840   824  16
gendisk                      272   256  16
floppy_drive_params          128   112  16
files_struct                 704   688  16
dio                          856   840  16
cfq_queue                    160   144  16
block_device                 200   184  16
bitmap                       232   216  16
z_stream_s                    96    88   8
writeback_control             64    56   8
vt_spawn_console              24    16   8
vfsmount                     208   200   8
usb_host_interface            48    40   8
usb_host_endpoint             64    56   8
usb_host_config              552   544   8
usb_hcd                      312   304   8
usb_bus                      120   112   8
udp_iter_state                56    48   8
uart_port                    168   160   8
tuple_t                       40    32   8
tty_ldisc                    136   128   8
tty_driver                   504   496   8
tty_bufhead                  152   144   8
timex                        208   200   8
tcf_common                   120   112   8
taskstats                    264   256   8
sysfs_dirent                  80    72   8
swsusp_info                 4096  4088   8
superblock_security_struct    96    88   8
socket                        80    72   8
signal_struct                720   712   8
sighand_struct              2064  2056   8
shmem_sb_info                 56    48   8
sg_io_hdr                     88    80   8
serio                        888   880   8
semid_ds                      88    80   8
selinux_class_perm            48    40   8
scm_cookie                    40    32   8
rt6_info                     312   304   8
rq                          4728  4720   8
rif_cache                     56    48   8
region_t                      96    88   8
rchan                       2392  2384   8
qdisc_rate_table            1056  1048   8
psmouse_protocol              48    40   8
proto                      16640 16632   8
pnp_card                     824   816   8
platform_device              712   704   8
pid_namespace               2072  2064   8
pid_entry                     48    40   8
pglist_data                14272 14264   8
pcmcia_device                888   880   8
pci_dynids                    32    24   8
pci_dev                     1688  1680   8
pccard_mem_map                32    24   8
packet_sock                  680   672   8
old_serial_port               40    32   8
nmi_watchdog_ctlblk           32    24   8
nf_sockopt_ops                88    80   8
nfsctl_export               2088  2080   8
nf_bridge_info                72    64   8
nf_afinfo                     40    32   8
netlbl_lsm_secattr            40    32   8
netlbl_dom_map                64    56   8
neigh_table                  416   408   8
neighbour                    208   200   8
ncp_mount_data_v4             80    72   8
msghdr                        56    48   8
mousedev                     232   224   8
mon_reader_text              184   176   8
mon_reader_bin               152   144   8
mon_bus                       96    88   8
mnt_namespace                 64    56   8
ml_device                    856   848   8
mdk_rdev_s                   248   240   8
linux_binprm                 496   488   8
kprobe                       120   112   8
kparam_array                  48    40   8
kmem_list3                   104    96   8
kmem_cache                  2664  2656   8
kiocb                        240   232   8
ip_sf_list                    40    32   8
ip_mc_list                   136   128   8
ip6_flowlabel                 80    72   8
io_context                    56    48   8
input_dev                   2000  1992   8
inotify_device               128   120   8
inode_security_struct         72    64   8
inode                        560   552   8
inet_timewait_sock           120   112   8
inet_timewait_death_row      504   496   8
inet6_ifaddr                 168   160   8
inet6_dev                    432   424   8
in_device                    304   296   8
ifmcaddr6                    160   152   8
ide_pci_device_s              96    88   8
hid_field                    112   104   8
hid_device                  6656  6648   8
gen_pool                      32    24   8
fs_quota_stat                 80    72   8
font_desc                     40    32   8
flow_cache_entry             104    96   8
floppy_write_errors           40    32   8
floppy_fdc_state              40    32   8
flock                         32    24   8
file_lock                    176   168   8
file                         240   232   8
fib_rules_ops                128   120   8
fib_config                    96    88   8
fb_info                      832   824   8
ext2_inode_info              720   712   8
epitem                       144   136   8
elf_thread_status            872   864   8
dquot                        208   200   8
dma_device                   144   136   8
dev_state                    144   136   8
cpuset                       136   128   8
cipso_v4_map_cache_entry      56    48   8
cfq_data                     440   432   8
cdrom_generic_command         64    56   8
cache_detail                 224   216   8
blk_user_trace_setup          72    64   8
blk_trace                     80    72   8
bind_info_t                   96    88   8
av_inherit                    24    16   8
audit_watch                   72    64   8
audit_context               1152  1144   8
audit_aux_data_mq_sendrecv    56    48   8
as_io_context                104    96   8
amd_ide_chip                  24    16   8
agp_kern_info                 80    72   8
agp_bridge_data              176   168   8
acpi_pscope_state             56    48   8
acpi_prt_entry                56    48   8
acpi_processor_power         872   864   8
acpi_processor_performance   136   128   8
acpi_processor_cx            104    96   8
acpi_blacklist_item           56    48   8
rtentry32                     84    80   4
cistpl_config_t               28    24   4
cistpl_cftable_entry_t       372   368   4
cdrom_tocentry                12     8   4

Now lets look at how struct module becomes with the following command:

[acme@filo pahole]$ pahole --reorganize --executable examples/vmlinux-x86_64 module

struct module {
	enum module_state          state;                /*     0     4 */
	unsigned int               num_syms;             /*     4     4 */
	struct list_head           list;                 /*     8    16 */
	char                       name[56];             /*    24    56 */
	/* --- cacheline 1 boundary (64 bytes) was 16 bytes ago --- */
	struct module_kobject      mkobj;                /*    80   120 */
	/* --- cacheline 3 boundary (192 bytes) was 8 bytes ago --- */
	struct module_param_attrs * param_attrs;         /*   200     8 */
	struct module_attribute *  modinfo_attrs;        /*   208     8 */
	const char  *              version;              /*   216     8 */
	const char  *              srcversion;           /*   224     8 */
	struct kobject *           holders_dir;          /*   232     8 */
	const struct kernel_symbol  * syms;              /*   240     8 */
	const long unsigned int  * crcs;                 /*   248     8 */
	/* --- cacheline 4 boundary (256 bytes) --- */
	const struct kernel_symbol  * gpl_syms;          /*   256     8 */
	unsigned int               num_gpl_syms;         /*   264     4 */
	unsigned int               num_unused_syms;      /*   268     4 */
	const long unsigned int  * gpl_crcs;             /*   272     8 */
	const struct kernel_symbol  * unused_syms;       /*   280     8 */
	const long unsigned int  * unused_crcs;          /*   288     8 */
	const struct kernel_symbol  * unused_gpl_syms;   /*   296     8 */
	unsigned int               num_unused_gpl_syms;  /*   304     4 */
	unsigned int               num_gpl_future_syms;  /*   308     4 */
	const long unsigned int  * unused_gpl_crcs;      /*   312     8 */
	/* --- cacheline 5 boundary (320 bytes) --- */
	const struct kernel_symbol  * gpl_future_syms;   /*   320     8 */
	const long unsigned int  * gpl_future_crcs;      /*   328     8 */
	unsigned int               num_exentries;        /*   336     4 */
	unsigned int               num_bugs;             /*   340     4 */
	const struct exception_table_entry  * extable;   /*   344     8 */
	int                        (*init)(void);        /*   352     8 */
	void *                     module_init;          /*   360     8 */
	void *                     module_core;          /*   368     8 */
	long unsigned int          init_size;            /*   376     8 */
	/* --- cacheline 6 boundary (384 bytes) --- */
	long unsigned int          core_size;            /*   384     8 */
	long unsigned int          init_text_size;       /*   392     8 */
	long unsigned int          core_text_size;       /*   400     8 */
	void *                     unwind_info;          /*   408     8 */
	struct mod_arch_specific   arch;                 /*   416     0 */
	int                        unsafe;               /*   416     4 */
	unsigned int               taints;               /*   420     4 */
	struct list_head           bug_list;             /*   424    16 */
	struct bug_entry *         bug_table;            /*   440     8 */
	/* --- cacheline 7 boundary (448 bytes) --- */
	char *                     args;                 /*   448     8 */
	void *                     percpu;               /*   456     8 */
	struct module_sect_attrs * sect_attrs;           /*   464     8 */
	char *                     strtab;               /*   472     8 */
	struct module_ref          ref[255];             /*   480 16320 */
	/* --- cacheline 262 boundary (16768 bytes) was 32 bytes ago --- */
	struct list_head           modules_which_use_me; /* 16800    16 */
	struct task_struct *       waiter;               /* 16816     8 */
	void                       (*exit)(void);        /* 16824     8 */
	/* --- cacheline 263 boundary (16832 bytes) --- */
	Elf64_Sym *                symtab;               /* 16832     8 */
	long unsigned int          num_symtab;           /* 16840     8 */
}; /* size: 16848, cachelines: 264 */
   /* last cacheline: 16 bytes */
   /* saved 112 bytes and 1 cacheline! */

Using:

[acme@filo pahole]$ pahole --reorganize --show_reorg_steps --executable examples/vmlinux-x86_64 module

We get what was done in each step of the reorganization process:

/* Moving 'num_syms' from after 'syms' to after 'state' */
/* Moving 'num_unused_syms' from after 'unused_syms' to after 'num_gpl_syms' */
/* Moving 'num_gpl_future_syms' from after 'gpl_future_syms' to after 'num_unused_gpl_syms' */
/* Moving 'num_bugs' from after 'bug_table' to after 'num_exentries' */
/* Moving 'args' from after 'percpu' to after 'bug_table' */
/* Moving 'percpu' from after 'sect_attrs' to after 'args' */
/* Moving 'sect_attrs' from after 'strtab' to after 'percpu' */
/* Moving 'strtab' from after 'num_symtab' to after 'sect_attrs' */

The complete output is at:
http://oops.ghostprotocols.net:81/acme/dwarves/pahole--reorganize--show_reorg_steps--executable_examples_vmlinux-x86_64_module.txt

	The packages for FC6 (SRPM, i386 and x86_65 packages) are at:

http://oops.ghostprotocols.net:81/acme/dwarves/rpm/

	And the git repo is at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/pahole.git

	There are some people trying these utilities in userspace, where bigger
savings are possible.

Regards,

- Arnaldo

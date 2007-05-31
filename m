Return-Path: <linux-kernel-owner+w=401wt.eu-S1761234AbXEaK5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234AbXEaK5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 06:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbXEaK50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 06:57:26 -0400
Received: from ns.unixsol.org ([193.110.159.2]:56930 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638AbXEaK5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 06:57:23 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2007 06:57:22 EDT
Message-ID: <465EA87F.3010507@unixsol.org>
Date: Thu, 31 May 2007 13:50:39 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd. (http://unixsol.org)
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc7 - filp_close, Fixing recursive fault but reboot is needed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, today one of my servers locked up, and after powercycling it
I've found this in syslog. I'll upgrade the machine to latest stable
todayy but decided to report the bug anyway.

May 30 01:15:56 server kernel: invalid opcode: 0000 [#3]
May 30 01:15:56 server kernel: SMP
May 30 01:15:56 server kernel: Modules linked in:
May 30 01:15:56 server kernel: CPU:    1
May 30 01:15:56 server kernel: EIP:    0060:[<c0150bca>]    Not tainted VLI
May 30 01:15:56 server kernel: EFLAGS: 00210246   (2.6.21-rc7 #2)
May 30 01:15:56 server kernel: EIP is at __fput+0x5a/0x14d
May 30 01:15:56 server kernel: eax: f6da0c6c   ebx: 00000010   ecx: 00000000   edx: f6da0ccc
May 30 01:15:56 server kernel: esi: f6da8dbc   edi: f6da8dbc   ebp: f743e240   esp: df951f70
May 30 01:15:56 server kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
May 30 01:15:56 server kernel: Process httpd (pid: 8713, ti=df950000 task=dfac90b0 task.ti=df950000)
May 30 01:15:56 server kernel: Stack: f6da0ccc 00000001 f6da0c6c c31219c0 f743e240 f74b2b00 00000000 df950000
May 30 01:15:56 server kernel:        c014e94a 00000007 f74b2b00 00000013 f743e240 c014f8e4 00000013 00000000
May 30 01:15:56 server kernel:        0825322c c0103100 00000013 00000001 082531b0 00000000 0825322c bfa426c8
May 30 01:15:56 server kernel: Call Trace:
May 30 01:15:56 server kernel:  [<c014e94a>] filp_close+0x51/0x58
May 30 01:15:56 server kernel:  [<c014f8e4>] sys_close+0x6d/0xa9
May 30 01:15:56 server kernel:  [<c0103100>] syscall_call+0x7/0xb
May 30 01:15:56 server kernel:  =======================
May 30 01:15:56 server kernel: Code: 0f b7 56 6a 19 db 83 e3 08 83 c3 08 89 d9 81 e2 00 f0 00 00 81 c9 00 00 00 40 81 fa 00 40 00 00 8b 50 24 0f 44 d9 31 c9 89 14 24 <89> da e8 04 0a 02 00 31 c9 89 f0 89 da c7 44 24 04 00 00 00 00
May 30 01:15:56 server kernel: EIP: [<c0150bca>] __fput+0x5a/0x14d SS:ESP 0068:df951f70
May 30 01:15:56 server kernel: invalid opcode: 0000 [#4]
May 30 01:15:56 server kernel: SMP
May 30 01:15:56 server kernel: Modules linked in:
May 30 01:15:56 server kernel: CPU:    1
May 30 01:15:56 server kernel: EIP:    0060:[<c0150bca>]    Not tainted VLI
May 30 01:15:56 server kernel: EFLAGS: 00210246   (2.6.21-rc7 #2)
May 30 01:15:56 server kernel: EIP is at __fput+0x5a/0x14d
May 30 01:15:56 server kernel: eax: dece2b64   ebx: 00000010   ecx: 00000000   edx: dece2bc4
May 30 01:15:56 server kernel: esi: e21c5b8c   edi: e21c5b8c   ebp: e6e8d900   esp: df951dc8
May 30 01:15:56 server kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
May 30 01:15:56 server kernel: Process httpd (pid: 8713, ti=df950000 task=dfac90b0 task.ti=df950000)
May 30 01:15:56 server kernel: Stack: dece2bc4 00200246 dece2b64 c3121dc0 e6e8d900 f74b2b00 00000000 f74b2b08
May 30 01:15:56 server kernel:        c014e94a 00000000 f74b2b00 00000024 000003ff c01199d8 00000000 00000000
May 30 01:15:56 server kernel:        f74b2b00 dfac90b0 00000001 0000000b c011a9ce df951e40 c01121cd 00000000
May 30 01:15:56 server kernel: Call Trace:
May 30 01:15:56 server kernel:  [<c014e94a>] filp_close+0x51/0x58
May 30 01:15:56 server kernel:  [<c01199d8>] put_files_struct+0x5f/0xa7
May 30 01:15:56 server kernel:  [<c011a9ce>] do_exit+0x1dc/0x69a
May 30 01:15:56 server kernel:  [<c01121cd>] __wake_up+0x32/0x43
May 30 01:15:56 server kernel:  [<c0104520>] die+0x1f1/0x216
May 30 01:15:56 server kernel:  [<c010492d>] do_invalid_op+0x0/0xab
May 30 01:15:56 server kernel:  [<c01049cf>] do_invalid_op+0xa2/0xab
May 30 01:15:56 server kernel:  [<c0150bca>] __fput+0x5a/0x14d
May 30 01:15:56 server kernel:  [<c01579fd>] do_path_lookup+0x16e/0x189
May 30 01:15:56 server kernel:  [<c0156a01>] getname+0x59/0x8f
May 30 01:15:56 server kernel:  [<c01d9af9>] copy_to_user+0x2d/0x44
May 30 01:15:56 server kernel:  [<c0158b06>] fasync_helper+0x3c/0xae
May 30 01:15:56 server kernel:  [<c015bee7>] __posix_lock_file_conf+0x431/0x48e
May 30 01:15:56 server kernel:  [<c037b56c>] error_code+0x7c/0x84
May 30 01:15:56 server kernel:  [<c0150bca>] __fput+0x5a/0x14d
May 30 01:15:56 server kernel:  [<c014e94a>] filp_close+0x51/0x58
May 30 01:15:56 server kernel:  [<c014f8e4>] sys_close+0x6d/0xa9
May 30 01:15:56 server kernel:  [<c0103100>] syscall_call+0x7/0xb
May 30 01:15:56 server kernel:  =======================
May 30 01:15:56 server kernel: Code: 0f b7 56 6a 19 db 83 e3 08 83 c3 08 89 d9 81 e2 00 f0 00 00 81 c9 00 00 00 40 81 fa 00 40 00 00 8b 50 24 0f 44 d9 31 c9 89 14 24 <89> da e8 04 0a 02 00 31 c9 89 f0 89 da c7 44 24 04 00 00 00 00
May 30 01:15:56 server kernel: EIP: [<c0150bca>] __fput+0x5a/0x14d SS:ESP 0068:df951dc8
May 30 01:15:56 server kernel: Fixing recursive fault but reboot is needed!
May 30 01:15:56 server kernel: invalid opcode: 0000 [#5]
May 30 01:15:56 server kernel: SMP
May 30 01:15:56 server kernel: Modules linked in:
May 30 01:15:56 server kernel: CPU:    1
May 30 01:15:56 server kernel: EIP:    0060:[<c0150bca>]    Not tainted VLI
May 30 01:15:56 server kernel: EFLAGS: 00210246   (2.6.21-rc7 #2)
May 30 01:15:56 server kernel: EIP is at __fput+0x5a/0x14d
May 30 01:15:56 server kernel: eax: e6a79324   ebx: 00000008   ecx: 00000000   edx: e6a79384
May 30 01:15:56 server kernel: esi: ed1d5828   edi: ed1d5828   ebp: c32c4600   esp: df4f7f70
May 30 01:15:56 server kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
May 30 01:15:56 server kernel: Process httpd (pid: 10537, ti=df4f6000 task=f7f0c070 task.ti=df4f6000)
May 30 01:15:56 server kernel: Stack: e6a79384 00000000 e6a79324 c3121640 c32c4600 f750d3c0 00000000 df4f6000
May 30 01:15:56 server kernel:        c014e94a 00000000 f750d3c0 00000012 c32c4600 c014f8e4 00000012 08288210
May 30 01:15:56 server kernel:        b7bac460 c0103100 00000012 08288830 b7bb51ec 08288210 b7bac460 bfa47fb8
May 30 01:15:56 server kernel: Call Trace:
May 30 01:15:56 server kernel:  [<c014e94a>] filp_close+0x51/0x58
May 30 01:15:56 server kernel:  [<c014f8e4>] sys_close+0x6d/0xa9
May 30 01:15:56 server kernel:  [<c0103100>] syscall_call+0x7/0xb
May 30 01:15:56 server kernel:  =======================
May 30 01:15:56 server kernel: Code: 0f b7 56 6a 19 db 83 e3 08 83 c3 08 89 d9 81 e2 00 f0 00 00 81 c9 00 00 00 40 81 fa 00 40 00 00 8b 50 24 0f 44 d9 31 c9 89 14 24 <89> da e8 04 0a 02 00 31 c9 89 f0 89 da c7 44 24 04 00 00 00 00
May 30 01:15:56 server kernel: EIP: [<c0150bca>] __fput+0x5a/0x14d SS:ESP 0068:df4f7f70
May 30 01:15:56 server kernel: invalid opcode: 0000 [#6]
May 30 01:15:56 server kernel: SMP
May 30 01:15:56 server kernel: Modules linked in:
May 30 01:15:56 server kernel: CPU:    1
May 30 01:15:56 server kernel: EIP:    0060:[<c0150bca>]    Not tainted VLI
May 30 01:15:56 server kernel: EFLAGS: 00210246   (2.6.21-rc7 #2)
May 30 01:15:56 server kernel: EIP is at __fput+0x5a/0x14d
May 30 01:15:56 server kernel: eax: e6488744   ebx: 00000010   ecx: 00000000   edx: e64887a4
May 30 01:15:56 server kernel: esi: dff51b8c   edi: dff51b8c   ebp: f7aa8240   esp: df4f7dc8
May 30 01:15:56 server kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
May 30 01:15:56 server kernel: Process httpd (pid: 10537, ti=df4f6000 task=f7f0c070 task.ti=df4f6000)
May 30 01:15:56 server kernel: Stack: e64887a4 00200246 e6488744 c3121dc0 f7aa8240 f750d3c0 00000000 f750d3c8
May 30 01:15:56 server kernel:        c014e94a 00000000 f750d3c0 00000024 000001ff c01199d8 00000000 00000000
May 30 01:15:56 server kernel:        f750d3c0 f7f0c070 00000001 0000000b c011a9ce f7f0c070 df4f6000 00000002
May 30 01:15:56 server kernel: Call Trace:
May 30 01:15:56 server kernel:  [<c014e94a>] filp_close+0x51/0x58
May 30 01:15:56 server kernel:  [<c01199d8>] put_files_struct+0x5f/0xa7
May 30 01:15:56 server kernel:  [<c011a9ce>] do_exit+0x1dc/0x69a
May 30 01:15:56 server kernel:  [<c022b58f>] do_unblank_screen+0x1b/0x110
May 30 01:15:56 server kernel:  [<c0104520>] die+0x1f1/0x216
May 30 01:15:56 server kernel:  [<c010492d>] do_invalid_op+0x0/0xab
May 30 01:15:56 server kernel:  [<c01049cf>] do_invalid_op+0xa2/0xab
May 30 01:15:56 server kernel:  [<c0150bca>] __fput+0x5a/0x14d
May 30 01:15:56 server kernel:  [<c011fa9b>] lock_timer_base+0x15/0x2f
May 30 01:15:56 server kernel:  [<c011fba3>] __mod_timer+0x90/0x9a
May 30 01:15:56 server kernel:  [<c030268c>] sk_reset_timer+0xc/0x16
May 30 01:15:56 server kernel:  [<c03378be>] __tcp_push_pending_frames+0x6f4/0x7aa
May 30 01:15:56 server kernel:  [<c037b56c>] error_code+0x7c/0x84
May 30 01:15:56 server kernel:  [<c0150bca>] __fput+0x5a/0x14d
May 30 01:15:56 server kernel:  [<c014e94a>] filp_close+0x51/0x58
May 30 01:15:56 server kernel:  [<c014f8e4>] sys_close+0x6d/0xa9
May 30 01:15:56 server kernel:  [<c0103100>] syscall_call+0x7/0xb
May 30 01:15:56 server kernel:  =======================
May 30 01:15:56 server kernel: Code: 0f b7 56 6a 19 db 83 e3 08 83 c3 08 89 d9 81 e2 00 f0 00 00 81 c9 00 00 00 40 81 fa 00 40 00 00 8b 50 24 0f 44 d9 31 c9 89 14 24 <89> da e8 04 0a 02 00 31 c9 89 f0 89 da c7 44 24 04 00 00 00 00
May 30 01:15:56 server kernel: EIP: [<c0150bca>] __fput+0x5a/0x14d SS:ESP 0068:df4f7dc8
May 30 01:15:56 server kernel: Fixing recursive fault but reboot is needed!


config:

CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_SMP=y
CONFIG_X86_GENERICARCH=y
CONFIG_X86_CYCLONE_TIMER=y
CONFIG_MK8=y
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_PREEMPT_BKL=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_HIGHMEM4G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_MTRR=y
CONFIG_SECCOMP=y
CONFIG_HZ_250=y
CONFIG_HZ=250
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_PM=y
CONFIG_ACPI=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=2001
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_MSI=y
CONFIG_ISA_DMA_API=y
CONFIG_BINFMT_ELF=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_NETFILTER=y
CONFIG_BRIDGE_NETFILTER=y
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK_ENABLED=y
CONFIG_NF_CONNTRACK_SUPPORT=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_IPRANGE=y
CONFIG_IP_NF_MATCH_TOS=y
CONFIG_IP_NF_MATCH_RECENT=y
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_MATCH_OWNER=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_SAME=y
CONFIG_NF_NAT_SNMP_BASIC=y
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_TOS=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_IP_NF_TARGET_TTL=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_RAW=y
CONFIG_BRIDGE=y
CONFIG_VLAN_8021Q=y
CONFIG_LLC=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_PNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_SCSI=y
CONFIG_SCSI_NETLINK=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_CHR_DEV_SG=y
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=4000
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_SCSI_GDTH=y
CONFIG_ATA=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
CONFIG_SATA_NV=y
CONFIG_SATA_SIL=y
CONFIG_SATA_INTEL_COMBINED=y
CONFIG_SATA_ACPI=y
CONFIG_MD=y
CONFIG_BLK_DEV_DM=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_NETDEVICES=y
CONFIG_TUN=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_TULIP=y
CONFIG_TULIP=y
CONFIG_NET_PCI=y
CONFIG_FORCEDETH=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000_NAPI=y
CONFIG_TIGON3=y
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_RTC=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_HID=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_DNOTIFY=y
CONFIG_AUTOFS4_FS=y
CONFIG_GENERIC_ACL=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_RAMFS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_TCP=y
CONFIG_ROOT_NFS=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_UTF8=y
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_BITREVERSE=y
CONFIG_CRC32=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

dmesg (after the powercycle reboot):
Linux version 2.6.21-rc7 (root@adstopbg) (gcc version 4.1.2) #2 SMP Tue May 15 05:13:01 EEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f000 end: 000000000009f000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f000 size: 0000000000001000 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 00000000dede0000 end: 00000000deee0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000deee0000 size: 0000000000003000 end: 00000000deee3000 type: 4
copy_e820_map() start: 00000000deee3000 size: 000000000000d000 end: 00000000deef0000 type: 3
copy_e820_map() start: 00000000deef0000 size: 0000000000010000 end: 00000000def00000 type: 2
copy_e820_map() start: 00000000df000000 size: 0000000001000000 end: 00000000e0000000 type: 2
copy_e820_map() start: 00000000f0000000 size: 0000000004000000 end: 00000000f4000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000001400000 end: 0000000100000000 type: 2
copy_e820_map() start: 0000000100000000 size: 0000000020000000 end: 0000000120000000 type: 1
copy_e820_map() type is E820_RAM
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000deee0000 (usable)
 BIOS-e820: 00000000deee0000 - 00000000deee3000 (ACPI NVS)
 BIOS-e820: 00000000deee3000 - 00000000deef0000 (ACPI data)
 BIOS-e820: 00000000deef0000 - 00000000def00000 (reserved)
 BIOS-e820: 00000000df000000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
Warning only 4GB will be used.
Use a PAE enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f5670
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->  1048576
early_node_map[1] active PFN ranges
    0:        0 ->  1048576
On node 0 totalpages: 1048576
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 6400 pages used for memmap
  HighMem zone: 812800 pages, LIFO batch:31
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP 000F7130, 0014 (r0 Nvidia)
ACPI: RSDT DEEE3040, 0030 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP DEEE30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT DEEE3180, 8BDF (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS DEEE0000, 0040
ACPI: MCFG DEEEBE80, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC DEEEBDC0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:11 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:11 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at e1000000 (gap: e0000000:10000000)
Built 1 zonelists.  Total pages: 1040384
Kernel command line: auto BOOT_IMAGE=2.6.21-rc7 ro root=801
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2310.592 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3612812k/4194304k available (2553k kernel code, 38528k reserved, 1335k data, 280k init, 2734976k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe16000 - 0xfffff000   (1956 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc04d4000 - 0xc051a000   ( 280 kB)
      .data : 0xc037e4cf - 0xc04cc420   (1335 kB)
      .text : 0xc0100000 - 0xc037e4cf   (2553 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4625.57 BogoMIPS (lpj=9251141)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000011f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000011f
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 14k freed
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1546 Objects with 103 Devices 371 Methods 65 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 01
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4621.27 BogoMIPS (lpj=9242550)
CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000011f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000011f
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ stepping 01
Total of 2 processors activated (9246.84 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
Brought up 2 CPUs
migration_cost=4000
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
PCI: No mmconfig possible on device 00:18
Setting up standard PCI resources
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 20 to 5F [_GPE] 8 regs on int 0x9
evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 0 Runtime GPEs in this block
evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 0 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.................................................................................................................................................
Initialized 65/65 Regions 11/11 Fields 36/36 Buffers 33/41 Packages (1555 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:....
Executed 4 _INI methods requiring 2 _STA executions (examined 108 objects)
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
0000:00:06.0: cannot adjust BAR0 (not I/O)
0000:00:06.0: cannot adjust BAR1 (not I/O)
0000:00:06.0: cannot adjust BAR2 (not I/O)
0000:00:06.0: cannot adjust BAR3 (not I/O)
Boot video device is 0000:00:0d.0
PCI: Transparent bridge - 0000:00:04.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIGP] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 9 devices
SCSI subsystem initialized
libata version 2.20 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:01: ioport range 0x1000-0x107f has been reserved
pnp: 00:01: ioport range 0x1080-0x10ff has been reserved
pnp: 00:01: ioport range 0x1400-0x147f has been reserved
pnp: 00:01: ioport range 0x1480-0x14ff has been reserved
pnp: 00:01: ioport range 0x1800-0x187f has been reserved
pnp: 00:01: ioport range 0x1880-0x18ff has been reserved
pnp: 00:07: iomem range 0x0-0x0 could not be reserved
pnp: 00:08: iomem range 0xd1800-0xd3fff has been reserved
pnp: 00:08: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:08: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:08: iomem range 0xfc000-0xfffff could not be reserved
PCI: Bridge: 0000:00:04.0
Time: acpi_pm clocksource has been installed.
  IO window: b000-bfff
  MEM window: fdf00000-fdffffff
  PREFETCH window: fd800000-fd8fffff
PCI: Bridge: 0000:00:09.0
  IO window: a000-afff
  MEM window: fde00000-fdefffff
  PREFETCH window: fdd00000-fddfffff
PCI: Bridge: 0000:00:0b.0
  IO window: 8000-9fff
  MEM window: fdc00000-fdcfffff
  PREFETCH window: fdb00000-fdbfffff
PCI: Bridge: 0000:00:0c.0
  IO window: 7000-7fff
  MEM window: fda00000-fdafffff
  PREFETCH window: fd900000-fd9fffff
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
microcode: CPU0 not a capable Intel processor
microcode: CPU1 not a capable Intel processor
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Fan [FAN] (on)
ACPI: Thermal Zone [THRM] (49 C)
Real Time Clock Driver v1.12ac
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01043:8235 bound to 0000:00:07.0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
netconsole: not configured, aborting
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-MCP61: IDE controller at PCI slot 0000:00:06.0
NFORCE-MCP61: chipset revision 162
NFORCE-MCP61: not 100% native mode: will probe irqs later
NFORCE-MCP61: 0000:00:06.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GSA-H42N, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
GDT-HA: Storage RAID Controller Driver. Version: 3.05
GDT-HA: Found 0 PCI Storage RAID Controllers
3ware Storage Controller device driver for Linux v1.26.02.002.
sata_nv 0000:00:08.0: version 3.3
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata1: SATA max UDMA/133 cmd 0x000109f0 ctl 0x00010bf2 bmdma 0x0001d800 irq 17
ata2: SATA max UDMA/133 cmd 0x00010970 ctl 0x00010b72 bmdma 0x0001d808 irq 17
scsi0 : sata_nv
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3250620AS, 3.AAK, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi1 : sata_nv
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: ST3250620AS, 3.AAK, max UDMA/133
ata2.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.1[B] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:08.1 to 64
ata3: SATA max UDMA/133 cmd 0x000109e0 ctl 0x00010be2 bmdma 0x0001c400 irq 18
ata4: SATA max UDMA/133 cmd 0x00010960 ctl 0x00010b62 bmdma 0x0001c408 irq 18
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x000109e7
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
ATA: abnormal status 0x7F on port 0x00010967
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
oprofile: using NMI interrupt.
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
ClusterIP Version 0.8 loaded successfully
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Bridge firewalling registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI Shortcut mode
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sda1: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 5668891
ext3_orphan_cleanup: deleting unreferenced inode 5668890
ext3_orphan_cleanup: deleting unreferenced inode 5668889
ext3_orphan_cleanup: deleting unreferenced inode 5668888
ext3_orphan_cleanup: deleting unreferenced inode 5668887
ext3_orphan_cleanup: deleting unreferenced inode 5668883
ext3_orphan_cleanup: deleting unreferenced inode 5668882
ext3_orphan_cleanup: deleting unreferenced inode 5668878
ext3_orphan_cleanup: deleting unreferenced inode 5668876
ext3_orphan_cleanup: deleting unreferenced inode 5668875
ext3_orphan_cleanup: deleting unreferenced inode 5668874
ext3_orphan_cleanup: deleting unreferenced inode 5668871
EXT3-fs: sda1: 12 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 280k freed
Adding 4931944k swap on /dev/sda4.  Priority:-1 extents:1 across:4931944k
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/

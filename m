Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbYCNXCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbYCNXCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYCNXCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:02:15 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:45021 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbYCNXCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:02:14 -0400
To: Jeff Dike <jdike@addtoit.com>
Cc: clowncoder <vincent-perrier@club-internet.fr>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@timesys.com>
Subject: [2.6.24.x] UML select()/poll() oversleeping reproducibly (was Re: [uml-devel] g_timeout_add)
References: <47B34BA0.30006@club-internet.fr>
	<20080214003853.GA15952@c2.user-mode-linux.org>
	<47B4BDCD.4080605@club-internet.fr>
	<20080215160205.GA6082@c2.user-mode-linux.org>
	<47B5CE40.9000005@club-internet.fr>
	<20080215184650.GA8810@c2.user-mode-linux.org>
From: Nix <nix@esperi.org.uk>
Emacs: (setq software-quality (/ 1 number-of-authors))
Date: Fri, 14 Mar 2008 23:01:35 +0000
In-Reply-To: <20080215184650.GA8810@c2.user-mode-linux.org> (Jeff Dike's message of "Fri, 15 Feb 2008 13:46:50 -0500")
Message-ID: <87y78kx640.fsf_-_@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 1114; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Feb 2008, Jeff Dike told this:
> The smoking gun - a poll that should have timed out in .5 sec slept
> for 12.

FWIW this breaks all sorts of things, as one might expect: obviously it
breaks select() as well as poll(). For me the symptoms were a failure of
DHCP and spontaneous dropping off the net because lease renewal wasn't
happening in time (with 2.6.24.3, not with 2.6.24.2 that I can see).

The precise degree of oversleeping seems to depend on the clocksource in
use on the host (all hosts here are lightly loaded, running on 2.6.24.2
throughout these tests: select() does not wait for way too long
here). On a 1.4GHz Athlon IV using the tsc clocksource, I see consistent
oversleeps, but not enormous ones:

bash-3.2# ./select-sleep 1
Slept for 1 seconds.
bash-3.2# ./select-sleep 5
Slept for 7 seconds.
bash-3.2# ./select-sleep 5
Slept for 7 seconds.
bash-3.2# ./select-sleep 10
Slept for 13 seconds.
bash-3.2# ./select-sleep 30
Slept for 39 seconds.
bash-3.2# ./select-sleep 30
Slept for 39 seconds.
bash-3.2# ./select-sleep 60
Slept for 78 seconds.

On a 900MHz PIII using the pit clocksource (ick, why the hell isn't it
using tsc? oh, tsc unstable, how helpful) I see huge discrepancies,
still consistent, and interestingly all exactly four times as long as we
asked to sleep:

bash-3.2# ./select-sleep 1
Slept for 4 seconds.
bash-3.2# ./select-sleep 5
Slept for 20 seconds.
bash-3.2# ./select-sleep 5
Slept for 20 seconds.
bash-3.2# ./select-sleep 30
Slept for 120 seconds.
bash-3.2# ./select-sleep 30
Slept for 120 seconds.
bash-3.2# ./select-sleep 60
Slept for 240 seconds.


I'll do the -ttt UML tracing you requested next.


I'm testing using a little filesystem image containing a shell, glibc, and
this trivial obvious five-minute hack:

#define _POSIX_C_SOURCE 200112L

#include <stdio.h>
#include <stdlib.h>
#include <sys/select.h>
#include <sys/time.h>

int main (int argc, char *argv[])
 {
  long interval;
  struct timeval now;
  struct timeval timeout;
  struct timeval then;
  char *converr;
  fd_set foo;

  if (argc != 2)
   {
    fprintf (stderr, "Syntax: select-sleep INTERVAL\n");
    return 1;
   }

  interval = strtol (argv[1], &converr, 10);

  if (*converr != '\0')
   {
    fprintf (stderr, "Cannot convert %s to an integer\n", argv[1]);
    return 2;
   }

  gettimeofday (&then, NULL);
  timeout.tv_sec = interval;
  timeout.tv_usec = 0;

  FD_ZERO(&foo);
  select (0, NULL, NULL, NULL, &timeout);

  /* Watch me not care about not EINTR, I'm interested in *overlong* sleeps */

  gettimeofday (&now, NULL);

  fprintf (stderr, "Slept for %li seconds.\n", now.tv_sec - then.tv_sec);

  return 0;
 }

The UML's .config:

CONFIG_DEFCONFIG_LIST="arch/$ARCH/defconfig"
CONFIG_GENERIC_HARDIRQS=y
CONFIG_UML=y
CONFIG_MMU=y
CONFIG_NO_IOMEM=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_IRQ_RELEASE_METHOD=y
CONFIG_MPENTIUMIII=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_UML_X86=y
CONFIG_X86_32=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_HOST_VMSPLIT_3G=y
CONFIG_TOP_ADDR=0xC0000000
CONFIG_ARCH_HAS_SC_SIGNALS=y
CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_LD_SCRIPT_DYN=y
CONFIG_NET=y
CONFIG_BINFMT_ELF=y
CONFIG_MCONSOLE=y
CONFIG_NEST_LEVEL=0
CONFIG_KERNEL_STACK_ORDER=2
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=128
CONFIG_LOCALVERSION=""
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_LOG_BUF_SHIFT=14
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
CONFIG_RELAY=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_DEFAULT_DEADLINE=y
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_UBD=y
CONFIG_BLK_DEV_COW_COMMON=y
CONFIG_STDERR_CONSOLE=y
CONFIG_STDIO_CONSOLE=y
CONFIG_SSL=y
CONFIG_NULL_CHAN=y
CONFIG_PORT_CHAN=y
CONFIG_PTY_CHAN=y
CONFIG_TTY_CHAN=y
CONFIG_XTERM_CHAN=y
CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
CONFIG_CON_CHAN="tty"
CONFIG_SSL_CHAN="pty"
CONFIG_UNIX98_PTYS=y
CONFIG_UML_RANDOM=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_NETFILTER=y
CONFIG_NF_CONNTRACK_ENABLED=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_HELPER=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_IPRANGE=y
CONFIG_IP_NF_MATCH_TOS=y
CONFIG_IP_NF_MATCH_RECENT=y
CONFIG_IP_NF_MATCH_OWNER=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_TOS=y
CONFIG_IP_NF_TARGET_ECN=y
CONFIG_NET_SCHED=y
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_SCH_FIFO=y
CONFIG_FIB_RULES=y
CONFIG_UML_NET=y
CONFIG_UML_NET_TUNTAP=y
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_TUN=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
CONFIG_GENERIC_ACL=y
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_CONFIGFS_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_MSDOS_PARTITION=y
CONFIG_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_SHA1=y
CONFIG_BITREVERSE=y
CONFIG_CRC32=y
CONFIG_PLIST=y
CONFIG_HAS_DMA=y
CONFIG_INSTRUMENTATION=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_BUGVERBOSE=y

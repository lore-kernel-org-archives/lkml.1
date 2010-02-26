Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966233Ab0BZVhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:37:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966192Ab0BZVhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:37:51 -0500
Date: Fri, 26 Feb 2010 16:36:55 -0500
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <cover.1267214186.git.jbaron@redhat.com>
Subject: [PATCH 00/12] tracing: add compat syscall support v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Re-post to add infrastructure for compat syscall event tracing support. This
patch series also adds x86_64 arch specific support as an example consumer
of the new infrastructure.

The new interface consists of:

1) int is_compat_task(void);
  - most arches seem to have this already
2) unsigned long arch_compat_syscall_addr(int nr);
  - returns a pointer to the compat syscall entry corresponding to syscall 'nr'
3) int NR_syscalls_compat;
  - number of entries in the compat syscall table.

Thus, arches that set CONFIG_FTRACE_SYSCALLS and CONFIG_COMPAT are going to
need to implement the above interfaces in order to build. Thus, I'm 'cc arch
maintainers.

Naming. I've also introduced a couple of new syscall macros:

ARCH_COMPAT_SYSCALL_DEFINE#N()
COMPAT_SYSCALL_DEFINE#N()

These tack on, "arch_compat_sys" and "compat_sys" respectively, to the
beginning of the compat syscall names.

thanks,

-Jason

Jason Baron (11):
  x86: add NR_syscalls_compat, make ia32 syscall table visible
  x86: add arch_compat_syscall_addr()
  tracing: remove syscall bitmaps in preparation for compat support
  tracing: add tracing support for compat syscalls
  syscalls: add ARCH_COMPAT_SYSCALL_DEFINE()
  x86, compat: convert ia32 layer to use ARCH_COMPAT_SYSCALL_DEFINE#N()
  syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
  compat: convert to use COMPAT_SYSCALL_DEFINE#N()
  compat: convert fs compat to use COMPAT_SYSCALL_DEFINE#N() macros
  tags: recognize syscalls
  cleanup: remove arg from TRACE_SYS_ENTER_PROFILE_INIT() macro

Heiko Carstens (1):
  compat: have generic is_compat_task for !CONFIG_COMPAT

 arch/s390/include/asm/compat.h  |    7 --
 arch/s390/kernel/ptrace.c       |    2 +-
 arch/s390/kernel/setup.c        |    2 +-
 arch/s390/mm/mmap.c             |    2 +-
 arch/x86/ia32/ia32entry.S       |   53 ++++++++-------
 arch/x86/ia32/sys_ia32.c        |  106 ++++++++++++++--------------
 arch/x86/include/asm/compat.h   |    2 +
 arch/x86/kernel/ftrace.c        |   11 +++
 drivers/s390/block/dasd_eckd.c  |    2 +-
 drivers/s390/block/dasd_ioctl.c |    1 +
 drivers/s390/char/fs3270.c      |    1 +
 drivers/s390/char/vmcp.c        |    1 +
 drivers/s390/cio/chsc_sch.c     |    1 +
 drivers/s390/scsi/zfcp_cfdc.c   |    1 +
 fs/compat.c                     |  147 +++++++++++++++++++--------------------
 include/linux/compat.h          |    9 +++
 include/linux/syscalls.h        |   70 ++++++++++++-------
 include/trace/syscall.h         |    8 ++
 kernel/compat.c                 |  106 ++++++++++++++---------------
 kernel/trace/trace.h            |    2 +
 kernel/trace/trace_syscalls.c   |  101 +++++++++++++++++++--------
 scripts/tags.sh                 |    8 ++-
 22 files changed, 369 insertions(+), 274 deletions(-)


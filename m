Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab0CJDZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 22:25:49 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46044 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab0CJDZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 22:25:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V/gR/9DdASzfaxABkU0O5Uwdx51V64Gk9J5HVS1por6pPwF2JeqZgjXYhtSpXXMXwp
         BnKj9Mxg/drIWtpXv0ecpmec8xEJhRjt2B9TkrA9CXq0A28NA0hqLYYzuWc6fs8O8r44
         SiYIP8qKqUbxbgKv4bNGKPgTDt00zBlxU6siQ=
Date: Wed, 10 Mar 2010 04:25:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 00/12] tracing: add compat syscall support v2
Message-ID: <20100310032539.GA10074@nowhere>
References: <cover.1267214186.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1267214186.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 04:36:55PM -0500, Jason Baron wrote:
> Hi,
> 
> Re-post to add infrastructure for compat syscall event tracing support. This
> patch series also adds x86_64 arch specific support as an example consumer
> of the new infrastructure.
> 
> The new interface consists of:
> 
> 1) int is_compat_task(void);
>   - most arches seem to have this already
> 2) unsigned long arch_compat_syscall_addr(int nr);
>   - returns a pointer to the compat syscall entry corresponding to syscall 'nr'
> 3) int NR_syscalls_compat;
>   - number of entries in the compat syscall table.
> 
> Thus, arches that set CONFIG_FTRACE_SYSCALLS and CONFIG_COMPAT are going to
> need to implement the above interfaces in order to build. Thus, I'm 'cc arch
> maintainers.
> 
> Naming. I've also introduced a couple of new syscall macros:
> 
> ARCH_COMPAT_SYSCALL_DEFINE#N()
> COMPAT_SYSCALL_DEFINE#N()
> 
> These tack on, "arch_compat_sys" and "compat_sys" respectively, to the
> beginning of the compat syscall names.
> 
> thanks,
> 
> -Jason


I'll review this series soon.

Thanks a lot!



> 
> Jason Baron (11):
>   x86: add NR_syscalls_compat, make ia32 syscall table visible
>   x86: add arch_compat_syscall_addr()
>   tracing: remove syscall bitmaps in preparation for compat support
>   tracing: add tracing support for compat syscalls
>   syscalls: add ARCH_COMPAT_SYSCALL_DEFINE()
>   x86, compat: convert ia32 layer to use ARCH_COMPAT_SYSCALL_DEFINE#N()
>   syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
>   compat: convert to use COMPAT_SYSCALL_DEFINE#N()
>   compat: convert fs compat to use COMPAT_SYSCALL_DEFINE#N() macros
>   tags: recognize syscalls
>   cleanup: remove arg from TRACE_SYS_ENTER_PROFILE_INIT() macro
> 
> Heiko Carstens (1):
>   compat: have generic is_compat_task for !CONFIG_COMPAT
> 
>  arch/s390/include/asm/compat.h  |    7 --
>  arch/s390/kernel/ptrace.c       |    2 +-
>  arch/s390/kernel/setup.c        |    2 +-
>  arch/s390/mm/mmap.c             |    2 +-
>  arch/x86/ia32/ia32entry.S       |   53 ++++++++-------
>  arch/x86/ia32/sys_ia32.c        |  106 ++++++++++++++--------------
>  arch/x86/include/asm/compat.h   |    2 +
>  arch/x86/kernel/ftrace.c        |   11 +++
>  drivers/s390/block/dasd_eckd.c  |    2 +-
>  drivers/s390/block/dasd_ioctl.c |    1 +
>  drivers/s390/char/fs3270.c      |    1 +
>  drivers/s390/char/vmcp.c        |    1 +
>  drivers/s390/cio/chsc_sch.c     |    1 +
>  drivers/s390/scsi/zfcp_cfdc.c   |    1 +
>  fs/compat.c                     |  147 +++++++++++++++++++--------------------
>  include/linux/compat.h          |    9 +++
>  include/linux/syscalls.h        |   70 ++++++++++++-------
>  include/trace/syscall.h         |    8 ++
>  kernel/compat.c                 |  106 ++++++++++++++---------------
>  kernel/trace/trace.h            |    2 +
>  kernel/trace/trace_syscalls.c   |  101 +++++++++++++++++++--------
>  scripts/tags.sh                 |    8 ++-
>  22 files changed, 369 insertions(+), 274 deletions(-)
> 


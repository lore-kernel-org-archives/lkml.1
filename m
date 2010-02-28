Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031743Ab0B1KJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 05:09:10 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:55172 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031648Ab0B1KJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:09:06 -0500
Date: Sun, 28 Feb 2010 11:09:02 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 08/12] syscalls: add new COMPAT_SYSCALL_DEFINE#N() macro
Message-ID: <20100228100902.GA2330@osiris.boeblingen.de.ibm.com>
References: <cover.1267214186.git.jbaron@redhat.com>
 <4aefea222db757a76ca70f20b6165e5084b99e8e.1267214186.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aefea222db757a76ca70f20b6165e5084b99e8e.1267214186.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 04:37:30PM -0500, Jason Baron wrote:
> Add COMPAT_SYSCALL_DEFINE#N() macro define common compat syscalls that
> are not arch specific. Prepends "compat_sys_" to the syscall name to identify
> it.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/linux/syscalls.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index cd7b959..241a19c 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -228,6 +228,13 @@ struct perf_event_attr;
>  #define ARCH_COMPAT_SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, arch_compat_sys_##name, __VA_ARGS__)
>  #define ARCH_COMPAT_SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, arch_compat_sys_##name, __VA_ARGS__)
> 
> +#define COMPAT_SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, compat_sys_##name, __VA_ARGS__)
> +#define COMPAT_SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, compat_sys_##name, __VA_ARGS__)
> +#define COMPAT_SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, compat_sys_##name, __VA_ARGS__)
> +#define COMPAT_SYSCALL_DEFINE4(name, ...) SYSCALL_DEFINEx(4, compat_sys_##name, __VA_ARGS__)
> +#define COMPAT_SYSCALL_DEFINE5(name, ...) SYSCALL_DEFINEx(5, compat_sys_##name, __VA_ARGS__)
> +#define COMPAT_SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, compat_sys_##name, __VA_ARGS__)
> +

For architectures which select CONFIG_HAVE_SYSCALL_WRAPPERS this adds
unnecessary sign extension code to each compat syscall.
On the other hand we could get rid partly of the arch specific sign extension
code but that would need some other changes before as well.
For example this one:

asmlinkage long compat_sys_gettimeofday(struct compat_timeval __user *tv,
                struct timezone __user *tz)

should be converted to a function which takes two compat_uptr_t's and let
the syscall code itself do the proper pointer conversion (compat_ptr()).

Besides that the syscall alias names for these compat calls do look a
bit strange:

000000000008b57c T SyScompat_sys_adjtimex
000000000008b57c T compat_sys_adjtimex

That needs to be fixed as well.
Or simply add a 1:1 wrapper independent of CONFIG_HAVE_SYSCALL_WRAPPERS.

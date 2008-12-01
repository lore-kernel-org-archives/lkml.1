Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYLAUwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYLAUwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYLAUv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:51:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbYLAUvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:51:55 -0500
Date: Mon, 1 Dec 2008 12:51:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: penberg@cs.helsinki.fi, rjw@sisk.pl, miles.lane@gmail.com,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       htejun@gmail.com, vegard.nossum@gmail.com, rostedt@goodmis.org,
       arjan@infradead.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
 at ffff8800be8b0019
Message-Id: <20081201125103.db4c026f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811271643250.9618@blonde.site>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
	<200811270026.37941.rjw@sisk.pl>
	<84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
	<Pine.LNX.4.64.0811271349040.21910@blonde.site>
	<84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
	<Pine.LNX.4.64.0811271643250.9618@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008 17:34:27 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> [PATCH] KSYM_SYMBOL_LEN fixes
> 
> Miles Lane tailing /sys files hit a BUG which Pekka Enberg has tracked to
> my 966c8c12dc9e77f931e2281ba25d2f0244b06949 sprint_symbol(): use less stack
> exposing a bug in slub's list_locations() - kallsyms_lookup() writes a 0
> to namebuf[KSYM_NAME_LEN-1], but that was beyond the end of page provided.
> 
> The 100 slop which list_locations() allows at end of page looks roughly
> enough for all the other stuff it might print after the symbol before
> it checks again: break out KSYM_SYMBOL_LEN earlier than before.
> 
> Latencytop and ftrace and are using KSYM_NAME_LEN buffers where they need
> KSYM_SYMBOL_LEN buffers, and vmallocinfo a 2*KSYM_NAME_LEN buffer where
> it wants a KSYM_SYMBOL_LEN buffer: fix those before anyone copies them.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> 
>  fs/proc/base.c         |    2 +-
>  include/linux/ftrace.h |    2 +-
>  kernel/latencytop.c    |    2 +-
>  mm/slub.c              |    2 +-
>  mm/vmalloc.c           |    2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> --- 2.6.28-rc6/fs/proc/base.c	2008-10-24 09:28:19.000000000 +0100
> +++ linux/fs/proc/base.c	2008-11-27 16:39:26.000000000 +0000
> @@ -371,7 +371,7 @@ static int lstats_show_proc(struct seq_f
>  				task->latency_record[i].time,
>  				task->latency_record[i].max);
>  			for (q = 0; q < LT_BACKTRACEDEPTH; q++) {
> -				char sym[KSYM_NAME_LEN];
> +				char sym[KSYM_SYMBOL_LEN];
>  				char *c;
>  				if (!task->latency_record[i].backtrace[q])
>  					break;
> --- 2.6.28-rc6/include/linux/ftrace.h	2008-11-02 23:17:56.000000000 +0000
> +++ linux/include/linux/ftrace.h	2008-11-27 16:39:26.000000000 +0000
> @@ -231,7 +231,7 @@ ftrace_init_module(unsigned long *start,
>  
>  struct boot_trace {
>  	pid_t			caller;
> -	char			func[KSYM_NAME_LEN];
> +	char			func[KSYM_SYMBOL_LEN];
>  	int			result;
>  	unsigned long long	duration;		/* usecs */
>  	ktime_t			calltime;

The ftrace.h change causes this:

In file included from arch/x86/kernel/machine_kexec_64.c:14:
include/linux/ftrace.h:234: error: 'MODULE_NAME_LEN' undeclared here (not in a function)

The fault really lies with include/linux/kallsyms.h, I think:

#define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
                         2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)

but it doesn't include module.h, so it requires that users of this
header perform the include.

But I'm a bit reluctant to include module.h from kallsyms.h because
kallsyms.h is a simple low-level thing:

#include <linux/errno.h>
#include <linux/kernel.h>
#include <linux/stddef.h>

and it wouldn't surprise me if module.h was including kallsyms.h by
some means.

So for now I'll try including module.h from ftrace.c.  It would be nice
to fix the kallsyms.h dependency..


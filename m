Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbZCXJVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbZCXJVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZCXJUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:20:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbZCXJUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:20:51 -0400
Date: Tue, 24 Mar 2009 10:20:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, fengguang.wu@intel.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter tools: remove glib dependency and fix
	bugs in kerneltop.c
Message-ID: <20090324092040.GC6605@elte.hu>
References: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18888.29986.340328.540512@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> The glib dependency in kerneltop.c is only for a little bit of list
> manipulation, and I find it inconvenient.  This adds a 'next' field to
> struct source_line, which lets us link them together into a list.  The
> code to do the linking ourselves turns out to be no longer or more
> difficult than using glib.
> 
> This also fixes a few other problems:
> 
> - We need to #include <limits.h> to get PATH_MAX on powerpc.
> 
> - We need to #include <linux/types.h> rather than have our own
>   definitions of __u64 and __s64; on powerpc the installed headers
>   define them to be unsigned long and long respectively, and if we
>   have our own, different definition here that causes a compile error.
> 
> - This takes out the x86 setting of errno from -ret in
>   sys_perf_counter_open.  My experiments on x86 indicate that the
>   glibc syscall() does this for us already.
> 
> - We had two CPU migration counters in the default set, which seems
>   unnecessary; I changed one of them to a context switch counter.
> 
> - In perfstat mode we were printing CPU cycles and instructions as
>   milliseconds, and the cpu clock and task clock counters as events.
>   This fixes that.
> 
> - In perfstat mode we were still printing a blank line after the first
>   counter, which was a holdover from when a task clock counter was
>   automatically included as the first counter.  This removes the blank
>   line.
> 
> - On a test machine here, parse_symbols() and parse_vmlinux() were
>   taking long enough (almost 0.5 seconds) for the mmap buffer to
>   overflow before we got to the first mmap_read() call, so this moves
>   them before we open all the counters.
> 
> - The error message if sys_perf_counter_open fails needs to use errno,
>   not -fd[i][counter].
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> 
> ---
>  Documentation/perf_counter/Makefile    |    2 +-
>  Documentation/perf_counter/kerneltop.c |  112 +++++++++++++-------------------
>  2 files changed, 46 insertions(+), 68 deletions(-)

Very nice, thanks Paul!

	Ingo

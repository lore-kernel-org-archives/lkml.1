Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZJZItN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZJZItN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbZJZItM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:49:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbZJZItL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:49:11 -0400
Date: Mon, 26 Oct 2009 09:48:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [alpha] Add minimal support for software performance
	events.
Message-ID: <20091026084854.GA26990@elte.hu>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Cree <mcree@orcon.net.nz> wrote:

> In the kernel the patch enables configuration of the perf event 
> option, adds the perf_event_open syscall, and includes a minimal 
> architecture specific asm/perf_event.h header file.
> 
> For the perf tool the patch implements an Alpha specific section
> in the perf.h header file and adjusts options used in the
> Makefile to allow compilation on Alpha.  The -Wcast-align gives
> a "cast increases required alignment of target type" warning for
> the list_for_each_entry() macro. The -fstack-protector-all
> option generates a "not supported for this target" warning which
> with -Werror causes the compiler to abort.
> 
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
>  arch/alpha/Kconfig                  |    1 +
>  arch/alpha/include/asm/perf_event.h |    9 +++++++++
>  arch/alpha/include/asm/unistd.h     |    3 ++-
>  arch/alpha/kernel/systbls.S         |    1 +
>  tools/perf/Makefile                 |    5 ++---
>  tools/perf/perf.h                   |    6 ++++++
>  6 files changed, 21 insertions(+), 4 deletions(-)
>  create mode 100644 arch/alpha/include/asm/perf_event.h

Nice!

I've picked up the perf.h bit in an independent commit. Is there a tree 
for Alpha bits?

This portion:

> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -201,7 +200,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
>  
> -CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
> +CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
>  LDFLAGS = -lpthread -lrt -lelf -lm
>  ALL_CFLAGS = $(CFLAGS)
>  ALL_LDFLAGS = $(LDFLAGS)

Should be done not by removing the stack-protector build unconditionally 
- but by auto-testing whether stackprotector is supported by GCC and 
using it if yes.

Examples can be found n arch/x86/Makefile's use of 
scripts/gcc-*-has-stack-protector.sh.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZBCFUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZBCFUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZBCFT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:19:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZBCFT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:19:56 -0500
Date: Tue, 3 Feb 2009 06:19:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/3] trace: disable branch tracer on alpha
Message-ID: <20090203051938.GB28361@elte.hu>
References: <20090203023830.440860800@goodmis.org> <20090203024358.093748679@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203024358.093748679@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: fix alpha compiler builds
> 
> The profile all branches tracer causes errors on alpha, due to
> the use of extern inlines. This patch disables it on alpha.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index dde1d46..2780665 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -183,9 +183,11 @@ config TRACE_BRANCH_PROFILING
>  
>  	  Say N if unsure.
>  
> +# PROFILE_ALL_BRANCHES fails on alph due to extern inlines.
>  config PROFILE_ALL_BRANCHES
>  	bool "Profile all if conditionals"
>  	depends on TRACE_BRANCH_PROFILING
> +	depends on !ALPHA
>  	help
>  	  This tracer profiles all branch conditions. Every if ()
>  	  taken in the kernel is recorded whether it hit or miss.

Alpha has 108 extern inlines in about a dozen include files:

earth4:~/tip> git grep 'extern inline' arch/alpha/include/asm/ | cut -d: -f1 
| uniq -c | sort -n
      1 arch/alpha/include/asm/core_apecs.h
      1 arch/alpha/include/asm/core_cia.h
      1 arch/alpha/include/asm/core_irongate.h
      1 arch/alpha/include/asm/core_lca.h
      1 arch/alpha/include/asm/core_marvel.h
      1 arch/alpha/include/asm/core_polaris.h
      1 arch/alpha/include/asm/core_titan.h
      1 arch/alpha/include/asm/core_tsunami.h
      1 arch/alpha/include/asm/core_wildfire.h
      1 arch/alpha/include/asm/jensen.h
      1 arch/alpha/include/asm/pci.h
      1 arch/alpha/include/asm/tlbflush.h
      2 arch/alpha/include/asm/core_mcpcia.h
      3 arch/alpha/include/asm/mmu_context.h
      3 arch/alpha/include/asm/processor.h
      5 arch/alpha/include/asm/system.h
      7 arch/alpha/include/asm/core_t2.h
      9 arch/alpha/include/asm/uaccess.h
     33 arch/alpha/include/asm/pgtable.h
     34 arch/alpha/include/asm/io.h

Wouldnt the right fix be to:

  sed -i 's/extern inline/static inline/' arch/alpha/include/asm/*.h
  git add arch/alpha/include/asm/*.h
  git commit -m "alpha: change extern inlines to static inlines"

?

	Ingo


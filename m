Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab0CCVgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:36:23 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57589 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753284Ab0CCVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:36:16 -0500
Date: Wed, 3 Mar 2010 16:36:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip 2/2] x86: Issue at least one memory barrier in
	stop_machine_text_poke().
Message-ID: <20100303213614.GA29880@Krystal>
References: <20100303212656.25645.48466.stgit@localhost6.localdomain6> <20100303212703.25645.50986.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303212703.25645.50986.stgit@localhost6.localdomain6>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:33:02 up 40 days, 10 min,  6 users,  load average: 1.29, 0.60,
	0.64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Fix stop_machine_text_poke() to issue smp_mb() before exiting waiting
> loop. Also, use ACCESS_ONCE() to check a flag according to Mathieu's
> comment.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jason Baron <jbaron@redhat.com>
> ---
> 
>  arch/x86/kernel/alternative.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 635e4f4..3236a11 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -596,9 +596,9 @@ static int __kprobes stop_machine_text_poke(void *data)
>  		smp_wmb();	/* Make sure other cpus see that this has run */
>  		wrote_text = 1;
>  	} else {
> -		while (!wrote_text)
> -			smp_rmb();
> -		sync_core();
> +		while (!ACCESS_ONCE(wrote_text))

Well, cpu_relax() has a "memory" clobber, so the access once is not required to
ensure the variable is re-read. And, sorry to contradict my previous statement
somewhat, but given that we don't care if the compiler fetches wrote_text in
chunks or not, ACCESS_ONCE() is not required here. So rather than leaving people
wondering why we put an ACCESS_ONCE() here, it's probably better to leave it
out.

Thanks,

Mathieu

> +			cpu_relax();
> +		smp_mb();	/* Load wrote_text before following execution */
>  	}
>  
>  	flush_icache_range((unsigned long)tpp->addr,
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZKPVXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZKPVXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZKPVXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:23:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37609 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbZKPVXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:23:08 -0500
Date: Mon, 16 Nov 2009 22:22:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86: Limit the number of processor bootup messages
Message-ID: <20091116212216.GA2221@elte.hu>
References: <20091116210718.412792000@alcatraz.americas.sgi.com>
 <20091116210726.585624000@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116210726.585624000@alcatraz.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> +	if (cpu == 0)
> +		printk(KERN_INFO "CPU0: Thermal monitoring enabled (%s)\n",
> +		       tm2 ? "TM2" : "TM1");

Hm, 'cpu==0 means boot cpu' assumptions are not particularly clean.

> +#ifdef CONFIG_NUMA
> +	if (system_state == SYSTEM_BOOTING) {
> +		static int current_node = -1;
> +		int node = cpu_to_node(cpu);
> +
> +		if (node != current_node) {
> +			if (current_node > (-1))
> +				pr_cont(" Ok.\n");
> +			current_node = node;
> +			pr_info("Booting Node %3d, Processors ", node);
> +		}
> +		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok.\n" : "");
> +	} else
> +#endif
> +		pr_info("Booting Processor %d APIC 0x%x\n", cpu, apicid);

preprocessor directives cutting into if/else branches in an assymetric 
way is being frowned upon. I'd also suggest to put this into a helper 
inline.

Is the SYSTEM_BOOTING check there to not re-print this on CPU hotplug?

	Ingo

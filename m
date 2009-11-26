Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbZKZJQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbZKZJQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760184AbZKZJQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:16:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48503 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760147AbZKZJQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:16:33 -0500
Date: Thu, 26 Nov 2009 10:15:59 +0100
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
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
Message-ID: <20091126091559.GG1389@elte.hu>
References: <20091118002211.709343000@alcatraz.americas.sgi.com>
 <20091118002219.163869000@alcatraz.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118002219.163869000@alcatraz.americas.sgi.com>
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

> +++ linux/arch/x86/kernel/smpboot.c
> @@ -671,6 +671,27 @@
>  	complete(&c_idle->done);
>  }
>  
> +/* reduce the number of lines printed when booting a large cpu count system */
> +static void __cpuinit announce_cpu(int cpu, int apicid)
> +{
> +	if (system_state == SYSTEM_BOOTING) {
> +#ifdef CONFIG_NUMA
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
> +		return;
> +#endif
> +	}

That's pretty ugly. (the #ifdef is at the wrong nesting level to begin 
with)

Also, cannot we print out the same thing with no #ifdef variances? Users 
of UP systems wont be confused by a 'Node 0, CPU 0' message and in 5 
years most x86 people will be running NUMA systems.

	Ingo

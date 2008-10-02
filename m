Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYJBTmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYJBTmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYJBTmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:42:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51489 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbYJBTmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:42:36 -0400
Date: Thu, 2 Oct 2008 21:42:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [patch x86/core] x86: allow number of additional hotplug CPUs
	to be set at compile time, V2
Message-ID: <20081002194215.GA8078@elte.hu>
References: <20081001191945.4182d0be@redhat.com> <20081002081231.GC17695@elte.hu> <20081002153007.2e031232@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002153007.2e031232@redhat.com>
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


* Chuck Ebbert <cebbert@redhat.com> wrote:

> From: Chuck Ebbert <cebbert@redhat.com>
> 
> x86: allow number of additional hotplug CPUs to be set at compile time, V2
> 
> The default number of additional CPU IDs for hotplugging is determined 
> by asking ACPI or mptables how many "disabled" CPUs there are in the 
> system, but many systems get this wrong so that e.g. a uniprocessor 
> machine gets an extra CPU allocated and never switches to single CPU 
> mode.
> 
> And sometimes CPU hotplugging is enabled only for suspend/hibernate 
> anyway, so the additional CPU IDs are not wanted. Allow the number to 
> be set to zero at compile time.
> 
> Also, force the number of extra CPUs to zero if hotplugging is disabled
> which allows removing some conditional code.
> 
> Tested on uniprocessor x86_64 that ACPI claims has a disabled processor,
> with CPU hotplugging configured.
> 
> ("After" has the number of additional CPUs set to 0)
> Before: NR_CPUS: 512, nr_cpu_ids: 2, nr_node_ids 1
> After: NR_CPUS: 512, nr_cpu_ids: 1, nr_node_ids 1
> 
> [Changed the name of the option and the prompt according to Ingo's
>  suggestion.]

> +config HOTPLUG_RESTRICT_TO_BOOTUP_CPUS
> +	def_bool n
> +	prompt "Restrict CPU hotplugging to processors found during boot" if HOTPLUG_CPU

ok, that description and naming makes the purpose much clearer, and it's 
default-disabled as well.

Applied to tip/x86/core, thanks Chuck!

note that this chunk:

> @@ -1282,16 +1282,13 @@ __init void prefill_possible_map(void)
>  	if (!num_processors)
>  		num_processors = 1;
>  
> -#ifdef CONFIG_HOTPLUG_CPU
>  	if (additional_cpus == -1) {
>  		if (disabled_cpus > 0)
>  			additional_cpus = disabled_cpus;
>  		else
>  			additional_cpus = 0;
>  	}
> -#else
> -	additional_cpus = 0;
> -#endif
> +

was already in -tip, by virtue of:

| commit 2bd455dbfebfd632a8dcf1d3d1612737986fde0a
| Author: Li Zefan <lizf@cn.fujitsu.com>
| Date:   Mon Aug 4 11:26:38 2008 +0800
|
|     x86: remove nesting CONFIG_HOTPLUG_CPU

please double-check latest tip/master nevertheless:

  http://people.redhat.com/mingo/tip.git/README

to make sure i merged your patch correctly and that it plays well with 
other changes.

Thanks,

	Ingo

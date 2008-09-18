Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYIRKYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYIRKYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 06:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYIRKYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 06:24:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbYIRKYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 06:24:44 -0400
Date: Thu, 18 Sep 2008 12:23:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
Message-ID: <20080918102353.GD20967@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com> <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu> <1221502142.19012.35.camel@bobble.smo.corp.google.com> <20080916084143.GC17287@elte.hu> <1221678187.13420.17.camel@bobble.smo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221678187.13420.17.camel@bobble.smo.corp.google.com>
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


* Frank Mayhar <fmayhar@google.com> wrote:

> I finally finished this.  Yeah, there's a visible size difference, 
> although it's small:
> 
> bobble ~/build/linux-2.6>size vmlinux
>    text    data     bss     dec     hex filename
> 6417840  824160  578416 7820416  775480 vmlinux
> 
> bobble ~/build/up-simplify-tree>size vmlinux
>    text    data     bss     dec     hex filename
> 6417999  824160  578416 7820575  77551f vmlinux
> 
> For a difference of 159 bytes.  Not big, but nonzero.  The delta patch 
> (relative to a tree containing all suggested changes _except_ this 
> simplification) follows:

i'd not worry about those 160 bytes - getting this stuff to work fine is 
far more important. Details around threading seem to be one of the 
slowest converging technological details of Linux.

a silly question:

> +#else /* CONFIG_SMP */
> +
> +/*
> + * Allocate the thread_group_cputime structure appropriately for UP kernels
> + * and fill in the current values of the fields.  Called from copy_signal()
> + * via thread_group_cputime_clone_thread() when adding a second or subsequent
> + * thread to a thread group.  Assumes interrupts are enabled when called.
> + */
> +int thread_group_cputime_alloc(struct task_struct *tsk)
> +{

why is there _any_ assymetry needed between UP and SMP? These days we 
just write straight code for SMP, and UP is just a single-CPU 
special-case of it. _Sometimes_ if it's really worth it we do some UP 
special cases but it's the exception, not the rule.

	Ingo

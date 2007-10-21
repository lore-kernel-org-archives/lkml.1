Return-Path: <linux-kernel-owner+w=401wt.eu-S1751478AbXJUHnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbXJUHnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbXJUHnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:43:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXJUHnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:43:16 -0400
Date: Sun, 21 Oct 2007 09:43:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Milton D. Miller II" <miltonm@realtime.net>
Cc: Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix sched_domain sysctl registration again
Message-ID: <20071021074301.GA14368@elte.hu>
References: <200710201941.l9KJfIGL008482@sullivan.realtime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710201941.l9KJfIGL008482@sullivan.realtime.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Milton D. Miller II <miltonm@realtime.net> wrote:

> commit 029190c515f15f512ac85de8fc686d4dbd0ae731 (cpuset 
> sched_load_balance flag) was not tested SCHED_DEBUG enabled as 
> committed as it dereferences NULL when used and it reordered the 
> sysctl registration to cause it to never show any domains or their 
> tunables.
> 
> Fixes:
> 
> 1) restore arch_init_sched_domains ordering
> 	we can't walk the domains before we build them
> 
> 	presently we register cpus with empty directories (no domain
> 	directories or files).
> 
> 2) make unregister_sched_domain_sysctl do nothing when already unregistered
> 	detach_destroy_domains is now called one set of cpus at a time
> 	unregister_syctl dereferences NULL if called with a null.
> 
> 	While the the function would always dereference null if called
> 	twice, in the previous code it was always called once and then
> 	was followed a register.  So only the hidden bug of the
> 	sysctl_root_table not being allocated followed by an attempt to
> 	free it would have shown the error.
> 
> 3) always call unregister and register in partition_sched_domains
> 	The code is "smart" about unregistering only needed domains.
> 	Since we aren't guaranteed any calls to unregister, always 
> 	unregister.   Without calling register on the way out we
> 	will not have a table or any sysctl tree.
> 
> 4) warn if register is called without unregistering
> 	The previous table memory is lost, leaving pointers to the
> 	later freed memory in sysctl and leaking the memory of the
> 	tables.

thanks, applied.

	Ingo

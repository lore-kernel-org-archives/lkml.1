Return-Path: <linux-kernel-owner+w=401wt.eu-S937694AbZDJMVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937694AbZDJMVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935153AbZDJMPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:15:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934969AbZDJMPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:15:38 -0400
Date: Fri, 10 Apr 2009 14:15:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>, Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, LTP <ltp-list@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] lockdep: choose to continue lock debugging despite
	taint
Message-ID: <20090410121515.GP21506@elte.hu>
References: <1239312460-13396-1-git-send-email-fweisbec@gmail.com> <1239312460-13396-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239312460-13396-2-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Lockdep is disabled after any kernel taints. This might be 
> convenient to ignore bad locking issues which sources come from 
> outside the kernel tree. Nevertheless, it might be a frustrating 
> experience for the staging developers or anyone who might develop 
> a kernel that happens to be tainted.

Good point. Not having lockdep coverage for drivers/staging/ just 
prolongs their transition - not good.

But instead of this:

>  void add_taint(unsigned flag)
>  {
> +#ifndef CONFIG_LOCKDEP_IGNORE_TAINT
>  	/*
>  	 * Can't trust the integrity of the kernel anymore.
>  	 * We don't call directly debug_locks_off() because the issue
> @@ -220,6 +221,7 @@ void add_taint(unsigned flag)
>  	 */
>  	if (xchg(&debug_locks, 0))
>  		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
> +#endif

I'd suggest to not do the debug_locks_off() call if TAINT_CRAP. I.e. 
something like:

	if (!(flag & TAINT_CRAP) && debug_locks_off())
		printk(...);

will do the trick.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYB0H0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYB0H0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYB0H0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:26:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYB0H0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:26:41 -0500
Date: Wed, 27 Feb 2008 08:26:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Tomasz Grobelny <tomasz@grobelny.oswiecenia.net>
Subject: Re: [PATCH] x86 tls prevent_tail_call
Message-ID: <20080227072617.GB4638@elte.hu>
References: <20080226210018.A031B26F9A4@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226210018.A031B26F9A4@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Roland McGrath <roland@redhat.com> wrote:

> The x86 TLS cleanup in commit efd1ca52d04d2f6df337a3332cee56cd60e6d4c4 
> made the sys_set_thread_area and sys_get_thread_area functions ripe 
> for tail call optimization.  If the compiler chooses to use it for 
> them, it can clobber the user trap frame because these are asmlinkage 
> functions.

thanks, applied.

>  asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
>  {
> -	return do_set_thread_area(current, -1, u_info, 1);
> +	int ret = do_set_thread_area(current, -1, u_info, 1);
> +	prevent_tail_call(ret);
> +	return ret;

i'm wondering, have you seen this happen in practice? We use 
sys_set_thread_area() for every new task started up. I guess we havent 
seen problems in the field yet because this early during startup tasks 
do not normally receive signals? (or if they do they are fatal and no 
user signal context is used.)

btw., gcc 4.2.3 doesnt do it due to CONFIG_FRAME_POINTERS=y here, and 
most distros turn on frame pointers.

btw., this whole thing of us having to notice such tail-optimization 
incidents is totally fragile and unreliable. Shouldnt there be a "dont 
tail-optimize me" attribute which we could stick into asmlinkage? 
Perhaps sparse could detect asmlinkage functions that do not do 
prevent_tail_call()s?

	Ingo

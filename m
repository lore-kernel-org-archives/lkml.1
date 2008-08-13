Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbYHMRbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbYHMRbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYHMRba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:31:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42103 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYHMRb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:31:29 -0400
Date: Wed, 13 Aug 2008 19:31:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH][retry 1] 2.6.27-rc2: invalidate caches before going
	into suspend
Message-ID: <20080813173115.GA28891@elte.hu>
References: <200808131228.50415.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808131228.50415.mark.langsdorf@amd.com>
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


(please keep Cc:s intact)

* Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> @@ -104,6 +103,7 @@ static inline void play_dead(void)
>  	 * With physical CPU hotplug, we should halt the cpu
>  	 */
>  	local_irq_disable();
> +	wbinvd();
>  	while (1)
>  		halt();

hm, why not do what i suggested in my first mail:

        if (cpu >= i486)
                asm("cli; wbinvd; cli; 1: hlt; jmp 1b")
        else
		halt();

perhaps turn it into a wbivd_halt() primitive, to make it clean and even 
more obvious.

This sequence does matter to reliable suspend/resume, and in theory gcc 
could insert something before a halt() as well.

[ i only have a pretty far-fetched example that in all likelyhood wont
  happen in practice: for example halt could be decided to be uninlined
  by a braindead compiler, ftrace could hook in there, and dirty some
  state. But still - the point is that we had a difficult bug in this 
  code for a long time and in such situations we should just over-do 
  robustness by default. ]

	Ingo

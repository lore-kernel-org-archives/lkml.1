Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbYHSNfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbYHSNfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYHSNe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:34:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44118 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbYHSNe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:34:56 -0400
Date: Tue, 19 Aug 2008 15:34:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080819133422.GA24369@elte.hu>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au> <20080818075459.GH30694@elte.hu> <48A9472F.908@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A9472F.908@panasas.com>
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


* Boaz Harrosh <bharrosh@panasas.com> wrote:

> > Link time warnings are easy enough to miss.
> > 
> > So unless there's a better way of doing it all at compile time (i'd 
> > really prefer that!) i'd prefer the link time error about botched 
> > BUILD_BUG_ON() conditions - as my commits introduce.
> > 
> > 	Ingo
> > --
> 
> #define BUILD_BUG_ON(condition)						\
> do {
> 	enum { bad = !!(condition)}; 									\
> 	static struct { char arr[1 - 2*bad]; } x __maybe_unused;	\
> } while(0)
> 
> the enum definition will not let in anything not compile-time constant.

nice trick!

> But then I fail on: (include/linux/virtio_config.h:99)
> 
> 	if (__builtin_constant_p(fbit))
> 		BUILD_BUG_ON(fbit >= 32);
> 
> is that code broken?

hmm ... that's a bit sad, gcc ought to have been able to figure this 
out. Can this be fixed somehow, without losing the strength of the 
checking here? I think we should not change BUILD_BUG_ON() to make it 
less useful.

	Ingo

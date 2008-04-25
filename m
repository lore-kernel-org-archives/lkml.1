Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbYDYPvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbYDYPvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756294AbYDYPvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:51:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbYDYPvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:51:15 -0400
Date: Fri, 25 Apr 2008 17:50:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
       zdenek.kabelac@gmail.com, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080425155000.GA4438@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> No. That whole code sequence is total and utter crap. It needs to be 
> rewritten.
> 
> It first does a BUG_ON() if it's not naturally aligned (because that 
> wouldn't be atomic), and then it has code for page crossing! What a 
> TOTAL PIECE OF SH*T!
> 
> Hint:
>  - if it's naturally aligned, it couldn't be page crossing ANYWAY
>  - and if it was a page-crosser, it sure as hell couldn't be atomic!
> 
> The code is just crap, crap, crap. It needs to be rewritten from 
> scratch. I'll have a patch soonish.

yeah :(

it seems that this code only worked because text_poke_early() [which can 
take arbitrary length and alignment] does most of the patching, it is 
the real code-patching machinery that is used during early bootup - and 
that's not used later on.

text_poke() itself only applies/unapplies the LOCK prefix - a single 
byte. We shouldnt be doing that at all: the cost of LOCK is 
insignificant (a few cycles) and most systems are SMP anyway.

any other type of code patching should use stop_machine_run(), where 
every CPU is stopped with irqs disabled.

	Ingo

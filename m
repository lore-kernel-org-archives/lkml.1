Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYJTMVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYJTMVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYJTMVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:21:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60364 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYJTMVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:21:14 -0400
Date: Mon, 20 Oct 2008 14:20:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Anholt <eric@anholt.net>
Cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
Message-ID: <20081020122046.GA25152@elte.hu>
References: <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com> <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com> <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu> <1224443274.5526.39.camel@vonnegut.anholt.net> <20081020115533.GB10594@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020115533.GB10594@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> that gets ugly very fast. I think we should not use atomic kmaps but 
> NR_CPUS _fixmaps_ with a per CPU array of mutexes (this is basically 
> atomic kmaps but without the preemption restrictions). We could 
> take/drop the mutex and statistically you'll stay on the same CPU and 
> wont ever contend on that lock in practice.

peterz pointed it out that we need to be careful with the TLBs in that 
case.

I think it's solvable: a small non-default special-case in switch_to() 
would invlpg any pending such page. (and no two such mappings could be 
held at the same time)

So as long as we dont leave the CPU we wont ever do TLB flushes, and the 
flush will be local even if we do.

	Ingo

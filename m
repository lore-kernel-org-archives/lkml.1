Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbYG0VET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbYG0VET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 17:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYG0VEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 17:04:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41761 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbYG0VEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 17:04:09 -0400
Date: Sun, 27 Jul 2008 23:03:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [git pull] cpus4096 fixes
Message-ID: <20080727210350.GA30033@elte.hu>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 27 Jul 2008, Ingo Molnar wrote:
> > 
> > Please pull the latest cpus4096-fixes git tree from:
> 
> No. Not without explanations.
> 
> Quite frankly, this "fix" looks like a huge stinking pile of sh*t.

Agreed :-/

NUMA-locality might have been a valid argument in favor of the massive 
array of constant cpumasks (common usage is to use it for the current 
cpu), if it wasnt all stupidly allocated on the boot node:

        cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
        for (i = 0; i < nr_cpu_ids; i++)
                cpu_set(i, cpumask_of_cpu_map[i]);

> And I further right, and you are so STUPID that you cannot see that 
> you can share all the zero words?

That's fair to say :-/ I cannot talk for the others but it certainly 
didnt occur to me and i should have caught it.

( To me it didnt occur because we rarely have the opportunity for such 
  rather clever optimizations, in most cases there's really just two 
  choices in practice: either maximally global, or maximally per cpu. 
  Here we can do something inbetween and overlap. I dont think we do any 
  comparable compression of constants in the kernel. That boxed in my
  imagination i guess. )

Sorry about this - please ignore these patches, we'll rework them along 
the lines you suggest. Your suggested data structure will indeed be both 
simpler, smaller and more cache-efficient.

	Ingo

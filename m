Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXLVTag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXLVTag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 14:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXLVTa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 14:30:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36989 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbXLVTa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 14:30:28 -0500
Date: Sat, 22 Dec 2007 20:29:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222192957.GA6646@elte.hu>
References: <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org> <20071222190933.GA2958@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222190933.GA2958@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> I'd also not rely on the fact that only a few people are complaining. 
> Most people, even 2.6.24-rc early adopters, still use SLAB because 
> early adopters typically use their .23 .config and do a 'make 
> oldconfig' - which picks up SLAB. So SLUB use will become more 
> widespread only once 2.6.24 is out and is packaged in distros. Distros 
> will likely pick SLUB if there's no performance worries and if it's 
> the default. Fedora rawhide already uses SLUB.

here's some silly statistics about allocator coverage on lkml, based on 
configs reported to lkml in the past 4 months:

  $ for N in SLAB SLUB SLOB; do printf "%s: " $N; grep ^CONFIG_$N=y linux-kernel | wc -l; done
  SLAB: 70
  SLUB: 77
  SLOB: 4

so SLUB and SLAB is utilized about equally amongst people who reported 
configs to lkml.

But people who use SLUB enabled it intentionally - and they are thus 
much less likely to complain about this choice of them.

Reporting:

 "I just enabled SLUB instead of SLAB, and hey guys, it does not have 
  SLABinfo"

has a foolish ring to it, doesnt it? I'd rather ask carefully, like this 
person did:

  http://kerneltrap.org/mailarchive/linux-kernel/2007/10/12/335765

This is one of the reasons why i think the whole SLAB->SLUB renaming was 
bad - we should have done SLAB2 or SLAB^2 instead, so that people expect 
_at least as good_ behavior (performance, features, etc.) from SLUB as 
from SLAB. Instead of "something different".

anyway ... i think we still generally suck _alot_ at providing 
near-transparent kernel upgrades to users. (kernel upgrades are still a 
pain and risk, and often just due to poor developer choices on our 
side.)

It's nowhere near as bad as the 2.4->2.6 transition was (in fact it 
shouldnt even be mentioned in the same sentence), and it's getting 
better gradually, but i think we should just by default be 10 times more 
careful about these things - whenever it is borderline technically sane 
to do so. We induce enough unintentional breakage of user-space, we 
shouldnt compound it with intentional breakages. The kernel community 
still has _a lot_ of user and distro trust to win back. So being seen as 
over-cautious wont harm.

	Ingo

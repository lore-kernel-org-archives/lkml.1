Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbYD0QKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbYD0QKB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 12:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYD0QJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 12:09:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbYD0QJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 12:09:50 -0400
Date: Sun, 27 Apr 2008 18:09:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-ID: <20080427160921.GA18920@elte.hu>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org> <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
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

> Because if it becomes normal coding practice, now people cannot work 
> with you sanely any more (ie some random person pulls your tree for 
> testing, and then I pull it at some other time, and the tester reports 
> a problem, but now the commits he is talking about don't actually even 
> exist in my tree any more, and it's all really messy!).

this is a real problem in practice, so i have a 'merge' repository of 
all published x86.git trees of the past. About a 150 tree rebases later 
it's still only 500 MB - so we know about the precise identity of every 
published commit ID, even long after the fact.

> The x86 tree still does this. I absolutely detest it. Ingo claims that 
> his model is better, and I'm pretty damn sure he's wrong. But until it 
> starts causing bigger problems, I'll give him the benefit of the 
> doubt.

if people basing stuff on x86.git becomes common and the rebasing 
becomes an annoyance to them then we'll change this - we already changed 
many other practices we had, according to feedback from developers.

Firstly, an architecture tree is kind of special, in that it's very, 
very easy to introduce a regression that makes systems not boot up at 
all. And that's a showstopper for developers. It's quite different from 
a core kernel tree where we can often limp along with regressions. So by 
far the most important thing that people value about our tree is 
stability (or at least so we think).

So we do have a couple of fundamental things about our workflow that we 
think developers value, and i'm not sure how to do that within Git.

For example the act of 'staging' various fixes, and in essence 
bubble-sorting topics by the amount of fixes/problems they get. The 
lifetime of topics within x86.git is like this, and this roots back to 
the -rt queue which for years we maintained in a similar fashion:

- a new, nontrivial topic comes - say kmemcheck. First it's completely 
  experimental and we dont publish it at all - we keep it observed for a 
  week or so to get a feel of how much we want that topic and how stable 
  it is.

- the topic is in it's first stage, the most experimental 'testing' 
  phase. It's in x86.git/testing branch, right at the tail of every 
  other patch. It is merged after every existing topic and disturbs
  nothing. If it breaks then it's easy to take it out - no harm done to
  any other topic. New topics often bounce out and back 2-3 times before 
  they get past this initial stage of integration.

- the topic is in it's second stage - no high flux development anymore,
  it can get into x86/for-akpm. That means it will go ahead of a lot of 
  other topics and that might mean merging work. It goes through another 
  level of review - Andrew is picky ;-)

- the topic is in its third stage - x86.git/for-linus - preparation for 
  push. It's merged ahead of all other topics, merge conflicts resolved.
  Another, final review as well. We make sure Acks are collected for out
  of tree stuff, etc.

if there's some problem with a topic at any stage, it usually bubbles 
back up a level or two. Sometimes the problem is unknown and unfixed so 
the topic gets removed completely from the tree (temporarily), until the 
problem if found. Since we provide good bisection data, developers can 
find problems fast. Sometimes there's fatal review feedback (say Andrew 
reviews it too and finds it lacking ;) that moves a topic back to the 
'experimental' section completely.

But it gets even more complex: often we append fixes/updates not to the 
topic, but to the tail of the queue. We wait a test cycle (24 hours or 
overnight test) and when the changes look OK for public release we push 
it out. Then when it's OK and enough updates batched up and we trust the 
result we move those changes back to their specific topics - and resolve 
any conflicts if needed. This basically mixes 'clean topic separation 
and ordering' with a short-term 'append only' practice.

but all this inner-queue lifetime is almost invisible to developers - 
all the reshuffling is done in an invariant way and we enforce that the 
end result does not change when we flip around topics. They might see 
topics disappearing occasionally, but given that x86.git carries up to a 
dozen topics at a time or more, it's never a true disruption.

But we dont keep the queue public with a known breakage in it. I.e. we 
merge easily, but we also find bugs agressively and revert easily. And 
an important rule is that the moment we know about a breakage we fix it 
immediately either by resolving the bug or by removing the topic, and 
release a new version right then.

Another benefit to developers is that we do all inter-topic merges 
ourselves. If we picked up two overlapping topics it's our task to 
resolve the inevitable conflicts - we dont push that back to the 
developers.

And the topic sorting of the queue becomes important in the merge window 
as well: that's when the final decision is done whether to merge a topic 
or not. This means that topics will again change order - and if there's 
some dependency between them (which is very common), that dependency is 
resolved.

Quilt gives this sort of workflow flexibility to us - but i never really 
found a good Git workflow that matches this type of maintenance model. 
But we are no Git wizards so suggestions would be welcome.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbYDUIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbYDUIX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYDUIXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:23:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYDUIXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:23:15 -0400
Date: Mon, 21 Apr 2008 10:22:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on
	latest -git
Message-ID: <20080421082254.GA2522@elte.hu>
References: <20080419100034.GA9475@elte.hu> <20080419.030337.244502148.davem@davemloft.net> <20080419103942.GA13599@elte.hu> <20080419.040945.13369499.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419.040945.13369499.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sat, 19 Apr 2008 12:39:42 +0200
> 
> I knew you were going to make a stink about this, and frankly Ingo I'm 
> starting to get extremely irritated about your persistant nagging 
> about how people should do this or that wrt. kernel development.
>
> I seem to see a lot of it because 1) I don't think pushing everything 
> to lkml is the answer to everything and 2) I think the trees like -mm 
> and linux-next take care of the scalability issues of watching the 
> state of trees that will be merged to Linus in the future.

And i'd like to make one thing really clear, before we discuss anything 
else. You seem to imply in your mail that i'm somehow picking on you. 
I'm not - i try to be as unbiased in terms of picking subsystems that i 
find bugs in as it gets: it's randconfig builds/bootups that selects the 
test target, not me. I'd be the happiest camper if these discussions 
werent happening at all. I'm not out here looking for bugs. Look at 
lkml, i reported the bugs in the order and frequency as they were found 
by the qa scripts.

Fact is that for the third straight day i cannot do meaningful overnight 
testing of my trees because -git keeps spewing out build failures.

( And i cannot just change the QA scripts to skip over networking build
  bugs. My build system _runs on the tested kernel_, to prove that the 
  kernel is reasonably self-hosting and to prove that the 
  user/developer, even if a kernel was buggy, would be able to download 
  a new kernel over the network and would be able to build a new kernel. 
  So if there's any build failure the whole test stops and i need to see 
  the exact nature of the failure myself. I found a handful of bugs 
  where there was no real build bug but a bug in the target kernel made 
  the build fail. Just two weeks ago i had a DMA bug that showed up as a 
  sporadic build error. )

Let me give you an example, for code neither of us maintains, maybe that 
works better as an argument. I dont remember the last time when i 
triggered _any_ VFS bug (build or runtime bug) - and it's a subsystem 
that is larger and even more central one than networking. The VFS rate 
of change (# of commits and diffstat) is comparably high as well:

  $ git-rev-list v2.6.24..v2.6.25 fs/ | wc -l
  929
  $ git-diff v2.6.24..v2.6.25 fs/  | diffstat | tail -1
  624 files changed, 27449 insertions(+), 16385 deletions(-)


  $ git-rev-list v2.6.24..v2.6.25 net/ | wc -l
  1389
  $ git-diff v2.6.24..v2.6.25 net/  | diffstat | tail -1
  654 files changed, 43514 insertions(+), 23357 deletions(-)

sure, there are crutial differences between the two codebases - but the 
difference seems striking to me, in actual hands-on testing. Why is 
that? Are the filesystem folks different due to the nature of their 
code?

> You haven't cared about how I push my trees to Linus for years, why is 
> it a problem all of a sudden?

the answer is simple, and it has nothing to do with you or with 
networking at all: i'm maintaining about 10 times more code (and more 
commits) than before. That means i'm signing off on more than 1000 
commits per release, and i'm exposed in a magnified way to other 
people's trees. And i still do what i did for the last 13 years of Linux 
kernel hacking: when i see a problem i either fix it or i complain about 
it so that it gets fixed. And when a problem stays unfixed i complain 
louder. And i do all that in a loop ;-)

and i'd like to remind you of the following unfixed v2.6.25 networking 
regression:

 Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10427
 Subject         : e1000e broke e1000
 Submitter       : Ingo Molnar <mingo@elte.hu>
 Date            : 2008-04-08 20:39 (13 days old)
 References      : http://lkml.org/lkml/2008/4/8/256
 Patch           : http://bugzilla.kernel.org/attachment.cgi?id=15704&amp;action=view

You pushed a stream of last-minute networking fixes upstream even in the 
very last minutes of v2.6.25 but this one was either forgotten or not 
deemed important enough. There was no followup i could see, the 
discusssion just went dead with no resolution that i can see.

> Different people operate differently, and might have alternate 
> approaches to insuring quality and smooth merging of the changes they 
> manage.  The only thing that really matters is that the people who 
> push directly to Linus are trusted by him, and they won't disappear 
> right after he pulls their changes in.
> 
> You got a bug fix in 5 minutes after sending your email to the lists, 
> and since you sent it to lkml anybody can find it, so I don't see what 
> the big deal is.

for the last 3 days my own automated bug finding capacity is at 10% of 
its normal throughput (it booted only 200 kernels, instead of 2000 
kernels) - which is OK in early phases of the merge window, but you seem 
to deny that i have any standing to argue development process issues.
:-/ Who has standing to argue with you in those issues, only Linus?

	Ingo

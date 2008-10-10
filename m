Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbYJJSd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbYJJSd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbYJJSdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:33:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbYJJSdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:33:49 -0400
Date: Fri, 10 Oct 2008 20:33:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull, take 2] x86 updates for v2.6.28, phase #2 - PAT
	updates
Message-ID: <20081010183332.GA26492@elte.hu>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org> <20081010164537.GA23664@elte.hu> <20081010170426.GA5947@elte.hu> <20081010174131.GA8806@elte.hu> <alpine.LFD.2.00.0810101114360.3503@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810101114360.3503@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 10 Oct 2008, Ingo Molnar wrote:
> > 
> > i'll re-roll the seven x86-v28-for-linus-phase3...phase10 trees as well.
> 
> Just checking: the scheduler/rcu trees you did pull requests for 
> yesterday are all independent and I can pull those as-is, right?

Correct, scheduler, RCU and fastboot are all independent. To make sure i 
just checked the merging aspects of all of them:

  sched-v28-for-linus: OK

    2c10c22: Merge branch 'linus' into sched/devel
    63e5c39: Merge branches 'sched/urgent' and 'sched/rt' into sched/devel
    09b22a2: Merge commit 'v2.6.27-rc6' into sched/devel
    7f79d85: Merge branch 'linus' into sched/devel
    3cf430b: Merge branch 'linus' into sched/devel

  rcu-v28-for-linus: OK

    cdbb92b: Merge branch 'linus' into core/rcu
    b5259d9: Merge commit 'v2.6.27-rc8' into core/rcu
    429b022: Merge commit 'v2.6.27-rc6' into core/rcu
    c4c0c56: Merge branch 'linus' into core/rcu

  fastboot-v28-for-linus: OK

    1562542: Merge branch 'linus' into fastboot
    3588ed2: Merge branch 'linus' into fastboot
    f793691: Merge commit 'v2.6.27-rc6' into fastboot
    b676303: Merge branch 'linus' into fastboot
    bf015f7: Merge branch 'linus' into fastboot

the x86-v28-phase*-linus branches were all interdependent but are easy 
to re-propagate because all the x86 topics are -git based and while they 
merged the old x86/pat, they merged it before it grew that ugliness. 

(and the pat2 rebase did not touch the old commits that were fine)

So it should be fine. I'm also doing rolling tests of the new branches.

In general, this is where the "extreme topical" setup rocks IMO: had 
this mishap happened in a linear tree i'd have had to rebase about 300 
followup commits to get rid of it - that would have been quite a mess to 
validate. But with the topical setup it was at the end of x86/pat and 
only a single followup commit had to be rebased.

And bisectability bugs easily slip into extreme rebasing excercises: 
crossing merges cause conflicts and manual steps that are easy to mess 
up. I had to do such a rebase once a couple of months ago and it was 
very stressful and very hard to get it right.

... we are not totally immune to it though, because sometimes we still 
do cross-merges between topics when the conflicts just get too ugly.

So this was pretty much close to a worst-case scenario: phase2 was 
unacceptable due to this really stupid v1->v2 series and i had to redo 
the whole followup integration - but still i did not have to do _one 
single_ manual step in the code space itself (only on branches), so 
while there are new-looking merge commits with conflicts, they are all 
cached git-rerere entries and thus the testing status should still all 
be valid.

btw., that might be a Git feature request: it would be _really_ nice if 
instead of:

    Merge branch 'linus' into x86/pat2

    Conflicts:
        arch/x86/mm/init_64.c

git-rerere facilities created this default commit message automatically:

    Merge branch 'linus' into x86/pat2

    Conflicts:
        arch/x86/mm/init_64.c, cached 14 days ago

that way it's a lot easier to judge and trust the quality of recent 
merge commits. (and reduce/manage risks associated with merge mistakes)

	Ingo

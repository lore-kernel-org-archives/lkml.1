Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZEQNLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZEQNLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZEQNK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:10:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZEQNK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:10:58 -0400
Date: Sun, 17 May 2009 15:10:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency at
	cleanup_workqueue_thread
Message-ID: <20090517131019.GA30821@elte.hu>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com> <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242559101.28127.63.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Sun, 2009-05-17 at 09:18 +0200, Ingo Molnar wrote:
> > Cc:s added. This dependency:
> 
> Not sure why you're not adding the cfg80211 maintainer if you 
> think cfg80211 causes the problem...

Oversight and lack of time. Why are you asking it in such an edgy 
way instead of just addig the Cc:s? Why do you want to set a 
negative tone in the thread? Do you think it results in a faster 
resolution?

> > > -> #2 (cfg80211_mutex){+.+.+.}:
> > >        [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
> > >        [<ffffffff80271f38>] lock_acquire+0x98/0x140
> > >        [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
> > >        [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
> > >        [<ffffffffa007e66a>] reg_todo+0x19a/0x590 [cfg80211]
> > >        [<ffffffff80258f18>] worker_thread+0x1e8/0x3a0
> > >        [<ffffffff8025dc3a>] kthread+0x5a/0xa0
> > >        [<ffffffff8020d23a>] child_rip+0xa/0x20
> > 
> > is what sets the dependencies upside down.
> 
> I'm also not sure how you arrived at that conclusion, I would be 
> interested to hear how you did. [...]

( no strong reason, i looked for 10 seconds and this is what popped
  up. You looked a bit deeper and found something different. )

> [...] In any case, it's most definitely not cfg80211 causing it.
> 
> Cf. this, almost identical, lockdep report for example:
> http://paste.pocoo.org/show/116240/
> The logical conclusion here would be to say that the rtnl is responsible
> here...
> 
> As you can see from the report, the only thing cfg80211_mutex does 
> is register a device struct while holding it -- claiming cfg80211 
> (or rtnl in the other report which behaves the same) 
> responsibility here because of that is totally ludicrous -- that 
> would mean you've suddenly changed all the locking rules so that 
> you can no longer register devices under a lock that you also need 
> from a work struct executed due to schedule_work().
> 
> I'm not entirely sure yet, but I would think the problem might be 
> a false positive in the workqueue code -- remember this report 
> only triggers because cleanup_workqueue_thread() acquires the fake 
> lock for the workqueue. Maybe it shouldn't do that from the 
> CPU_POST_DEAD notifier? Oleg, can you help me out here?
> 
> johannes

We can also remove the workqueue lockdep annotations if the false 
positive rate is too high.

	Ingo

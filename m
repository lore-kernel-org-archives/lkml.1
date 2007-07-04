Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbXGDMWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbXGDMWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbXGDMWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:22:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338AbXGDMWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:22:11 -0400
X-Greylist: delayed 59966 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 08:22:11 EDT
Date: Wed, 4 Jul 2007 14:21:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
Message-ID: <20070704122159.GA21813@elte.hu>
References: <1182969638.4769.56.camel@johannes.berg> <1183048429.4089.1.camel@johannes.berg> <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4> <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg> <20070703173112.GA108@tv-sign.ru> <1183549772.3812.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183549772.3812.10.camel@johannes.berg>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> > > @@ -257,7 +260,9 @@ static void run_workqueue(struct cpu_wor
> > >
> > >  		BUG_ON(get_wq_data(work) != cwq);
> > >  		work_clear_pending(work);
> > > +		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> > >  		f(work);
> > > +		lock_release(&cwq->wq->lockdep_map, 0, _THIS_IP_);
> >                                                    ^^^
> > Isn't it better to call lock_release() with nested == 1 ?
> 
> Not sure, Ingo?

well, in this case the lock/unlock should nest perfectly (i.e. it should 
always be balanced perfectly), so indeed calling with nested==1 leads to 
stricter checking.

non-nested unlocks occur when people do stuff like:

	spin_lock(&lock1);
	spin_lock(&lock2);
	spin_unlock(&lock1);
	spin_unlock(&lock2);

the first unlock is not 'nested perfectly'. Now for the workqueue 
dep_map this shouldnt be a legal combination, right?

	Ingo

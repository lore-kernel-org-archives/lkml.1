Return-Path: <linux-kernel-owner+w=401wt.eu-S935226AbXJOSxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226AbXJOSxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935042AbXJOSxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:53:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761311AbXJOSxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:53:14 -0400
Date: Mon, 15 Oct 2007 20:53:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] scheduler updates for v2.6.24
Message-ID: <20071015185307.GA26763@elte.hu>
References: <20071015141723.GA29486@elte.hu> <20071015113527.6bf91baf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015113527.6bf91baf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0024]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 15 Oct 2007 16:17:23 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Linus, please pull the latest scheduler git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> Did Paul Jackson's crash get fixed?

yes - that crash was a showstopper that was holding up the pull request 
for 2 days. Paul bisected it down to the culprit and the fix was to do 
this in wake_up_new_task():

-       if (!p->sched_class->task_new || !current->se.on_rq) {
+       if (!p->sched_class->task_new || !current->se.on_rq || !rq->cfs.curr) {

(during early bootup the cfs_rq has no curr pointer yet.) It's not clear 
why this race did not trigger earlier. (and the two checks can probably 
be consolidated into a single "!rq->cfs.curr" condition.)

	Ingo

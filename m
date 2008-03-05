Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbYCEG5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbYCEG5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbYCEG5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:57:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbYCEG5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:57:09 -0500
Date: Wed, 5 Mar 2008 07:56:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: balbir@linux.vnet.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-ID: <20080305065635.GC28398@elte.hu>
References: <200803030316.07165.rjw@sisk.pl> <20080304112741.GA13428@linux.vnet.ibm.com> <1204682782.3248.189.camel@ymzhang> <47CE183C.7040105@linux.vnet.ibm.com> <1204694154.3248.194.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204694154.3248.194.camel@ymzhang>
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


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> > Have you had a chance to git-bisect the culprit after the revert?
>
> How to bisect it if the reverted patch is submitted after the culprit 
> patch?

i do this by using quilt ontop of git-bisect.

I do something like this:

  mkdir patches
  echo revert.patch > patches/series
  git-log -1 -p 62fb185130e4d420f > patches/revert.patch 

  git-bisect start
  git-bisect  bad v2.6.24-rc3
  git-bisect good v2.6.24

  quilt push           # the revert is applied
  [ test the kernel ]
  quilt pop            # revert is unapplied

  git-bisect bad       # if it's still bad

  quilt push           # apply the revert again
  [ test the next kernel ]
  quilt pop            # undo the revert

  git-bisect good      # if it's good

etc. NOTE: if the "quilt push" fails, it's likely because you are in a 
point in the tree that does not have the reverted commits applied yet. 
In that case there's no need to push/pop, just test the bisection point.

Note, since there are _two_ guilty commits here:

      commit 58e2d4ca581167c2a079f4ee02be2f0bc52e8729
      Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
      Date:   Fri Jan 25 21:08:00 2008 +0100
      sched: group scheduling, change how cpu load is calculated

      commit 6b2d7700266b9402e12824e11e0099ae6a4a6a79
      Author: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
      Date:   Fri Jan 25 21:08:00 2008 +0100
      sched: group scheduler, fix fairness of cpu bandwidth allocation for task

make sure the bisection point is never "between" these two commits.

You can check whether a bisection point has the two guilty commits 
applied, via:

  git-log | grep -E '58e2d4ca581167c2a0|6b2d7700266b9402e12'

if this comes up empty, the guilty commits are not applied.

	Ingo

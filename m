Return-Path: <linux-kernel-owner+w=401wt.eu-S1763628AbXHXOM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763628AbXHXOM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 10:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbXHXOMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 10:12:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41896 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbXHXOMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 10:12:19 -0400
Date: Fri, 24 Aug 2007 16:12:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull request] scheduler updates
Message-ID: <20070824141215.GA24403@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

It includes 8 commits, 3 of which are important: the most important 
change is a bugfix to the new task startup penalty code. This could 
explain the task-startup unpredictability problem reported by Al Boldi.

Then there's also a change/tweak that increases the default granularity: 
it's still well below human perception so should not be noticeable, but 
servers win a bit from less preemption of CPU-bound tasks. (this is also 
the first step towards eliminating HZ from the granularity default 
calculation.)

Plus a bonus balance inconsistency has been fixed: the previous logic 
was slightly inflatory of sleeper wait-runtime, without a 
counter-balance on runners. (I found no noticeable or measurable impact, 
other than a ~5% improvement in hackbench performance [due to less 
preemption scheduling] and a slightly nicer looking /proc/sched_debug 
output when there are lots of sleepers.)

Five other, low-impact changes: a group-scheduling fixlet from Bruce 
Ashfield, two nice simplifications from Peter Zijlstra to the 
bonus-balance code (which eliminate a 64-bit multiplication and shrink 
the code), a QOI improvement from Dmitry Adamushko to RR RT task 
preemption [not strictly required for .23 but this has been in my tree 
for some time already with no ill effects and the code is obviously 
correct] and a dead code elimination fix from Sven-Thorsten Dietrich.

Test-built and test-booted on x86-32 and x86-64, and it passed a few 
dozen "make randconfig" builds as well.

	Ingo

------------------>
Bruce Ashfield (1):
      sched: CONFIG_SCHED_GROUP_FAIR=y fixlet

Dmitry Adamushko (1):
      sched: optimize task_tick_rt() a bit

Ingo Molnar (3):
      sched: increase default granularity a bit
      sched: tidy up and simplify the bonus balance
      sched: fix startup penalty calculation

Peter Zijlstra (2):
      sched: simplify bonus calculation #1
      sched: simplify bonus calculation #2

Sven-Thorsten Dietrich (1):
      sched: simplify can_migrate_task()

 sched.c      |    6 ------
 sched_fair.c |   26 +++++++++++++++-----------
 sched_rt.c   |   11 ++++++++---
 3 files changed, 23 insertions(+), 20 deletions(-)


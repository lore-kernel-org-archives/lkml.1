Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbZAGWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbZAGWdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762820AbZAGW0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:26:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762722AbZAGW0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:26:49 -0500
Date: Wed, 7 Jan 2009 23:26:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fix
Message-ID: <20090107222641.GA27541@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched: fix possible recursive rq->lock


 kernel/sched.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2e3545f..deb5ac8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3728,8 +3728,13 @@ redo:
 		}
 
 		double_unlock_balance(this_rq, busiest);
+		/*
+		 * Should not call ttwu while holding a rq->lock
+		 */
+		spin_unlock(&this_rq->lock);
 		if (active_balance)
 			wake_up_process(busiest->migration_thread);
+		spin_lock(&this_rq->lock);
 
 	} else
 		sd->nr_balance_failed = 0;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbYAVKeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbYAVKeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYAVKeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:34:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760288AbYAVKd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:33:56 -0500
Date: Tue, 22 Jan 2008 11:33:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fix
Message-ID: <20080122103344.GA18673@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


Linus, please pull the latest scheduler-fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

it's a fix for a late-breaking bug: if the root user / admin sets the 
new /sys/uids/*/cpu_share tunable too low from the default 1024 then we 
can crash/hang. [ in sched-devel.git we've already had MIN_GROUP_SHARES 
for a long time to enforce this limit - but it was not backported. ]

	Ingo

------------------>
Ingo Molnar (1):
      sched: group scheduler, set uid share fix

 sched.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched.c b/kernel/sched.c
index 37cf07a..e76b11c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7153,6 +7153,14 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 {
 	int i;
 
+	/*
+	 * A weight of 0 or 1 can cause arithmetics problems.
+	 * (The default weight is 1024 - so there's no practical
+	 *  limitation from this.)
+	 */
+	if (shares < 2)
+		shares = 2;
+
 	spin_lock(&tg->lock);
 	if (tg->shares == shares)
 		goto done;

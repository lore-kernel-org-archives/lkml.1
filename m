Return-Path: <linux-kernel-owner+w=401wt.eu-S965414AbXCLJN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414AbXCLJN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXCLJN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:13:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965414AbXCLJN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:13:57 -0400
Date: Mon, 12 Mar 2007 10:13:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>
Subject: [patch] futex: PI state locking fix
Message-ID: <20070312091342.GA27425@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch] futex: PI state locking fix
From: Ingo Molnar <mingo@elte.hu>

testing of -rt by IBM uncovered a locking bug in wake_futex_pi(): the PI 
state needs to be locked before we access it.

this patch has been tested in -rt. Must-have for v2.6.21.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
--
 kernel/futex.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/kernel/futex.c
===================================================================
--- linux.orig/kernel/futex.c
+++ linux/kernel/futex.c
@@ -566,6 +566,7 @@ static int wake_futex_pi(u32 __user *uad
 	if (!pi_state)
 		return -EINVAL;
 
+	spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
@@ -605,6 +606,7 @@ static int wake_futex_pi(u32 __user *uad
 	pi_state->owner = new_owner;
 	spin_unlock_irq(&new_owner->pi_lock);
 
+	spin_unlock(&pi_state->pi_mutex.wait_lock);
 	rt_mutex_unlock(&pi_state->pi_mutex);
 
 	return 0;

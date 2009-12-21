Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZLUQqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZLUQqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbZLUQqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:46:38 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:58966 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851AbZLUQqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:46:37 -0500
Date: Mon, 21 Dec 2009 17:46:08 +0100
From: "Carlos R. Mafra" <crmafra@aei.mpg.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: 2.6.33-rc1+ bisected (?) s2ram regression
Message-ID: <20091221164608.GA3909@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 2.6.33-rc1 suspend to RAM (echo mem > /sys/power/state) stopped working
on my Vaio. Plain 2.6.33-rc1 is fine.

The symptom is that it seems to never finish suspending, and the last 
messages on the console stay there forever and the laptop stays dead
(no leds blinking, can't hear the fan, no nothing). I have to press 
the power button to use it again.

I bisected it down to e2912009fb7b7157 ("sched: Ensure set_task_cpu() is 
never called on blocked tasks"), but it does not revert cleanly for me
to double check it.

[ I tried to "solve"  the merge conflict and the kernel compiled, but 
  s2ram did not work after that. So I am not sure if my bisection culprit 
  makes sense. ]
  
This is the bisect log:

# good: [55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f] Linux 2.6.33-rc1
git bisect good 55639353a0035052d9ea6cfe4dde0ac7fcbb2c9f
# bad: [dd59f6c76b265ed2ff18b497d6105a9511b1feb1] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha-2.6
git bisect bad dd59f6c76b265ed2ff18b497d6105a9511b1feb1
# bad: [aac3d39693529ca538e37ebdb6ed5d6432a697c7] Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad aac3d39693529ca538e37ebdb6ed5d6432a697c7
# bad: [077614ee1e93245a3b9a4e1213659405dbeb0ba6] sched: Fix broken assertion
git bisect bad 077614ee1e93245a3b9a4e1213659405dbeb0ba6
# bad: [e2912009fb7b715728311b0d8fe327a1432b3f79] sched: Ensure set_task_cpu() is never called on blocked tasks
git bisect bad e2912009fb7b715728311b0d8fe327a1432b3f79
# good: [b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac] sched: Fix cpu_clock() in NMIs, on !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
git bisect good b9f8fcd55bbdb037e5332dbdb7b494f0b70861ac
# good: [9ee349ad6d326df3633d43f54202427295999c47] sched: Fix set_cpu_active() in cpu_down()
git bisect good 9ee349ad6d326df3633d43f54202427295999c47
# good: [e4f4288842ee12747e10c354d72be7d424c0b627] sched: Select_task_rq_fair() must honour SD_LOAD_BALANCE
git bisect good e4f4288842ee12747e10c354d72be7d424c0b627
# good: [06b83b5fbea273672822b6ee93e16781046553ec] sched: Use TASK_WAKING for fork wakups
git bisect good 06b83b5fbea273672822b6ee93e16781046553ec
  

If there is anything else I can do, let me know.

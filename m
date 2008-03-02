Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbYCBTLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbYCBTLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYCBTL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:11:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYCBTL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:11:28 -0500
Subject: Re: 2.6.25-rc: complete lockup on boot/start of X (bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080302185935.GA6100@joi>
References: <20080302185935.GA6100@joi>
Content-Type: text/plain
Date: Sun, 02 Mar 2008 20:11:11 +0100
Message-Id: <1204485071.6240.56.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-03-02 at 20:00 +0100, Marcin Slusarz wrote:
> Hi
> Since early 2.6.25 days I'm having strange lockup on boot. As it happens
> rarely (in ~10% of boots), I couldn't bisect it. No kernel panic, SysRq
> didn't work, so I couldn't provide any useful informations to LK community.
> I hoped someone else would fix it... :)
> 
> It's rc3 so I decided to narrow it down myself. I enabled netconsole 
> to see whether some other informations are printed before lockup.
> It didn't help, but I noticed that lockup happens much more frequenly! (~50%)
> So I bisected it down to:
> 
> 8f4d37ec073c17e2d4aa8851df5837d798606d6f is first bad commit
> commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:29 2008 +0100
> 
>     sched: high-res preemption tick
> 
>     Use HR-timers (when available) to deliver an accurate preemption tick.
> 
>     The regular scheduler tick that runs at 1/HZ can be too coarse when nice
>     level are used. The fairness system will still keep the cpu utilisation 'fair'
>     by then delaying the task that got an excessive amount of CPU time but try to
>     minimize this by delivering preemption points spot-on.
> 
>     The average frequency of this extra interrupt is sched_latency / nr_latency.
>     Which need not be higher than 1/HZ, its just that the distribution within the
>     sched_latency period is important.
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 ab225228500f7a19d5ad20ca12ca3fc8ff5f5ad1 f1742e1d225a72aecea9d6961ed989b5943d31d8 M      arch
> :040000 040000 25d85e4ef7a71b0cc76801a2526ebeb4dce180fe ae61510186b4fad708ef0211ac169decba16d4e5 M      include
> :040000 040000 9247cec7dd506c648ac027c17e5a07145aa41b26 950832cc1dc4d30923f593ecec883a06b45d62e9 M      kernel
> 
> I can't revert it on top of rc3 because of conflicts.

This should do, I guess. Weird though, I haven't had trouble with this
patch in a long long while. Nor I suppose has Ingo's QA setup.

Will try if I can reproduce using your .config.

---

diff --git a/kernel/sched.c b/kernel/sched.c
index b73ee9e..02cbf34 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -741,7 +741,7 @@ const_debug unsigned int sysctl_sched_features =
 		SCHED_FEAT_NEW_FAIR_SLEEPERS	* 1 |
 		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
 		SCHED_FEAT_START_DEBIT		* 1 |
-		SCHED_FEAT_HRTICK		* 1 |
+		SCHED_FEAT_HRTICK		* 0 |
 		SCHED_FEAT_DOUBLE_TICK		* 0;
 
 #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)




Return-Path: <linux-kernel-owner+w=401wt.eu-S1761763AbYA3WzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761763AbYA3WzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:55:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbYA3Wyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:54:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:4685 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbYA3Wys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:54:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nb+U7lYUlPX7IAVZ74kXQJ4VE+IdWwNRm16zq+b50lNxjgN2f8jubayHuAY+RmNHp5X4vF1zPO7Anmh1UARuf7JWhDUHj8pzMi0bWt8ETTioozVocmES9Gk7RJiSTYYIJLaD3954SRZIt71nmZw/m2VLEgnfeB/vsWyDRoMl8gQ=
Message-ID: <3d8471ca0801301454l56dd8607g25aad3ac3cd88e75@mail.gmail.com>
Date: Wed, 30 Jan 2008 23:54:46 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Hang in work_resched
In-Reply-To: <3d8471ca0801291430n68c0a845u1b24a590df8360f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0801291430n68c0a845u1b24a590df8360f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2008 11:30 PM, Guillaume Chazarain <guichaz@gmail.com> wrote:
>  =======================
> gnome-termina S 00000027     0  2201      1
>        f6711fb0 00200082 cb330d62 00000027 f664105c 00000b1e 00000000 cb331880
>        00000027 f660d780 009e3840 080ab7d8 080ab298 f6711000 c0103e7e 009e3840
>        000e0002 00000002 080ab7d8 080ab298 bfb41be8 080ab7d8 0000007b c010007b
> Call Trace:
>  [<c0103e7e>] work_resched+0x5/0x16
>  =======================
>
> This corresponds to the cli instruction:
> c0103e7e:       fa                      cli

I bisected it, and the resulting commit is appended. Rerverting this
commit applies cleanly on today's git
(dd430ca20c40ecccd6954a7efd13d4398f507728) and makes the hang go away
-:)


commit 37bb6cb4097e29ffee970065b74499cbf10603a3
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jan 25 21:08:32 2008 +0100

    hrtimer: unlock hrtimer_wakeup

    hrtimer_wakeup creates a

      base->lock
        rq->lock

    lock dependancy. Avoid this by switching to HRTIMER_CB_IRQSAFE_NO_SOFTIRQ
    which doesn't hold base->lock.

    This fully untangles hrtimer locks from the scheduler locks, and allows
    hrtimer usage in the scheduler proper.

    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 061ae28..bd5d6b5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1293,7 +1293,7 @@ void hrtimer_init_sleeper(struct hrtimer_sleeper
*sl, struct task_struct *task)
 	sl->timer.function = hrtimer_wakeup;
 	sl->task = task;
 #ifdef CONFIG_HIGH_RES_TIMERS
-	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_RESTART;
+	sl->timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 #endif
 }

@@ -1304,6 +1304,8 @@ static int __sched do_nanosleep(struct
hrtimer_sleeper *t, enum hrtimer_mode mod
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		hrtimer_start(&t->timer, t->timer.expires, mode);
+		if (!hrtimer_active(&t->timer))
+			t->task = NULL;

 		if (likely(t->task))
 			schedule();


-- 
Guillaume

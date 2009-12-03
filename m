Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbZLCGtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbZLCGtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 01:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZLCGtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 01:49:09 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:42820 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZLCGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 01:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LiTXih0Ha5VptHi9oIuA+NNHMRhDxj5euLW3hpkxEYDNjBHPYCpbzR1BINTdH3+Led
         uZeRrPiH+KXyPntYGDywUiloiZClQwZMQWobTAG0fdF5hh3+npt9GuwCGfhMtABXEFob
         87dTRq5zDw0/XR9Mgb7wN1LSiLrxeKFEda9hg=
MIME-Version: 1.0
Date: Thu, 3 Dec 2009 14:49:14 +0800
Message-ID: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com>
Subject: Should we use preempt_disable() in sleep_on_common()?
From: liu pf <kernelfans@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

I am puzzled with the following scenario. Could anyone enlighten me?

Thanks
pfliu


static long __sched
sleep_on_common(wait_queue_head_t *q, int state, long timeout)
{
    unsigned long flags;
    wait_queue_t wait;

    init_waitqueue_entry(&wait, current);

    __set_current_state(state);

    ==========>suppose that after task A  set state=TASK_INTERRUPTIBLE
, it is preempted by task B.

    spin_lock_irqsave(&q->lock, flags);
...............................................................
}

asmlinkage void __sched schedule(void)
{
.......................................................................................................
    if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
        if (unlikely(signal_pending_state(prev->state, prev)))
            prev->state = TASK_RUNNING;
        else
            deactivate_task(rq, prev, 1);
       =============>This will remove task A from rq, but there are no
wait queue referring to A, so we lose A.
        switch_count = &prev->nvcsw;
    }

..................................................................................................
}

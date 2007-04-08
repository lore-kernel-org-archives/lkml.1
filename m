Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXDHICM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXDHICM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 04:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXDHICL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 04:02:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:43294 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXDHICJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 04:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=ZXBPXS5wzfDgyNjcFtKgK9sMJOHv1G8045e6tXuAZnIXlOkeas8GqehiE8ynlzM+ggDIsRZprRCc7IQsXRl0k87iqSfyxnI2iEjmnwEhTC57OvA8CWyCNRGmC48ygALP6SLphpj0Av3827R7iYVRe0g806K+Q7u+zQ5ShQWCpus=
From: "Tomer Morad" <tomer.morad@gmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: task migration problem
Date: Sun, 8 Apr 2007 11:02:03 +0300
Message-ID: <023801c779b4$32f54f00$840a10ac@int.horizonsemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: Acd5tCznDJ9dj7viQISaYEz0akc5PQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As part of my PhD research, I'm trying to migrate a task from one CPU to another, but without success. Any help here would be much
appreciated!

The decision whether to migrate a task is taken at scheduler_tick(). I have tried the following approaches:
1. add a request to the migration queue of the current cpu.
2. deactivate the task on this cpu and activating it on the other cpu.
In both cases, the kernel hangs.

This is an example code I used at the end of schedule(), after spin_unlock_irq(rq->lock):

...

        finish_task_switch(this_rq(), prev);
} else
        spin_unlock_irq(&rq->lock);

//my code starts here. Prev->asymmetric_do_migrate is updated at scheduler_tick
//task_deactivated keeps track whether prev was deactivated in schedule()
//the task should migrate to prev->asymmetric_migrate_to_cpu
if (prev->asymmetric_do_migrate && !task_deactivated && !(prev->flags & PF_DEAD) && (prev != next))
{
        struct rq *dest_rq = cpu_rq(prev->asymmetric_migrate_to_cpu);
        struct rq *src_rq;
        int src_cpu;
        local_irq_disable();
        src_rq = task_rq(prev);
        double_rq_lock(src_rq,dest_rq);
        src_cpu = task_cpu(prev);

        if (src_cpu!=prev->asymmetric_migrate_to_cpu)
        {
                set_task_cpu(prev,prev->asymmetric_migrate_to_cpu);
                deactivate_task(prev, src_rq);
                __activate_task(prev, dest_rq);
        }
        prev->asymmetric_do_migrate = 0;
        double_rq_unlock(src_rq,dest_rq);
        local_irq_enable();
}
//my code ends here

prev = current;
if (unlikely(reacquire_kernel_lock(prev) < 0))
        goto need_resched_nonpreemptible;

...


Obviously I'm overlooking something trivial, perhaps something with the locks or with the activation mechanism.

Thanks in advance for any help!
Tomer.



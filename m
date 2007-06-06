Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXFFHmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXFFHmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXFFHl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:41:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:17863 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXFFHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=fV4BaYO6ZKBuy/+9oy3QB7xup3TFDggYX4HixdU8VQrSEXrBJDbJBMoAV8rNUaseexHMvZO39Q32xI4Kj8tG6Rcv7avEuL5k3W9uTxsv2euWsiDSsCtkrOwmORFRMUAenrwa4UmkFPRJyENbGiU6V5tVWOHAn/PF+YQpf7WoWQY=
Message-ID: <46666537.6050306@gmail.com>
Date: Wed, 06 Jun 2007 15:41:43 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu> <4658F1D6.3070706@gmail.com> <20070529061544.GA28523@elte.hu> <20070529080738.GA28657@elte.hu> <465E992C.4020601@gmail.com> <20070531095337.GA8104@elte.hu> <465FC7E7.7080804@gmail.com> <20070601192142.GA10039@elte.hu> <4664CB6D.8060507@gmail.com> <20070605080130.GA4301@elte.hu>
In-Reply-To: <20070605080130.GA4301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo:

    I am sorry for disturbing you again, I am interesting on CFS, 
however, had really confused on the fairness implementation of CFS.

    After reviewed the past mails of LKML, I known the virtual clock is 
used by fairness measuring scale, it is excellent idea. and CFS use 
wait_runtime (the total time to run) to simulate the virtual clock of 
the task. however, from my experiment, it seem we can not get well 
fairness effect if we just only take care of task->wait_runtime. but, 
CFS work well-known fine ;-)

    Here is the detail of my experiment:

    Suppose it is one UP system, and there are three 100 % cpuhog tasks 
on that processor,  they have 1, 2, 3  weight respectively,  so they 
should have 1, 2, 3 seconds time to run itself in 6 secords interval 
respectively.

    The clock tick interval is 1 sec. so the step of virtual time(VT) is 
0.17 (1/6) wall time(WT). I use follow convention to describe runtime 
information:

    VTR0.17: the virtual time 0.17 of runqueue
    VTT11.0 : the virtual time 11.0 of task
    WT2: the wall time 2.
    TASK_1/123.00: the task named TASK_1, it has 123.00 wait_runtime at 
that time.

for example:

    WT1/VTR0.17     [ VTT0.00:[TASK_2/1.00, TASK_3/1.00], 
VTT1.00:[TASK_1/-0.83] ] current: TASK_2/1.00  

its meaning is we pick TASK_2 as next task at wall time 1 / virtual time 
of runqueue 0.17, the ready task list has three tasks:

TASK_2:  the virtual time of it is 0.00, the wait_runtime of it is 1.00
TASK_3:  the virtual time of it is 0.00, the wait_runtime of it is 1.00
TASK_1:  the virtual time of it is 1.00, the wait_runtime of it is -0.83

It seem the result of picking next task by least VTT or by largest 
wait_runtime is same at this time, lucky.

Follow is complete result of running my script to simulate 6 clock ticks:

-----------------------------
WT0/VTR0.00     [ VTT0.00:[TASK_1/0.00, TASK_2/0.00, TASK_3/0.00] ] 
current: TASK_1/0.00
Before WT1 :
TASK_2/1.00 wait 1.00 sec
TASK_3/1.00 wait 1.00 sec
TASK_1/0.00 spent - 0.83 sec (delta_mine-delta_exec, delta_exec always 
is 1.0)
WT1/VTR0.17     [ VTT0.00:[TASK_2/1.00, TASK_3/1.00], 
VTT1.00:[TASK_1/-0.83] ] current: TASK_2/1.00
Before WT2 :
TASK_3/2.00 wait 1.00 sec
TASK_1/0.17 wait 1.00 sec
TASK_2/1.00 spent - 0.67 sec (delta_mine-delta_exec, delta_exec always 
is 1.0)
WT2/VTR0.33     [ VTT0.00:[TASK_3/2.00], VTT0.50:[TASK_2/0.33], 
VTT1.00:[TASK_1/0.17] ] current: TASK_3/2.00
Before WT3 :
TASK_1/1.17 wait 1.00 sec
TASK_2/1.33 wait 1.00 sec
TASK_3/2.00 spent - 0.50 sec (delta_mine-delta_exec, delta_exec always 
is 1.0)
WT3/VTR0.50     [ VTT0.33:[TASK_3/1.50], VTT0.50:[TASK_2/1.33], 
VTT1.00:[TASK_1/1.17] ] current: TASK_3/1.50
Before WT4 :
TASK_1/2.17 wait 1.00 sec
TASK_2/2.33 wait 1.00 sec
TASK_3/1.50 spent - 0.50 sec (delta_mine-delta_exec, delta_exec always 
is 1.0)
WT4/VTR0.67     [ VTT0.50:[TASK_2/2.33], VTT0.67:[TASK_3/1.00], 
VTT1.00:[TASK_1/2.17] ] current: TASK_2/2.33
Before WT5 :
TASK_1/3.17 wait 1.00 sec
TASK_3/2.00 wait 1.00 sec
TASK_2/2.33 spent - 0.67 sec (delta_mine-delta_exec, delta_exec always 
is 1.0)
WT5/VTR0.83     [ VTT0.67:[TASK_3/2.00], VTT1.00:[TASK_1/3.17, 
TASK_2/1.67] ] current: TASK_3/2.00
-----------------------------
TASK_1/3.17 run 1.00 sec
TASK_2/1.67 run 1.00 sec
TASK_3/2.00 run 2.00 sec
TASK_2/1.67 run 1.00 sec
TASK_3/2.00 run 1.00 sec
==============================
TASK_1 / 1.0 total run: 1.0 sec
TASK_2 / 2.0 total run: 2.0 sec
TASK_3 / 3.0 total run: 3.0 sec
==============================

if we pick next task by the least VTT (as above showing),  we can get 
the well fair result, the scheduling sequence is :

TASK_1 -> TASK_2 -> TASK_3 -> TASK_2 -> TASK_3

however, if we pick next task by the largest wait_runtime ,we can get 
other scheduling sequence:

TASK_1 -> TASK_2 -> TASK_3 -> TASK_2 -> TASK_1

In this case, they are not fairness anymore. every task got same 
processor time!

if we run the latter longer time, for example, to simulate 6000 times 
clock tick. the result is:

==============================
TASK_1 / 1.0  total run : 1806.0 sec
TASK_2 / 2.0  total run : 1987.0 sec
TASK_3 / 3.0  total run : 2207.0 sec
==============================

Do not need any vindication,  I really trust CFS works fine (it work 
fine for my desktop ;), it is fact.

so I think there must have some wrongs in my above experiment. but it is 
true apparently. What is really cleft between VTT and wait_runtime? and 
how you fill it in CFS? It seem I should give TASK_3  some extra credits 
in some ways.

Sorry for such long mail and so bad English.

Good luck.

- Li Yu

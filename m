Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXJUJgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXJUJgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXJUJf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:35:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:33793 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbXJUJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gvIjkUvWnPOFsaSToTwL2JipU/h2izqCFvzyl0V1HSAs+MgsrPZpfa+NN/TlUftK7LrxRNFh2sWMiq1qaVR4CSFSryhp0wTCmY7Pus3EZdx+SO3havjc1+ao0plf+nug5lEuRvdulTcG4Wmo3vc/N/JFQDaElSQ6IrRIgsG53xA=
Message-ID: <b647ffbd0710210235tf487bb3x1ffe73161fe0c9f7@mail.gmail.com>
Date: Sun, 21 Oct 2007 11:35:56 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [patch 6/8] pull RT tasks
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20071019184336.983272715@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071019184254.456160632@goodmis.org>
	 <20071019184336.983272715@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

> When a pull RT is initiated, all overloaded runqueues are examined for
> a RT task that is higher in prio than the highest prio task queued on the
> target runqueue. If another runqueue holds a RT task that is of higher
> prio than the highest prio task on the target runqueue is found it is pulled
> to the target runqueue.

I think, 2 things should be accomplished here :

(1) be sure to pull the _highest_ prio task ;

i.e. the _highest_ prio task amongst all runnable (but not running) RT
tasks across all the run-queues which is capable of running on
this_cpu ;

(2) don't pull more than 1 task at once.

that said, just pull the highest prio task and run it.

---

why (2)? Just to avoid situations when tasks are being pulled/pushed
back and forth between run-queues.

Let's say we have 4 cpu system:

0:  task(10) , task(92)
1:  task(10), task(91)
2:  task(10), task(90)
3:  task(10)

when task(10) on cpu#3 is inactive, we pull task(92), task(91),
task(90) and then run task(90)... in the mean time, some of cpu[0..2]
becomes inactive and pull task(91) and task(92) back and run them...
that may repeat again and again depending on when/how long task(10)
run on their corresponding cpus...

so it seems to me that the more optimal behavior would be "don't pull
more than you can run at the moment -- that's 1".

to this goal, something like find_lock_highest_rq() would be necessary.

and I guess, {get,put}_task_struct() should be used in pull_rt_task()
for the 'next' in a similar way as it's done in push_rt_task() .


>
> [ ... ]
>

-- 
Best regards,
Dmitry Adamushko

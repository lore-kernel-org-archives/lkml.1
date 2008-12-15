Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYLOBG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYLOBG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 20:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYLOBGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 20:06:51 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47668 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYLOBGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 20:06:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Slaby <jirislaby@gmail.com>
Cc: oleg@tv-sign.ru, kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <494581D7.6000203@gmail.com>
Date: Sun, 14 Dec 2008 17:02:05 -0800
In-Reply-To: <494581D7.6000203@gmail.com> (Jiri Slaby's message of "Sun, 14
	Dec 2008 22:59:51 +0100")
Message-ID: <m1wse29roy.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: jirislaby@gmail.com, linux-kernel@vger.kernel.org, kenchen@google.com, oleg@tv-sign.ru
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jiri Slaby <jirislaby@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: broken do_each_pid_{thread,task}
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> Hi,
>
> I'm getting
> `if (type == PIDTYPE_PID)' is unreachable
> warning from kernel/exit.c. The preprocessed code looks like:
> do {
>          struct hlist_node *pos___;
>          if (pgrp != ((void *)0))
>                  for (LIST ITERATION) {
>                          {
>                           if (!((p->state & 4) != 0))
>                            continue;
>                           retval = 1;
>                           break;
>                          }
>                          if (PIDTYPE_PGID == PIDTYPE_PID)
>                                  break;
>                  }
> } while (0);
> and it's obviously wrong.

Actually the test: 
>                          if (PIDTYPE_PGID == PIDTYPE_PID)
>                                  break;
Is technically ok.  The compiler should optimize it out instead of warning.
Although seeing the unexpected corner case it gets us into I think it would
be good to reconsider this test.

The break statement is also fine because the outer loop is only executed
once so it simply functions as an enclosing block, and the break transfers
control to where it should go.

> After investigating this code usage all around, it's broken on many places
> this or similar way.
>
> For do_each_pid_thread(), even this code snippet from fs/ioprio.c is broken
> due to double do {} while expansion:
> do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
>   ret = set_task_ioprio(p, ioprio);
>   if (ret)
>     break;
> } while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
>
> Any idea how to get rid of this issue?

The double loop there is certainly an issue.  I'm not quite convinced that
the error handling is correct even with the break statement.  But the
break statement was written when the code was just a single loop, so the
behavior is definitely not what we intended.

However I also agree with Ken Chen's assessment that we need to loop over
threads and not just the process group leaders in some cases such as
setting the io-priority.

With respect to error handling and IO priorities can we fix the error handling
by doing what we do when we send a signal to a process group?  That is note
that there was an error, finish processing all of the other processes and then
return the error?

Eric


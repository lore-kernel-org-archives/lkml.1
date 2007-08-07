Return-Path: <linux-kernel-owner+w=401wt.eu-S935041AbXHGW4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041AbXHGW4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbXHGW4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:56:33 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:39111 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756968AbXHGW4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:56:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=IcYLip5pf8aU0Q07bQdaQD5h2WAzgE2a5FT+Rs7Sn5KQK2Eta8+/J1spp1GVaYZT;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7d945$f30af1a0$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Question: RT schedular : task_tick_rt(struct rq *rq, struct task_struct *p) : decreases overhead when  rq->nr_running == 1
Date: Tue, 7 Aug 2007 15:54:41 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79490ec1cb95f0c0c5a81925b8270f1702350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.93.14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar and group,

If their is a single RT task on this rq, then why not just reset the
timeslice and return??? Just MAYBE decreasing re-scheduling
overhead..

Thus,,,,

After
    p->time_slice = static_prio_timeslice(p->static_prio);

Why isn't their a check like
    if  (rq->nr_running == 1)
         return;

Which world remove the need for any recheduling
or requeue'ing...

Mitchell Erblich
FYI: below is believed to be a snap of the current/ orig func
-----------------------------


+static void task_tick_rt(struct rq *rq, struct task_struct *p)
+{
+ /*
+  * RR tasks need a special form of timeslice management.
+  * FIFO tasks have no timeslices.
+  */
+ if (p->policy != SCHED_RR)
+  return;
+
+ if (--p->time_slice)
+  return;
+
+ p->time_slice = static_prio_timeslice(p->static_prio);
+ set_tsk_need_resched(p);
+
+ /* put it at the end of the queue: */
+ requeue_task_rt(rq, p);
+}

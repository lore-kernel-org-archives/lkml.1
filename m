Return-Path: <linux-kernel-owner+w=401wt.eu-S934008AbXHNSnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbXHNSnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbXHNSnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:43:33 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:36617 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbXHNSnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:43:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=TP3S9U0yWyovfKUGOMhayKy3VR+zcyVEuHT3r+z15hRLJRvyN5U9QXwxLWwL+6tV;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7dea3$48bf98a0$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: <akpm@zip.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "\"Dmitry Adamushko\"" <dmitry.adamushko@gmail.com>
Subject: minor Suggested cleanup: RT / sched : Have RT tasks use PF_LESS_THROTTLE flag
Date: Tue, 14 Aug 2007 11:45:25 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec7929c61f3345233a22fe77862b9f1ee4e0350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.86.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Group, Ingo Molnar, and Dmitry, et al,

task mm/page-writeback.c : get_dirty_limits()

Shouldn't the PF_LESS_THROTTLE flag be
scheduling class independent?

The below is a suggestion is to use the flag for
RT tasks.

-- to drop the rt_task() call within the function

if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {

1) becomes
if (tsk->flags & PF_LESS_THROTTLE)

Then 
2) in kernel/sched.c set:
   p->flags |= PF_LESS_THROTTLE before the break;

case SCHED_FIFO:
case SCHED_RR:
              p->sched_class = &rt_sched_class;
              p->flags |= PF_LESS_THROTTLE;
            break;

3) Unset it in case sched class changed; before the break
case SCHED_NORMAL:
case SCHED_BATCH:
case SCHED_IDLE:
           p->sched_class = &fair_sched_class;
           p->flags &= ~PF_LESS_THROTTLE;
           break;

4) set the flag rt_mutex_setprio with braces
if (rt_prio(prio)) {
                 p->sched_class = &rt_sched_class;
                 p->flags |= PF_LESS_THROTTLE;

                 
 }      else


5) Am I missing anything?

Mitchell Erblich


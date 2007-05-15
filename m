Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbXEODAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbXEODAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 23:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbXEOC74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 22:59:56 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4349 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbXEOC7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 22:59:55 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: fair clock use in CFS
Date: Mon, 14 May 2007 19:59:03 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKENLDMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200705141031.13528.dhazelton@enter.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 14 May 2007 20:59:25 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 14 May 2007 20:59:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Either you have a strange definition of fairness or you chose an
> extremely
> poor example, Ingo. In a fair scheduler I'd expect all tasks to
> get the exact
> same amount of time on the processor.

Yes, as a long-term average. However, that is impossible to do in the
short-term. Some taks has to run first and some task has to run last.
Whatever task runs last has had no CPU for all the time the other tasks were
running.

> So if there are 10 tasks running at
> nice 0 and the current task has run for 20msecs before a new task
> is swapped
> onto the CPU, the new task and *all* other tasks waiting to get
> onto the CPU
> should get the same 20msecs. What you've described above is fundamentally
> unfair - one process running for 20msecs while the 10 processes that are
> waiting for their chance each get a period that increases from a
> short period
> at a predictable rate.

The thing you're missing is that you are jumping into the middle of a system
that operates based on history. You are assuming concurrent creation of ten
tasks with no history and that for some reason the first task gets to run
for 20 milliseconds. The scheduler has to compensate for that past or it's
not fair.

> Some numbers based on your above description:
> Process 1 runs for 20msecs
> Process 2 runs for 2msecs  (20/10 == 2msecs)
> Process 3 runs for 2.2msecs (has waited 22msecs, 22/10 == 2.2)
> Process 4 runs for 2.4msecs (has waited 24.2msecs - rounded for brevity)
> Process 5 runs for 2.7msecs (has waited 26.6msecs - rounded for brevity)
> process 6 runs for 3msecs  (has waited 30.3msecs)
> process 7 runs for 3.3msecs (has waited approx. 33msecs)
> process 8 runs for 3.6msecs (has waited approx. 36msecs)
> process 9 runs for 3.9msecs (has waited approx. 39msecs)
> process 10 runs for 4.2msecs (has waited approx. 42msecs)

This is the scheduler making up for the assumed past that you got you into
this situation. It cannot simply predict a perfect distribution and apply it
because when it chooses how much CPU time to give process 2, it has no idea
how many processes will be ready to run when it chooses how much CPU time to
give process 10.

> Now if the "process time" isn't scaled to match the length of
> time that the
> process has spent waiting to get on the CPU you get some measure
> of fairness
> back, but even then the description of CFS you've given shows a
> fundamental
> unfairness.

What is that unfairness? That if there are 10 processes that want to run,
all things being equal, someone has to go first and someone has to go last?
That over a very short period of time, one process gets 100% of the CPU and
the others get none?

Yes. This fundamental unfairness is in every scheduler. The issue is what
you do to make up for this and create long-term fairness.

> However, if you meant that "the new process has spent 20msecs
> waiting to get
> on the CPU", then the rest of your description does show what I'd
> expect from
> a fair scheduler. If not, then I guess that CFS is only
> "Completely Fair" for
> significantly large values of "fair".

Same with every scheduler. It's fair over periods of time significantly
longer than the context switch interval.

> Hrm... Okay, so you're saying that "fair_clock" runs slower the
> more process
> there are running to keep the above run-up in "Time Spent on CPU"
> I noticed
> based solely on your initial example? If that is the case, then I
> can see the
> fairness - its just not visible from a really quick look at the
> code and the
> simplified description you gave earlier.

You have to long over a longer period of time and taking into account that
the scheduler also has to compensate for past inequities.

DS



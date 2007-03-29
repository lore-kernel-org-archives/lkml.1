Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbXC2HLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbXC2HLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 03:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934039AbXC2HLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 03:11:24 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3245 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038AbXC2HLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 03:11:24 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: RSDL v0.31
Date: Thu, 29 Mar 2007 00:10:23 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEMCCJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <460AFC35.5070806@tmr.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 29 Mar 2007 00:10:29 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 29 Mar 2007 00:10:31 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Bill Davidsen wrote:

> I agree for giving a process more than a fair share, but I don't think
> "latency" is the best term for what you describe later. If you think of
> latency as the time between a process unblocking and the time when it
> gets CPU, that is a more traditional interpretation. I'm not really sure
> latency and CPU-starved are compatible.

For CPU-starvation, I think 'nice' is always going to be the fix. If you
want a process to get more than its 'fair share' of the CPU, you have to ask
for that. I think the scheduler should be fair by default.

However, cleverness in the scheduler with latency can make things better
without being unfair to anyone. It's perfectly fair for a task that has been
blocked for awhile to pre-empt a CPU-limited task when it unblocks.

What I'm arguing is that if your task is CPU-limited and the scheduler is
fair, that's your fault -- nice it. If your task is suffering from poor
latency, and it's using less than its fair share of the CPU (because it is
not CPU-limited), that is something the scheduler can be smarter about.

Two things that I think can help improve interactivity without breaking
fairness are:

1) Keep a longer-term history of tasks that have yielded the CPU so that
they can be more likely to pre-empt when they are unblocked by I/O. (The
improved accounting accuracy may go a long way towards doing this. I
personally like exponential decay measurements of CPU usage.)

2) Be smart about things like pipes. When one process unblocks another
through a pipe, socket, or the like, do not pre-empt (this defeats batching
and blows out caches needlessly), but do try to schedule the unblocked
process soon. Don't penalize one process for unblocking another, that's a
good thing for it to do.

I believe that the process of making schedulers smarter and fairer (and
fixing bugs in them) will get us to a place where interactivity is superb
without sacrificing fairness among tasks at equal static priority.

Honestly, I have always been against aggressive pre-emption. I think as CPUs
get faster and timeslices get shorter, it makes less and less sense. In many
cases you are better off just making the task ready-to-run and allowing its
higher dynamic priority to make it next. I strongly believe this for cases
where the running task unblocked the other task. (I think in too many cases,
you blow out the caches and force a context switch on a task that was just a
few hundred instructions short of being finished with what it was doing as
you punish it for getting useful work done.)

DS



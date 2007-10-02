Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbXJBPiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbXJBPiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbXJBPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:37:55 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1726 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbXJBPhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:37:54 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Network slowdown due to CFS
Date: Tue, 2 Oct 2007 08:37:26 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEEEHDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <20071001155530.5661fdef@laptopd505.fenrus.org>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 02 Oct 2007 08:38:21 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 02 Oct 2007 08:38:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a combined response to Arjan's:

> that's also what trylock is for... as well as spinaphores...
> (you can argue that futexes should be more intelligent and do
> spinaphore stuff etc... and I can buy that, lets improve them in the
> kernel by any means. But userspace yield() isn't the answer. A
> yield_to() would have been a ton better (which would return immediately
> if the thing you want to yield to is running already somethere), a
> blind "yield" isn't, since it doesn't say what you want to yield to.

And Ingo's:

> but i'll attempt to weave the chain of argument one step forward (in the
> hope of not distorting your point in any way): _if_ the sched_yield()
> call in that memory allocator is done because it uses a locking
> primitive that is unfair (hence the memory pool lock can be starved),
> then the "guaranteed large latency" is caused by "guaranteed
> unfairness". The solution is not to insert a random latency (via a
> sched_yield() call) that also has a side-effect of fairness to other
> tasks, because this random latency introduces guaranteed unfairness for
> this particular task. The correct solution IMO is to make the locking
> primitive more fair _without_ random delays, and there are a number of
> good techniques for that. (they mostly center around the use of futexes)

So now I not only have to come up with an example where sched_yield is the
best practical choice, I have to come up with one where sched_yield is the
best conceivable choice? Didn't we start out by agreeing these are very rare
cases? Why are we designing new APIs for them (Arjan) and why do we care
about their performance (Ingo)?

These are *rare* cases. It is a waste of time to optimize them.

In this case, nobody cares about fairness to the service thread. It is a
cleanup task that probably runs every few minutes. It could be delayed for
minutes and nobody would care. What they do care about is the impact of the
service thread on the threads doing real work.

You two challenged me to present any legitimate use case for sched_yield. I
see now that was not a legitimate challenge and you two were determined to
shoot down any response no matter how reasonable on the grounds that there
is some way to do it better, no matter how complex, impractical, or
unjustified by the real-world problem.

I think if a pthread_mutex had a 'yield to others blocking on this mutex'
kind of a 'go to the back of the line' option, that would cover the majority
of cases where sched_yield is your best choice currently. Unfortunately,
POSIX gave us yield.

Note that I think we all agree that any program whose performance relies on
quirks of sched_yield (such as the examples that have been cited as CFS
'regressions') are broken horribly. None of the cases I am suggesting use
sched_yield as anything more than a minor optimization.

DS



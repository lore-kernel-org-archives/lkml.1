Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbXCUKnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbXCUKnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 06:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXCUKnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 06:43:49 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3939 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbXCUKns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 06:43:48 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: RSDL v0.31
Date: Wed, 21 Mar 2007 03:43:16 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEMNCGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070321075033.GA10368@elte.hu>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 21 Mar 2007 03:43:30 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 21 Mar 2007 03:43:30 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> there were multiple attempts with renicing X under the vanilla
> scheduler, and they were utter failures most of the time. _More_ people
> complained about interactivity issues _after_ X has been reniced to -5
> (or -10) than people complained about "nice 0" interactivity issues to
> begin with.

Unfortunately, nicing X is not going to work. It causes X to pre-empt any
local process that tries to batch requests to it, defeating the batching.
What you really want is X to get scheduled after the client pauses in
sending data to it or has sent more than a certain amount. It seems kind of
crazy to put such login in a scheduler.

Perhaps when one process unblocks another, you put that other process at the
head of the run queue but don't pre-empt the currently running process. That
way, the process can continue to batch requests, but X's maximum latency
delay will be the quantum of the client program.

> The vanilla scheduler's auto-nice feature rewards _behavior_, so it gets
> X right most of the time. The fundamental issue is that sometimes X is
> very interactive - we boost it then, there's lots of scheduling but nice
> low latencies. Sometimes it's a hog - we penalize it then and things
> start to batch up more and we get out of the overload situation faster.
> That's the case even if all you care about is desktop performance.
>
> no doubt it's hard to get the auto-nice thing right, but one thing is
> clear: currently RSDL causes problems in areas that worked well in the
> vanilla scheduler for a long time, so RSDL needs to improve. RSDL should
> not lure itself into the false promise of 'just renice X statically'. It
> wont work. (You might want to rewrite X's request scheduling - but if so
> then i'd like to see that being done _first_, because i just dont trust
> such 10-mile-distance problem analysis.)

I am hopeful that there exists a heuristic that both improves this problem
and is also inherently fair. If that's true, then such a heuristic can be
added to RSDL without damaging its properties and without requiring any
special settings. Perhaps longer-term latency benefits to processes that
have yielded in the past?

I think there are certain circumstances, however, where it is inherently
reasonable to insist that 'nice' be used. If you want a CPU-starved task to
get more than 1/X of the CPU, where X is the number of CPU-starved tasks,
you should have to ask for that. If you want one CPU-starved task to get
better latency than other CPU-starved tasks, you should have to ask for
that.

Fundamentally, the scheduler cannot do it by itself. You can create cases
where the load is precisely identical and one person wants X and another
person wants Y. The scheduler cannot know what's important to you.

DS



Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXDJIeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXDJIeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbXDJIeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:34:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33718 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXDJIeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:34:05 -0400
Message-ID: <461B4BF5.6070909@garzik.org>
Date: Tue, 10 Apr 2007 04:33:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>	<4616CBF0.7090606@garzik.org>	<20070409172339.48d661d6.akpm@linux-foundation.org>	<20070410015912.GE1994@redhat.com>	<20070409193056.6b52c354.akpm@linux-foundation.org>	<461B3754.9040107@garzik.org> <20070410003702.f8a49b75.akpm@linux-foundation.org>
In-Reply-To: <20070410003702.f8a49b75.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 10 Apr 2007 03:05:56 -0400 Jeff Garzik <jeff@garzik.org> wrote:
> 
>> My main 
>> worry with keventd is that we might get stuck behind an unrelated 
>> process for an undefined length of time.
> 
> I don't think it has ever been demonstrated that keventd latency is
> excessive, or a problem.  I guess we could instrument it and fix stuff
> easily enough.

It's simple math, combined with user expectations.

On a 1-CPU or 2-CPU box, if you have three or more tasks, all of which 
are doing hardware reset tasks that could take 30-60 seconds (realistic 
for libata, SCSI and network drivers, at least), then OBVIOUSLY you have 
other tasks blocked for that length of time.

Since the cause of the latency is msleep() -- the entire reason why the 
driver wanted to use a kernel thread in the first place -- it would seem 
to me that the simple fix is to start a new thread, possibly exceeding 
the number of CPUs in the box.


> The main problem with keventd has been flush_scheduled_work() deadlocks: the

That's been a problem in the past, yes, but a minor one.

I'm talking about a key conceptual problem with keventd.

It is easy to see how an extra-long tg3 hardware reset might prevent a 
disk hotplug event from being processed for 30-60 seconds.  And as 
hardware gets more complex -- see the Intel IOP storage card which runs 
Linux -- the reset times get longer, too.

So the issue is /not/ deadlocks.


> The thing to concentrate on here is the per-cpu threads, which is where the
> proliferation appears to be coming from.

Strongly agreed.

	Jeff



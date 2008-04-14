Return-Path: <linux-kernel-owner+w=401wt.eu-S1761707AbYDNXWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761707AbYDNXWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbYDNXWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:22:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023AbYDNXWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:22:06 -0400
Message-ID: <4803E711.8020008@redhat.com>
Date: Mon, 14 Apr 2008 19:21:53 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
References: <200804141547.57719.vda.linux@googlemail.com>
In-Reply-To: <200804141547.57719.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> Hi Ingo,
> 
> You are one of the experts in processes/threads and scheduling
> in Linux kernel, I hope you can answer this question.
> 
> A lot of effort went into minimizing of stack usage.
> If I understand it correctly, one of the reasons for this
> was to be efficient and not have lots of pages
> used for stacks when we have a lot of threads
> (tens of thousands).

If your application is using tens of thousands of threads on hardware that can't 
spare tens of megabytes to ensure that a thread will always have a kernel stack 
when it needs one, your application is horribly misdesigned.

> A random thought occurred to me: in a system with so many
> threads most of them are not executing anyway, even on
> that gigantic Altix machines. Do they all need to have
> kernel stack, all the time? I mean: the process which
> is running in user space is not using kernel stack at all.
> Process which is not running on a CPU right now
> is not using it either. But they do still consume
> at least 4k (or 8k on 64bits) of RAM.

If they're sleeping, they need a kernel stack.  If they're simply scheduled out, 
then your system is massively overloaded, and you need more CPUs or fewer threads.

> Process absolutely must have kernel stack only when
> it is actively running in kernel code (not sleeping),
> right?

It absolutely needs a kernel stack when it's sleeping in the kernel.  It does 
not really need a stack if it's simply scheduled out, but sleeping should be the 
typical case, if the application is designed and configured to operate efficiently.

> Can we have per-CPU kernel stacks instead, so that process
> gets a kernel stack only every time it enters the kernel;
> and make it so that the process which is scheduled away
> from a CPU does not need to have kernel stack?

You're essentially asking us to optimize forkbombs at the expense of 
well-designed applications.  Unless the cost is nearly zero (and it's not) we 
shouldn't do something like this.

> Currently, when process sleeps, we save some
> state in stack, and such a change may require
> some substantial surgery.

Yes, and that surgery will absolutely kill performance on the page fault and I/O 
paths, while only saving a few kilobytes of RAM on well-configured systems.

> Can you tell me whether this is possible at all,
> and how difficult you estimate it to be?

It may be possible, but it's certainly not a good idea.  Applications that 
suffer a performance hit due to kernel stack usage while scheduled out are 
poorly designed and need to be fixed.  The fraction of a percent performance 
boost they'd get from this change is nothing compared to the thousand percent 
speedup they'd get from using threads intelligently.

-- Chris

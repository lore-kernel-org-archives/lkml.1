Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYKJSBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYKJSBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYKJSBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:01:30 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55926 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbYKJSB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:01:29 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=O3xGMCujH7Xf8e9LYFosyHEncAcWddln8rrYkKkVQWZy4VO5wPTaaf4DbFJgED870
	eO5xk2kvcNYt0VDyWOP6w==
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Frank Mayhar <fmayhar@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1226328152.7685.192.camel@twins>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins>
	 <Pine.LNX.4.64.0811060900450.3595@quilx.com>
	 <1225984098.7803.4642.camel@twins>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
	 <1226053744.7803.5851.camel@twins>
	 <1226081448.28191.64.camel@bobble.smo.corp.google.com>
	 <1226089574.31966.85.camel@lappy.programming.kicks-ass.net>
	 <Pine.LNX.4.64.0811100834500.21257@quilx.com>
	 <1226328152.7685.192.camel@twins>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 10 Nov 2008 10:00:09 -0800
Message-Id: <1226340009.19109.17.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 15:42 +0100, Peter Zijlstra wrote:
> On Mon, 2008-11-10 at 08:38 -0600, Christoph Lameter wrote:
> > Can we at least somehow make sure that nothing significantly happens in a
> > timer interrupt on a processor if the thread has not scheduled any events
> > or not odone any system calls?
> Do threads actually scale that far? I thought mmap_sem contention and
> other shared state would render threads basically useless on these very
> large machines.
> 
> But afaiu this stuff, the per-cpu loop is only done when an itimer is
> actually active.

Correct.

> The detail I've not looked at is, if when this itimer is indeed active
> and we are running 256 threads of the same application on all cpus do we
> then do the per-cpu loop for each tick on each cpu?

The answer to this question is, "that depends."  You can have an itimer
for a single thread or for the whole thread group.  In the former case,
it never happens; it only does the loops for the thread group case.  If
there is a thread group itimer then of course we have to sum the tick
count across all CPUs to determine whether the timer has expired.

Personally, I would argue that it's silly to have an itimer running when
you have many threads, and if you care about performance it's even
_more_ silly.  But it's sillier yet to be able to wedge the kernel by
running a program in user space.

As far as Christoph's concern regarding latency for 8- and 16-processor
systems, my belief (supported by data I can't discuss, sigh) is that the
loop adds negligible latency.  In fact, it can't really be discussed in
this way since the existing implementation adds *lots* of latency when
an itimer is running, since it sums the values across all threads.  I
never collected latency versus number of threads data but it's bad
enough that at about 4500 threads (on a dual amd64) it took longer than
a tick to do a tick's worth of processing.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.


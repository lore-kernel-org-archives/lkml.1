Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYKJPmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYKJPmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYKJPmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:42:11 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:48404 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbYKJPmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:42:10 -0500
Date: Mon, 10 Nov 2008 09:41:25 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Frank Mayhar <fmayhar@google.com>, Doug Chapman <doug.chapman@hp.com>,
       mingo@elte.hu, roland@redhat.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
In-Reply-To: <1226328152.7685.192.camel@twins>
Message-ID: <Pine.LNX.4.64.0811100937250.22539@quilx.com>
References: <1224694989.8431.23.camel@oberon>  <1225132746.14792.13.camel@bobble.smo.corp.google.com>
  <1225219114.24204.37.camel@oberon>  <1225936715.27507.44.camel@bobble.smo.corp.google.com>
  <1225969420.7803.4366.camel@twins>  <Pine.LNX.4.64.0811060900450.3595@quilx.com>
  <1225984098.7803.4642.camel@twins>  <1226015568.2186.20.camel@bobble.smo.corp.google.com>
  <1226053744.7803.5851.camel@twins>  <1226081448.28191.64.camel@bobble.smo.corp.google.com>
  <1226089574.31966.85.camel@lappy.programming.kicks-ass.net> 
 <Pine.LNX.4.64.0811100834500.21257@quilx.com> <1226328152.7685.192.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Peter Zijlstra wrote:

> > Can we at least somehow make sure that nothing significantly happens in a
> > timer interrupt on a processor if the thread has not scheduled any events
> > or not odone any system calls?
>
> Do threads actually scale that far? I thought mmap_sem contention and
> other shared state would render threads basically useless on these very
> large machines.

They scale well. The problem is startup when they concurrently allocate
memory. That has been solved with distributing the pte locks. mmap_sem is
taken for read in the fault handler. So you have a wildly bouncing
cacheline at startup time that causes performance issues but no busy
spinning.

> But afaiu this stuff, the per-cpu loop is only done when an itimer is
> actually active.
>
> The detail I've not looked at is, if when this itimer is indeed active
> and we are running 256 threads of the same application on all cpus do we
> then do the per-cpu loop for each tick on each cpu?

I would check how 8p and 16p fare with this? How much potential latency is
added to  thread because it is interrupted and the timer interrupt goes
through this loop?

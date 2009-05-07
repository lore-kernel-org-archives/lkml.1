Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbZEGRKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbZEGRKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbZEGRKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:10:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:49150 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbZEGRKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:10:09 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0905071010170.24528@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>
	 <1241560625.8665.17.camel@alok-dev1>
	 <alpine.DEB.1.10.0905071010170.24528@qirst.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 19:07:33 +0200
Message-Id: <1241716053.6311.1514.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 10:13 -0400, Christoph Lameter wrote:
> I think we need to reduce the general tick frequency to be as low as
> possible. With high resolution timers the tick frequency is just the
> frequency with which the timer interrupt disturbs a running application.
> 
> Are there any benefits remaining from frequent timer interrupts? I would
> think that 60 HZ would be sufficient.
> 
> It would be good if the kernel would be truly tickless. Scheduler events
> would be driven by the scheduling intervals and not the invokations of the
> scheduler softirq.

The only thing that's driven by the softirq is load-balancing, there's
way more to the scheduler-tick than kicking that thing awake every so
often.

The problem is that running the scheduler of off hrtimers is too
expensive. We have the code, we tried it, people complained.

Another random user that relies on the jiffy tick is
CLOCK_THREAD_CPUTIME_ID posix timers, although I'm planning to convert
that to hrtimers some time in the future.

We also use the scheduler tick to generate a somewhat coupled time
source from flaky TSCs -- reducing HZ decreases the accuracy. This is
something only fixable in hardware by providing a proper (and cheap)
high resolution clock source -- nehalem class machines have such a
thing, provided you stick to one (maybe two) sockets [s390, ppc64 and
sparc64 also rule].




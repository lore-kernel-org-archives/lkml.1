Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075Ab0AMQmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab0AMQmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967Ab0AMQmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:42:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:57515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab0AMQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:42:53 -0500
Subject: Re: introduce NMI_AUTO as nmi_watchdog option
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       aris@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100113162534.GX24885@redhat.com>
References: <20100111191633.GT24885@redhat.com>
	 <20100111202729.GI4923@lenovo> <20100111203356.GU24885@redhat.com>
	 <20100113093240.GC6739@elte.hu> <1263388422.4244.214.camel@laptop>
	 <20100113162534.GX24885@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 17:42:47 +0100
Message-ID: <1263400967.4244.246.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 11:25 -0500, Don Zickus wrote:
> On Wed, Jan 13, 2010 at 02:13:42PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-01-13 at 10:32 +0100, Ingo Molnar wrote:
> > > other architectures have NMI concepts as well, such as Sparc64. 
> > 
> > I think both sparc64 and ppc64 fake NMIs by playing games with hw IRQ
> > priorities and partial masks. But yes.
> > 
> > One interesting 'feature' for the perf-nmi interaction is creating an
> > idle scheduling class for counters, because as long as there is a
> > counter present you can use his NMIs to drive the watchdog, but as soon
> > as there are non left, you need to install one.
> 
> Interesting idea.  How can I guarantee the frequency of the NMI I want to
> piggyback off of?  A breakpoint that takes an hour to trigger may not be
> the best NMI to use?  Then again I am still trying to understand the perf
> event code a little better.

You could play games with the period, we can handle getting more NMIs
than are needed. This is how we implement a period larger than the
physical counter for example.

But yeah, its a tricky game since a tight loop might never generate the
event we're counting.. we could limit this to things like
cycles/ins/bus-cycles etc.. those will always tick.

Anyway, its all an optimization, the simple/first implementation would
simply install a kernel cpu perf counter and hook the overflow handler.


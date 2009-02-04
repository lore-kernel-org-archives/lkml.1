Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZBDCSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZBDCSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZBDCS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:18:28 -0500
Received: from ozlabs.org ([203.10.76.45]:54482 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZBDCS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:18:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18824.64228.358045.890823@cargo.ozlabs.ibm.com>
Date: Wed, 4 Feb 2009 13:18:12 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Maynard Johnson <mpjohn@us.ibm.com>, carll@us.ibm.com
Subject: Re: Performance counter API review was [patch] Performance
 Counters for Linux, v3
In-Reply-To: <1233606782.10184.4.camel@laptop>
References: <20081211155230.GA4230@elte.hu>
	<87r64ag68n.fsf@basil.nowhere.org>
	<49875199.3010609@linux.vnet.ibm.com>
	<1233606782.10184.4.camel@laptop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Doing a single fd for all cpus is going to suck chunks because its going
> to be a global serialization point.

If we need statistics for the system as a whole (and we do), then the
serialization is going to happen somewhere - the only question is
whether it's in the kernel or in userspace.  I don't see that it needs
to be a _global_ serialization point in either case.  Given that the
kernel has facilities like smp_call_function() available that
userspace doesn't, I think it will end up cleaner to do it in the
kernel.

That's actually a bit independent of whether it should be accessed via
one fd or multiple fds.  One alternative might be to use something
analogous to the counter group concept we have (i.e. multiple fd's,
but have a way to logically join them together).

By the way, how does userspace get to know about cpus being added or
removed?  Is there a better way than continually reading
/sys/devices/system/cpu/online?

> Also, why would you be profiling while doing a hotplug? Both cpu
> profiling, and hotplug, are administrator operations, just don't do
> that.

Performance counters are also used for counting, which by definition
is something that takes place over a period of time, possibly quite a
long time.  It would be annoying to have to stop counting and start a
new count every time we need to plug or unplug a cpu.

> The inheritance thing will also suffer this issue, if you're going to do
> reads of your fds at any other point than at the end -- it will have to
> walk the whole inheritance tree and sum all the values (or propagate
> interrupts up the tree). Which sounds rather expensive.

I'm planning to make that operation (summing over all children) be
something that userspace can request via an ioctl, so userspace gets
to decide when and how often it's worth the expense of doing it.

Paul.

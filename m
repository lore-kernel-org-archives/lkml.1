Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZLAObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZLAObT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZLAObS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:31:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42980 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbZLAObS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:31:18 -0500
Date: Tue, 1 Dec 2009 15:31:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jamie Iles <jamie@jamieiles.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Perf events/ARM
Message-ID: <20091201143105.GB1183@elte.hu>
References: <20091201120439.GB4061@wear.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201120439.GB4061@wear.picochip.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jamie Iles <jamie@jamieiles.com> wrote:

> Hi,
> 
> I'm looking at adding support for the hardware performance counters in ARMv6
> using the new perf events framework. I have a simple setup that uses the
> counters on their own, but wrt the perf events framework:
> 
> 	- what are the requirements of set_perf_event_pending() and
> 	perf_event_do_pending()? As far as I can tell from sparc/x86/powerpc,
> 	set_perf_event_pending() triggers an interrupt that then calls
> 	perf_event_do_pending(). Does perf_event_do_pending need to run in
> 	interrupt context or could I use a soft IRQ if platforms don't have a
> 	spare IRQ?

softirq would be fine too i suspect - but then you need to increase the 
buffering of perf_pending_head, as multiple hardirqs could hit before 
the softirq processing has finished.

As that gets complex quick, an acceptable first-order approach would be 
to just ignore those lost events and run it from a softirq - i _think_ 
everything should be OK.

> 	- ARM does not have proper support for atomic64's. Other than
> 	performance, would there be any known problems with using the generic
> 	spinlocked atomic64's?

Not a problem at all. Even performance-wise they are pretty nice - Paul 
has done a nice job hashing it along 16 spinlocks - so for small SMP 
systems there should be no global cacheline bounce.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYJQRZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYJQRZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYJQRZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:25:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58156 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbYJQRZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:25:19 -0400
Date: Fri, 17 Oct 2008 13:25:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch 15/15] LTTng timestamp x86
Message-ID: <20081017172515.GA9639@goodmis.org>
References: <20081016232729.699004293@polymtl.ca> <20081016234657.837704867@polymtl.ca> <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org> <20081017012835.GA30195@Krystal> <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 07:19:48PM -0700, Luck, Tony wrote:
> > This cache-line bouncing global clock is a best-effort to provide
> > correct event order in the trace on architectures with unsync tsc. It's
> > actually better than a global tracing buffer because it limits the
> > number of cache line transfers required to one per event.
> 
> Even one line bouncing between cpus can be a performamce disaster.
> You'll probably hit a serious wall somewhere between 8 and 16
> cpus (ia64 has code that looks a lot like this in the gettimeofday()
> path because it does not synchronize cpu cycle counters ... some
> applications that are overly fond of timestamping internal
> events using gettimeofday() end up spending significant time
> doing so on large systems ... even with only a few thousands
> of calls per second).
> 

I agree that one cache line bouncer is devastating to performance. But
as Mathieu said, it is better than a global tracer with lots of bouncing
going on. My logdev tracer (something similar to ftrace, but used only
for debugging) use to have a single buffer. By moving it to a per cpu
buffer and using an atomic counter to sort the events, the increase of
speed was a few magnitudes.

ftrace does not have a global counter, but on some boxes with out of
sync TSCs, it could not find race conditions. I had to pull in logdev,
which found the race right away, because of this atomic counter.

logdev adds a bit of perfomance degradation, but for debugging, I don't
care, and it has helped me quite a bit.

ftrace can help in debugging most of the time, but on some boxes with
wacky time stamps, it is useless to find race problems between CPUS. But
ftrace is for production, and can not afford the performance penalty of
a global counter.

-- Steve


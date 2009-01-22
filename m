Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbZAVIlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbZAVIlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZAVIlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:41:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZAVIla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:41:30 -0500
Date: Thu, 22 Jan 2009 09:41:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] trace: do not disable wake up tracer on output of
	trace
Message-ID: <20090122084105.GD7438@elte.hu>
References: <20090121235306.224764198@goodmis.org> <20090121235805.771064570@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121235805.771064570@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0430]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: fix to erased trace output
> 
> To try not to have the outputing of a trace interfere with the wakeup 
> tracer, it would disable tracing while the output was printing. But if a 
> trace had started when it was disabled, it can show a partial trace. To 
> try to solve this, on closing of the tracer, it would clear the trace 
> buffer.
> 
> The latency tracers (wakeup and irqsoff) have two buffers. One for 
> recording and one for holding the max trace that is printed. The 
> clearing of the trace above should only affect the recording buffer. But 
> for some reason it would move the erased trace to the print buffer. 
> Probably due to a race with the closing of the trace and the saving ofhe 
> max race.

hm, that race needs to be fixed then.

> The above is all pretty useless, and if the user does not want the 
> printing of the trace to be traced itself, then the user can manual 
> disable tracing. This patch removes all the code that tries to keep the 
> output of the tracer from modifying the trace.

printing of the trace should not be traced. I cannot imagine any usage 
mode where that would be interesting - and i can imagine a ton of cases 
where users would be confused/distracted by the tracer in essence zapping 
their measurement by replacing it with some uninteresting 'the tracer 
itself has wakeup delays' data.

auto-disabling latency tracing while the trace is being output is 
essential. Measurement should never impact the workload that is being 
measured.

We should fix that race instead.

	Ingo

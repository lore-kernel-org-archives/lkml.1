Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbYKMJPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbYKMJPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKMJPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:15:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53834 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYKMJPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:15:02 -0500
Date: Thu, 13 Nov 2008 10:14:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call
	prepare_ftrace_return by registers
Message-ID: <20081113091454.GH25479@elte.hu>
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu> <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com> <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com> <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com> <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com> <20081113085949.GG25479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113085949.GG25479@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Or perhaps we could name it the "callgraph" tracer? (as opposed to 
> the simpler function tracer which traces function entries) Note that 
> we could use the output to build function call coverage graphs.
> 
> It definitely must convey the idea that this is a more capable (and 
> also more expensive) form of function tracing.

on a related note.

Frederic, it would be nice to fine-tune the tracer output to convey 
the callgraph information more clearly. Here's a mockup of a good 
default output:

  getnstimeofday() {
   set_normalized_timespec() {
    clocksource_read() {
     acpi_pm_read()                     ( 1547 ns)
    } clocksource_read()                ( 1951 ns)
   } set_normalized_timespec()          ( 2200 ns)
  } getnstimeofday()                    ( 2354 ns)

  [...]

Such output would be _very_ nice and intuitive to have. Developers 
would love it instantly. Note its C-ish syntax - that is obviously the 
easiest to parse for kernel developers.

and note how natural it will be in the future to embellish certain 
function calls in the above trace, for example with function 
arguments:

    clocksource_read("acpi_pm") {

i'd suggest to hide the offset bit of the ksym (like the mockup does 
it - unless a tracing_option is set for more verbose symbol output). 
For these traces it's almost always useless and the context tells us 
in 99% of the cases where a function got called.

Easiest would be to add a depth field to the trace entry as well, to 
make sure we get the right depth in the end, even if we somehow mix up 
the trace entries.

We could also trace function entry and exit separately, and 
post-process the call stack (and the cost) during trace output 
formatting - not during tracing.

Hm?

	Ingo

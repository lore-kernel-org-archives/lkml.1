Return-Path: <linux-kernel-owner+w=401wt.eu-S1751671AbYKMKJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbYKMKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYKMKJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:09:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42017 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbYKMKJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:09:44 -0500
Date: Thu, 13 Nov 2008 11:09:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call
	prepare_ftrace_return by registers
Message-ID: <20081113100938.GA24602@elte.hu>
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu> <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com> <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com> <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com> <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com> <20081113085949.GG25479@elte.hu> <20081113091454.GH25479@elte.hu> <c62985530811130202r7721c927w58beb34ec92c34f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811130202r7721c927w58beb34ec92c34f7@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> That's right, it's much more better for the eyes. I didn't want to 
> output such a disposition from the kernel because I thought that 
> would result in too much strings work from kernel-space. But 
> actually, as you suggest,
>  if I append a depth field in the trace that could be easy and not 
> so costly. I just have a last thought about post-processing parsing. 
> Would it make it harder for that?

humans are the priority targets for tracer output - tools are a 
distant second target. Whatever is nice for humans is also usually 
easy to process via tools. A tool can set an option flag just fine.

To help tooling, add a trace_options flag for more predictable/faster 
output. We already have the binary output format for example.

> Why not a flag that could be set through iter_ctrl (which has 
> changed its name yesterday) and that could let the user to choose 
> its output? That's where I renew my proposition to make the tracers 
> able to propose custom flags for this file with a new callback such 
> as tracer_ctrl, or tracer_opt.

yes, your proposal is fine.

> But as you say, why not set it through a flag.

yes - and make the defaults for flags favor human visual parsing.

> > Easiest would be to add a depth field to the trace entry as well, to
> > make sure we get the right depth in the end, even if we somehow mix up
> > the trace entries.
> 
> Yeah, that's good! I will just have to output "\t" * depth to have 
> the correct indentation.

i'd suggest spaces for the function indentation, because we'll also 
have quite deep call stacks in practice.

and i'd suggest you flip around the cost field to something like:

 [...]
               getnstimeofday() {
                set_normalized_timespec() {
                 clocksource_read() { 
 ( 1547 ns)       acpi_pm_read()                     
 ( 1951 ns)      } clocksource_read()
 ( 2200 ns)     } set_normalized_timespec()
 ( 2354 ns)    } getnstimeofday()

that makes it fixed-width up to the inevitable variable-length field, 
the function name.

	Ingo

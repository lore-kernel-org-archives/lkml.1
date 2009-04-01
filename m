Return-Path: <linux-kernel-owner+w=401wt.eu-S1762487AbZDALfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762487AbZDALfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762232AbZDALe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:34:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38003 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761839AbZDALe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:34:57 -0400
Date: Wed, 1 Apr 2009 13:34:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 1/21] x86, bts: fix race when bts tracer is removed
Message-ID: <20090401113438.GA23678@elte.hu>
References: <20090331145051.A12111@sedona.ch.intel.com> <20090331234823.GB28228@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E926D5095@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E926D5095@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Oleg Nesterov [mailto:oleg@redhat.com]
> >Sent: Wednesday, April 01, 2009 1:48 AM
> >To: Metzger, Markus T
> >Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
> >markus.t.metzger@gmail.com; roland@redhat.com; eranian@googlemail.com; Villacis, Juan;
> >ak@linux.jf.intel.com
> >Subject: Re: [patch 1/21] x86, bts: fix race when bts tracer is removed
> >
> >On 03/31, Markus Metzger wrote:
> >>
> >> Read the tracer once during a context switch.
> >> ...
> >> @@ -1044,36 +1051,39 @@ void ds_switch_to(struct task_struct *pr
> >>  {
> >>  	struct ds_context *prev_ctx = prev->thread.ds_ctx;
> >>  	struct ds_context *next_ctx = next->thread.ds_ctx;
> >> +	unsigned long debugctlmsr = next->thread.debugctlmsr;
> >>
> >>  	if (prev_ctx) {
> >> +		struct bts_tracer *tracer = prev_ctx->bts_master;
> >> +
> >>  		update_debugctlmsr(0);
> >>
> >> -		if (prev_ctx->bts_master &&
> >> -		    (prev_ctx->bts_master->trace.ds.flags & BTS_TIMESTAMPS)) {
> >> +		if (tracer && (tracer->flags & BTS_TIMESTAMPS)) {
> >
> >In theory, we need barrier() after reading ->bts_master.
> >
> >(actually, I did see the bug reports when the compiler read the pointer
> > twice with the code like above).
> 
> I guess the same is true for prev_ctx, next_ctx, and debugctlmsr, then.
> 
> Ingo,
> would it be OK to resend this one patch with the barrier()s added?

Sure - but note that i have put the series on hold until you get 
broad Ack's from Oleg for the ptrace bits. Please fix the review 
feedback from Oleg and propagate his acks into the commit logs as 
well. Oleg is finding bugs we missed in the past so his review work 
is very valuable.

Also - minor patch submission technicality observation: currently 
each of your mails goes into a separate discussion thread, making it 
hard to review them as a group.

The preferred way to send such series is to use "git format-patch" + 
"git send-email". (That will give a nice 0/21 mail and a properly 
threaded discussion with proper References header lines.)

Thanks,

	Ingo

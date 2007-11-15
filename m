Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbXKOTff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbXKOTff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbXKOTf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:35:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071AbXKOTf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:35:26 -0500
Date: Thu, 15 Nov 2007 20:34:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071115193424.GA31691@elte.hu>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473C825E.3030307@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Lord <lkml@rtr.ca> wrote:

>> Can you try nohz=off highres=off? Strange stuff is happening with 
>> nohz.
>
> (added Ingo to CC: list: maybe this is some weird interaction with CFS 
> and jiffies being reset to 0 on resume ??)

hm, CFS should have no impact here. To see what's happening you could 
try to use the latency tracer of the -rt patch and do a cross-resume 
trace.

pick up the latest latency tracer patch from:

  http://redhat.com/~mingo/private/latency-tracer-v2.6.24-rc2-git5-combo.patch

apply it and enable CONFIG_FUNCTION_TRACING, then pick up trace-cmd.c:

  http://redhat.com/~mingo/private/trace-cmd.c

and do something like:

  ./trace-cmd pm-suspend > trace.txt

or:

  ./trace-cmd /bin/bash -c "echo ram > /sys/power/state" > trace.txt

this should trigger suspend - then you should do the resume. If 
everything goes well then trace.txt should contain a pretty large trace 
of all the stuff we do during a suspend+resume.

and wait for such a pause and send us the resulting trace.txt.

if it's an SMP box then first do:

  echo 1 > /proc/sys/kernel/trace_all_cpus

to get a global trace. Let me know if something doesnt work with this 
scheme.

	Ingo

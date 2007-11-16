Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbXKPHQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbXKPHQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 02:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXKPHQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 02:16:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbXKPHQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 02:16:31 -0500
Date: Fri, 16 Nov 2007 08:15:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071116071522.GA1453@elte.hu>
References: <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <473CC6D4.2010909@rtr.ca> <20071116055531.GA16273@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116055531.GA16273@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Is there a version of these that works with 2.6.23.1 ?
> 
> yes, i've backported it and have uploaded the v2.6.23 version to:
> 
>   http://redhat.com/~mingo/latency-tracing-patches/latency-tracer-v2.6.23.1-combo.patch

btw., if the trace is too large and the interesting section of suspend 
does not fit into it then you can narrow it down to the most important 
events only by changing this in trace-cmd.c:

        system("echo 1 > /proc/sys/kernel/mcount_enabled");

to:

        system("echo 0 > /proc/sys/kernel/mcount_enabled");

that way we'll still trace IRQs and scheduling events, which is enough 
to see roughly where the delay is happening. To include symbolic 
backtraces in the trace, do this:

	echo 1 > /proc/sys/kernel/stackframe_tracing

to get such trace entries:

      ls 3688  1D..3 4642us+: deactivate_task <ls 3688> (0 0)
      ls 3688  1D..3 4644us+: schedule()<-do_exit()<-sys_exit_group()<-sys_exit_group()
      ls 3688  1D..3 4647us+: sysenter_past_esp()<-(   -1)()<-(    0)()<-(    0)()
  <idle> 0     1D..2 4652us : schedule <ls 3688> (0 20)

this way we can see why a task goes to sleep and which exact kernel 
codepath is waking it up.

	Ingo

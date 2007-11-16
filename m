Return-Path: <linux-kernel-owner+w=401wt.eu-S1764473AbXKPLYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764473AbXKPLYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbXKPLYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:24:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668AbXKPLYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:24:10 -0500
Date: Fri, 16 Nov 2007 12:23:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
       Len Brown <lenb@kernel.org>
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071116112317.GA12724@elte.hu>
References: <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <473CC6D4.2010909@rtr.ca> <20071116055531.GA16273@elte.hu> <20071116071522.GA1453@elte.hu> <20071116082146.GA14685@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116082146.GA14685@elte.hu>
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

> once that tracer bug was fixed, the best method to generate a trace 
> was to do this:
> 
>    echo 1 > /proc/sys/kernel/stackframe_tracing
>    echo 1 > /proc/sys/kernel/syscall_tracing
>    ./trace-cmd bash -c "echo mem > /sys/power/state" > trace.txt

so here's an UP suspend+resume trace i did:

  http://redhat.com/~mingo/latency-tracing-patches/misc/trace-suspend-long.txt.bz2

tons of detail - which might be interesting to other folks as well. Fact 
is, our suspend-to-RAM+resume cycle is very, very slow, even on fast 
hardware - and this trace shows all the reasons why.

This was a fully cached system - i.e. i've done a suspend+resume before 
to warm up the caches. (not that suspend+resume does much IO normally.)

The trace shows that a suspend+resume cycle is 7.95 seconds long 
(without counting the time the box spent suspended) - ouch! This was a 
T60 with Core2Duo 1.83GHz.

For example here is where freezing starts:

    bash-2397  0.... 31686us : remove_wait_queue (vt_waitactive)
    bash-2397  0.... 31688us : freeze_processes (enter_state)
    bash-2397  0.... 31689us : printk (freeze_processes)

here is where the ACPI code triggers the suspend:

    bash-2397  0D... 1904138us : acpi_hw_low_level_write (acpi_hw_register_write)

but this is a whopping 1.9 seconds into the trace already!

first sign of life after i opened the laptop lid again:

    bash-2397  0D... 1904138us : __restore_processor_state (restore_processor_state)
    bash-2397  0D... 1904138us : enable_sep_cpu (__restore_processor_state)

(in the trace there's no delay visible - the period of time spent 
suspended is not visible to the tracer.)

One good way to start looking at such traces is to filter out 
rescheduling events alone:

  grep ': schedule <'  trace-suspend-long.txt

that gives a rough outline of what's going on:

   <idle>-0     0D... 1776566us : schedule <bash-2397> (0 20)
     bash-2397  0D... 1786748us : schedule <<idle>-0> (20 0)
 scsi_eh_-419   0D... 1786814us : schedule <bash-2397> (0 -5)
     bash-2397  0D... 1786960us : schedule <scsi_eh_-419> (-5 0)
 scsi_eh_-421   0D... 1787020us : schedule <bash-2397> (0 -5)
     bash-2397  0D... 1787125us : schedule <scsi_eh_-421> (-5 0)

so you can zoom in on the real area of interest by searching for the 
timestamp.

Hope this helps,

	Ingo

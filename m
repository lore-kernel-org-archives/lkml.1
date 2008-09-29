Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYI2Ihh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYI2Ihh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYI2Iha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:37:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYI2Ih3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:37:29 -0400
Date: Mon, 29 Sep 2008 10:37:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
Message-ID: <20080929083709.GD18663@elte.hu>
References: <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com> <48D9460C.5040504@yahoo.com> <48D96725.1080909@yahoo.com> <20080927204834.GA31650@elte.hu> <48DFEF8A.3000502@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DFEF8A.3000502@yahoo.com>
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


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Ingo Molnar wrote:
>> does it get better if you have CONFIG_PREEMPT_VOLUNTARY=y enabled? That 
>> 
>
> CONFIG_PREEMPT_VOLUNTARY=y has always been enabled in these results.

okay - then this definitely needs fixed.

>> _should_ break up this section neatly. If it doesnt then please add a  
>> might_sleep() check to kernel/kernel/semaphore.c's down_timeout()  
>> function - that is called a number of times in this trace.
>
> I added might_sleep() to the start of down_timeout() but it neither 
> printed anything to dmesg nor changed the latency issue...
>
> Strangely stalling only seems to turn up in linux-tip kernels with 
> very little debugging options set within them. I have a linux-tip that 
> has lots of extra debugging options set and this problem doesn't show 
> up...
>
> I've also asked about this on the ACPI mailing list and had a huge 
> amount of help from finding a good point for a cond_resched - 
> http://marc.info/?l=linux-acpi&m=122236450105747&w=2 . Certain things 
> (like games) still stutter when the battery is read but it's enough to 
> play back sound in rhythmbox without stuttering.
>
> Any ideas why the issue would go away with a debug kernel though?

hm, that's weird indeed. You could try to trace the full battery readout 
itself, via a script like this:

  cat /debug/tracing/trace > /dev/null        # drain trace
  cat /proc/acpi/whatever  
  cat /debug/tracing/trace > trace.txt

this way you should be seeing a full trace of the whole thing. (with the 
'ftrace' tracer plugin set in current_tracer)

then, assuming the trace.txt is complete, you can check where it 
reschedules and why. Search for 'schedule' calls. Compare the debug 
versus non-debug traces.

You can even turn on stack backtrace tracing feature, via:

  echo stacktrace > /debug/tracing/iter_ctrl

this adds extra trace entries that show the call path of every 
reschedule. [this attribute is default-disabled.]

	Ingo

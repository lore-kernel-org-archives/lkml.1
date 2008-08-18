Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbYHRImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbYHRImX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYHRImP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:42:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbYHRImO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:42:14 -0400
Date: Mon, 18 Aug 2008 10:42:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: a.p.zijlstra@chello.nl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scale sysctl_sched_shares_ratelimit with nr_cpus
Message-ID: <20080818084201.GA25432@elte.hu>
References: <37E52D09333DE2469A03574C88DBF40F024EBD2F@pdsmsx414.ccr.corp.intel.com> <20080818065220.GA2711@elte.hu> <37E52D09333DE2469A03574C88DBF40F024EBD69@pdsmsx414.ccr.corp.intel.com> <20080818070147.GA4801@elte.hu> <37E52D09333DE2469A03574C88DBF40F024EBE06@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37E52D09333DE2469A03574C88DBF40F024EBE06@pdsmsx414.ccr.corp.intel.com>
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


* Zhang, Yanmin <yanmin.zhang@intel.com> wrote:

> >>Does a scheduler trace show anything about why that drop happens? Do
> >>something like this to trace the scheduler:
> >>
> >>assuming debugfs is mounted under /debug and CONFIG_SCHED_TRACER=y:
> >>
> >>  echo 1 > /debug/tracing/tracing_cpumask
> >>  echo sched_switch > /debug/tracing/available_tracers
> >>  cat /debug/tracing/trace_pipe > trace.txt
> [YM] Thanks for your good pointer. I collected the data and didn't find
> anything abnormal except the pid about waker.
> 
>     Receiver-197-13665 [00]  1369.966423:  13665:120:R   + 13607:120:S
>     Receiver-197-13665 [00]  1369.966440:  13665:120:R   + 13611:120:S
>     Receiver-197-13665 [00]  1369.966458:  13665:120:R   + 13615:120:S
>     Receiver-197-13665 [00]  1369.966463:  13665:120:R   + 13619:120:S
>     Receiver-197-13665 [00]  1369.966466:  13665:120:R   + 13623:120:S
>     Receiver-197-13665 [00]  1369.966469:  13665:120:R   + 13627:120:S
>     Receiver-197-13665 [00]  1369.966475:  13665:120:R   + 13631:120:S
>     Receiver-197-13665 [00]  1369.966480:  13665:120:R   + 13635:120:S
>     Receiver-197-13665 [00]  1369.966485:  13665:120:R   + 13639:120:S
>     Receiver-197-13665 [00]  1369.966495:  13665:120:R   + 13643:120:S
>     Receiver-197-13665 [00]  1369.966507:  13871:120:R   + 13647:120:S
> Above waker pid is 13871 while the current pid is 13665. I found lots of
> such mismatch data.
> 
>     Receiver-197-13665 [00]  1369.966513:  13465:120:R   + 13651:120:S
>     Receiver-197-13665 [00]  1369.966516:  13665:120:R   + 13655:120:S
>     Receiver-197-13665 [00]  1369.966521:  13665:120:R   + 13659:120:S
>     Receiver-197-13665 [00]  1369.966530:  13665:120:R   + 13667:120:S
>     Receiver-197-13665 [00]  1369.966544:  13883:120:R   + 13663:120:S
>     Receiver-197-13665 [00]  1369.966549:  13665:120:R ==> 13667:120:R
>       Sender-140-13667 [00]  1369.966573:  13351:120:R   + 13668:120:S
>       Sender-140-13667 [00]  1369.966578:  13667:120:R ==> 13659:120:R
> 
> 
> BTW, I analyzed schedstat data and found wake_affine and 
> load_balance_newidle seem abnormal. 2.6.27-rc has more task pulls. I 
> set CONFIG_GROUP_SCHED=n with above testing.

hm, does this mean there's too much idle time during the testrun, 
because we dont load-balance agressively enough?

	Ingo

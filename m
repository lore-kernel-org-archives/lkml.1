Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbYHRI0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbYHRI0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYHRI0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:26:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:15398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYHRI0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:26:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,227,1217833200"; 
   d="scan'208";a="430029989"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: scale sysctl_sched_shares_ratelimit with nr_cpus
Date: Mon, 18 Aug 2008 16:26:09 +0800
Message-ID: <37E52D09333DE2469A03574C88DBF40F024EBE06@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20080818070147.GA4801@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: scale sysctl_sched_shares_ratelimit with nr_cpus
Thread-Index: AckBAFYfepk6YueYRvGhR8UVhn2FQgACnlYA
References: <37E52D09333DE2469A03574C88DBF40F024EBD2F@pdsmsx414.ccr.corp.intel.com> <20080818065220.GA2711@elte.hu> <37E52D09333DE2469A03574C88DBF40F024EBD69@pdsmsx414.ccr.corp.intel.com> <20080818070147.GA4801@elte.hu>
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Aug 2008 08:26:13.0096 (UTC) FILETIME=[133FE680:01C9010C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>-----Original Message-----
>>From: Ingo Molnar [mailto:mingo@elte.hu]
>>Sent: Monday, August 18, 2008 3:02 PM
>>To: Zhang, Yanmin
>>Cc: a.p.zijlstra@chello.nl; Linux Kernel Mailing List
>>Subject: Re: scale sysctl_sched_shares_ratelimit with nr_cpus
>>
>>
>>* Zhang, Yanmin <yanmin.zhang@intel.com> wrote:
>>
>>> >>cool. It's already upstream (post-rc3 commit):
>>> [YM] But comparing with 2.6.26, volanoMark result still has about
60%
>>> regression.
>>
>>Does a scheduler trace show anything about why that drop happens? Do
>>something like this to trace the scheduler:
>>
>>assuming debugfs is mounted under /debug and CONFIG_SCHED_TRACER=y:
>>
>>  echo 1 > /debug/tracing/tracing_cpumask
>>  echo sched_switch > /debug/tracing/available_tracers
>>  cat /debug/tracing/trace_pipe > trace.txt
[YM] Thanks for your good pointer. I collected the data and didn't find
anything abnormal except the pid about waker.

    Receiver-197-13665 [00]  1369.966423:  13665:120:R   + 13607:120:S
    Receiver-197-13665 [00]  1369.966440:  13665:120:R   + 13611:120:S
    Receiver-197-13665 [00]  1369.966458:  13665:120:R   + 13615:120:S
    Receiver-197-13665 [00]  1369.966463:  13665:120:R   + 13619:120:S
    Receiver-197-13665 [00]  1369.966466:  13665:120:R   + 13623:120:S
    Receiver-197-13665 [00]  1369.966469:  13665:120:R   + 13627:120:S
    Receiver-197-13665 [00]  1369.966475:  13665:120:R   + 13631:120:S
    Receiver-197-13665 [00]  1369.966480:  13665:120:R   + 13635:120:S
    Receiver-197-13665 [00]  1369.966485:  13665:120:R   + 13639:120:S
    Receiver-197-13665 [00]  1369.966495:  13665:120:R   + 13643:120:S
    Receiver-197-13665 [00]  1369.966507:  13871:120:R   + 13647:120:S
Above waker pid is 13871 while the current pid is 13665. I found lots of
such mismatch data.

    Receiver-197-13665 [00]  1369.966513:  13465:120:R   + 13651:120:S
    Receiver-197-13665 [00]  1369.966516:  13665:120:R   + 13655:120:S
    Receiver-197-13665 [00]  1369.966521:  13665:120:R   + 13659:120:S
    Receiver-197-13665 [00]  1369.966530:  13665:120:R   + 13667:120:S
    Receiver-197-13665 [00]  1369.966544:  13883:120:R   + 13663:120:S
    Receiver-197-13665 [00]  1369.966549:  13665:120:R ==> 13667:120:R
      Sender-140-13667 [00]  1369.966573:  13351:120:R   + 13668:120:S
      Sender-140-13667 [00]  1369.966578:  13667:120:R ==> 13659:120:R


BTW, I analyzed schedstat data and found wake_affine and
load_balance_newidle
seem abnormal. 2.6.27-rc has more task pulls.
I set CONFIG_GROUP_SCHED=n with above testing.

>>
>>( regarding tracing_cpumask: trace only 1 CPU to make sure volanomark
is
>>  not disturbed too much by many-CPUs tracing. )
>>
>>	Ingo

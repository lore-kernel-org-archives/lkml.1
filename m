Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXDRFkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXDRFkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 01:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXDRFke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 01:40:34 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:32697 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbXDRFk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 01:40:27 -0400
From: Buytaert_Steven@emc.com
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE:  Re: sched_yield proposals/rationale
Date: Wed, 18 Apr 2007 01:40:14 -0400
Message-ID: <585DC2133F7C974F87D4EC432896F1720313698E@CORPUSMX10A.corp.emc.com>
In-Reply-To: A<4625220C.2060201@tmr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: sched_yield proposals/rationale
Thread-Index: AceBKOFupBT9MYpeQTOHr9LHodbETQAT9mJg
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com> <p737ish90ss.fsf@bingen.suse.de> <585DC2133F7C974F87D4EC432896F1720309F3DB@CORPUSMX10A.corp.emc.com> <20070412133158.GB31455@one.firstfloor.org> <585DC2133F7C974F87D4EC432896F1720309F485@CORPUSMX10A.corp.emc.com> <461EB367.1050405@tmr.com> <585DC2133F7C974F87D4EC432896F1720309F645@CORPUSMX10A.corp.emc.com> <461FDDF9.7040503@rtr.ca> A<4625220C.2060201@tmr.com>
To: <davidsen@tmr.com>, <linux-kernel@vger.kernel.org>
Cc: <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Apr 2007 05:40:15.0924 (UTC) FILETIME=[0ABA0740:01C7817C]
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.4.17.220434
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, SUPERLONG_LINE 0.05, NO_REAL_NAME 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __IMS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Bill Davidsen
> Sent: dinsdag 17 april 2007 21:38
> To: linux-kernel@vger.kernel.org
> Cc: Buytaert, Steven; andi@firstfloor.org; linux-kernel@vger.kernel.org
> Subject: Re: sched_yield proposals/rationale
> 
> Mark Lord wrote:
> >
> > Cool.  You *do know* that there is a brand new CPU scheduler
> > scheduled to replace the current one for the 2.6.22 Kernel, right?
> >
> Having tried both nicksched and Con's fair sched on some normal loads,
> as opposed to benchmarks, I sure hope Linus changes his mind about
> having several schedulers in the kernel. The "one perfect and
> self-adjusting scheduler" isn't here yet.

I have the same opinion, and it is still a long time out I'm afraid. Probably people only read my suggestion for a 'fix' diagonally, let alone they read my footer. Too bad the archives only go back to 95, I would love to retrieve my posts from 93. Anybody still have these?

Now a bit more on topic:

1) My problem is/was solved by making the default time slice much smaller than the default 100 in a 250Hz system. But that's only masking it away.

2) I made a schedstat program sort of like vmstat that samples and prints deltas each second (from /proc/schedstat). Just printing the jiffies delta and the # times schedule is called per CPU, is already thought provoking; a small 12 second example:

2.6.16 vanilla scheduler

   Jiffies CPU0    CPU1
    Delta 
    250  | 1756 |  7301 |
    252  | 1730 |  2638 |
    254  | 1963 |  1663 |
    385  |  868 |   658 | <--- stall starts
    325  |  138 |   112 |
    330  |  184 |   130 |
    339  |  682 |   122 |
    335  |  367 |   159 |
    334  |  653 |   127 |
    345  |  467 |   137 |
    335  |  673 |   128 |
    337  |  471 |   131 |
    334  |  673 |   127 |
    332  |  321 |   144 |
    333  |  523 |   129 |
    332  |   98 |   123 |
    356  |  496 |   124 |
    270  |   96 |    87 |
    277  | 5878 | 26228 | <-- yes 26K
    252  |18263 | 19130 | ...
    255  | 2024 |  5747 | <-- back to normal

Let's talk about fairness when we get the basics right. And yes, the real physical elapsed time per line IS 1 second, so the jiffies jumping up from the normal expected value of 250 to up to 356 is not normal; it's in fact very very bad. This box was unusable for 13 seconds in a row.

But this doesn't look serious enough to most people, it seems. 

Steven Buytaert
--
La perfection est atteinte non quand il ne reste rien ajouter, mais quand il ne reste rien à enlever. (Antoine de Saint-Exupéry)

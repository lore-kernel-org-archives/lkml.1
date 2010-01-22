Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206Ab0AVSwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0AVSwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 13:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157Ab0AVSwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 13:52:53 -0500
Received: from irongate.mail.utexas.edu ([146.6.25.6]:22246 "EHLO
	irongate.mail.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0AVSwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 13:52:53 -0500
X-IronPort-MID: 12213159
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAJ+CWUuAUyC8/2dsb2JhbACDYZcbry6CHYUYh2SBLoI1WQSFeQ
From: "John  McCalpin" <mccalpin@tacc.utexas.edu>
To: "'Peter Zijlstra'" <peterz@infradead.org>
CC: "'Dan Terpstra'" <terpstra@eecs.utk.edu>,
       "eranian@google.com" <eranian@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ptools-perfapi@eecs.utk.edu" <ptools-perfapi@eecs.utk.edu>,
       "perfmon2-devel@lists.sf.net" <perfmon2-devel@lists.sf.net>,
       "fweisbec@gmail.com" <fweisbec@gmail.com>,
       "paulus@samba.org" <paulus@samba.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>
Date: Fri, 22 Jan 2010 12:52:51 -0600
Subject: RE: [Ptools-perfapi] [perfmon2] [PATCH] perf_events: AMD event
 scheduling (v1)
Thread-Topic: [Ptools-perfapi] [perfmon2] [PATCH] perf_events: AMD event
 scheduling (v1)
Thread-Index: AcqbikMiaPLHVaJBTZCf808su0s8jgACHFOA
Message-ID: <CF3466DD76A94945B5723C073FE74B0A69E64117E8@MAIL02.austin.utexas.edu>
References: <4b5991c4.0c58560a.44d3.ffffeedc@mx.google.com>
	 <05F95E05F0394ED3B66F16ACA8ED4650@terpstrat60p>
	 <CF3466DD76A94945B5723C073FE74B0A69E64117E6@MAIL02.austin.utexas.edu>
 <1264182121.4283.1549.camel@laptop>
In-Reply-To: <1264182121.4283.1549.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o0MIrb54002384

In the comments for perfctr's linux/drivers/perfctr/x86.c driver file, there is a note on this.
>From perfctr version 2.6.31, item (2) refers to this issue:
/*
 * Multicore K8s have issues with northbridge events:
 * 1. The NB is shared between the cores, so two different cores
 *    in the same node cannot count NB events simultaneously.
 *    This can be handled by using perfctr_cpus_forbidden_mask to
 *    restrict NB-using threads to core0 of all nodes.
 * 2. The initial multicore chips (Revision E) have an erratum
 *    which causes the NB counters to be reset when either core
 *    reprograms its evntsels (even for non-NB events).
 *    This is only an issue because of scheduling of threads, so
 *    we restrict NB events to the non thread-centric API.
 *
 * For now we only implement the workaround for issue 2, as this
 * also handles issue 1.
 *
 * TODO: Detect post Revision E chips and implement a weaker
 * workaround for them.
 */

I have gone back through the AMD Opteron Revision Guide for these processors 
   http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25759.pdf
but I don't see any publicly disclosed errata that appear to be related to this issue.

Perhaps I will check it on my Athlon64FX system at home this weekend....

john






-----Original Message-----
From: Peter Zijlstra [mailto:peterz@infradead.org] 
Sent: Friday, January 22, 2010 11:42 AM
To: John McCalpin
Cc: 'Dan Terpstra'; eranian@google.com; linux-kernel@vger.kernel.org; ptools-perfapi@eecs.utk.edu; perfmon2-devel@lists.sf.net; fweisbec@gmail.com; paulus@samba.org; mingo@elte.hu; davem@davemloft.net
Subject: RE: [Ptools-perfapi] [perfmon2] [PATCH] perf_events: AMD event scheduling (v1)

On Fri, 2010-01-22 at 11:33 -0600, John McCalpin wrote:

> * Think of the system as having four performance monitors per core
> *plus* four performance monitors for the "shared" structures on the
> chip (L3, crossbar, HyperTransport links, memory controllers).

Would have been nice to have them as a separately addressable pmu
instead of shadowing the logical cpu's pmu.

But that's all ancient history of course..

> There is an additional hazard when working with early K8 processors --
> a hardware bug causes the counts of all shared counters to be reset to
> zero any time any shared register is programmed.  This makes
> "protecting" users somewhat more difficult....

Could you qualify early k8 a bit more, it shouldn't be hard to add a
quirk for a specific set of cpus to read/reset all counters before
writing to the shared pmu.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

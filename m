Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZC3LaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZC3LaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZC3L35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:29:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:41145 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbZC3L34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:29:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,446,1233561600"; 
   d="scan'208";a="125599622"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@googlemail.com>
Date: Mon, 30 Mar 2009 12:29:32 +0100
Subject: RE: [rfc] x86, bts: fix crash
Thread-Topic: [rfc] x86, bts: fix crash
Thread-Index: AcmvI6U4PpqZaExDT6u3n/ie5jVDDgB4RT6QAAjcMzA=
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9266BB48@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com>
 <20090326015801.GA451@redhat.com>
 <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com>
 <20090327165038.GA25762@redhat.com> <1238175204.6077.18.camel@raistlin>
 <20090327212933.GA5325@redhat.com>
 <928CFBE8E7CB0040959E56B4EA41A77E9266B8F1@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9266B8F1@irsmsx504.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Metzger, Markus T
>Sent: Monday, March 30, 2009 9:24 AM
>To: Oleg Nesterov; Markus Metzger
>Cc: Kleen, Andi; Ingo Molnar; Roland McGrath; linux-kernel@vger.kernel.org


>But that's exactly the problem if the bts_tracer is released by another
>task (!= current).
>We first need to disable tracing by clearing bits in debugctlmsr.
>Then, we can set ->bts to NULL and clear TIF_DS_AREA_MSR.
>
>If the traced task is currently in a context switch, clearing debugctlmsr bits
>might come too late. We need to wait for the next context switch until we can
>clear TIF_DS_AREA_MSR.
>
>
>The benefit would be that I don't need to hook into do_exit() anymore.
>This would rid us of the nasty ->ptraced loop.
>I will give it a try.
>
>
>I use something like this to wait for the context switch:
>  nvcsw = task->nvcsw + 1;
>  nivcsw = task->nivcsw + 1;
>  for (;;) {
>	if (nvcsw < task->nvcsw)
>		break;
>	if (nivcsw < task->nivcsw)
>		break;
>	if (task->state != TASK_RUNNING)
>		break;
>  }
>
>I would need to check for overflows, but for my examples, I don't expect any.


That is not quite right, as well. There's a race on the task state.
In my example, I got TASK_DEAD before the dying task could complete its
final schedule(), and the cpu continued tracing.

When I use the task_running() test that wait_task_inactive() uses, as well,
it seems to work. Together with checking the number of context switches,
it should be reasonably fast, as well (I don't run the risk of being scheduled
perfectly synchronous to the task I'm waiting for).

I would need to add an extern function task_is_running(struct task_struct *)
to sched.h, though. I hope that's acceptable.


regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.


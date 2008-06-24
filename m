Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbYFXPPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbYFXPPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbYFXPOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:14:52 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:44054 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYFXPOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:14:51 -0400
Message-Id: <4860D726.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 24 Jun 2008 09:14:46 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <jbe@pengutronix.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: 2.6.25.8-rt7
References: <4860CD0B0200005A0003944C@sinclair.provo.novell.com>
 <4860CD140200005A0003944F@sinclair.provo.novell.com>
 <4860CD140200005A0003944F@sinclair.provo.novell.com>
 <Pine.LNX.4.58.0806241043070.32368@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0806241043070.32368@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part38111C76.4__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=__Part38111C76.4__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>>> On Tue, Jun 24, 2008 at 10:44 AM, in message
<Pine.LNX.4.58.0806241043070.32368@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote:=20

> On Tue, 24 Jun 2008, Gregory Haskins wrote:
>=20
>>
>> (Sorry for toppost)
>>
>> I believe this is my fault.  You must be building for uniprocessor?  =
Ingo=20
> has a fix for this issue in sched-devel that should be pulled into -rt.
>>
>> Sorry for the inconvenience.  I will pull the patch myself and submit =
it=20
> when I get home (if someone doesn't beat me to it)
>>
>=20
> I'm looking forward to it ;-)

Patch is attached (from linux-2.6-tip).  I meant to send this back around =
when the
offending patch went in, but it slipped through the cracks.  Sorry for the
inconvenience.

Regards,
-Greg


--=__Part38111C76.4__=
Content-Type: text/plain; name="sched-fix-cpuprio-build-bug.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="sched-fix-cpuprio-build-bug.patch"

>From 1100ac91b6af02d8639d518fad5b434b1bf44ed6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 5 Jun 2008 12:25:37 +0200
Subject: [PATCH] sched: fix cpuprio build bug

this patch was not built on !SMP:

 kernel/sched_rt.c: In function 'inc_rt_tasks':
 kernel/sched_rt.c:404: error: 'struct rq' has no member named 'online'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_rt.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e482159..eaa6060 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -399,16 +399,19 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, =
struct rt_rq *rt_rq)
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio) {
 		struct rq *rq =3D rq_of_rt_rq(rt_rq);
-		rt_rq->highest_prio =3D rt_se_prio(rt_se);
=20
+		rt_rq->highest_prio =3D rt_se_prio(rt_se);
+#ifdef CONFIG_SMP
 		if (rq->online)
 			cpupri_set(&rq->rd->cpupri, rq->cpu,
 				   rt_se_prio(rt_se));
+#endif
 	}
 #endif
 #ifdef CONFIG_SMP
 	if (rt_se->nr_cpus_allowed > 1) {
 		struct rq *rq =3D rq_of_rt_rq(rt_rq);
+
 		rq->rt.rt_nr_migratory++;
 	}
=20
--=20
1.5.4.5


--=__Part38111C76.4__=--

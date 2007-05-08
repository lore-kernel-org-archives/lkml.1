Return-Path: <linux-kernel-owner+w=401wt.eu-S968201AbXEHOa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968201AbXEHOa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968161AbXEHOa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:30:58 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:43975 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967955AbXEHOa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:30:58 -0400
Message-id: <735170251589527543@wsc.cz>
In-reply-to: <20070508142025.GB1105@tv-sign.ru>
Subject: [PATCH 1/1] vmstat-use-our-own-timer-events-fix
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Cc: <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
References: <46403B7F.1050009@gmail.com> <20070508021131.438cee31.akpm@linux-foundation.org> <20070508105528.GA86@tv-sign.ru> <46405A67.8020105@gmail.com> <46406656.9060504@gmail.com> <20070508134815.GA1074@tv-sign.ru> <20070508134815.GA1074@tv-sign.ru>
Date: Tue,  8 May 2007 16:30:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 05/08, Oleg Nesterov wrote:
> >
> > On 05/08, Jiri Slaby wrote:
> >
> > This should not happen because we are doing cancel_rearming_delayed_work()
> > below, however:
> > 
> > > +       case CPU_DOWN_PREPARE:
> > > +       case CPU_DOWN_PREPARE_FROZEN:
> > > +               cancel_rearming_delayed_work(&per_cpu(vmstat_work, cpu));
> > > +               per_cpu(vmstat_work, cpu).work.func = NULL;
> > > +       case CPU_DOWN_FAILED:
> > > +       case CPU_DOWN_FAILED_FROZEN:
> > > +               start_cpu_timer(cpu);
> > 
> > we need a "break;" before "case CPU_DOWN_FAILED", otherwise we re-start
> > vmstat_update() immediately.
> > 
> > This is a bug, but I am not sure is this the only problem.
> 
> In case I was not clear, this _can_ explain the problem. Because an extra
> start_cpu_timer() (due to missed "break;") re-initializes dwork, and clears
> _PENDING.

Yes, it helped, thanks. If no objections, please apply the patch below.

--

vmstat-use-our-own-timer-events-fix

add missing break

Cc: Christoph Lameter <clameter@sgi.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit e0fe3cf4776a3c16ac7625ce9eae75ea42eb9b4e
tree c9a4277860e2cea03911b3d73c9386c9284d991b
parent b1034323f7e57642eee59a0f5e77c50bc26982c5
author Jiri Slaby <jirislaby@gmail.com> Tue, 08 May 2007 16:25:28 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 08 May 2007 16:25:28 +0200

 mm/vmstat.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 709e2f0..fac05e8 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -677,6 +677,7 @@ static int __cpuinit vmstat_cpuup_callback(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE_FROZEN:
 		cancel_rearming_delayed_work(&per_cpu(vmstat_work, cpu));
 		per_cpu(vmstat_work, cpu).work.func = NULL;
+		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		start_cpu_timer(cpu);

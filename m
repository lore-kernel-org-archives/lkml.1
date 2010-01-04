Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172Ab0ADNpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0ADNpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 08:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158Ab0ADNpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 08:45:00 -0500
Received: from mail.gmx.net ([213.165.64.20]:38145 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751883Ab0ADNo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 08:44:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX193c7A0TM13Y2VgZLBco6+qH2DjC4xtYYiD/6JPY7
	iGCIOhbmkqsx85
Subject: [patch] Re: volano ~30% regression with 2.6.33-rc1 & -rc2
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <1262611608.6408.126.camel@laptop>
References: <1262592958.22471.104.camel@minggr.sh.intel.com>
	 <20100104044024.5390ff1c@infradead.org>
	 <1262609854.9734.56.camel@marge.simson.net>
	 <1262610123.6408.120.camel@laptop>
	 <1262610927.9734.64.camel@marge.simson.net>
	 <1262611608.6408.126.camel@laptop>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 14:44:56 +0100
Message-Id: <1262612696.15495.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 14:26 +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-04 at 14:15 +0100, Mike Galbraith wrote:

> > WRT the regression, would you prefer only the sched_fair.c hunk, and
> > maybe plunking the topology hunk in sched_devel, or both lines in one
> > patch, since ramp-up gain remains unrealized half of the time on Nehalem
> > and ilk.
> 
> Both bits seem sane I guess, you change SD_SIBLING_INIT(), right?

Right.

> Threads really do share package resources so it makes sense to set it.
> 
> I guess its back to poking at nehalem to see what makes it tick..

I asked Santa for a quad socket Nehalem and a portable nuclear reactor
to power it, but the stingy old fart let me down ;-)

sched: fix vmark regression on big machines

SD_PREFER_SIBLING is set at the CPU domain level if power saving isn't enabled,
leading to many cache misses on large machines as we traverse looking for an
idle shared cache to wake to.  Change the enabler of select_idle_sibling() to
SD_SHARE_PKG_RESOURCES, and enable same at the sibling domain level.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <new-submission>

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 57e6357..5b81156 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 42ac3c9..8fe7ee8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1508,7 +1508,7 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING)
+			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {



Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759803AbYLQAGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbYLQAGW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbYLQAFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:05:51 -0500
Received: from kroah.org ([198.145.64.141]:41182 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756238AbYLQAFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:05:50 -0500
Date: Tue, 16 Dec 2008 16:04:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 03/22] Revert "sched_clock: prevent scd->clock from moving
	backwards"
Message-ID: <20081217000402.GD4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-sched_clock-prevent-scd-clock-from-moving-backwards.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325 upstream.

This reverts commit 5b7dba4ff834259a5623e03a565748704a8fe449, which
caused a regression in hibernate, reported by and bisected by Fabio
Comolli.

This revert fixes

 http://bugzilla.kernel.org/show_bug.cgi?id=12155
 http://bugzilla.kernel.org/show_bug.cgi?id=12149

Bisected-by: Fabio Comolli <fabio.comolli@gmail.com>
Requested-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_clock.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -118,13 +118,13 @@ static u64 __update_sched_clock(struct s
 
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
-	 *		      max(scd->tick_gtod, scd->clock),
-	 *		      max(scd->clock, scd->tick_gtod + TICK_NSEC));
+	 * 		      max(scd->tick_gtod, scd->clock),
+	 * 		      scd->tick_gtod + TICK_NSEC);
 	 */
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
+	max_clock = scd->tick_gtod + TICK_NSEC;
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);


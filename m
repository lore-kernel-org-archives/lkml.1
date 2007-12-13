Return-Path: <linux-kernel-owner+w=401wt.eu-S1760400AbXLMGks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbXLMGks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXLMGhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:37:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbXLMGhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:13 -0500
Date: Wed, 12 Dec 2007 22:34:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 11/36] hrtimers: avoid overflow for large relative timeouts
	(CVE-2007-5966)
Message-ID: <20071213063431.GL25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hrtimers-avoid-overflow-for-large-relative-timeouts.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

patch 62f0f61e6673e67151a7c8c0f9a09c7ea43fe2b5 in mainline

Relative hrtimers with a large timeout value might end up as negative
timer values, when the current time is added in hrtimer_start().

This in turn is causing the clockevents_set_next() function to set an
huge timeout and sleep for quite a long time when we have a clock
source which is capable of long sleeps like HPET. With PIT this almost
goes unnoticed as the maximum delta is ~27ms. The non-hrt/nohz code
sorts this out in the next timer interrupt, so we never noticed that
problem which has been there since the first day of hrtimers.

This bug became more apparent in 2.6.24 which activates HPET on more
hardware.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/hrtimer.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -825,6 +825,14 @@ hrtimer_start(struct hrtimer *timer, kti
 #ifdef CONFIG_TIME_LOW_RES
 		tim = ktime_add(tim, base->resolution);
 #endif
+		/*
+		 * Careful here: User space might have asked for a
+		 * very long sleep, so the add above might result in a
+		 * negative number, which enqueues the timer in front
+		 * of the queue.
+		 */
+		if (tim.tv64 < 0)
+			tim.tv64 = KTIME_MAX;
 	}
 	timer->expires = tim;
 

-- 

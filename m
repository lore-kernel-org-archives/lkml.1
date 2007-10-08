Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbXJHSiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbXJHSiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbXJHSiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:38:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:32940 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbXJHSiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:38:13 -0400
Date: Mon, 8 Oct 2007 11:06:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mingo@elte.hu, anton@samba.org
Subject: [patch 10/12] Fix timer_stats printout of events/sec
Message-ID: <20071008180636.GK7627@kroah.com>
References: <20071008180406.052382073@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-timer_stats-printout-of-events-sec.patch"
In-Reply-To: <20071008180551.GA7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

commit 74922be1485818ed368c4cf4f0b100f70bf01e08 upstream.

When using /proc/timer_stats on ppc64 I noticed the events/sec field wasnt
accurate.  Sometimes the integer part was incorrect due to rounding (we
werent taking the fractional seconds into consideration).

The fraction part is also wrong, we need to pad the printf statement and
take the bottom three digits of 1000 times the value.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

 kernel/time/timer_stats.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -319,8 +319,9 @@ static int tstats_show(struct seq_file *
 		ms = 1;
 
 	if (events && period.tv_sec)
-		seq_printf(m, "%ld total events, %ld.%ld events/sec\n", events,
-			   events / period.tv_sec, events * 1000 / ms);
+		seq_printf(m, "%ld total events, %ld.%03ld events/sec\n",
+			   events, events * 1000 / ms,
+			   (events * 1000000 / ms) % 1000);
 	else
 		seq_printf(m, "%ld total events\n", events);
 

-- 

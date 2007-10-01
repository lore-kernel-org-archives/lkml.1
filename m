Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbXJANHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbXJANHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXJANHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:07:30 -0400
Received: from ozlabs.org ([203.10.76.45]:35794 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbXJANHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:07:30 -0400
Date: Mon, 1 Oct 2007 08:05:40 -0500
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, tglx@timesys.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix timer_stats printout of events/sec
Message-ID: <20071001130540.GA22646@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

When using /proc/timer_stats on ppc64 I noticed the events/sec field
wasnt accurate. Sometimes the integer part was incorrect due to rounding
(we werent taking the fractional seconds into consideration).

The fraction part is also wrong, we need to pad the printf statement and
take the bottom three digits of 1000 times the value.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 3c38fb5..c36bb7e 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -327,8 +327,9 @@ static int tstats_show(struct seq_file *m, void *v)
 		ms = 1;
 
 	if (events && period.tv_sec)
-		seq_printf(m, "%ld total events, %ld.%ld events/sec\n", events,
-			   events / period.tv_sec, events * 1000 / ms);
+		seq_printf(m, "%ld total events, %ld.%03ld events/sec\n",
+			   events, events * 1000 / ms,
+			   (events * 1000000 / ms) % 1000);
 	else
 		seq_printf(m, "%ld total events\n", events);
 

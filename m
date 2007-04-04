Return-Path: <linux-kernel-owner+w=401wt.eu-S1766912AbXDDTu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766912AbXDDTu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766906AbXDDTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:50:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54983 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766904AbXDDTuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:50:21 -0400
Subject: [PATCH -mm] fix jiffies clocksource inittime
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 12:50:15 -0700
Message-Id: <1175716216.17711.59.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,
	In debugging a problem w/ the -rt tree, I noticed that on systems that
mark the tsc as unstable before it is registered, the TSC would still be
selected and used for a short period of time. Digging in it looks to be
a result of the mix of the clocksource list changes and my clocksource
initialization changes.

With the -rt tree, using a bad TSC, even for a short period of time can
results in a hang at boot. I was not able to reproduce this hang w/
mainline, but I'm not completely certain that someone won't trip on it.

This patch resolves the issue by initializing the jiffies clocksource
earlier so a bad TSC won't get selected just because nothing else is yet
registered.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 3be8da8..4c256fd 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -69,4 +69,4 @@ static int __init init_jiffies_clocksour
 	return clocksource_register(&clocksource_jiffies);
 }
 
-module_init(init_jiffies_clocksource);
+core_initcall(init_jiffies_clocksource);



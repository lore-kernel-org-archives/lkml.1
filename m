Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbYBSS7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbYBSS7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYBSS64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:58:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbYBSS6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:58:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] MN10300: Call update_process_times() outside of the
	xtime_lock
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 19 Feb 2008 18:58:49 +0000
Message-ID: <20080219185848.22304.75764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call update_process_times() outside of the xtime_lock.  Somewhere somewhere
inside one of the functions called by that, xtime_lock is readlocked, which
ends up in a deadlock situation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/time.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index ff492e3..babb7c2 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -84,11 +84,13 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		/* advance the kernel's time tracking system */
 		profile_tick(CPU_PROFILING);
 		do_timer(1);
-		update_process_times(user_mode(get_irq_regs()));
 		check_rtc_time();
 	}
 
 	write_sequnlock(&xtime_lock);
+
+	update_process_times(user_mode(get_irq_regs()));
+
 	return IRQ_HANDLED;
 }
 


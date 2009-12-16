Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbZLPWU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbZLPWU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763035AbZLPWUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:20:36 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:49652 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762957AbZLPWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:20:32 -0500
Date: Thu, 17 Dec 2009 09:20:28 +1100
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC] timers: Remove duplicate setting of new_base in __mod_timer()
Message-ID: <20091216222028.GA15841@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am wondering if the first line of the following snippet of
__mod_timer() can be removed as new_base always seems to be reset.

Alternatively perhaps smp_processor_id() and  per_cpu() could
be moved to inside the #if and the call to __get_cpu_var() moved to
inside #else ?

        new_base = __get_cpu_var(tvec_bases);

        cpu = smp_processor_id();
        
#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
        if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
                int preferred_cpu = get_nohz_load_balancer();
                        
                if (preferred_cpu >= 0)
                        cpu = preferred_cpu;
        }
#endif
        new_base = per_cpu(tvec_bases, cpu);

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c	2009-12-17 07:02:57.000000000 +0900
+++ linux-2.6/kernel/timer.c	2009-12-17 07:03:17.000000000 +0900
@@ -656,8 +656,6 @@ __mod_timer(struct timer_list *timer, un
 
 	debug_activate(timer, expires);
 
-	new_base = __get_cpu_var(tvec_bases);
-
 	cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)

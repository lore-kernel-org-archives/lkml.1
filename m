Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZLWEJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZLWEJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZLWEJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:09:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:32930 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZLWEJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:09:09 -0500
Subject: [RFC][PATCH 8/14] Convert ia64 to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
In-Reply-To: <1261541286.3508.69.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
	 <1261541054.3508.65.camel@localhost.localdomain>
	 <1261541130.3508.66.camel@localhost.localdomain>
	 <1261541188.3508.67.camel@localhost.localdomain>
	 <1261541286.3508.69.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:09:02 -0800
Message-ID: <1261541342.3508.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the ia64  architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 time.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: gettimeoffset/arch/ia64/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/ia64/kernel/time.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/ia64/kernel/time.c	2009-12-22 18:51:10.000000000 -0800
@@ -430,18 +430,16 @@ static int __init rtc_init(void)
 }
 module_init(rtc_init);
 
+void read_persistent_clock(struct timespec *ts)
+{
+	efi_gettimeofday(ts);
+}
+
 void __init
 time_init (void)
 {
 	register_percpu_irq(IA64_TIMER_VECTOR, &timer_irqaction);
-	efi_gettimeofday(&xtime);
 	ia64_init_itm();
-
-	/*
-	 * Initialize wall_to_monotonic such that adding it to xtime will yield zero, the
-	 * tv_nsec field must be normalized (i.e., 0 <= nsec < NSEC_PER_SEC).
-	 */
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 }
 
 /*



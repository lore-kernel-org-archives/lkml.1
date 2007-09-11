Return-Path: <linux-kernel-owner+w=401wt.eu-S1763757AbXIKMCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763757AbXIKMCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763692AbXIKMCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:02:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763659AbXIKMCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:02:11 -0400
From: Andi Kleen <ak@suse.de>
References: <20070911202.911586000@suse.de>
In-Reply-To: <20070911202.911586000@suse.de>
To: cebbert@redhat.com, torvalds@osdl.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.23] [1/3] x86_64: Add missing mask operation to vdso
Message-Id: <20070911120210.0CFFC14EEC@wotan.suse.de>
Date: Tue, 11 Sep 2007 14:02:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


vdso vgetns() didn't mask the time source offset calculation, which could
lead to time problems with 32bit HPET. Add the masking.

Thanks to Chuck Ebbert for tracking down.

Cc: cebbert@redhat.com

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86_64/vdso/vclock_gettime.c
===================================================================
--- linux.orig/arch/x86_64/vdso/vclock_gettime.c
+++ linux/arch/x86_64/vdso/vclock_gettime.c
@@ -34,10 +34,11 @@ static long vdso_fallback_gettime(long c
 
 static inline long vgetns(void)
 {
+	long v;
 	cycles_t (*vread)(void);
 	vread = gtod->clock.vread;
-	return ((vread() - gtod->clock.cycle_last) * gtod->clock.mult) >>
-		gtod->clock.shift;
+	v = (vread() - gtod->clock.cycle_last) & gtod->clock.mask;
+	return (v * gtod->clock.mult) >> gtod->clock.shift;
 }
 
 static noinline int do_realtime(struct timespec *ts)

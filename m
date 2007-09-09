Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbXIIH1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbXIIH1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 03:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXIIH1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 03:27:13 -0400
Received: from ns1.suse.de ([195.135.220.2]:58786 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbXIIH1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 03:27:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
Date: Sun, 9 Sep 2007 09:27:06 +0200
User-Agent: KMail/1.9.6
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, jakub@redhat.com,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D6EFDE.4020107@redhat.com> <7671.1189297449@turing-police.cc.vt.edu>
In-Reply-To: <7671.1189297449@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709090927.07069.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Updating on this issue:   Both myself and another person have reported on
> the RedHat bugzilla that it's a clocksource issue - if you are using the
> hpet clocksource, the time warps, but booting with clocksource=acpi_pm works.
> 
> This ring any bells?

Does this patch fix it? 
-Andi

Add missing mask operation to vdso

vdso vgetns() didn't mask the time source offset calculation, which could
lead to time problems with 32bit HPET. Add the masking.

Thanks to Chuck Ebbert for tracking down.

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

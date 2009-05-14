Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbZENNHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbZENNHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762038AbZENNHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:07:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762055AbZENNHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:07:09 -0400
X-Sieve: CMU Sieve 2.2
From: Petr Tesarik <ptesarik@suse.cz>
To: linux-kernel@vger.kernel.org, linux-x86_64@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org
Cc: zwane@arm.linux.org.uk, roland@redhat.com, Petr Tesarik <ptesarik@suse.cz>
Message-Id: <231dbdc2eeb094c2d8ec847cb4ea869510c79ca7.1242299014.git.ptesarik@suse.cz>
In-Reply-To: <7921ac39159b69e2154857655259c7bb6d4589cc.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
	 <f249c3f58a699ce72b6cb416ddff98811848ff6f.1242299014.git.ptesarik@suse.cz>
	 <2bc7564b5c902a0ebabd5ab652b12c1ffa4214eb.1242299014.git.ptesarik@suse.cz>
	 <7921ac39159b69e2154857655259c7bb6d4589cc.1242299014.git.ptesarik@suse.cz>
In-Reply-To: <cover.1242299014.git.ptesarik@suse.cz>
References: <cover.1242299014.git.ptesarik@suse.cz>
Subject: [PATCH 4/4] x86: add rdtsc_barrier() to vgetns()
Organization: SUSE LINUX
Date: Thu, 14 May 2009 15:07:09 +0200
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cb9e35dce94a1b9c59d46224e8a94377d673e204 removed
rdtsc_barrier() from vget_cycles() and moved it to
do_vgettimeofday().

AFAICS the same is also needed for vgetns(), because it may
call vread_tsc(), which in turn reads the TSC counter
using vget_cycles().

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vclock_gettime.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 6a40b78..ab1ae6c 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -36,11 +36,14 @@ notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
 
 notrace static inline long vgetns(void)
 {
-	long v;
-	cycles_t (*vread)(void);
+	cycle_t now, cycle_delta;
+	cycle_t (*vread)(void);
 	vread = gtod->clock.vread;
-	v = (vread() - gtod->clock.cycle_last) & gtod->clock.mask;
-	return (v * gtod->clock.mult) >> gtod->clock.shift;
+	rdtsc_barrier();
+	now = vread();
+	rdtsc_barrier();
+	cycle_delta = (now - gtod->clock.cycle_last) & gtod->clock.mask;
+	return (cycle_delta * gtod->clock.mult) >> gtod->clock.shift;
 }
 
 notrace static noinline int do_realtime(struct timespec *ts)
-- 
1.6.0.2



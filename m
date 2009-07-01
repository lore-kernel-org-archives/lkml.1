Return-Path: <linux-kernel-owner+w=401wt.eu-S1764923AbZGAA72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764923AbZGAA72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761473AbZGAAeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:50 -0400
Received: from kroah.org ([198.145.64.141]:60364 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761452AbZGAAet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:27 2009
Message-Id: <20090701002427.764470416@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Petr Tesarik <ptesarik@suse.cz>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 046/108] x86: move rdtsc_barrier() into the TSC vread method
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=x86-move-rdtsc_barrier-into-the-tsc-vread-method.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Petr Tesarik <ptesarik@suse.cz>

commit 7d96fd41cadc55f4e00231c8c71b8e25c779f122 upstream.

The *fence instructions were moved to vsyscall_64.c by commit
cb9e35dce94a1b9c59d46224e8a94377d673e204.  But this breaks the
vDSO, because vread methods are also called from there.

Besides, the synchronization might be unnecessary for other
time sources than TSC.

[ Impact: fix potential time warp in VDSO ]

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
LKML-Reference: <9d0ea9ea0f866bdc1f4d76831221ae117f11ea67.1243241859.git.ptesarik@suse.cz>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/tsc.c         |   11 ++++++++++-
 arch/x86/kernel/vsyscall_64.c |    8 --------
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -710,7 +710,16 @@ static cycle_t read_tsc(struct clocksour
 #ifdef CONFIG_X86_64
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
-	cycle_t ret = (cycle_t)vget_cycles();
+	cycle_t ret;
+
+	/*
+	 * Surround the RDTSC by barriers, to make sure it's not
+	 * speculated to outside the seqlock critical section and
+	 * does not cause time warps:
+	 */
+	rdtsc_barrier();
+	ret = (cycle_t)vget_cycles();
+	rdtsc_barrier();
 
 	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
 		ret : __vsyscall_gtod_data.clock.cycle_last;
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -132,15 +132,7 @@ static __always_inline void do_vgettimeo
 			return;
 		}
 
-		/*
-		 * Surround the RDTSC by barriers, to make sure it's not
-		 * speculated to outside the seqlock critical section and
-		 * does not cause time warps:
-		 */
-		rdtsc_barrier();
 		now = vread();
-		rdtsc_barrier();
-
 		base = __vsyscall_gtod_data.clock.cycle_last;
 		mask = __vsyscall_gtod_data.clock.mask;
 		mult = __vsyscall_gtod_data.clock.mult;



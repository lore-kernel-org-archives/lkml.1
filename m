Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbXEVX2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbXEVX2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761158AbXEVX14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:27:56 -0400
Received: from ozlabs.org ([203.10.76.45]:37106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760936AbXEVX1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:27:55 -0400
Subject: Re: lguest broken in 2.6.22-rc1-mm1
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070522223828.GV11115@waste.org>
References: <20070522223828.GV11115@waste.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 09:27:40 +1000
Message-Id: <1179876460.20705.157.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 17:38 -0500, Matt Mackall wrote:
> [    0.120007] EIP is at resync_sc_freq+0x4b/0x56

Hi Matt,

	Thanks for the report!  Andrew should have these two patches queued,
but here they are again:

If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
divide by zero on boot.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/i386/kernel/sched-clock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/i386/kernel/sched-clock.c
+++ b/arch/i386/kernel/sched-clock.c
@@ -103,7 +103,7 @@ static void resync_sc_freq(struct sc_dat
 static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
 {
 	sc->sync_base = jiffies;
-	if (!cpu_has_tsc) {
+	if (!cpu_has_tsc || tsc_disable) {
 		sc->unstable = 1;
 		return;
 	}

Lguest guests don't use the TSC, and so we must disable it otherwise
sched-clock.c barfs.

Also, we no longer need to explicitly set the PGE feature bit:
cpu_detect->cpuid->lguest_cpuid does that for us now that cpu_detect
uses paravirt_ops (IIRC it used to do a direct cpuid from assembler).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 drivers/lguest/lguest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -504,10 +504,10 @@ __init void lguest_init(void *boot)
 	reserve_top_address(lguest_data.reserve_mem);
 
 	cpu_detect(&new_cpu_data);
-	/* Need this before paging_init. */
-	set_bit(X86_FEATURE_PGE, new_cpu_data.x86_capability);
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
+
+	tsc_disable = 1;
 
 #ifdef CONFIG_X86_MCE
 	mce_disabled = 1;



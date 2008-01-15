Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYAOQGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYAOQGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYAOQFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:05:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53213 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYAOQFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:05:53 -0500
Date: Tue, 15 Jan 2008 17:05:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
Message-ID: <20080115160538.GA19383@elte.hu>
References: <20080114190236.GA31546@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114190236.GA31546@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus, please pull the latest x86 git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> Thanks!

just updated it: added a fix for a sparsemem bootup crash on large-RAM 
boxes, and removed the documentation update patch (we can do that in 
.25). Find the updated shortlog below.

	Ingo

------------------>
Bernhard Walle (1):
      x86: fix RTC_AIE with CONFIG_HPET_EMULATE_RTC

Ingo Molnar (1):
      x86: fix boot crash on HIGHMEM4G && SPARSEMEM

Mike Frysinger (1):
      x86: asm-x86/msr.h: pull in linux/types.h

 arch/x86/kernel/hpet.c |    2 +-
 arch/x86/mm/init_32.c  |    9 +++++++--
 include/asm-x86/msr.h  |    4 ++++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4a86ffd..2f99ee2 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -657,7 +657,7 @@ irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 		hpet_pie_count = 0;
 	}
 
-	if (hpet_rtc_flags & RTC_PIE &&
+	if (hpet_rtc_flags & RTC_AIE &&
 	    (curr_time.tm_sec == hpet_alarm_time.tm_sec) &&
 	    (curr_time.tm_min == hpet_alarm_time.tm_min) &&
 	    (curr_time.tm_hour == hpet_alarm_time.tm_hour))
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c7d1947..76d89a2 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -321,8 +321,13 @@ extern void set_highmem_pages_init(int);
 static void __init set_highmem_pages_init(int bad_ppro)
 {
 	int pfn;
-	for (pfn = highstart_pfn; pfn < highend_pfn; pfn++)
-		add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);
+	for (pfn = highstart_pfn; pfn < highend_pfn; pfn++) {
+		/*
+		 * Holes under sparsemem might not have a mem-map:
+		 */
+		if (pfn_valid(pfn))
+			add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);
+	}
 	totalram_pages += totalhigh_pages;
 }
 #endif /* CONFIG_FLATMEM */
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 664a2fa..80b0270 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -3,6 +3,10 @@
 
 #include <asm/msr-index.h>
 
+#ifndef __ASSEMBLY__
+# include <linux/types.h>
+#endif
+
 #ifdef __i386__
 
 #ifdef __KERNEL__

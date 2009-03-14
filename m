Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZCNB6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZCNB6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZCNBVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:21:54 -0400
Received: from kroah.org ([198.145.64.141]:35824 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754501AbZCNBVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:46 2009
Message-Id: <20090314011046.207940178@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, John Stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 100/114] x86, hpet: fix for LS21 + HPET = boot hang
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=x86-hpet-fix-for-ls21-hpet-boot-hang.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: john stultz <johnstul@us.ibm.com>

commit b13e24644c138d0ddbc451403c30a96b09bfd556 upstream.

Between 2.6.23 and 2.6.24-rc1 a change was made that broke IBM LS21
systems that had the HPET enabled in the BIOS, resulting in boot hangs
for x86_64.

Specifically commit b8ce33590687888ebb900d09557b8807c4539022, which
merges the i386 and x86_64 HPET code.

Prior to this commit, when we setup the HPET timers in x86_64, we did
the following:

	hpet_writel(HPET_TN_ENABLE | HPET_TN_PERIODIC | HPET_TN_SETVAL |
                    HPET_TN_32BIT, HPET_T0_CFG);

However after the i386/x86_64 HPET merge, we do the following:

	cfg = hpet_readl(HPET_Tn_CFG(timer));
	cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
			HPET_TN_SETVAL | HPET_TN_32BIT;
	hpet_writel(cfg, HPET_Tn_CFG(timer));

However on LS21s with HPET enabled in the BIOS, the HPET_T0_CFG register
boots with Level triggered interrupts (HPET_TN_LEVEL) enabled. This
causes the periodic interrupt to be not so periodic, and that results in
the boot time hang I reported earlier in the delay calibration.

My fix: Always disable HPET_TN_LEVEL when setting up periodic mode.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -267,6 +267,8 @@ static void hpet_set_mode(enum clock_eve
 		now = hpet_readl(HPET_COUNTER);
 		cmp = now + (unsigned long) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
+		/* Make sure we use edge triggered interrupts */
+		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));



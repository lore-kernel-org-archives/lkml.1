Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYJFX23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYJFX23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYJFXWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:55215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688AbYJFXWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:35 -0400
Date: Mon, 6 Oct 2008 16:17:41 -0700
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
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 19/28] x86: HPET: read back compare register before reading
	counter
Message-ID: <20081006231741.GT20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-09.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 72d43d9bc9210d24d09202eaf219eac09e17b339 upstream

After fixing the u32 thinko I sill had occasional hickups on ATI chipsets
with small deltas. There seems to be a delay between writing the compare
register and the transffer to the internal register which triggers the
interrupt. Reading back the value makes sure, that it hit the internal
match register befor we compare against the counter value.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -290,6 +290,13 @@ static int hpet_legacy_next_event(unsign
 	cnt += (u32) delta;
 	hpet_writel(cnt, HPET_T0_CMP);
 
+	/*
+	 * We need to read back the CMP register to make sure that
+	 * what we wrote hit the chip before we compare it to the
+	 * counter.
+	 */
+	WARN_ON((u32)hpet_readl(HPET_T0_CMP) != cnt);
+
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
 

-- 

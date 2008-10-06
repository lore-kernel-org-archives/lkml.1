Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYJFX2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYJFX2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbYJFXWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:55193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919AbYJFXWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:32 -0400
Date: Mon, 6 Oct 2008 16:17:38 -0700
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
Subject: [patch 18/28] x86: HPET fix moronic 32/64bit thinko
Message-ID: <20081006231738.GS20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-08.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit f7676254f179eac6b5244a80195ec8ae0e9d4606 upstream

We use the HPET only in 32bit mode because:
1) some HPETs are 32bit only
2) on i386 there is no way to read/write the HPET atomic 64bit wide

The HPET code unification done by the "moron of the year" did
not take into account that unsigned long is different on 32 and
64 bit.

This thinko results in a possible endless loop in the clockevents
code, when the return comparison fails due to the 64bit/332bit
unawareness.

unsigned long cnt = (u32) hpet_read() + delta can wrap over 32bit.
but the final compare will fail and return -ETIME causing endless
loops.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -282,15 +282,15 @@ static void hpet_legacy_set_mode(enum cl
 }
 
 static int hpet_legacy_next_event(unsigned long delta,
-			   struct clock_event_device *evt)
+				  struct clock_event_device *evt)
 {
-	unsigned long cnt;
+	u32 cnt;
 
 	cnt = hpet_readl(HPET_COUNTER);
-	cnt += delta;
+	cnt += (u32) delta;
 	hpet_writel(cnt, HPET_T0_CMP);
 
-	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0) ? -ETIME : 0;
+	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
 
 /*

-- 

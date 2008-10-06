Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYJFX1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYJFX1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbYJFXWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:55130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637AbYJFXWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:24 -0400
Date: Mon, 6 Oct 2008 16:17:33 -0700
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
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 16/28] HPET: make minimum reprogramming delta useful
Message-ID: <20081006231733.GQ20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-06.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 7cfb0435330364f90f274a26ecdc5f47f738498c upstream

The minimum reprogramming delta was hardcoded in HPET ticks,
which is stupid as it does not work with faster running HPETs.
The C1E idle patches made this prominent on AMD/RS690 chipsets,
where the HPET runs with 25MHz. Set it to 5us which seems to be
a reasonable value and fixes the problems on the bug reporters
machines. We have a further sanity check now in the clock events,
which increases the delta when it is not sufficient.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Tested-by: Dmitry Nezhevenko <dion@inhex.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -222,8 +222,8 @@ static void hpet_legacy_clockevent_regis
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
-	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
-							   &hpet_clockevent);
+	/* 5 usec minimum reprogramming delta. */
+	hpet_clockevent.min_delta_ns = 5000;
 
 	/*
 	 * Start hpet with the boot cpu mask and make it

-- 

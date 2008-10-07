Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbYJGA4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbYJGA4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYJGApG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbYJGApE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:04 -0400
Date: Mon, 6 Oct 2008 17:39:23 -0700
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
Subject: [patch 44/71] HPET: make minimum reprogramming delta useful
Message-ID: <20081007003923.GS3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="timer-fix-06.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
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
@@ -223,8 +223,8 @@ static void hpet_legacy_clockevent_regis
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

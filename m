Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbYGVX3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbYGVX3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbYGVXUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:20:12 -0400
Received: from ns.suse.de ([195.135.220.2]:53239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223AbYGVXUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:20:10 -0400
Date: Tue, 22 Jul 2008 16:16:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       Ingo Molnar <mingo@elte.hu>, David Brownell <david-b@pacbell.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 32/47] rtc: fix reported IRQ rate for when HPET is enabled
Message-ID: <20080722231640.GG8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtc-fix-reported-irq-rate-for-when-hpet-is-enabled.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit 61ca9daa2ca3022dc9cb22bd98e69c1b61e412ad upstream

The IRQ rate reported back by the RTC is incorrect when HPET is enabled.

Newer hardware that has HPET to emulate the legacy RTC device gets this value
wrong since after it sets the rate, it returns before setting the variable
used to report the IRQ rate back to users of the device -- so the set rate and
the reported rate get out of sync.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/rtc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -677,12 +677,13 @@ static int rtc_do_ioctl(unsigned int cmd
 		if (arg != (1<<tmp))
 			return -EINVAL;
 
+		rtc_freq = arg;
+
 		spin_lock_irqsave(&rtc_lock, flags);
 		if (hpet_set_periodic_freq(arg)) {
 			spin_unlock_irqrestore(&rtc_lock, flags);
 			return 0;
 		}
-		rtc_freq = arg;
 
 		val = CMOS_READ(RTC_FREQ_SELECT) & 0xf0;
 		val |= (16 - tmp);

-- 

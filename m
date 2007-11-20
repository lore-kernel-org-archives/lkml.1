Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbXKTS32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbXKTS32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbXKTS0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:26:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60220 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761322AbXKTS0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:23 -0500
Date: Tue, 20 Nov 2007 10:23:31 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mitov@issp.bas.bg, ak@suse.de,
       tglx@linutronix.de, mingo@elte.hu
Subject: [patch 10/29] x86: disable preemption in delay_tsc()
Message-ID: <20071120182331.GK28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-disable-preemption-in-delay_tsc.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

patch 35d5d08a085c56f153458c3f5d8ce24123617faf in mainline.

Marin Mitov points out that delay_tsc() can misbehave if it is preempted and
rescheduled on a different CPU which has a skewed TSC.  Fix it by disabling
preemption.

(I assume that the worst-case behaviour here is a stall of 2^32 cycles)

Cc: Andi Kleen <ak@suse.de>
Cc: Marin Mitov <mitov@issp.bas.bg>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/lib/delay.c   |    3 +++
 arch/x86_64/lib/delay.c |   11 +++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/arch/i386/lib/delay.c
+++ b/arch/i386/lib/delay.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/preempt.h>
 #include <linux/delay.h>
 
 #include <asm/processor.h>
@@ -42,11 +43,13 @@ static void delay_tsc(unsigned long loop
 {
 	unsigned long bclock, now;
 
+	preempt_disable();		/* TSC's are per-cpu */
 	rdtscl(bclock);
 	do {
 		rep_nop();
 		rdtscl(now);
 	} while ((now-bclock) < loops);
+	preempt_enable();
 }
 
 /*
--- a/arch/x86_64/lib/delay.c
+++ b/arch/x86_64/lib/delay.c
@@ -10,7 +10,9 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/preempt.h>
 #include <linux/delay.h>
+
 #include <asm/delay.h>
 #include <asm/msr.h>
 
@@ -27,14 +29,15 @@ int read_current_timer(unsigned long *ti
 void __delay(unsigned long loops)
 {
 	unsigned bclock, now;
-	
+
+	preempt_disable();		/* TSC's are pre-cpu */
 	rdtscl(bclock);
-	do
-	{
+	do {
 		rep_nop(); 
 		rdtscl(now);
 	}
-	while((now-bclock) < loops);
+	while ((now-bclock) < loops);
+	preempt_enable();
 }
 EXPORT_SYMBOL(__delay);
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYJGAlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYJGAlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYJGAk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:40:58 -0400
Received: from mx1.suse.de ([195.135.220.2]:46462 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYJGAk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:40:57 -0400
Date: Mon, 6 Oct 2008 17:37:18 -0700
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
Subject: [patch 01/71] x86-32: AMD c1e force timer broadcast late
Message-ID: <20081007003718.GB3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-32-amd-c1e-force-timer-broadcast-late.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

This patch is not needed in 2.6.27 because it has new c1e-aware idle code.

In kernel 2.6.26 the 32-bit x86 timers are started earlier than before.
This breaks AMD c1e detection trying to force timer broadcast for the
local apic timer. Copy the code from the 64-bit kernel to force timer
broadcast late.

Reference:
http://bugzilla.kernel.org/show_bug.cgi?id=11427

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic_32.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -552,8 +552,31 @@ void __init setup_boot_APIC_clock(void)
 	setup_APIC_timer();
 }
 
-void __devinit setup_secondary_APIC_clock(void)
+/*
+ * AMD C1E enabled CPUs have a real nasty problem: Some BIOSes set the
+ * C1E flag only in the secondary CPU, so when we detect the wreckage
+ * we already have enabled the boot CPU local apic timer. Check, if
+ * disable_apic_timer is set and the DUMMY flag is cleared. If yes,
+ * set the DUMMY flag again and force the broadcast mode in the
+ * clockevents layer.
+ */
+static void __cpuinit check_boot_apic_timer_broadcast(void)
+{
+	if (!local_apic_timer_disabled ||
+	    (lapic_clockevent.features & CLOCK_EVT_FEAT_DUMMY))
+		return;
+
+	lapic_clockevent.features |= CLOCK_EVT_FEAT_DUMMY;
+
+	local_irq_enable();
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
+			   &boot_cpu_physical_apicid);
+	local_irq_disable();
+}
+
+void __cpuinit setup_secondary_APIC_clock(void)
 {
+	check_boot_apic_timer_broadcast();
 	setup_APIC_timer();
 }
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760381AbXHUG7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381AbXHUG7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbXHUGzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:55:31 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44348 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760452AbXHUGz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:55:29 -0400
Date: Mon, 20 Aug 2007 23:56:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, avi@qumranet.com,
       patches@x86-64.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andi Kleen <ak@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 18/20] i386: Handle P6s without performance counters in nmi
	watchdog
Message-ID: <20070821065600.GS5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i386-handle-p6s-without-performance-counters-in-nmi-watchdog.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andi Kleen <ak@suse.de>

I got an oops while booting a 32bit kernel on KVM because it doesn't
implement performance counters used by the NMI watchdog. Handle this
case.


Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/cpu/perfctr-watchdog.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -346,7 +346,9 @@ static int setup_p6_watchdog(unsigned nm
 	perfctr_msr = MSR_P6_PERFCTR0;
 	evntsel_msr = MSR_P6_EVNTSEL0;
 
-	wrmsrl(perfctr_msr, 0UL);
+	/* KVM doesn't implement this MSR */
+	if (wrmsr_safe(perfctr_msr, 0, 0) < 0)
+		return 0;
 
 	evntsel = P6_EVNTSEL_INT
 		| P6_EVNTSEL_OS

-- 

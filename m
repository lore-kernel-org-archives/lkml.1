Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbZKFWXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbZKFWXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760185AbZKFWW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:59 -0500
Received: from kroah.org ([198.145.64.141]:56867 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186AbZKFWW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:44 2009
Message-Id: <20091106221544.643003214@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Len Brown <len.brown@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [44/99] cpuidle: always return with interrupts enabled
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=cpuidle-always-return-with-interrupts-enabled.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kevin Hilman <khilman@deeprootsystems.com>

commit 246eb7f0ed1a8aeddec5313137767658f378949b upstream.

In the case where cpuidle_idle_call() returns before changing state due to
a need_resched(), it was returning with IRQs disabled.

The idle path assumes that the platform specific idle code returns with
interrupts enabled (although this too is undocumented AFAICT) and on ARM
we have a WARN_ON(!(irqs_disabled()) when returning from the idle loop, so
the user-visible effects were only a warning since interrupts were
eventually re-enabled later.

On x86, this same problem exists, but there is no WARN_ON() to detect it.
As on ARM, the interrupts are eventually re-enabled, so I'm not sure of
any actual bugs triggered by this.  It's primarily a
correctness/consistency fix.

This patch ensures IRQs are (re)enabled before returning.

Reported-by: Hemanth V <hemanthv@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Tested-by: Martin Michlmayr <tbm@cyrius.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpuidle/cpuidle.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -75,8 +75,11 @@ static void cpuidle_idle_call(void)
 #endif
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(dev);
-	if (need_resched())
+	if (need_resched()) {
+		local_irq_enable();
 		return;
+	}
+
 	target_state = &dev->states[next_state];
 
 	/* enter the state and update stats */



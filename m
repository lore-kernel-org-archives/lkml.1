Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0AOBxs (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984Ab0AOBxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:53:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:27425 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0AOBxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,278,1262592000"; 
   d="scan'208";a="531463718"
Message-Id: <20100115014210.299455000@intel.com>
References: <20100115013957.027452000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jan 2010 17:40:01 -0800
From: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Len Brown" <lenb@kernel.org>,
        "Mark Hounschell" <markh@compro.net>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Alain Knaff" <alain@knaff.lu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: [patch 4/4] x86: Adjust HPET MSI timer rating to work with tick_check_fallback_timer
Content-Disposition: inline; filename=0005-x86-Adjust-HPET-MSI-timer-rating-to-work-with-tick_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change we had
Normal lapic_clockevent rating 100
hpet MSI (percpu) clockevent rating 110
Always Running lapic_clockevent rating 150

As a result, on systems that support HPET MSI, percpu clockevents got
priority over LAPIC timer. That was ok when systems supported deep
C-state. But, that was sub-optimal on systems that did not support deep
C-states as HPETs are slower than LAPIC.

There was also a functional issue with usage of HPET MSI on some
platforms, which do not support deep C-state as reported here.
http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01118.html

After the change,
hpet MSI (percpu) clockevent rating 95
Normal lapic_clockevent rating 100
Always Running lapic_clockevent rating 150

And we reduce the rating of non-Always_Running LAPIC timer (to 90),
when we see that deep C-states are supported and switch to hpet MSI.

This change makes the timer usage optimal in terms of performance and
also eliminates the functionality issue mentioned above.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/kernel/hpet.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index dd9370b..ccb3752 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -555,7 +555,11 @@ static void init_one_hpet_msi_clockevent(struct hpet_dev *hdev, int cpu)
 	hpet_setup_irq(hdev);
 	evt->irq = hdev->irq;
 
-	evt->rating = 110;
+	/*
+	 * Rating should be within 10 less than lapic timer for
+	 * timer switch to happen when deep C-states are supported.
+	 */
+	evt->rating = 95;
 	evt->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_NO_BROADCAST;
 	if (hdev->flags & HPET_DEV_PERI_CAP)
 		evt->features |= CLOCK_EVT_FEAT_PERIODIC;
-- 
1.6.0.6

-- 


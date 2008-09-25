Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYIYJ2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYIYJ2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYIYJ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:28:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:39858 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231AbYIYJ2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:28:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,307,1220252400"; 
   d="scan'208";a="620169874"
Subject: [PATCH] USB: improve ehci_watchdog's side effect in CPU power
	management
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: linux-kernel@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, gregkh@suse.de, akpm@linux-foundation.org
Content-Type: text/plain
Organization: Intel
Date: Thu, 25 Sep 2008 17:25:44 +0800
Message-Id: <1222334744.9267.41.camel@yangyi-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ehci_watchdog will wake up CPU very frequently so that CPU
stays at C3 very short, average residence time is about 50
ms on Aspire One, but we expect it should be about 1 second
or more, so this kind of periodic timer is very bad for power
saving.

We can't remove this timer because of some bad USB controller
chipset, but at least we should reduce its side effect to as
possible as low.

This patch can make CPU stay at C3 longer, average residence time
is about twice as long as original. 

Please consider to apply it, thanks

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 ehci.h |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 5799298..9d530d9 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -181,14 +181,16 @@ timer_action (struct ehci_hcd *ehci, enum ehci_timer_action action)
 	 * the async ring; just the I/O watchdog.  Note that if a
 	 * SHRINK were pending, OFF would never be requested.
 	 */
-	if (timer_pending(&ehci->watchdog)
-			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
-				& ehci->actions))
-		return;
+	enum ehci_timer_action oldactions = ehci->actions;
 
 	if (!test_and_set_bit (action, &ehci->actions)) {
 		unsigned long t;
 
+		if (timer_pending(&ehci->watchdog)
+			&& ((BIT(TIMER_ASYNC_SHRINK) | BIT(TIMER_ASYNC_OFF))
+				& oldactions))
+			return;
+
 		switch (action) {
 		case TIMER_IO_WATCHDOG:
 			t = EHCI_IO_JIFFIES;
@@ -204,7 +206,7 @@ timer_action (struct ehci_hcd *ehci, enum ehci_timer_action action)
 			t = DIV_ROUND_UP(EHCI_SHRINK_FRAMES * HZ, 1000) + 1;
 			break;
 		}
-		mod_timer(&ehci->watchdog, t + jiffies);
+		mod_timer(&ehci->watchdog, round_jiffies(t + jiffies));
 	}
 }
 



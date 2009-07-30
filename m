Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZG3T7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZG3T7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZG3T7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:59:38 -0400
Received: from www.tglx.de ([62.245.132.106]:56362 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZG3T7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:59:38 -0400
Date: Thu, 30 Jul 2009 21:58:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timers fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907302158180.2936@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	tglx

------------------>
Magnus Damm (1):
      clocksource: save mult_orig in clocksource_disable()


 include/linux/clocksource.h |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c56457c..aff9f01 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -293,7 +293,11 @@ static inline int clocksource_enable(struct clocksource *cs)
 	if (cs->enable)
 		ret = cs->enable(cs);
 
-	/* save mult_orig on enable */
+	/* The frequency may have changed while the clocksource
+	 * was disabled. If so the code in ->enable() must update
+	 * the mult value to reflect the new frequency. Make sure
+	 * mult_orig follows this change.
+	 */
 	cs->mult_orig = cs->mult;
 
 	return ret;
@@ -309,6 +313,12 @@ static inline int clocksource_enable(struct clocksource *cs)
  */
 static inline void clocksource_disable(struct clocksource *cs)
 {
+	/* Save mult_orig in mult so clocksource_enable() can
+	 * restore the value regardless if ->enable() updates
+	 * the value of mult or not.
+	 */
+	cs->mult = cs->mult_orig;
+
 	if (cs->disable)
 		cs->disable(cs);
 }

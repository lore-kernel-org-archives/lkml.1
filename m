Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbZG3T6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbZG3T6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZG3T6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:58:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:55321 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZG3T6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:58:04 -0400
Date: Thu, 30 Jul 2009 19:57:36 GMT
From: tip-bot for Magnus Damm <magnus.damm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       damm@igel.co.jp, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       damm@igel.co.jp, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
References: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
Subject: [tip:timers/urgent] clocksource: save mult_orig in clocksource_disable()
Message-ID: <tip-a52c77102626951144165c53a6b54f1e812360d5@git.kernel.org>
Git-Commit-ID: a52c77102626951144165c53a6b54f1e812360d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Jul 2009 19:57:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a52c77102626951144165c53a6b54f1e812360d5
Gitweb:     http://git.kernel.org/tip/a52c77102626951144165c53a6b54f1e812360d5
Author:     Magnus Damm <magnus.damm@gmail.com>
AuthorDate: Tue, 28 Jul 2009 14:09:55 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 30 Jul 2009 21:55:47 +0200

clocksource: save mult_orig in clocksource_disable()

Save clocksource mult_orig in clocksource_disable().

To fix the common case where ->enable() does not setup
mult, make sure mult_orig is saved in mult on disable.

Also add comments to explain why we do this.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: johnstul@us.ibm.com
Cc: lethal@linux-sh.org
Cc: akpm@linux-foundation.org
LKML-Reference: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
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

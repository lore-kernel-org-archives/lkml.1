Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZGaMRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZGaMRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 08:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZGaMQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 08:16:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:35607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZGaMQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 08:16:59 -0400
Date: Fri, 31 Jul 2009 12:16:22 GMT
From: tip-bot for Magnus Damm <magnus.damm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       damm@igel.co.jp, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       damm@igel.co.jp, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
References: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
Subject: [tip:timers/urgent] clocksource: Save mult_orig in clocksource_disable()
Message-ID: <tip-c7121843685de2bf7f3afd3ae1d6a146010bf1fc@git.kernel.org>
Git-Commit-ID: c7121843685de2bf7f3afd3ae1d6a146010bf1fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 31 Jul 2009 12:16:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7121843685de2bf7f3afd3ae1d6a146010bf1fc
Gitweb:     http://git.kernel.org/tip/c7121843685de2bf7f3afd3ae1d6a146010bf1fc
Author:     Magnus Damm <magnus.damm@gmail.com>
AuthorDate: Tue, 28 Jul 2009 14:09:55 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 31 Jul 2009 14:12:36 +0200

clocksource: Save mult_orig in clocksource_disable()

To fix the common case where ->enable() does not set up
mult, make sure mult_orig is saved in mult on disable.

Also add comments to explain why we do this.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: johnstul@us.ibm.com
Cc: lethal@linux-sh.org
Cc: akpm@linux-foundation.org
LKML-Reference: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 include/linux/clocksource.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c56457c..1219be4 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -293,7 +293,12 @@ static inline int clocksource_enable(struct clocksource *cs)
 	if (cs->enable)
 		ret = cs->enable(cs);
 
-	/* save mult_orig on enable */
+	/*
+	 * The frequency may have changed while the clocksource
+	 * was disabled. If so the code in ->enable() must update
+	 * the mult value to reflect the new frequency. Make sure
+	 * mult_orig follows this change.
+	 */
 	cs->mult_orig = cs->mult;
 
 	return ret;
@@ -309,6 +314,13 @@ static inline int clocksource_enable(struct clocksource *cs)
  */
 static inline void clocksource_disable(struct clocksource *cs)
 {
+	/*
+	 * Save mult_orig in mult so clocksource_enable() can
+	 * restore the value regardless if ->enable() updates
+	 * the value of mult or not.
+	 */
+	cs->mult = cs->mult_orig;
+
 	if (cs->disable)
 		cs->disable(cs);
 }

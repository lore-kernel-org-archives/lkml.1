Return-Path: <linux-kernel-owner+w=401wt.eu-S1762315AbZFRP2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315AbZFRP2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbZFRP2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:28:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:40331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbZFRP2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=QQ203zm4rTwmBPXHOT+1cUmIpiKeTh5eDtAFiuUJiG+PRg5AQH5f7JlZ2WLdWGv3dk
         8/vhOx3BJYBkAoWZY2xaqLWdQ6aNta5UfUB+FcCfvXDQMVQuC/qvDNz+2/GH4iZdBHyy
         J5pMzGmMAc7eEclrlZgn1MTihZG4MLe/5qfK4=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, lethal@linux-sh.org,
       tglx@linutronix.de, akpm@linux-foundation.org,
       Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 19 Jun 2009 00:24:32 +0900
Message-Id: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
Subject: [PATCH] clocksource: save mult_orig in clocksource_disable()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Save clocksource mult_orig in clocksource_disable().

To fix the common case where ->enable() does not setup
mult, make sure mult_orig is saved in mult on disable.

Also add comments to explain why we do this.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/linux/clocksource.h |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- 0001/include/linux/clocksource.h
+++ work/include/linux/clocksource.h	2009-06-19 00:12:16.000000000 +0900
@@ -293,7 +293,11 @@ static inline int clocksource_enable(str
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
@@ -309,6 +313,12 @@ static inline int clocksource_enable(str
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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYIAXP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYIAXP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYIAXPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:15:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:40542 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYIAXPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:20 -0400
Date: Mon, 1 Sep 2008 16:05:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 1/13] hrtimer: add abstraction functions for accessing the
 "expires" member
Message-ID: <20080901160502.1dbfed9e@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: add abstraction functions for accessing the "expires" member

In order to be able to turn hrtimers into range based, we need to provide
accessor functions for getting to the "expires" ktime_t member of the
struct hrtimer.

This patch adds a set of accessors for this purpose:
* hrtimer_set_expires
* hrtimer_set_expires_tv64
* hrtimer_add_expires
* hrtimer_add_expires_ns
* hrtimer_get_expires
* hrtimer_get_expires_tv64
* hrtimer_get_expires_ns
* hrtimer_expires_remaining
* hrtimer_start_expires

No users of these new accessors are added yet; these follow in later patches.
Hopefully this patch can even go into 2.6.27-rc so that the conversions will
not have a bottleneck in -next

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/hrtimer.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index becd17d..9900e99 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -217,6 +217,45 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 	return timer->base->cpu_base->hres_active;
 }
 
+static inline void hrtimer_set_expires(struct hrtimer *timer, ktime_t time)
+{
+	timer->expires = time;
+}
+static inline void hrtimer_set_expires_tv64(struct hrtimer *timer, s64 tv64)
+{
+	timer->expires.tv64 = tv64;
+}
+
+static inline void hrtimer_add_expires(struct hrtimer *timer, ktime_t time)
+{
+	timer->expires = ktime_add_safe(timer->expires, time);
+}
+
+static inline void hrtimer_add_expires_ns(struct hrtimer *timer, unsigned long ns)
+{
+	timer->expires = ktime_add_ns(timer->expires, ns);
+}
+
+static inline ktime_t hrtimer_get_expires(const struct hrtimer *timer)
+{
+	return timer->expires;
+}
+
+static inline s64 hrtimer_get_expires_tv64(const struct hrtimer *timer)
+{
+	return timer->expires.tv64;
+}
+
+static inline s64 hrtimer_get_expires_ns(const struct hrtimer *timer)
+{
+	return ktime_to_ns(timer->expires);
+}
+
+static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
+{
+    return ktime_sub(timer->expires, timer->base->get_time());
+}
+
 /*
  * The resolution of the clocks. The resolution value is returned in
  * the clock_getres() system call to give application programmers an
@@ -287,6 +326,12 @@ extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
 extern int hrtimer_cancel(struct hrtimer *timer);
 extern int hrtimer_try_to_cancel(struct hrtimer *timer);
 
+static inline int hrtimer_start_expires(struct hrtimer *timer,
+						enum hrtimer_mode mode)
+{
+	return hrtimer_start(timer, hrtimer_get_expires(timer), mode);
+}
+
 static inline int hrtimer_restart(struct hrtimer *timer)
 {
 	return hrtimer_start(timer, timer->expires, HRTIMER_MODE_ABS);
-- 
1.5.5.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbZBDSq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbZBDSq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758600AbZBDShf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:35 -0500
Received: from kroah.org ([198.145.64.141]:51178 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754723AbZBDShX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:23 -0500
Date: Wed, 4 Feb 2009 10:35:07 -0800
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
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       venkatesh.pallipadi@intel.com, Thomas Renninger <trenn@suse.de>
Subject: [patch 26/33] cpuidle: Add decaying history logic to menu idle
	predictor
Message-ID: <20090204183507.GA13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpuidle-add-decaying-history-logic-to-menu-idle-predictor.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit 816bb611e41be29b476dc16f6297eb551bf4d747 upstream

Add decaying history of predicted idle time, instead of using the last early
wakeup. This logic helps menu governor do better job of predicting idle time.

With this change, we also measured noticable (~8%) power savings on
a DP server system with CPUs supporting deep C states, when system
was lightly loaded. There was no change to power or perf on other load
conditions.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpuidle/governors/menu.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -15,12 +15,14 @@
 #include <linux/tick.h>
 
 #define BREAK_FUZZ	4	/* 4 us */
+#define PRED_HISTORY_PCT	50
 
 struct menu_device {
 	int		last_state_idx;
 
 	unsigned int	expected_us;
 	unsigned int	predicted_us;
+	unsigned int    current_predicted_us;
 	unsigned int	last_measured_us;
 	unsigned int	elapsed_us;
 };
@@ -47,6 +49,12 @@ static int menu_select(struct cpuidle_de
 	data->expected_us =
 		(u32) ktime_to_ns(tick_nohz_get_sleep_length()) / 1000;
 
+	/* Recalculate predicted_us based on prediction_history_pct */
+	data->predicted_us *= PRED_HISTORY_PCT;
+	data->predicted_us += (100 - PRED_HISTORY_PCT) *
+				data->current_predicted_us;
+	data->predicted_us /= 100;
+
 	/* find the deepest idle state that satisfies our constraints */
 	for (i = CPUIDLE_DRIVER_STATE_START + 1; i < dev->state_count; i++) {
 		struct cpuidle_state *s = &dev->states[i];
@@ -97,7 +105,7 @@ static void menu_reflect(struct cpuidle_
 		measured_us = -1;
 
 	/* Predict time until next break event */
-	data->predicted_us = max(measured_us, data->last_measured_us);
+	data->current_predicted_us = max(measured_us, data->last_measured_us);
 
 	if (last_idle_us + BREAK_FUZZ <
 	    data->expected_us - target->exit_latency) {


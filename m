Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbYF0AQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbYF0AQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbYF0APc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:15:32 -0400
Received: from saeurebad.de ([85.214.36.134]:59901 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbYF0APb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:15:31 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri Jun 27 02:08:05 2008
Message-Id: <20080627000805.279106291@saeurebad.de>
References: <20080627000445.346130358@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 02:04:47 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] softlockup: sanitize print-out limit checks
Content-Disposition: inline; filename=softlockup-bogus-report-delay-checks.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The print_timestamp can never be bigger than the touch_timestamp, at
maximum it can be equal.  And if it is, the second check for
touch_timestamp + 1 bigger print_timestamp is always true, too.

The check for equality is sufficient as we proceed in one-second-steps
and are at least one second away from the last print-out if we have
another timestamp.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 kernel/softlockup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -93,11 +93,11 @@ void softlockup_tick(void)
 	print_timestamp = per_cpu(print_timestamp, this_cpu);
 
 	/* report at most once a second */
-	if ((print_timestamp >= touch_timestamp &&
-			print_timestamp < (touch_timestamp + 1)) ||
-			did_panic || !per_cpu(watchdog_task, this_cpu)) {
+	if (print_timestamp == touch_timestamp)
+		return;
+
+	if (did_panic || !per_cpu(watchdog_task, this_cpu))
 		return;
-	}
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {

-- 


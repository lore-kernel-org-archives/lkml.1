Return-Path: <linux-kernel-owner+w=401wt.eu-S933286AbXBWXSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbXBWXSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933272AbXBWXRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:17:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:54401 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbXBWXRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:17:38 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/9] power management: no valid states w/o pm_ops
Date: Fri, 23 Feb 2007 15:15:52 -0800
Message-Id: <1172272569255-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.1
In-Reply-To: <1172272565581-git-send-email-gregkh@suse.de>
References: <20070223231426.GA20498@kroah.com> <11722725561867-git-send-email-gregkh@suse.de> <11722725592291-git-send-email-gregkh@suse.de> <11722725623183-git-send-email-gregkh@suse.de> <1172272565581-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

Change /sys/power/state to not advertise any valid states (except for disk
if SOFTWARE_SUSPEND is enabled) when no pm_ops have been set so userspace
can easily discover what states should be available.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Macheck <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/power/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index e1c4131..a064dfd 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -167,7 +167,10 @@ static inline int valid_state(suspend_state_t state)
 	if (state == PM_SUSPEND_DISK)
 		return 1;
 
-	if (pm_ops && pm_ops->valid && !pm_ops->valid(state))
+	/* all other states need lowlevel support and need to be
+	 * valid to the lowlevel implementation, no valid callback
+	 * implies that all are valid. */
+	if (!pm_ops || (pm_ops->valid && !pm_ops->valid(state)))
 		return 0;
 	return 1;
 }
-- 
1.5.0.1


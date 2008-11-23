Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYKWNPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYKWNPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 08:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbYKWNP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 08:15:27 -0500
Received: from ns.suse.de ([195.135.220.2]:43933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590AbYKWNPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 08:15:25 -0500
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, wim@iguana.be, stable@kernel.org,
       Thomas.Mingarelli@hp.com, Bernhard Walle <bwalle@suse.de>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] [WATCHDOG] Fix kdump when using hpwdt
Date: Sun, 23 Nov 2008 14:15:24 +0100
Message-Id: <1227446124-10856-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the "hpwdt" module is loaded (even if the /dev/watchdog device is not
opened), then kdump does not work. The panic kernel either does not start at
all or crash in various places.

The problem is that hpwdt_pretimeout is registered with register_die_notifier()
with the highest possible priority. Because it returns NOTIFY_STOP, the
crash_nmi_callback which is also registered with register_die_notifier() is
never executed. This causes the shutdown of other CPUs to fail.

Reverting the order is no option: The crash_nmi_callback executes HLT and so
never returns normally. Because of that, it must be executed as last notifier,
which currently is done.

So, that patch returns NOTIFY_OK to keep the crash_nmi_callback executed.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/watchdog/hpwdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a3765e0..21fe202 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -482,7 +482,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 			"Management Log for details.\n");
 	}
 
-	return NOTIFY_STOP;
+	return NOTIFY_OK;
 }
 
 /*
-- 
1.6.0.2


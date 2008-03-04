Return-Path: <linux-kernel-owner+w=401wt.eu-S935381AbYCDX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935381AbYCDX0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934981AbYCDXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:19:16 -0500
Received: from mx1.suse.de ([195.135.220.2]:49216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934095AbYCDXTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:19:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/8] PM: fix new mutex-locking bug in the PM core
Date: Tue,  4 Mar 2008 15:18:49 -0800
Message-Id: <1204672732-3127-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080304231519.GC3073@suse.de>
References: <20080304231519.GC3073@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1041) fixes a bug introduced by the
acquire-all-device-semaphores reversion.  The error pathway of
dpm_suspend() fails to reacquire a mutex it should be holding.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index b0c16f6..d887d5c 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -428,6 +428,7 @@ static int dpm_suspend(pm_message_t state)
 
 		mutex_unlock(&dpm_list_mtx);
 		error = suspend_device(dev, state);
+		mutex_lock(&dpm_list_mtx);
 		if (error) {
 			printk(KERN_ERR "Could not suspend device %s: "
 					"error %d%s\n",
@@ -438,7 +439,6 @@ static int dpm_suspend(pm_message_t state)
 					""));
 			break;
 		}
-		mutex_lock(&dpm_list_mtx);
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &dpm_off);
 	}
-- 
1.5.4.3


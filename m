Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbZLONa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbZLONa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 08:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbZLONa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 08:30:26 -0500
Received: from smtp-out-130.synserver.de ([212.40.180.130]:1259 "HELO
	smtp-out-130.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759623AbZLONaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 08:30:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 4354
From: Lars-Peter Clausen <lars@metafoo.de>
To: lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regulator: Fix unbalanced disables/enables in regulator_bulk_{enable,disable} error path
Date: Tue, 15 Dec 2009 14:30:01 +0100
Message-Id: <1260883801-22667-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it is possible for regulator_bulk_{enable,disable} operations to
generate unbalanced regulator_{disable,enable} calls in its error path.
In case of an error only those regulators of the bulk operation which actually
had been enabled/disabled should get their original state restored.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/regulator/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1af8df2..686ef27 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1977,7 +1977,7 @@ int regulator_bulk_enable(int num_consumers,
 
 err:
 	printk(KERN_ERR "Failed to enable %s: %d\n", consumers[i].supply, ret);
-	for (i = 0; i < num_consumers; i++)
+	for (--i; i >= 0; --i)
 		regulator_disable(consumers[i].consumer);
 
 	return ret;
@@ -2013,7 +2013,7 @@ int regulator_bulk_disable(int num_consumers,
 err:
 	printk(KERN_ERR "Failed to disable %s: %d\n", consumers[i].supply,
 	       ret);
-	for (i = 0; i < num_consumers; i++)
+	for (--i; i >= 0; --i)
 		regulator_enable(consumers[i].consumer);
 
 	return ret;
-- 
1.5.6.5


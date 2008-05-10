Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYEJMRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYEJMRr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 08:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbYEJMRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 08:17:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:46315 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbYEJMRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 08:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=P7uqC//5HATtygI3FcyiqggvDQrW9DIKFbzGB/OMxZNSLFWU5wsr1GYW5bOxUVsCuYrb2i+yekKBgjb/6jz+zkODxSBuS4mw7WfvhJhfbeipvLGvg7rCSQbP1SXhXw7UmMxqxue+SdBNKOjsXDvbbCVIu+B6MzVijnJYmrTk6do=
From: Abdel Benamrouche <draconux@gmail.com>
To: aeb@cwi.nl
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Abdel Benamrouche <draconux@gmail.com>
Subject: [PATCH] /fs/partition/check.c: fix return value warning
Date: Sat, 10 May 2008 13:40:53 +0200
Message-Id: <1210419653-19234-1-git-send-email-draconux@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/partitions/check.c:381: warning: ignoring return value of ‘device_add’,
 declared with attribute warn_unused_result

Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
---
:100644 100644 6149e4b... 7a87fad... M	fs/partitions/check.c
 fs/partitions/check.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6149e4b..7a87fad 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -378,7 +378,13 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
 
 	/* delay uevent until 'holders' subdir is created */
 	p->dev.uevent_suppress = 1;
-	device_add(&p->dev);
+	if (device_add(&p->dev)) {
+		put_device(&p->dev);
+		free_part_stats(p);
+		kfree(p);
+		return;
+	}
+
 	partition_sysfs_add_subdir(p);
 	p->dev.uevent_suppress = 0;
 	if (flags & ADDPART_FLAG_WHOLEDISK)
-- 
1.5.4.3


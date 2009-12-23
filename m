Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZLWTzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZLWTzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbZLWTze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:55:34 -0500
Received: from kroah.org ([198.145.64.141]:52964 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756851AbZLWTxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/10] devtmpfs: unlock mutex in case of string allocation error
Date: Wed, 23 Dec 2009 11:52:43 -0800
Message-Id: <1261597963-18323-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 278371c..090dd48 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -101,8 +101,10 @@ static int create_path(const char *nodepath)
 
 		/* parent directories do not exist, create them */
 		path = kstrdup(nodepath, GFP_KERNEL);
-		if (!path)
-			return -ENOMEM;
+		if (!path) {
+			err = -ENOMEM;
+			goto out;
+		}
 		s = path;
 		for (;;) {
 			s = strchr(s, '/');
@@ -117,6 +119,7 @@ static int create_path(const char *nodepath)
 		}
 		kfree(path);
 	}
+out:
 	mutex_unlock(&dirlock);
 	return err;
 }
-- 
1.6.5.7


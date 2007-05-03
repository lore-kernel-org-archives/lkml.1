Return-Path: <linux-kernel-owner+w=401wt.eu-S1767318AbXECCN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767318AbXECCN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767320AbXECCN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:13:56 -0400
Received: from mx1.suse.de ([195.135.220.2]:56270 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767318AbXECCNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:13:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tilman Schmidt <tilman@imap.cc>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 1/5] Driver core: fix show_uevent from taking up way too much stack
Date: Wed,  2 May 2007 19:11:29 -0700
Message-Id: <11781582932668-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <20070503020924.GB21316@kroah.com>
References: <20070503020924.GB21316@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring an array of PAGE_SIZE does bad things for people running with
4k stacks...

Thanks to Tilman Schmidt for tracking this down.

Cc: Tilman Schmidt <tilman@imap.cc>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 8aa090d..59d9816 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -252,7 +252,7 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 	struct kobject *top_kobj;
 	struct kset *kset;
 	char *envp[32];
-	char data[PAGE_SIZE];
+	char *data = NULL;
 	char *pos;
 	int i;
 	size_t count = 0;
@@ -276,6 +276,10 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 		if (!kset->uevent_ops->filter(kset, &dev->kobj))
 			goto out;
 
+	data = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	/* let the kset specific function add its keys */
 	pos = data;
 	retval = kset->uevent_ops->uevent(kset, &dev->kobj,
@@ -290,6 +294,7 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 		count += sprintf(pos, "%s\n", envp[i]);
 	}
 out:
+	free_page((unsigned long)data);
 	return count;
 }
 
-- 
1.5.1.2


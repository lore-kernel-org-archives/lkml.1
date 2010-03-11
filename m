Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0CKUu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:50:58 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47679 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0CKUu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EEHzym61TLhJgUvl8DI9ngfCyS7qkPulZSiHuGB8RoBUkKS57Fc4XN/RiATrcjMV+G
         xBmGvJF7wkYrH32WiyWs2wWa8ICH2OWhCUEgK6V6itJkAF5z8t9cBk2v1jvsiRl0JKjy
         ryvZg5fwMaUoWsUQyLhVlIwEMgRoh2yAgVVyU=
Subject: [PATCH] kobject: Fix kobject_set_name_vargs()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 21:50:52 +0100
Message-ID: <1268340652.2845.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of kvasprintf() failure, we can leak old kobject name.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/lib/kobject.c b/lib/kobject.c
index 8115eb1..1247c57 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return 0;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	if (!kobj->name) {
+		kobj->name = old_name;
 		return -ENOMEM;
+	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))



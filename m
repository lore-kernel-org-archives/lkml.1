Return-Path: <linux-kernel-owner+w=401wt.eu-S1761177AbXJEJip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177AbXJEJip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXJEJih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:38:37 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:54918 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbXJEJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:38:36 -0400
To: wfg@mail.ustc.edu.cn
CC: linux-kernel@vger.kernel.org, miklos@szeredi.hu, gregkh@suse.de,
       akpm@linux-foundation.org
In-reply-to: <391574553.18064@ustc.edu.cn> (message from Fengguang Wu on Fri,
	5 Oct 2007 16:55:50 +0800)
Subject: Re: BUG on unloading the fuse module
References: <391574553.18064@ustc.edu.cn>
Message-Id: <E1Idjd8-0002rY-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 11:37:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In 2.6.23-rc8-mm2, the fuse module always bugs on unloading.

It's fixed in Greg's patch queue.

This patch against -mm will also fix it.

Thanks,
Miklos
---

Index: linux/lib/kobject.c
===================================================================
--- linux.orig/lib/kobject.c	2007-10-02 17:20:04.000000000 +0200
+++ linux/lib/kobject.c	2007-10-03 13:58:42.000000000 +0200
@@ -498,18 +498,17 @@ void kobject_cleanup(struct kobject * ko
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
 	struct kobject * parent = kobj->parent;
-	const char *k_name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
-	kobj->k_name = NULL;
-	if (t && t->release)
+	if (t && t->release) {
 		t->release(kobj);
-	else
+		kfree(kobj->k_name);
+		kobj->k_name = NULL;
+	} else
 		pr_debug("kobject '%s' does not have a release() function, "
 			"if this is not a directory kobject, it is broken "
 			"and must be fixed.\n",
-			k_name);
-	kfree(k_name);
+			kobj->k_name);
 	if (s)
 		kset_put(s);
 	kobject_put(parent);

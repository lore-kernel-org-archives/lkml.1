Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbXJEKyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbXJEKyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 06:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJEKy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 06:54:29 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:39747 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbXJEKy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 06:54:28 -0400
To: wfg@mail.ustc.edu.cn
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, gregkh@suse.de,
       akpm@linux-foundation.org
In-reply-to: <391581094.26735@ustc.edu.cn> (message from Fengguang Wu on Fri,
	5 Oct 2007 18:44:50 +0800)
Subject: Re: BUG on unloading the fuse module
References: <391574553.18064@ustc.edu.cn> <E1Idjd8-0002rY-00@dorka.pomaz.szeredi.hu> <391581094.26735@ustc.edu.cn>
Message-Id: <E1Idkor-0002v6-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 12:54:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > In 2.6.23-rc8-mm2, the fuse module always bugs on unloading.
> > 
> > It's fixed in Greg's patch queue.
> > 
> > This patch against -mm will also fix it.
> 
> Oh no, it panics:

How about this one?

Thanks,
Miklos
---

Index: linux/lib/kobject.c
===================================================================
--- linux.orig/lib/kobject.c	2007-10-02 17:20:04.000000000 +0200
+++ linux/lib/kobject.c	2007-10-05 12:52:52.000000000 +0200
@@ -498,18 +498,18 @@ void kobject_cleanup(struct kobject * ko
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
 	struct kobject * parent = kobj->parent;
-	const char *k_name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
-	kobj->k_name = NULL;
-	if (t && t->release)
+	if (t && t->release) {
+		const char *k_name = kobj->k_name;
+		kobj->k_name = NULL;
 		t->release(kobj);
-	else
+		kfree(k_name);
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

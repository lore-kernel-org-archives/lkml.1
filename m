Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbZD1HjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbZD1HjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760373AbZD1Hix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:38:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:49281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760251AbZD1Hiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:38:52 -0400
Message-ID: <49F6B1E6.7050008@kernel.org>
Date: Tue, 28 Apr 2009 00:36:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] driver: make dev_set_name(, NULL) work
References: <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain> <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de> <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy> <20090418203718.GD30144@elte.hu> <49EA4EB9.2030307@kernel.org>
In-Reply-To: <49EA4EB9.2030307@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


while looking dev_set_name() calling, there is one
	dev_set_name(&dev->dev, NULL)
to used to try to free the device name, before kfree that device.

need to move the check for device_add in
| commit 8a577ffc75d9194fe8cdb7479236f2081c26ca1f
| Author: Kay Sievers <kay.sievers@vrfy.org>
| Date:   Sat Apr 18 15:05:45 2009 -0700
|
|    driver: dont update dev_name via device_add path
from kobject_set_name_vargs to kobject_add_vargs instead.

in kobject_set_name_vargs will check if fmt is NULL.

actually we need to use dev_set_name(,NULL) later on failing path
and release to prevent leaking

[ Impact: make dev_set_name(, NULL) could kfree old name ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 lib/kobject.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/lib/kobject.c
===================================================================
--- linux-2.6.orig/lib/kobject.c
+++ linux-2.6/lib/kobject.c
@@ -218,8 +218,8 @@ int kobject_set_name_vargs(struct kobjec
 	const char *old_name = kobj->name;
 	char *s;
 
-	if (kobj->name && !fmt)
-		return 0;
+	if (!fmt)
+		goto out;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
 	if (!kobj->name)
@@ -229,6 +229,7 @@ int kobject_set_name_vargs(struct kobjec
 	while ((s = strchr(kobj->name, '/')))
 		s[0] = '!';
 
+out:
 	kfree(old_name);
 	return 0;
 }
@@ -301,11 +302,16 @@ static int kobject_add_varg(struct kobje
 {
 	int retval;
 
+	if (kobj->name && !fmt)
+		goto add_with_name;
+
 	retval = kobject_set_name_vargs(kobj, fmt, vargs);
 	if (retval) {
 		printk(KERN_ERR "kobject: can not set name properly!\n");
 		return retval;
 	}
+
+add_with_name:
 	kobj->parent = parent;
 	return kobject_add_internal(kobj);
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbZIIQxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbZIIQxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZIIQxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:53:38 -0400
Received: from mtagate8-bp.emea.ibm.com ([195.212.17.168]:56731 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751987AbZIIQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:53:38 -0400
Date: Wed, 9 Sep 2009 18:53:21 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost.localdomain
To: linux-kernel@vger.kernel.org
cc: kay.sievers@vrfy.org, gregkh@suse.de
Subject: [PATCH] kobject_set_name: free old_name in case of ENOMEM
Message-ID: <alpine.LFD.2.00.0909091838080.3303@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Erich Baier Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If the memory allocation for the kobject's name fails we should free
the old_name since it is no longer accessible via kobj->name.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 lib/kobject.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: git.linux-2.6/lib/kobject.c
===================================================================
--- git.linux-2.6.orig/lib/kobject.c	2009-06-17 10:35:55.000000000 +0200
+++ git.linux-2.6/lib/kobject.c	2009-09-09 18:21:39.000000000 +0200
@@ -222,8 +222,10 @@ int kobject_set_name_vargs(struct kobjec
 		return 0;
 
 	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	if (!kobj->name) {
+		kfree(old_name);
 		return -ENOMEM;
+	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
 	while ((s = strchr(kobj->name, '/')))

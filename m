Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbXDJMdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbXDJMdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXDJMdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:33:10 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:51279 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbXDJMdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:33:09 -0400
Date: Tue, 10 Apr 2007 14:35:27 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg K-H <greg@kroah.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk
Subject: [Patch -mm] kobject: kobject_add() reference leak
Message-ID: <20070410143527.2b7718b8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070410143106.03d62e7c@gondolin.boeblingen.de.ibm.com>
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
	<20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
	<20070405045410.GA4692@localhost.localdomain>
	<20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
	<20070405144409.GA5294@localhost.localdomain>
	<20070405170514.481b765f@gondolin.boeblingen.de.ibm.com>
	<20070405152732.GA5569@localhost.localdomain>
	<20070405180016.5099e0cd@gondolin.boeblingen.de.ibm.com>
	<20070406025343.GA2407@localhost.localdomain>
	<20070410143106.03d62e7c@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<This patch is the "pathological case" in the referenced mail.>

We leak a reference if we attempt to add a kobject with no name.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 lib/kobject.c |    1 +
 1 files changed, 1 insertion(+)

--- linux-2.6.21-rc6-mm1.orig/lib/kobject.c
+++ linux-2.6.21-rc6-mm1/lib/kobject.c
@@ -218,6 +218,7 @@ int kobject_shadow_add(struct kobject * 
 	if (!*kobj->k_name) {
 		pr_debug("kobject attempted to be registered with no name!\n");
 		WARN_ON(1);
+		kobject_put(kobj);
 		return -EINVAL;
 	}
 	parent = kobject_get(kobj->parent);

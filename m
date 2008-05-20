Return-Path: <linux-kernel-owner+w=401wt.eu-S1765374AbYETMEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765374AbYETMEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbYETMEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:04:08 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:50257 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756542AbYETMEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:04:06 -0400
Date: Tue, 20 May 2008 21:04:05 +0900 (JST)
Message-Id: <20080520.210405.107683253.taka@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, agk@sourceware.org
Subject: [PATCH 4/4] BIO tracking take2
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080520.205949.127764004.taka@valinux.co.jp>
References: <20080520.205949.127764004.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With this patch, dm-ioband can work with the bio cgroup.


Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


diff -dupr linux-2.6.26-rc2.cg2/drivers/md/dm-ioband-type.c linux-2.6.26-rc2/drivers/md/dm-ioband-type.c
--- linux-2.6.26-rc2.cg2/drivers/md/dm-ioband-type.c	2008-05-19 13:51:23.000000000 +0900
+++ linux-2.6.26-rc2/drivers/md/dm-ioband-type.c	2008-05-19 18:40:10.000000000 +0900
@@ -6,6 +6,7 @@
  * This file is released under the GPL.
  */
 #include <linux/bio.h>
+#include <linux/biocontrol.h>
 #include "dm.h"
 #include "dm-bio-list.h"
 #include "dm-ioband.h"
@@ -53,13 +54,13 @@ static int ioband_node(struct bio *bio)
 
 static int ioband_cgroup(struct bio *bio)
 {
-  /*
-   * This function should return the ID of the cgroup which issued "bio".
-   * The ID of the cgroup which the current process belongs to won't be
-   * suitable ID for this purpose, since some BIOs will be handled by kernel
-   * threads like aio or pdflush on behalf of the process requesting the BIOs.
-   */
-	return 0;	/* not implemented yet */
+	struct io_context *ioc = get_bio_cgroup_iocontext(bio);
+	int id = 0;
+	if (ioc) {
+		id = ioc->id;
+		put_io_context(ioc);
+	}
+	return id;
 }
 
 struct group_type dm_ioband_group_type[] = {

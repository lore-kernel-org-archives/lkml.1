Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYHLMh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYHLMh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYHLMhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:37:10 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:38045 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752450AbYHLMhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:37:09 -0400
Date: Tue, 12 Aug 2008 21:37:08 +0900 (JST)
Message-Id: <20080812.213708.39164284.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, fernando@oss.ntt.co.jp
Subject: [PATCH 7/7] bio-cgroup: Add a cgroup support to dm-ioband
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20080812.213640.183031086.ryov@valinux.co.jp>
References: <20080812.213533.189720227.ryov@valinux.co.jp>
	<20080812.213604.112616601.ryov@valinux.co.jp>
	<20080812.213640.183031086.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, dm-ioband can work with the bio cgroup.

Based on 2.6.27-rc1-mm1
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>

diff -Ndupr linux-2.6.27-rc1-mm1.cg2/drivers/md/dm-ioband-type.c linux-2.6.27-rc1-mm1.cg3/drivers/md/dm-ioband-type.c
--- linux-2.6.27-rc1-mm1.cg2/drivers/md/dm-ioband-type.c	2008-08-12 14:45:59.000000000 +0900
+++ linux-2.6.27-rc1-mm1.cg3/drivers/md/dm-ioband-type.c	2008-08-12 15:07:03.000000000 +0900
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

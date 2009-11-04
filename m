Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbZKDV6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbZKDV6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933049AbZKDV6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:58:06 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:20181 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042AbZKDV6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:58:03 -0500
Date: Wed, 4 Nov 2009 13:57:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] edac: fix i7core build
Message-Id: <20091104135733.cb878718.randy.dunlap@oracle.com>
In-Reply-To: <20091104170931.4aa51b77.sfr@canb.auug.org.au>
References: <20091104170931.4aa51b77.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AF1F8DB.00A3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build warning (missing header file) and
build error when CONFIG_SMP=n.

drivers/edac/i7core_edac.c:860: error: implicit declaration of function 'msleep'
drivers/edac/i7core_edac.c:1700: error: 'struct cpuinfo_x86' has no member named 'phys_proc_id'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20091104.orig/drivers/edac/i7core_edac.c
+++ linux-next-20091104/drivers/edac/i7core_edac.c
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <linux/edac.h>
 #include <linux/mmzone.h>
 #include <linux/edac_mce.h>
@@ -1696,9 +1697,11 @@ static int i7core_mce_check_error(void *
 	if (mce->bank != 8)
 		return 0;
 
+#ifdef CONFIG_SMP
 	/* Only handle if it is the right mc controller */
 	if (cpu_data(mce->cpu).phys_proc_id != pvt->i7core_dev->socket)
 		return 0;
+#endif
 
 	smp_rmb();
 	if ((pvt->mce_out + 1) % MCE_LOG_LEN == pvt->mce_in) {

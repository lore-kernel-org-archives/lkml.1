Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbYEXBQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbYEXBQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 21:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYEXBQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 21:16:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48486 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYEXBQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 21:16:45 -0400
Subject: Re: 2.6.26-rc2-mm1 (SCSI_DH build errors)
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel@vger.kernel.org, hare@suse.de,
       scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <48372900.6050600@oracle.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <20080514141348.e71feed6.randy.dunlap@oracle.com>
	 <1210862779.15852.4.camel@localhost.localdomain>
	 <1210881374.21974.285.camel@chandra-ubuntu>
	 <20080522202543.d15e8c3b.akpm@linux-foundation.org>
	 <1211571560.10532.7.camel@chandra-ubuntu>  <48372900.6050600@oracle.com>
Content-Type: text/plain
Organization: IBM
Date: Fri, 23 May 2008 18:16:40 -0700
Message-Id: <1211591800.10532.31.camel@chandra-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 13:28 -0700, Randy Dunlap wrote:
> Chandra Seetharaman wrote:
> > Yikes.... Sorry again... Hopefully this attached patch work properly.
> 
> Did it build cleanly for you?
> Hint:
> Use SCSI_DH as module and MD_MULTIPATH=y.  Build errors for me.

Oh, my... it is getting very tricky.

Here is a patch that compiles clean in different combinations. But, I
agree that the "depends" (under DM_MULTIPATH) sure looks weird.

-----------
Do not automatically "select" SCSI_DH for dm-multipath. If SCSI_DH
doesn't exist,just do not allow  hardware handlers to be used.

Handle SCSI_DH being a module also. Make sure it doesn't allow DM_MULTIPATH
to be compiled in when SCSI_DH is a module.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Anderson <andmike@us.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
---

Index: scsi-misc-2.6/drivers/md/Kconfig
===================================================================
--- scsi-misc-2.6.orig/drivers/md/Kconfig
+++ scsi-misc-2.6/drivers/md/Kconfig
@@ -252,7 +252,7 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
-	select SCSI_DH
+	depends on SCSI_DH || !SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
Index: scsi-misc-2.6/drivers/md/dm-mpath.c
===================================================================
--- scsi-misc-2.6.orig/drivers/md/dm-mpath.c
+++ scsi-misc-2.6/drivers/md/dm-mpath.c
@@ -664,6 +664,8 @@ static int parse_hw_handler(struct arg_s
 	request_module("scsi_dh_%s", m->hw_handler_name);
 	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
 		ti->error = "unknown hardware handler type";
+		kfree(m->hw_handler_name);
+		m->hw_handler_name = NULL;
 		return -EINVAL;
 	}
 	consume(as, hw_argc - 1);
Index: scsi-misc-2.6/include/scsi/scsi_dh.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_dh.h
+++ scsi-misc-2.6/include/scsi/scsi_dh.h
@@ -54,6 +54,16 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
-
+#if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
+#else
+static inline int scsi_dh_activate(struct request_queue *req)
+{
+	return 0;
+}
+static inline int scsi_dh_handler_exist(const char *name)
+{
+	return 0;
+}
+#endif



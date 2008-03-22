Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbYCVDVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbYCVDVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYCVDVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:21:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:58695 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbYCVDVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:21:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=R6P+tCj4ydVG73TOlPoAVmKd5PqDL0kaDyCBIZTbvTLQqjm9dL5faSVSAJzLAjfW/uBy1gMYKJ1AKmxGEFqqpnRbZhImi1gfshK8irsle6r4rGyJTZlj4cyscIt61xwaM8K3EgKXtBgbyzlKOo+fS+0LJEr/OrpR6XilHuXHYfM=
Date: Sat, 22 Mar 2008 12:12:49 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] cdrom: use list_head for cdrom_device_info list
Message-ID: <20080322031248.GD3665@APFDCB5C>
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C> <20080322031204.GC3665@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080322031204.GC3665@APFDCB5C>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_head for cdrom_device_info list instead of opencoded
singly list handling.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/cdrom/cdrom.c |   29 ++++++-----------------------
 include/linux/cdrom.h |    3 ++-
 2 files changed, 8 insertions(+), 24 deletions(-)

Index: 2.6-git/drivers/cdrom/cdrom.c
===================================================================
--- 2.6-git.orig/drivers/cdrom/cdrom.c
+++ 2.6-git/drivers/cdrom/cdrom.c
@@ -362,7 +362,7 @@ static int cdrom_get_disc_info(struct cd
 
 static void cdrom_sysctl_register(void);
 
-static struct cdrom_device_info *topCdromPtr;
+static LIST_HEAD(cdrom_list);
 
 static int cdrom_dummy_generic_packet(struct cdrom_device_info *cdi,
 				      struct packet_command *cgc)
@@ -436,35 +436,18 @@ int register_cdrom(struct cdrom_device_i
 
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	mutex_lock(&cdrom_mutex);
-	cdi->next = topCdromPtr; 	
-	topCdromPtr = cdi;
+	list_add(&cdi->list, &cdrom_list);
 	mutex_unlock(&cdrom_mutex);
 	return 0;
 }
 #undef ENSURE
 
-int unregister_cdrom(struct cdrom_device_info *unreg)
+int unregister_cdrom(struct cdrom_device_info *cdi)
 {
-	struct cdrom_device_info *cdi, *prev;
 	cdinfo(CD_OPEN, "entering unregister_cdrom\n"); 
 
-	prev = NULL;
 	mutex_lock(&cdrom_mutex);
-	cdi = topCdromPtr;
-	while (cdi && cdi != unreg) {
-		prev = cdi;
-		cdi = cdi->next;
-	}
-
-	if (cdi == NULL) {
-		mutex_unlock(&cdrom_mutex);
-		return -2;
-	}
-	if (prev)
-		prev->next = cdi->next;
-	else
-		topCdromPtr = cdi->next;
-
+	list_del(&cdi->list);
 	mutex_unlock(&cdrom_mutex);
 
 	if (cdi->exit)
@@ -3306,7 +3289,7 @@ static int cdrom_print_info(const char *
 
 	*pos += ret;
 
-	for (cdi = topCdromPtr; cdi; cdi = cdi->next) {
+	list_for_each_entry(cdi, &cdrom_list, list) {
 		switch (option) {
 		case CTL_NAME:
 			ret = scnprintf(info + *pos, max_size - *pos,
@@ -3428,7 +3411,7 @@ static void cdrom_update_settings(void)
 	struct cdrom_device_info *cdi;
 
 	mutex_lock(&cdrom_mutex);
-	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next) {
+	list_for_each_entry(cdi, &cdrom_list, list) {
 		if (autoclose && CDROM_CAN(CDC_CLOSE_TRAY))
 			cdi->options |= CDO_AUTO_CLOSE;
 		else if (!autoclose)
Index: 2.6-git/include/linux/cdrom.h
===================================================================
--- 2.6-git.orig/include/linux/cdrom.h
+++ 2.6-git/include/linux/cdrom.h
@@ -910,6 +910,7 @@ struct mode_page_header {
 #ifdef __KERNEL__
 #include <linux/fs.h>		/* not really needed, later.. */
 #include <linux/device.h>
+#include <linux/list.h>
 
 struct packet_command
 {
@@ -934,7 +935,7 @@ struct packet_command
 /* Uniform cdrom data structures for cdrom.c */
 struct cdrom_device_info {
 	struct cdrom_device_ops  *ops;  /* link to device_ops */
-	struct cdrom_device_info *next; /* next device_info for this major */
+	struct list_head list;		/* linked list of all device_info */
 	struct gendisk *disk;		/* matching block layer disk */
 	void *handle;		        /* driver-dependent data */
 /* specifications */

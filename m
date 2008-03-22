Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbYCVDU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbYCVDU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYCVDUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:20:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:9898 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYCVDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HS5R8R/lz7OvOCjpHw4QqKAMyeRGcsyy1ATMSj6XmjfMMtxKRYL8rWOTBdER/nHH84N0lNZx+0I+FdqyQ/0inb5WkLJw4wgjDTPsxzmfUVpfEVBXUxNzGmDkwzYqNs36bLVZK1mM6q5laJzaf8jLe56PNrrrTKzeehFUwCGY3Fg=
Date: Sat, 22 Mar 2008 12:12:05 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] cdrom: protect cdrom_device_info list by mutex
Message-ID: <20080322031204.GC3665@APFDCB5C>
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080322031047.GB3665@APFDCB5C>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch protects the list of cdrom_device_info by cdrom_mutex
when the file in /proc/sys/dev/cdrom/ is written.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/cdrom/cdrom.c |    2 ++
 1 file changed, 2 insertions(+)

Index: 2.6-git/drivers/cdrom/cdrom.c
===================================================================
--- 2.6-git.orig/drivers/cdrom/cdrom.c
+++ 2.6-git/drivers/cdrom/cdrom.c
@@ -3427,6 +3427,7 @@ static void cdrom_update_settings(void)
 {
 	struct cdrom_device_info *cdi;
 
+	mutex_lock(&cdrom_mutex);
 	for (cdi = topCdromPtr; cdi != NULL; cdi = cdi->next) {
 		if (autoclose && CDROM_CAN(CDC_CLOSE_TRAY))
 			cdi->options |= CDO_AUTO_CLOSE;
@@ -3445,6 +3446,7 @@ static void cdrom_update_settings(void)
 		else
 			cdi->options &= ~CDO_CHECK_TYPE;
 	}
+	mutex_unlock(&cdrom_mutex);
 }
 
 static int cdrom_sysctl_handler(ctl_table *ctl, int write, struct file * filp,

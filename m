Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbXD0Iri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbXD0Iri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXD0Irh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:47:37 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:38253
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755482AbXD0Irh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:47:37 -0400
Date: Fri, 27 Apr 2007 10:50:27 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: isely@pobox.com, video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/5] pvrusb2: use mutex instead of semaphore
Message-ID: <20070427085027.GF4213@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	isely@pobox.com, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070427083857.GB4213@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427083857.GB4213@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the pvrusb2 driver use a semaphore as mutex. use the mutex API instead
of the (binary) semaphore

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index 9916cf3..ea450b0 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -83,7 +83,7 @@ static struct pvr2_string_table pvr2_client_lists[] = {
 };
 
 static struct pvr2_hdw *unit_pointers[PVR_NUM] = {[ 0 ... PVR_NUM-1 ] = NULL};
-static DECLARE_MUTEX(pvr2_unit_sem);
+static DEFINE_MUTEX(pvr2_unit_mtx);
 
 static int ctlchg = 0;
 static int initusbreset = 1;
@@ -2069,14 +2069,14 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	hdw->ctl_read_urb = usb_alloc_urb(0,GFP_KERNEL);
 	if (!hdw->ctl_read_urb) goto fail;
 
-	down(&pvr2_unit_sem); do {
+	mutex_lock(&pvr2_unit_mtx); do {
 		for (idx = 0; idx < PVR_NUM; idx++) {
 			if (unit_pointers[idx]) continue;
 			hdw->unit_number = idx;
 			unit_pointers[idx] = hdw;
 			break;
 		}
-	} while (0); up(&pvr2_unit_sem);
+	} while (0); mutex_unlock(&pvr2_unit_mtx);
 
 	cnt1 = 0;
 	cnt2 = scnprintf(hdw->name+cnt1,sizeof(hdw->name)-cnt1,"pvrusb2");
@@ -2174,13 +2174,13 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
 	}
 	pvr2_i2c_core_done(hdw);
 	pvr2_hdw_remove_usb_stuff(hdw);
-	down(&pvr2_unit_sem); do {
+	mutex_lock(&pvr2_unit_mtx); do {
 		if ((hdw->unit_number >= 0) &&
 		    (hdw->unit_number < PVR_NUM) &&
 		    (unit_pointers[hdw->unit_number] == hdw)) {
 			unit_pointers[hdw->unit_number] = NULL;
 		}
-	} while (0); up(&pvr2_unit_sem);
+	} while (0); mutex_unlock(&pvr2_unit_mtx);
 	kfree(hdw->controls);
 	kfree(hdw->mpeg_ctrl_info);
 	kfree(hdw->std_defs);

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      The assumption that what currently exists must necessarily
        exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

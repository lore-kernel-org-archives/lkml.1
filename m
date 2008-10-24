Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYJXVom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYJXVom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbYJXVn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:43:59 -0400
Received: from kroah.org ([198.145.64.141]:39530 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755432AbYJXVn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:43:59 -0400
Date: Fri, 24 Oct 2008 14:40:30 -0700
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       torvalds@linux-foundation.org, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 28/27] V4L/DVB (9300): pvrusb2: Fix deadlock problem
Message-ID: <20081024214030.GA20723@kroah.com>
References: <20081024043303.GA30828@kroah.com> <20081024054111.GB17405@kroah.com> <20081024213852.GA20713@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024213852.GA20713@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable patch

---------------------

From: Mike Isely <isely@pobox.com>

commit c82732a42896364296599b0f73f01c5e3fd781ae upstream

Fix deadlock problem in 2.6.27 caused by new USB core behavior in
response to a USB device reset request.  With older kernels, the USB
device reset was "in line"; the reset simply took place and the driver
retained its association with the hardware.  However now this reset
triggers a disconnect, and worse still the disconnect callback happens
in the context of the caller who asked for the device reset.  This
results in an attempt by the pvrusb2 driver to recursively take a
mutex it already has, which deadlocks the driver's worker thread.
(Even if the disconnect callback were to happen on a different thread
we'd still have problems however - because while the driver should
survive and correctly disconnect / reconnect, it will then trigger
another device reset during the repeated initialization, which will
then cause another disconect, etc, forever.)  The fix here is simply
to not attempt the device reset (it was of marginal value anyway).

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -60,7 +60,6 @@ static struct pvr2_hdw *unit_pointers[PV
 static DEFINE_MUTEX(pvr2_unit_mtx);
 
 static int ctlchg;
-static int initusbreset = 1;
 static int procreload;
 static int tuner[PVR_NUM] = { [0 ... PVR_NUM-1] = -1 };
 static int tolerance[PVR_NUM] = { [0 ... PVR_NUM-1] = 0 };
@@ -71,8 +70,6 @@ module_param(ctlchg, int, S_IRUGO|S_IWUS
 MODULE_PARM_DESC(ctlchg, "0=optimize ctl change 1=always accept new ctl value");
 module_param(init_pause_msec, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(init_pause_msec, "hardware initialization settling delay");
-module_param(initusbreset, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(initusbreset, "Do USB reset device on probe");
 module_param(procreload, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(procreload,
 		 "Attempt init failure recovery with firmware reload");
@@ -1698,9 +1695,6 @@ static void pvr2_hdw_setup_low(struct pv
 	}
 	hdw->fw1_state = FW1_STATE_OK;
 
-	if (initusbreset) {
-		pvr2_hdw_device_reset(hdw);
-	}
 	if (!pvr2_hdw_dev_ok(hdw)) return;
 
 	for (idx = 0; idx < hdw->hdw_desc->client_modules.cnt; idx++) {

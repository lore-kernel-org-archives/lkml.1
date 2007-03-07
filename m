Return-Path: <linux-kernel-owner+w=401wt.eu-S1422790AbXCGRyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422790AbXCGRyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422769AbXCGROK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:10 -0500
Received: from mx1.suse.de ([195.135.220.2]:43453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422768AbXCGRNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:39 -0500
Message-Id: <20070307171159.218196228@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Adrian Bunk <bunk@stusta.de>, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 013/101] USB: fix concurrent buffer access in the hub driver
Content-Disposition: inline; filename=usb-fix-concurrent-buffer-access-in-the-hub-driver.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch (as849) fixes a bug in the USB hub driver.  A single
pre-allocated buffer is used for all port status reads, but nothing
guarantees exclusive use of the buffer.  A mutex is added to provide
this guarantee.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hub.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.20.1.orig/drivers/usb/core/hub.c
+++ linux-2.6.20.1/drivers/usb/core/hub.c
@@ -44,6 +44,7 @@ struct usb_hub {
 		struct usb_hub_status	hub;
 		struct usb_port_status	port;
 	}			*status;	/* buffer for status reports */
+	struct mutex		status_mutex;	/* for the status buffer */
 
 	int			error;		/* last reported error */
 	int			nerrors;	/* track consecutive errors */
@@ -538,6 +539,7 @@ static int hub_hub_status(struct usb_hub
 {
 	int ret;
 
+	mutex_lock(&hub->status_mutex);
 	ret = get_hub_status(hub->hdev, &hub->status->hub);
 	if (ret < 0)
 		dev_err (hub->intfdev,
@@ -547,6 +549,7 @@ static int hub_hub_status(struct usb_hub
 		*change = le16_to_cpu(hub->status->hub.wHubChange); 
 		ret = 0;
 	}
+	mutex_unlock(&hub->status_mutex);
 	return ret;
 }
 
@@ -620,6 +623,7 @@ static int hub_configure(struct usb_hub 
 		ret = -ENOMEM;
 		goto fail;
 	}
+	mutex_init(&hub->status_mutex);
 
 	hub->descriptor = kmalloc(sizeof(*hub->descriptor), GFP_KERNEL);
 	if (!hub->descriptor) {
@@ -1418,6 +1422,7 @@ static int hub_port_status(struct usb_hu
 {
 	int ret;
 
+	mutex_lock(&hub->status_mutex);
 	ret = get_port_status(hub->hdev, port1, &hub->status->port);
 	if (ret < 4) {
 		dev_err (hub->intfdev,
@@ -1429,6 +1434,7 @@ static int hub_port_status(struct usb_hu
 		*change = le16_to_cpu(hub->status->port.wPortChange); 
 		ret = 0;
 	}
+	mutex_unlock(&hub->status_mutex);
 	return ret;
 }
 

--

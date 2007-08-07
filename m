Return-Path: <linux-kernel-owner+w=401wt.eu-S934929AbXHGUpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929AbXHGUpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758320AbXHGUpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:45:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51221 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397AbXHGUpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:45:39 -0400
Date: Tue, 7 Aug 2007 13:42:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.name>, "A. Kalten" <akalten@comcast.net>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [2.6.22.2 review 01/84] USB: cdc-acm: fix sysfs attribute
	registration bug
Message-ID: <20070807204231.GB23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-cdc-acm-fix-sysfs-attribute-registration-bug.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as950) fixes a bug in the cdc-acm driver.  It doesn't keep
track of which interface (control or data) the sysfs attributes get
registered for, and as a result, during disconnect it will sometimes
attempt to remove the attributes from the wrong interface.  The
left-over attributes can cause a crash later on, particularly if the driver
module has been unloaded.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -919,6 +919,10 @@ skip_normal_probe:
 			return -EINVAL;
 		}
 	}
+
+	/* Accept probe requests only for the control interface */
+	if (intf != control_interface)
+		return -ENODEV;
 	
 	if (usb_interface_claimed(data_interface)) { /* valid in this context */
 		dev_dbg(&intf->dev,"The data interface isn't available");
@@ -1107,10 +1111,12 @@ static void acm_disconnect(struct usb_in
 		return;
 	}
 	if (acm->country_codes){
-		device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
-		device_remove_file(&intf->dev, &dev_attr_iCountryCodeRelDate);
+		device_remove_file(&acm->control->dev,
+				&dev_attr_wCountryCodes);
+		device_remove_file(&acm->control->dev,
+				&dev_attr_iCountryCodeRelDate);
 	}
-	device_remove_file(&intf->dev, &dev_attr_bmCapabilities);
+	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 	acm->dev = NULL;
 	usb_set_intfdata(acm->control, NULL);
 	usb_set_intfdata(acm->data, NULL);

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S934245AbXHWWkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245AbXHWWkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933392AbXHWWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:30:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33323 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbXHWWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:30:25 -0400
Date: Thu, 23 Aug 2007 15:27:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>
Subject: [patch 25/28] USB: cdc-acm: fix sysfs attribute registration bug
Message-ID: <20070823222750.GY18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-cdc-acm-fix-sysfs-attribute-registration-bug.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as950) fixes a bug in the cdc-acm driver.  It doesn't keep
track of which interface (control or data) the sysfs attributes get
registered for, and as a result, during disconnect it will sometimes
attempt to remove the attributes from the wrong interface.  The
left-over attributes can cause a crash later on, particularly if the driver
module has been unloaded.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -900,6 +900,10 @@ next_desc:
 			return -ENODEV;
 		}
 	}
+
+	/* Accept probe requests only for the control interface */
+	if (intf != control_interface)
+		return -ENODEV;
 	
 	if (data_interface_num != call_interface_num)
 		dev_dbg(&intf->dev,"Seperate call control interface. That is not fully supported.");

-- 

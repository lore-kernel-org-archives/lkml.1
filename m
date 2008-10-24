Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYJXElh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYJXElh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYJXEjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:12 -0400
Received: from kroah.org ([198.145.64.141]:51682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751707AbYJXEjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:08 -0400
Date: Thu, 23 Oct 2008 21:33:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 06/27] USB: dont rebind drivers after failed resume or reset
Message-ID: <20081024043350.GG30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-don-t-rebind-drivers-after-failed-resume-or-reset.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 6c6409459a18a825ce12ecb003d5686af61f7a2f upstream

This patch (as1152) may help prevent some problems associated with the
new policy of unbinding drivers that don't support suspend/resume or
pre_reset/post_reset.  If for any reason the resume or reset fails, and
the device is logically disconnected, there's no point in trying to
rebind the driver.  So the patch checks for success before carrying
out the unbind/rebind.

There was a report from one user that this fixed a problem he was
experiencing, but the details never became fully clear.  In any case,
adding these tests can't hurt.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |    3 ++-
 drivers/usb/core/hub.c    |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1609,7 +1609,8 @@ int usb_external_resume_device(struct us
 	status = usb_resume_both(udev);
 	udev->last_busy = jiffies;
 	usb_pm_unlock(udev);
-	do_unbind_rebind(udev, DO_REBIND);
+	if (status == 0)
+		do_unbind_rebind(udev, DO_REBIND);
 
 	/* Now that the device is awake, we can start trying to autosuspend
 	 * it again. */
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3424,7 +3424,7 @@ int usb_reset_device(struct usb_device *
 						USB_INTERFACE_BOUND)
 					rebind = 1;
 			}
-			if (rebind)
+			if (ret == 0 && rebind)
 				usb_rebind_intf(cintf);
 		}
 	}

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZHMUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZHMUCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZHMUCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:02:19 -0400
Received: from kroah.org ([198.145.64.141]:41938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298AbZHMUAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:34 2009
Message-Id: <20090813195134.019510489@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>, Pete Zaitcev <zaitcev@redhat.com>
Subject: [patch 64/74] USB: devio: Properly do access_ok() checks
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=usb-devio-properly-do-access_ok-checks.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

commit 18753ebc8a98efe0e8ff6167afb31cef220c8e50 upstream.

access_ok() checks must be done on every part of the userspace structure
that is accessed. If access_ok() on one part of the struct succeeded, it
does not imply it will succeed on other parts of the struct. (Does
depend on the architecture implementation of access_ok()).

This changes the __get_user() users to first check access_ok() on the
data structure.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1308,7 +1308,8 @@ static int get_urb32(struct usbdevfs_urb
 		     struct usbdevfs_urb32 __user *uurb)
 {
 	__u32  uptr;
-	if (get_user(kurb->type, &uurb->type) ||
+	if (!access_ok(VERIFY_READ, uurb, sizeof(*uurb)) ||
+	    __get_user(kurb->type, &uurb->type) ||
 	    __get_user(kurb->endpoint, &uurb->endpoint) ||
 	    __get_user(kurb->status, &uurb->status) ||
 	    __get_user(kurb->flags, &uurb->flags) ||
@@ -1523,8 +1524,9 @@ static int proc_ioctl_compat(struct dev_
 	u32 udata;
 
 	uioc = compat_ptr((long)arg);
-	if (get_user(ctrl.ifno, &uioc->ifno) ||
-	    get_user(ctrl.ioctl_code, &uioc->ioctl_code) ||
+	if (!access_ok(VERIFY_READ, uioc, sizeof(*uioc)) ||
+	    __get_user(ctrl.ifno, &uioc->ifno) ||
+	    __get_user(ctrl.ioctl_code, &uioc->ioctl_code) ||
 	    __get_user(udata, &uioc->data))
 		return -EFAULT;
 	ctrl.data = compat_ptr(udata);



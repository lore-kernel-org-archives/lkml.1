Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZJBBzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZJBBzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbZJBBzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:55:06 -0400
Received: from kroah.org ([198.145.64.141]:33083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbZJBBdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:12 2009
Message-Id: <20091002012412.484113524@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>
Subject: [043/136] USB: CDC WDM driver doesnt support non-blocking reads
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-cdc-wdm-driver-doesn-t-support-non-blocking-reads.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oliver Neukum <oliver@neukum.org>

commit 7f1dc313d01f5f0f84c06051343a3b8623932d3c upstream.

support for O_NONBLOCK in read and write path
by simply not waiting for data in read or availability
of the write urb in write but returning -EAGAIN

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Tested-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-wdm.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -313,8 +313,13 @@ static ssize_t wdm_write
 	r = usb_autopm_get_interface(desc->intf);
 	if (r < 0)
 		goto outnp;
-	r = wait_event_interruptible(desc->wait, !test_bit(WDM_IN_USE,
-							   &desc->flags));
+
+	if (!file->f_flags && O_NONBLOCK)
+		r = wait_event_interruptible(desc->wait, !test_bit(WDM_IN_USE,
+								&desc->flags));
+	else
+		if (test_bit(WDM_IN_USE, &desc->flags))
+			r = -EAGAIN;
 	if (r < 0)
 		goto out;
 
@@ -377,7 +382,7 @@ outnl:
 static ssize_t wdm_read
 (struct file *file, char __user *buffer, size_t count, loff_t *ppos)
 {
-	int rv, cntr;
+	int rv, cntr = 0;
 	int i = 0;
 	struct wdm_device *desc = file->private_data;
 
@@ -389,10 +394,23 @@ static ssize_t wdm_read
 	if (desc->length == 0) {
 		desc->read = 0;
 retry:
+		if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
+			rv = -ENODEV;
+			goto err;
+		}
 		i++;
-		rv = wait_event_interruptible(desc->wait,
-					      test_bit(WDM_READ, &desc->flags));
+		if (file->f_flags & O_NONBLOCK) {
+			if (!test_bit(WDM_READ, &desc->flags)) {
+				rv = cntr ? cntr : -EAGAIN;
+				goto err;
+			}
+			rv = 0;
+		} else {
+			rv = wait_event_interruptible(desc->wait,
+				test_bit(WDM_READ, &desc->flags));
+		}
 
+		/* may have happened while we slept */
 		if (test_bit(WDM_DISCONNECTING, &desc->flags)) {
 			rv = -ENODEV;
 			goto err;
@@ -448,7 +466,7 @@ retry:
 
 err:
 	mutex_unlock(&desc->rlock);
-	if (rv < 0)
+	if (rv < 0 && rv != -EAGAIN)
 		dev_err(&desc->intf->dev, "wdm_read: exit error\n");
 	return rv;
 }



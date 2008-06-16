Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYFPWFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYFPWFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbYFPWFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:05:45 -0400
Received: from gw.goop.org ([64.81.55.164]:56349 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbYFPWFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:05:44 -0400
Message-ID: <4856E38E.1040203@goop.org>
Date: Mon, 16 Jun 2008 15:05:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaya Kumar <jayakumar.lkml@gmail.com>
CC: Markus Armbruster <armbru@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "fb-defio: fix page list with concurrent processes"
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch "fb-defio: fix page list with concurrent processes" 
definitely seems to help with the suspend/resume problem I had with the 
Xen pvfb device.  Is it queued up anywhere?  It seems to be a real 
bugfix, and should probably be queued for 2.6.26...

    J

fb-defio: fix page list with concurrent processes

From: Jaya Kumar <jayakumar.lkml@gmail.com>

Hi Tony, Geert, Andrew, fbdev,

This patch is a bugfix for how defio handles multiple processes manipulating
the same framebuffer. Thanks to Bernard Blackham for identifying this bug.
It occurs when two applications mmap the same framebuffer and concurrently
write to the same page. Normally, this doesn't occur since only a single
process mmaps the framebuffer. The symptom of the bug is that the mapping
applications will hang. The cause is that defio incorrectly tries to add the
same page twice to the pagelist. The solution I have is to walk the pagelist
and check for a duplicate before adding. Since I needed to walk the
pagelist, I now also keep the pagelist in sorted order.

Thanks,
jaya

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>

---
 drivers/video/fb_defio.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

===================================================================
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -74,6 +74,7 @@ static int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
 {
 	struct fb_info *info = vma->vm_private_data;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct page *cur;
 
 	/* this is a callback we get when userspace first tries to
 	write to the page. we schedule a workqueue. that workqueue
@@ -83,7 +84,24 @@ static int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
 
 	/* protect against the workqueue changing the page list */
 	mutex_lock(&fbdefio->lock);
-	list_add(&page->lru, &fbdefio->pagelist);
+
+	/* we loop through the pagelist before adding in order
+	to keep the pagelist sorted */
+	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
+		/* this check is to catch the case where a new
+		process could start writing to the same page
+		through a new pte. this new access can cause the
+		mkwrite even when the original ps's pte is marked
+		writable */
+		if (unlikely(cur == page))
+			goto page_already_added;
+		else if (cur->index > page->index)
+			break;
+	}
+
+	list_add_tail(&page->lru, &cur->lru);
+
+page_already_added:
 	mutex_unlock(&fbdefio->lock);
 
 	/* come back after delay to process the deferred IO */



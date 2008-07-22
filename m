Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYGVXbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYGVXbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbYGVXXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:08 -0400
Received: from mx1.suse.de ([195.135.220.2]:53612 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968AbYGVXXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:05 -0400
Date: Tue, 22 Jul 2008 16:17:13 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Bernard Blackham <bernard@largestprime.net>
Subject: [patch 38/47] fbdev: bugfix for multiprocess defio
Message-ID: <20080722231713.GM8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fbdev-bugfix-for-multiprocess-defio.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jaya Kumar <jayakumar.lkml@gmail.com>

commit f31ad92f34913043cf008d6e479e92dfbaf02df1 upstream

This patch is a bugfix for how defio handles multiple processes manipulating
the same framebuffer.

Thanks to Bernard Blackham for identifying this bug.

It occurs when two applications mmap the same framebuffer and concurrently
write to the same page.  Normally, this doesn't occur since only a single
process mmaps the framebuffer.  The symptom of the bug is that the mapping
applications will hang.  The cause is that defio incorrectly tries to add the
same page twice to the pagelist.  The solution I have is to walk the pagelist
and check for a duplicate before adding.  Since I needed to walk the pagelist,
I now also keep the pagelist in sorted order.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Bernard Blackham <bernard@largestprime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/fb_defio.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -74,6 +74,7 @@ static int fb_deferred_io_mkwrite(struct
 {
 	struct fb_info *info = vma->vm_private_data;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct page *cur;
 
 	/* this is a callback we get when userspace first tries to
 	write to the page. we schedule a workqueue. that workqueue
@@ -83,7 +84,24 @@ static int fb_deferred_io_mkwrite(struct
 
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

-- 

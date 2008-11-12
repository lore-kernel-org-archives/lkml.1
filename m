Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYKLAfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYKLAfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYKLA0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:37 -0500
Received: from kroah.org ([198.145.64.141]:42374 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752335AbYKLA0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:34 -0500
Date: Tue, 11 Nov 2008 16:23:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Maciej Sosnowski <maciej.sosnowski@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 25/49] I/OAT: fix dma_pin_iovec_pages() error handling
Message-ID: <20081112002345.GZ10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="i-oat-fix-dma_pin_iovec_pages-error-handling.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maciej Sosnowski <maciej.sosnowski@intel.com>

commit c2c0b4c5434c0a25f7f7796b29155d53805909f5 upstream

Error handling needs to be modified in dma_pin_iovec_pages().
It should return NULL instead of ERR_PTR
(pinned_list is checked for NULL in tcp_recvmsg() to determine
if iovec pages have been successfully pinned down).
In case of error for the first iovec,
local_list->nr_iovecs needs to be initialized.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dma/iovlock.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/drivers/dma/iovlock.c
+++ b/drivers/dma/iovlock.c
@@ -55,7 +55,6 @@ struct dma_pinned_list *dma_pin_iovec_pa
 	int nr_iovecs = 0;
 	int iovec_len_used = 0;
 	int iovec_pages_used = 0;
-	long err;
 
 	/* don't pin down non-user-based iovecs */
 	if (segment_eq(get_fs(), KERNEL_DS))
@@ -72,23 +71,21 @@ struct dma_pinned_list *dma_pin_iovec_pa
 	local_list = kmalloc(sizeof(*local_list)
 		+ (nr_iovecs * sizeof (struct dma_page_list))
 		+ (iovec_pages_used * sizeof (struct page*)), GFP_KERNEL);
-	if (!local_list) {
-		err = -ENOMEM;
+	if (!local_list)
 		goto out;
-	}
 
 	/* list of pages starts right after the page list array */
 	pages = (struct page **) &local_list->page_list[nr_iovecs];
 
+	local_list->nr_iovecs = 0;
+
 	for (i = 0; i < nr_iovecs; i++) {
 		struct dma_page_list *page_list = &local_list->page_list[i];
 
 		len -= iov[i].iov_len;
 
-		if (!access_ok(VERIFY_WRITE, iov[i].iov_base, iov[i].iov_len)) {
-			err = -EFAULT;
+		if (!access_ok(VERIFY_WRITE, iov[i].iov_base, iov[i].iov_len))
 			goto unpin;
-		}
 
 		page_list->nr_pages = num_pages_spanned(&iov[i]);
 		page_list->base_address = iov[i].iov_base;
@@ -109,10 +106,8 @@ struct dma_pinned_list *dma_pin_iovec_pa
 			NULL);
 		up_read(&current->mm->mmap_sem);
 
-		if (ret != page_list->nr_pages) {
-			err = -ENOMEM;
+		if (ret != page_list->nr_pages)
 			goto unpin;
-		}
 
 		local_list->nr_iovecs = i + 1;
 	}
@@ -122,7 +117,7 @@ struct dma_pinned_list *dma_pin_iovec_pa
 unpin:
 	dma_unpin_iovec_pages(local_list);
 out:
-	return ERR_PTR(err);
+	return NULL;
 }
 
 void dma_unpin_iovec_pages(struct dma_pinned_list *pinned_list)

-- 

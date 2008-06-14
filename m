Return-Path: <linux-kernel-owner+w=401wt.eu-S1763855AbYFNA1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763855AbYFNA1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762307AbYFNAPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:34661 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762300AbYFNAPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:35 -0400
Date: Fri, 13 Jun 2008 17:12:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 45/47] bttv: Fix a deadlock in the bttv driver
Message-ID: <20080614001218.GS24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bttv-fix-a-deadlock-in-the-bttv-driver.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Arjan van de Ven <arjan@linux.intel.com>

commit 81b2dbcad86732ffc02bad87aa25c4651199fc77 in mainline.

vidiocgmbuf() does this:
        mutex_lock(&fh->cap.vb_lock);
        retval = videobuf_mmap_setup(&fh->cap, gbuffers, gbufsize,
                                     V4L2_MEMORY_MMAP);

and videobuf_mmap_setup() then just does
        mutex_lock(&q->vb_lock);
        ret = __videobuf_mmap_setup(q, bcount, bsize, memory);
        mutex_unlock(&q->vb_lock);

which is an obvious double-take deadlock.

This patch fixes this by having vidiocgmbuf() just call the
__videobuf_mmap_setup function instead.

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Reported-by: Koos Vriezen <koos.vriezen@gmail.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/bt8xx/bttv-driver.c |    2 +-
 drivers/media/video/videobuf-core.c     |    3 ++-
 include/media/videobuf-core.h           |    3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -2613,7 +2613,7 @@ static int vidiocgmbuf(struct file *file
 	struct bttv_fh *fh = priv;
 
 	mutex_lock(&fh->cap.vb_lock);
-	retval = videobuf_mmap_setup(&fh->cap, gbuffers, gbufsize,
+	retval = __videobuf_mmap_setup(&fh->cap, gbuffers, gbufsize,
 				     V4L2_MEMORY_MMAP);
 	if (retval < 0) {
 		mutex_unlock(&fh->cap.vb_lock);
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -335,7 +335,7 @@ int videobuf_mmap_free(struct videobuf_q
 }
 
 /* Locking: Caller holds q->vb_lock */
-static int __videobuf_mmap_setup(struct videobuf_queue *q,
+int __videobuf_mmap_setup(struct videobuf_queue *q,
 			unsigned int bcount, unsigned int bsize,
 			enum v4l2_memory memory)
 {
@@ -1093,6 +1093,7 @@ EXPORT_SYMBOL_GPL(videobuf_read_stream);
 EXPORT_SYMBOL_GPL(videobuf_read_one);
 EXPORT_SYMBOL_GPL(videobuf_poll_stream);
 
+EXPORT_SYMBOL_GPL(__videobuf_mmap_setup);
 EXPORT_SYMBOL_GPL(videobuf_mmap_setup);
 EXPORT_SYMBOL_GPL(videobuf_mmap_free);
 EXPORT_SYMBOL_GPL(videobuf_mmap_mapper);
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -227,6 +227,9 @@ unsigned int videobuf_poll_stream(struct
 int videobuf_mmap_setup(struct videobuf_queue *q,
 			unsigned int bcount, unsigned int bsize,
 			enum v4l2_memory memory);
+int __videobuf_mmap_setup(struct videobuf_queue *q,
+			unsigned int bcount, unsigned int bsize,
+			enum v4l2_memory memory);
 int videobuf_mmap_free(struct videobuf_queue *q);
 int videobuf_mmap_mapper(struct videobuf_queue *q,
 			 struct vm_area_struct *vma);

-- 

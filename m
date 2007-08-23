Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXHWW3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXHWW3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765980AbXHWW2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50641 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765936AbXHWW2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:02 -0400
Date: Thu, 23 Aug 2007 15:26:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jdike@linux.intel.com, jdike@addtoit.com
Subject: [patch 04/28] uml: fix previous request size limit fix
Message-ID: <20070823222604.GE18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-fix-previous-request-size-limit-fix.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Dike <jdike@addtoit.com>

The previous patch which limited the number of sectors in a single request
to a COWed device was correct in concept, but the limit was implemented in
the wrong place.

By putting it in ubd_add, it covered the cases where the COWing was
specified on the command line.  However, when the command line only has the
COW file specified, the fact that it's a COW file isn't known until it's
opened, so the limit is missed in these cases.

This patch moves the sector limit from ubd_add to ubd_open_dev.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/drivers/ubd_kern.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -612,6 +612,8 @@ static int ubd_open_dev(struct ubd *ubd_
 	ubd_dev->fd = fd;
 
 	if(ubd_dev->cow.file != NULL){
+		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
+
 		err = -ENOMEM;
 		ubd_dev->cow.bitmap = (void *) vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
@@ -712,8 +714,6 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->queue->queuedata = ubd_dev;
 
 	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
-	if(ubd_dev->cow.file != NULL)
-		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";

-- 

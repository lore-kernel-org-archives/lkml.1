Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYLKTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYLKTVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbYLKTSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:14 -0500
Received: from kroah.org ([198.145.64.141]:55865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756629AbYLKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:04 -0500
Date: Thu, 11 Dec 2008 11:13:57 -0800
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>
Subject: [patch 13/83] Enforce a minimum SG_IO timeout
Message-ID: <20081211191357.GM5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="enforce-a-minimum-sg_io-timeout.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit f2f1fa78a155524b849edf359e42a3001ea652c0 upstream.

There's no point in having too short SG_IO timeouts, since if the
command does end up timing out, we'll end up through the reset sequence
that is several seconds long in order to abort the command that timed
out.

As a result, shorter timeouts than a few seconds simply do not make
sense, as the recovery would be longer than the timeout itself.

Add a BLK_MIN_SG_TIMEOUT to match the existign BLK_DEFAULT_SG_TIMEOUT.

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/bsg.c            |    2 ++
 block/scsi_ioctl.c     |    2 ++
 include/linux/blkdev.h |    1 +
 3 files changed, 5 insertions(+)

--- a/block/bsg.c
+++ b/block/bsg.c
@@ -202,6 +202,8 @@ static int blk_fill_sgv4_hdr_rq(struct r
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
+	if (rq->timeout < BLK_MIN_SG_TIMEOUT)
+		rq->timeout = BLK_MIN_SG_TIMEOUT;
 
 	return 0;
 }
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -208,6 +208,8 @@ static int blk_fill_sghdr_rq(struct requ
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
+	if (rq->timeout < BLK_MIN_SG_TIMEOUT)
+		rq->timeout = BLK_MIN_SG_TIMEOUT;
 
 	return 0;
 }
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -623,6 +623,7 @@ extern unsigned long blk_max_low_pfn, bl
  * default timeout for SG_IO if none specified
  */
 #define BLK_DEFAULT_SG_TIMEOUT	(60 * HZ)
+#define BLK_MIN_SG_TIMEOUT	(7 * HZ)
 
 #ifdef CONFIG_BOUNCE
 extern int init_emergency_isa_pool(void);


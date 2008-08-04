Return-Path: <linux-kernel-owner+w=401wt.eu-S1765071AbYHDVf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765071AbYHDVf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764858AbYHDVeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:34:46 -0400
Received: from mx1.suse.de ([195.135.220.2]:54481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765317AbYHDVeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:34:44 -0400
Date: Mon, 4 Aug 2008 14:29:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
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
       alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pete Wyckoff <pw@osc.edu>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 04/25] SCSI: bsg: fix bsg_mutex hang with device removal
Message-ID: <20080804212942.GD8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-bsg-fix-bsg_mutex-hang-with-device-removal.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 3f27e3ed11e67c5ee19d560a50eafd93cf8c6682 upstream

[SCSI] bsg: fix bsg_mutex hang with device removal

We don't need to hold bsg_mutex during bsg_complete_all_commands(). It
leads to a problem that we block bsg_unregister_queue during
bsg_complete_all_commands (untill all the outstanding commands
complete).

Thanks to Pete Wyckoff for finding the bug and testing the patch.

The detailed bug report is:

http://marc.info/?l=linux-scsi&m=121182137132145&w=2

Tested-by: Pete Wyckoff <pw@osc.edu>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/bsg.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/block/bsg.c
+++ b/block/bsg.c
@@ -725,8 +725,13 @@ static int bsg_put_device(struct bsg_dev
 	mutex_lock(&bsg_mutex);
 
 	do_free = atomic_dec_and_test(&bd->ref_count);
-	if (!do_free)
+	if (!do_free) {
+		mutex_unlock(&bsg_mutex);
 		goto out;
+	}
+
+	hlist_del(&bd->dev_list);
+	mutex_unlock(&bsg_mutex);
 
 	dprintk("%s: tearing down\n", bd->name);
 
@@ -742,10 +747,8 @@ static int bsg_put_device(struct bsg_dev
 	 */
 	ret = bsg_complete_all_commands(bd);
 
-	hlist_del(&bd->dev_list);
 	kfree(bd);
 out:
-	mutex_unlock(&bsg_mutex);
 	kref_put(&q->bsg_dev.ref, bsg_kref_release_function);
 	if (do_free)
 		blk_put_queue(q);

-- 

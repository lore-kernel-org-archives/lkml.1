Return-Path: <linux-kernel-owner+w=401wt.eu-S932670AbZE0Tpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbZE0Tpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZE0Tpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:45:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56765 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbZE0Tpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:45:42 -0400
Date: Wed, 27 May 2009 21:45:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
Message-ID: <20090527194543.GT11363@kernel.dk>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <20090527144754.GD10842@mit.edu> <20090527175353.GE10842@mit.edu> <20090527175830.GF10842@mit.edu> <20090527181402.GP11363@kernel.dk> <20090527191524.GS11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527191524.GS11363@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27 2009, Jens Axboe wrote:
> On Wed, May 27 2009, Jens Axboe wrote:
> > On Wed, May 27 2009, Theodore Tso wrote:
> > > On Wed, May 27, 2009 at 01:53:53PM -0400, Theodore Tso wrote:
> > > > On Wed, May 27, 2009 at 10:47:54AM -0400, Theodore Tso wrote:
> > > > > 
> > > > > I'll retry the test with your stock writeback-v8 git branch w/o any
> > > > > ext4 patches planned the next mere window mainline to see if I get the
> > > > > same soft lockup, but I thought I should give you an early heads up.
> > > > 
> > > > Confirmed.  I had to run fsstress twice, but I was able to trigger a
> > > > soft hangup with just the per-bdi v8 patches using ext4.
> > > 
> > > As you requested, here's the .config file which I used.  This was on a
> > > Lenovo S10 (N270 Atom dual-core CPU, 1.5 gigs of memory, 5400 rpm hdd).
> > 
> > If you have time, can you rerun with this little patch? It moves the
> > super sync to a separate thread. Thanks!

This one has been tested good, where good means that it boots and
functions normally at least. Whether it fixes your issue, that would be
interesting to know :-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f71588c..cc246df 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -218,10 +218,14 @@ static __init int bdi_class_init(void)
 }
 postcore_initcall(bdi_class_init);
 
+static int bdi_sync_supers(void *unused);
+
 static int __init default_bdi_init(void)
 {
 	int err;
 
+	kthread_run(bdi_sync_supers, NULL, "bdi-super");
+
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
 		bdi_register(&default_backing_dev_info, NULL, "default");
@@ -412,6 +416,23 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
 	generic_sync_bdi_inodes(NULL, &wbc);
 }
 
+static int bdi_sync_supers(void *unused)
+{
+	set_user_nice(current, 0);
+
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(dirty_expire_interval * 10));
+
+		/*
+		 * Do this periodically, like kupdated() did before.
+		 */
+		sync_supers();
+	}
+
+	return 0;
+}
+
 static int bdi_forker_task(void *ptr)
 {
 	struct bdi_writeback *me = ptr;
@@ -424,11 +445,6 @@ static int bdi_forker_task(void *ptr)
 		struct bdi_writeback *wb;
 
 		/*
-		 * Do this periodically, like kupdated() did before.
-		 */
-		sync_supers();
-
-		/*
 		 * Temporary measure, we want to make sure we don't see
 		 * dirty data on the default backing_dev_info
 		 */

-- 
Jens Axboe


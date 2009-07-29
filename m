Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZG2BlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZG2BlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZG2Bk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:40:59 -0400
Received: from ozlabs.org ([203.10.76.45]:50788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZG2Bk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:40:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: drbd tree build failure
Date: Wed, 29 Jul 2009 11:10:55 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090727154816.24e81531.sfr@canb.auug.org.au> <200907271917.56148.philipp.reisner@linbit.com> <20090728142040.9b2df926.sfr@canb.auug.org.au>
In-Reply-To: <20090728142040.9b2df926.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907291110.56241.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 01:50:40 pm Stephen Rothwell wrote:
> Hi Philipp, Lars,
> 
> On Mon, 27 Jul 2009 19:17:55 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
> >
> > Ok. Lars' patch is now complete and arrived in the git tree...
> > 
> > It should build now with Rusty's paches.
> 
> Thanks.
> 

This is untested, but fairly trivial transform to avoid cpumask_t in the struct
as well:

Subject: drdb: use cpumask_var_t in struct drdb_conf

Any code which can be compiled on x86 should try to avoid cpumask_t
(or even struct cpumask) declarations; we are heading towards struct
cpumask being undefined if CONFIG_CPUMASK_OFFSTACK.

The code is the same for CONFIG_CPUMASK_OFFSTACK=n.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 5813d7d..10fa153 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1006,7 +1006,7 @@ struct drbd_conf {
 	spinlock_t peer_seq_lock;
 	unsigned int minor;
 	unsigned long comm_bm_set; /* communicated number of set bits. */
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 	struct bm_io_work bm_io_work;
 	u64 ed_uuid; /* UUID of the exposed data */
 	struct mutex state_mutex;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 20f4d40..9c85a4b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1550,18 +1550,18 @@ void drbd_calc_cpu_mask(struct drbd_conf *mdev)
 	int ord, cpu;
 
 	/* user override. */
-	if (cpumask_weight(&mdev->cpu_mask))
+	if (cpumask_weight(mdev->cpu_mask))
 		return;
 
 	ord = mdev_to_minor(mdev) % cpumask_weight(cpu_online_mask);
 	for_each_online_cpu(cpu) {
 		if (ord-- == 0) {
-			cpumask_set_cpu(cpu, &mdev->cpu_mask);
+			cpumask_set_cpu(cpu, mdev->cpu_mask);
 			return;
 		}
 	}
 	/* should not be reached */
-	cpumask_setall(&mdev->cpu_mask);
+	cpumask_setall(mdev->cpu_mask);
 }
 
 /**
@@ -1584,7 +1584,7 @@ void drbd_thread_current_set_cpu(struct drbd_conf *mdev)
 	if (!thi->reset_cpu_mask)
 		return;
 	thi->reset_cpu_mask = 0;
-	set_cpus_allowed_ptr(p, &mdev->cpu_mask);
+	set_cpus_allowed_ptr(p, mdev->cpu_mask);
 }
 #endif
 
@@ -3001,6 +3001,8 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	mdev = kzalloc(sizeof(struct drbd_conf), GFP_KERNEL);
 	if (!mdev)
 		return NULL;
+	if (!zalloc_cpumask_var(&mdev->cpu_mask, GFP_KERNEL))
+		goto out_no_cpumask;
 
 	mdev->minor = minor;
 
@@ -3079,6 +3081,8 @@ out_no_io_page:
 out_no_disk:
 	blk_cleanup_queue(q);
 out_no_q:
+	free_cpumask_var(mdev->cpu_mask);
+out_no_cpumask:
 	kfree(mdev);
 	return NULL;
 }
@@ -3095,6 +3099,7 @@ void drbd_free_mdev(struct drbd_conf *mdev)
 	__free_page(mdev->md_io_page);
 	put_disk(mdev->vdisk);
 	blk_cleanup_queue(mdev->rq_queue);
+	free_cpumask_var(mdev->cpu_mask);
 	kfree(mdev);
 }
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 936ec73..ede19be 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1657,8 +1657,8 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 	if (mdev->state.conn >= C_CONNECTED)
 		drbd_send_sync_param(mdev, &sc);
 
-	if (!cpumask_equal(&mdev->cpu_mask, new_cpu_mask)) {
-		cpumask_copy(&mdev->cpu_mask, new_cpu_mask);
+	if (!cpumask_equal(mdev->cpu_mask, new_cpu_mask)) {
+		cpumask_copy(mdev->cpu_mask, new_cpu_mask);
 		drbd_calc_cpu_mask(mdev);
 		mdev->receiver.reset_cpu_mask = 1;
 		mdev->asender.reset_cpu_mask = 1;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1030313AbXBTRVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030313AbXBTRVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030328AbXBTRVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:21:07 -0500
Received: from mail.parknet.jp ([210.171.160.80]:1772 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030313AbXBTRVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:21:05 -0500
X-AuthUser: hirofumi@parknet.jp
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
References: <6EF4DB85-C7D4-445B-B9B5-0D22D5D893CD@kernel.crashing.org>
	<87vehzqwf6.fsf@duaron.myhome.or.jp>
	<04C493C2-1D8D-41B7-955A-F5C5B08023BB@kernel.crashing.org>
	<87ejolkcyt.fsf@duaron.myhome.or.jp>
	<3D8A0565-36F9-4216-839E-4B4815E9AC78@kernel.crashing.org>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 21 Feb 2007 02:20:54 +0900
In-Reply-To: <3D8A0565-36F9-4216-839E-4B4815E9AC78@kernel.crashing.org> (Kumar Gala's message of "Mon\, 19 Feb 2007 16\:27\:03 -0600")
Message-ID: <874ppg924p.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Kumar Gala <galak@kernel.crashing.org> writes:

> On Feb 19, 2007, at 4:19 PM, OGAWA Hirofumi wrote:
>
>> Kumar Gala <galak@kernel.crashing.org> writes:
>>
>>> Once the system locks up I dont have any ability to do anything.
>>
>> Ah, doesn't sysrq also work? If sysrq work, it can use to see IO
>> request state with a patch.
>
> Yeah, got sysrq working today.  If you can point me at the patch I  
> happy to apply it and get data.

Ok, please try attached patch. I hope it helps you.
BTW, new sysrq is sysrq-j, and it will show disk stats.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=debug-block.patch



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 block/genhd.c        |   27 +++++++++++++++++++++++++++
 drivers/char/sysrq.c |   15 ++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff -puN drivers/char/sysrq.c~debug-block drivers/char/sysrq.c
--- linux-2.6/drivers/char/sysrq.c~debug-block	2007-02-21 00:58:35.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/sysrq.c	2007-02-21 02:02:52.000000000 +0900
@@ -311,6 +311,19 @@ static struct sysrq_key_op sysrq_kill_op
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
+extern void block_req_callback(struct work_struct *ignored);
+static DECLARE_WORK(block_req_work, block_req_callback);
+static void sysrq_handle_block_req(int key, struct tty_struct *tty)
+{
+	schedule_work(&block_req_work);
+}
+static struct sysrq_key_op sysrq_block_req_op = {
+	.handler	= sysrq_handle_block_req,
+	.help_msg	= "block req (j)",
+	.action_msg	= "Block Req",
+	.enable_mask	= SYSRQ_ENABLE_DUMP,
+};
+
 static void sysrq_handle_unrt(int key, struct tty_struct *tty)
 {
 	normalize_rt_tasks();
@@ -351,7 +364,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	NULL,				/* g */
 	NULL,				/* h */
 	&sysrq_kill_op,			/* i */
-	NULL,				/* j */
+	&sysrq_block_req_op,		/* j */
 	&sysrq_SAK_op,			/* k */
 	NULL,				/* l */
 	&sysrq_showmem_op,		/* m */
diff -puN block/genhd.c~debug-block block/genhd.c
--- linux-2.6/block/genhd.c~debug-block	2007-02-21 01:02:13.000000000 +0900
+++ linux-2.6-hirofumi/block/genhd.c	2007-02-21 02:15:56.000000000 +0900
@@ -555,6 +555,33 @@ static struct kset_uevent_ops block_ueve
 
 decl_subsys(block, &ktype_block, &block_uevent_ops);
 
+void block_req_callback(struct work_struct *ignored)
+{
+	struct gendisk *gp;
+	char buf[BDEVNAME_SIZE];
+
+	mutex_lock(&block_subsys_lock);
+	list_for_each_entry(gp, &block_subsys.kset.list, kobj.entry) {
+		printk("%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u:"
+		       " %u %u %u\n",
+		       gp->major, gp->first_minor, disk_name(gp, 0, buf),
+		       disk_stat_read(gp, ios[0]),
+		       disk_stat_read(gp, merges[0]),
+		       (unsigned long long)disk_stat_read(gp, sectors[0]),
+		       jiffies_to_msecs(disk_stat_read(gp, ticks[0])),
+		       disk_stat_read(gp, ios[1]),
+		       disk_stat_read(gp, merges[1]),
+		       (unsigned long long)disk_stat_read(gp, sectors[1]),
+		       jiffies_to_msecs(disk_stat_read(gp, ticks[1])),
+		       gp->in_flight,
+		       jiffies_to_msecs(disk_stat_read(gp, io_ticks)),
+		       jiffies_to_msecs(disk_stat_read(gp, time_in_queue)),
+		       gp->queue->rq.count[0], gp->queue->rq.count[1],
+		       gp->queue->in_flight);
+	}
+	mutex_unlock(&block_subsys_lock);
+}
+
 /*
  * aggregate disk stat collector.  Uses the same stats that the sysfs
  * entries do, above, but makes them available through one seq_file.
_

--=-=-=--

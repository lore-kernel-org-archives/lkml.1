Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYKUQSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYKUQSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYKUQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:18:21 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:33650 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYKUQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:18:20 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Fix locking for shca_list_lock
Date: Fri, 21 Nov 2008 17:18:16 +0100
User-Agent: KMail/1.9.1
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
References: <200806061835.43802.fenkes@de.ibm.com> <200811211637.15300.fenkes@de.ibm.com> <1227283347.3599.8.camel@johannes.berg>
In-Reply-To: <1227283347.3599.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811211718.17489.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shca_list_lock is taken from softirq context in ehca_poll_eqs, so we need to
lock IRQ safe elsewhere.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

On Friday 21 November 2008 17:02, Johannes Berg wrote:
> On Fri, 2008-11-21 at 16:37 +0100, Joachim Fenkes wrote:
> 
> > +	u64 flags;
> 
> > -	spin_lock(&shca_list_lock);
> > +	spin_lock_irqsave(&shca_list_lock, flags);
> 
> That's wrong and I think will give a warning on all machines where
> u64 != unsigned long. Might not particularly matter in this case.

Doesn't matter for a ppc64 only driver, but you're right nonetheless. Thanks.
 
> Also, generally it seems wrong to say "fix lockdep failure" when the
> patch really fixes a bug that lockdep happened to find.

Whatever -- changed.

Here's the updated patch.

Regards,
  Joachim


 drivers/infiniband/hw/ehca/ehca_main.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index bb02a86..169aa1a 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -717,6 +717,7 @@ static int __devinit ehca_probe(struct of_device *dev,
 	const u64 *handle;
 	struct ib_pd *ibpd;
 	int ret, i, eq_size;
+	unsigned long flags;
 
 	handle = of_get_property(dev->node, "ibm,hca-handle", NULL);
 	if (!handle) {
@@ -830,9 +831,9 @@ static int __devinit ehca_probe(struct of_device *dev,
 		ehca_err(&shca->ib_device,
 			 "Cannot create device attributes  ret=%d", ret);
 
-	spin_lock(&shca_list_lock);
+	spin_lock_irqsave(&shca_list_lock, flags);
 	list_add(&shca->shca_list, &shca_list);
-	spin_unlock(&shca_list_lock);
+	spin_unlock_irqrestore(&shca_list_lock, flags);
 
 	return 0;
 
@@ -878,6 +879,7 @@ probe1:
 static int __devexit ehca_remove(struct of_device *dev)
 {
 	struct ehca_shca *shca = dev->dev.driver_data;
+	unsigned long flags;
 	int ret;
 
 	sysfs_remove_group(&dev->dev.kobj, &ehca_dev_attr_grp);
@@ -915,9 +917,9 @@ static int __devexit ehca_remove(struct of_device *dev)
 
 	ib_dealloc_device(&shca->ib_device);
 
-	spin_lock(&shca_list_lock);
+	spin_lock_irqsave(&shca_list_lock, flags);
 	list_del(&shca->shca_list);
-	spin_unlock(&shca_list_lock);
+	spin_unlock_irqrestore(&shca_list_lock, flags);
 
 	return ret;
 }
@@ -975,6 +977,7 @@ static int ehca_mem_notifier(struct notifier_block *nb,
 			     unsigned long action, void *data)
 {
 	static unsigned long ehca_dmem_warn_time;
+	unsigned long flags;
 
 	switch (action) {
 	case MEM_CANCEL_OFFLINE:
@@ -985,12 +988,12 @@ static int ehca_mem_notifier(struct notifier_block *nb,
 	case MEM_GOING_ONLINE:
 	case MEM_GOING_OFFLINE:
 		/* only ok if no hca is attached to the lpar */
-		spin_lock(&shca_list_lock);
+		spin_lock_irqsave(&shca_list_lock, flags);
 		if (list_empty(&shca_list)) {
-			spin_unlock(&shca_list_lock);
+			spin_unlock_irqrestore(&shca_list_lock, flags);
 			return NOTIFY_OK;
 		} else {
-			spin_unlock(&shca_list_lock);
+			spin_unlock_irqrestore(&shca_list_lock, flags);
 			if (printk_timed_ratelimit(&ehca_dmem_warn_time,
 						   30 * 1000))
 				ehca_gen_err("DMEM operations are not allowed"
-- 
1.5.5




Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZHJQHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZHJQHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZHJQHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:07:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:7764 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbZHJQHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PZBPcFV4z2SQbMZYT/1HIFjBVuyyKCmC2q/56g552S9/UqiAp0MoPBczJIJaCvjvSW
         epVkkjZdhPs41y9HL0x2UGwXpnqBF3n0L0fglIsmMmfpcjBHth7SBtEJBLtb9PIPszGv
         0hqjI/+1RDZjTjI7z5mollTIioQ0hlUMwOX+M=
Message-ID: <4A8045BD.8010803@gmail.com>
Date: Mon, 10 Aug 2009 18:07:25 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       general@lists.openfabrics.org
Subject: Re: [PATCH 10/14] infiniband: use printk_once
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>	<1249847649-11631-11-git-send-email-marcin.slusarz@gmail.com> <adaocqo9sb4.fsf@cisco.com>
In-Reply-To: <adaocqo9sb4.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  >  drivers/infiniband/hw/cxgb3/iwch.c |    4 +---
>  >  drivers/infiniband/hw/mlx4/main.c  |    6 +-----
> 
>  > --- a/drivers/infiniband/hw/mlx4/main.c
>  > +++ b/drivers/infiniband/hw/mlx4/main.c
>  > @@ -540,15 +540,11 @@ static struct device_attribute *mlx4_class_attributes[] = {
>  >  
>  >  static void *mlx4_ib_add(struct mlx4_dev *dev)
>  >  {
>  > -	static int mlx4_ib_version_printed;
>  >  	struct mlx4_ib_dev *ibdev;
>  >  	int num_ports = 0;
>  >  	int i;
>  >  
>  > -	if (!mlx4_ib_version_printed) {
>  > -		printk(KERN_INFO "%s", mlx4_ib_version);
>  > -		++mlx4_ib_version_printed;
>  > -	}
>  > +	printk_once(KERN_INFO "%s", mlx4_ib_version);
>  >  
>  >  	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
>  >  		num_ports++;
> 
> Looks fine but there is near-identical code in
> drivers/infiniband/hw/mthca/mthca_main.c that you might as well convert
> too.

Thanks for a hint. Updated patch below.

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Date: Mon, 10 Aug 2009 18:01:49 +0200
Subject: [PATCH 10/14 v2] infiniband: use printk_once

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: general@lists.openfabrics.org
---
 drivers/infiniband/hw/cxgb3/iwch.c       |    4 +---
 drivers/infiniband/hw/mlx4/main.c        |    6 +-----
 drivers/infiniband/hw/mthca/mthca_main.c |    6 +-----
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch.c b/drivers/infiniband/hw/cxgb3/iwch.c
index 26fc0a4..9cc99df 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.c
+++ b/drivers/infiniband/hw/cxgb3/iwch.c
@@ -105,11 +105,9 @@ static void rnic_init(struct iwch_dev *rnicp)
 static void open_rnic_dev(struct t3cdev *tdev)
 {
 	struct iwch_dev *rnicp;
-	static int vers_printed;
 
 	PDBG("%s t3cdev %p\n", __func__,  tdev);
-	if (!vers_printed++)
-		printk(KERN_INFO MOD "Chelsio T3 RDMA Driver - version %s\n",
+	printk_once(KERN_INFO MOD "Chelsio T3 RDMA Driver - version %s\n",
 		       DRV_VERSION);
 	rnicp = (struct iwch_dev *)ib_alloc_device(sizeof(*rnicp));
 	if (!rnicp) {
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ae3d759..0b2f77a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -540,15 +540,11 @@ static struct device_attribute *mlx4_class_attributes[] = {
 
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
-	static int mlx4_ib_version_printed;
 	struct mlx4_ib_dev *ibdev;
 	int num_ports = 0;
 	int i;
 
-	if (!mlx4_ib_version_printed) {
-		printk(KERN_INFO "%s", mlx4_ib_version);
-		++mlx4_ib_version_printed;
-	}
+	printk_once(KERN_INFO "%s", mlx4_ib_version);
 
 	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
 		num_ports++;
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index 13da9f1..2e4e043 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1215,15 +1215,11 @@ int __mthca_restart_one(struct pci_dev *pdev)
 static int __devinit mthca_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
-	static int mthca_version_printed = 0;
 	int ret;
 
 	mutex_lock(&mthca_device_mutex);
 
-	if (!mthca_version_printed) {
-		printk(KERN_INFO "%s", mthca_version);
-		++mthca_version_printed;
-	}
+	printk_once(KERN_INFO "%s", mthca_version);
 
 	if (id->driver_data >= ARRAY_SIZE(mthca_hca_table)) {
 		printk(KERN_ERR PFX "%s has invalid driver data %lx\n",
-- 
1.6.3.3


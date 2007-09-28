Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXI1Nz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXI1Nz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbXI1Nzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:55:48 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:42552 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbXI1Nzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:55:47 -0400
Date: Fri, 28 Sep 2007 15:54:48 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 4/4] sysfs: make suicidal nodes just do it directly
Message-ID: <20070928155448.3dedd801@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11902731751771-git-send-email-htejun@gmail.com>
References: <11902731752407-git-send-email-htejun@gmail.com>
	<11902731751771-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 16:26:15 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Sysfs now allows direct suicide.  Make suicidial sysfs nodes to use
> it and remove now unncessary callback mechanism.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  drivers/base/core.c         |   33 ----------------------
>  drivers/s390/cio/ccwgroup.c |   25 +++-------------
>  drivers/scsi/scsi_sysfs.c   |   13 +--------
>  fs/sysfs/file.c             |   63 -------------------------------------------
>  include/linux/device.h      |    6 ----
>  include/linux/sysfs.h       |    9 ------
>  6 files changed, 6 insertions(+), 143 deletions(-)

ccwgroup was implicitly relying on a held reference, fix that.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/s390/cio/ccwgroup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/s390/cio/ccwgroup.c
+++ linux-2.6/drivers/s390/cio/ccwgroup.c
@@ -72,7 +72,7 @@ ccwgroup_ungroup_store(struct device *de
 	struct ccwgroup_device *gdev;
 	int rc;
 
-	gdev = to_ccwgroupdev(dev);
+	gdev = to_ccwgroupdev(get_device(dev));
 
 	if (gdev->state != CCWGROUP_OFFLINE)
 		return -EINVAL;
@@ -81,6 +81,7 @@ ccwgroup_ungroup_store(struct device *de
 	__ccwgroup_remove_symlinks(gdev);
 	device_unregister(dev);
 	mutex_unlock(&gdev->reg_mutex);
+	put_device(dev);
 
 	return count;
 }

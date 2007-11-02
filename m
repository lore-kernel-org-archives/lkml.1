Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXKBXi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXKBXi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 19:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbXKBXiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 19:38:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:13581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225AbXKBXiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 19:38:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,364,1188802800"; 
   d="scan'208";a="261528334"
Date: Fri, 2 Nov 2007 16:37:08 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-Id: <20071102163708.15304989.kristen.c.accardi@intel.com>
In-Reply-To: <20071101084145.GA5037@kernel.dk>
References: <20071031201308.GK11514@kernel.dk>
	<20071101084145.GA5037@kernel.dk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 09:41:46 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Oct 31 2007, Jens Axboe wrote:
> > Hi,
> > 
> > My x60 stopped suspending about two days ago. It just freezes after
> > printing
> > 
> > Suspending console(s)
> > 
> > where it would normally turn everything off and the 'moon' light would
> > go on. Posting this message in case somebody else knows what is up, if
> > not I'll do a bisect on it tomorrow.
> 
> Did the bisect, it points to this commit:
> 
> 1556594f913fa81d008cecfe46d7211c919a853 is first bad commit
> commit 31556594f913fa81d008cecfe46d7211c919a853
> Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> Date:   Thu Oct 25 01:33:26 2007 -0400
> 
>     [libata] AHCI: add hw link power management support
> 
> Booting any kernel after this commit fails suspending to ram, it just
> sits there forever.
> 
> -- 
> Jens Axboe
> 

Does this patch fix your problem?  It seems to get hung up while disabling
DIPM, and after thinking about this a bit, I don't think we really need
to do this anyway.


Don't disable dipm with SET FEATURES

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

---
 drivers/ata/libata-core.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: 2.6-git/drivers/ata/libata-core.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-core.c	2007-11-01 09:59:17.000000000 -0700
+++ 2.6-git/drivers/ata/libata-core.c	2007-11-02 16:35:13.000000000 -0700
@@ -676,10 +676,11 @@ static int ata_dev_set_dipm(struct ata_d
 		if (rc)
 			return rc;
 
-		/* disable DIPM */
-		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
-			err_mask = ata_dev_set_feature(dev,
-					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		/*
+		 * we don't have to disable DIPM since IPM flags
+		 * disallow transitions to SLUMBER, which effectively
+		 * disable DIPM if it does not support PARTIAL
+		 */
 		break;
 	case NOT_AVAILABLE:
 	case MAX_PERFORMANCE:
@@ -689,10 +690,11 @@ static int ata_dev_set_dipm(struct ata_d
 		if (rc)
 			return rc;
 
-		/* disable DIPM */
-		if (ata_dev_enabled(dev) && (dev->flags & ATA_DFLAG_DIPM))
-			err_mask = ata_dev_set_feature(dev,
-					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+		/*
+		 * we don't have to disable DIPM since IPM flags
+		 * disallow all transitions which effectively
+		 * disable DIPM anyway.
+		 */
 		break;
 	}
 

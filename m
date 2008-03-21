Return-Path: <linux-kernel-owner+w=401wt.eu-S1763290AbYCUWsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763290AbYCUWsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762660AbYCUWqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:12 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34721 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762635AbYCUWqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:08 -0400
Message-Id: <20080321224356.256629483@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 28/76] SCSI gdth: dont call pci_free_consistent under spinlock
Content-Disposition: inline; filename=scsi-gdth-don-t-call-pci_free_consistent-under-spinlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

The spinlock is held over too large a region: pscratch is a permanent
address (it's allocated at boot time and never changes).  All you need
the smp lock for is mediating the scratch in use flag, so fix this by
moving the spinlock into the case where we set the pscratch_busy flag
to false.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/gdth_proc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -694,15 +694,13 @@ static void gdth_ioctl_free(gdth_ha_str 
 {
     ulong flags;
 
-    spin_lock_irqsave(&ha->smp_lock, flags);
-
     if (buf == ha->pscratch) {
+	spin_lock_irqsave(&ha->smp_lock, flags);
         ha->scratch_busy = FALSE;
+	spin_unlock_irqrestore(&ha->smp_lock, flags);
     } else {
         pci_free_consistent(ha->pdev, size, buf, paddr);
     }
-
-    spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
 #ifdef GDTH_IOCTL_PROC

-- 

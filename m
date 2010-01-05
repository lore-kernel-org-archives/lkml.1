Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027Ab0AEAeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0AEAeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094Ab0AEAeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:31 -0500
Received: from kroah.org ([198.145.64.141]:34054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0AEAeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/97] SCSI: ipr: fix EEH recovery
Date: Mon,  4 Jan 2010 16:32:14 -0800
Message-Id: <1262651630-7354-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

commit 99c965dd9ee1a004efc083c3d760ba982bb76adf upstream.

After commits c82f63e411f1b58427c103bd95af2863b1c96dd1 (PCI: check saved
state before restore) and 4b77b0a2ba27d64f58f16d8d4d48d8319dda36ff (PCI:
Clear saved_state after the state has been restored) PCI drivers are
prevented from restoring the device standard configuration registers
twice in a row. These changes introduced a regression on ipr EEH
recovery.

The ipr device driver saves the PCI state only during the device probe
and restores it on ipr_reset_restore_cfg_space() during IOA resets. This
behavior is causing the EEH recovery to fail after the second error
detected, since the registers are not being restored.

One possible solution would be saving the registers after restoring
them. The problem with this approach is that while recovering from an
EEH error if pci_save_state() results in an EEH error, the adapter/slot
will be reset, and end up back in ipr_reset_restore_cfg_space(), but it
won't have a valid saved state to restore, so pci_restore_state() will
fail.

The following patch introduces a workaround for this problem, hacking
around the PCI API by setting pdev->state_saved = true before we do the
restore. It fixes the EEH regression and prevents that we hit another
EEH error during EEH recovery.


[jejb: fix is a hack ... Jesse and Rafael will fix properly]
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/ipr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 76d294f..c3ff9a6 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6516,6 +6516,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
 	int rc;
 
 	ENTER;
+	ioa_cfg->pdev->state_saved = true;
 	rc = pci_restore_state(ioa_cfg->pdev);
 
 	if (rc != PCIBIOS_SUCCESSFUL) {
-- 
1.6.6


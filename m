Return-Path: <linux-kernel-owner+w=401wt.eu-S1763140AbYHDUU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763140AbYHDUU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762124AbYHDUUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:20:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:45416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762140AbYHDUUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:20:19 -0400
Date: Mon, 4 Aug 2008 13:14:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Hannes Reinecke <hare@suse.de>,
       Bo Yang <Bo.Yang@lsi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 03/33] SCSI: megaraid_mbox: fix Dell CERC firmware problem
Message-ID: <20080804201445.GD1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-megaraid_mbox-fix-dell-cerc-firmware-problem.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 69cd39e94669e2994277a29249b6ef93b088ddbb upstream

Newer Dell CERC firmware (>= 6.62) implement a random deletion handling
compatible with the legacy megaraid driver.  The legacy handling shifted
the target ID by 0x80 only for I/O commands (READ/WRITE/etc), whereas
megaraid_mbox shifts the target ID always if random deletion is supported.
The resulted in megaraid_mbox sending an INQUIRY to the wrong channel, and
not finding any devices, obviously.

So we disable the random deletion support if the offending firmware is
found.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=6695

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Bo Yang <Bo.Yang@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/megaraid/megaraid_mbox.c |   17 +++++++++++++++++
 drivers/scsi/megaraid/megaraid_mbox.h |    1 +
 2 files changed, 18 insertions(+)

--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3168,6 +3168,23 @@ megaraid_mbox_support_random_del(adapter
 	uint8_t		raw_mbox[sizeof(mbox_t)];
 	int		rval;
 
+	/*
+	 * Newer firmware on Dell CERC expect a different
+	 * random deletion handling, so disable it.
+	 */
+	if (adapter->pdev->vendor == PCI_VENDOR_ID_AMI &&
+	    adapter->pdev->device == PCI_DEVICE_ID_AMI_MEGARAID3 &&
+	    adapter->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL &&
+	    adapter->pdev->subsystem_device == PCI_SUBSYS_ID_CERC_ATA100_4CH &&
+	    (adapter->fw_version[0] > '6' ||
+	     (adapter->fw_version[0] == '6' &&
+	      adapter->fw_version[2] > '6') ||
+	     (adapter->fw_version[0] == '6'
+	      && adapter->fw_version[2] == '6'
+	      && adapter->fw_version[3] > '1'))) {
+		con_log(CL_DLEVEL1, ("megaraid: disable random deletion\n"));
+		return 0;
+	}
 
 	mbox = (mbox_t *)raw_mbox;
 
--- a/drivers/scsi/megaraid/megaraid_mbox.h
+++ b/drivers/scsi/megaraid/megaraid_mbox.h
@@ -88,6 +88,7 @@
 #define PCI_SUBSYS_ID_PERC3_QC				0x0471
 #define PCI_SUBSYS_ID_PERC3_DC				0x0493
 #define PCI_SUBSYS_ID_PERC3_SC				0x0475
+#define PCI_SUBSYS_ID_CERC_ATA100_4CH			0x0511
 
 
 #define MBOX_MAX_SCSI_CMDS	128	// number of cmds reserved for kernel

-- 

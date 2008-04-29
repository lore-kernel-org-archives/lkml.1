Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbYD2Rda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbYD2Rda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbYD2RWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:22:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:43687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbYD2RWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:22:12 -0400
Date: Tue, 29 Apr 2008 10:19:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chien Tung <ctung@neteffect.com>, Roland Dreier <rolandd@cisco.com>
Subject: [33/37] RDMA/nes: Fix adapter reset after PXE boot
Message-ID: <20080429171917.GH14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rdma-nes-fix-adapter-reset-after-pxe-boot.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Chien Tung <ctung@neteffect.com>

commit: bc5698f3ecc9587e1edb343a2878f8d228c49e0e upstream

After PXE boot, the iw_nes driver does a full reset to ensure the card
is in a clean state.  However, it doesn't wait for firmware to
complete its work before issuing a port reset to enable the ports,
which leads to problems bringing up the ports.

The solution is to wait for firmware to complete its work before
proceeding with port reset.

This bug was flagged by Roland Dreier <rolandd@cisco.com>.

Signed-off-by: Chien Tung <ctung@neteffect.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/nes/nes_cm.c |    6 ++++--
 drivers/infiniband/hw/nes/nes_hw.c |   20 +++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1834,8 +1834,10 @@ int mini_cm_recv_pkt(struct nes_cm_core 
 	nfo.rem_addr = ntohl(iph->saddr);
 	nfo.rem_port = ntohs(tcph->source);
 
-	nes_debug(NES_DBG_CM, "Received packet: dest=0x%08X:0x%04X src=0x%08X:0x%04X\n",
-			iph->daddr, tcph->dest, iph->saddr, tcph->source);
+	nes_debug(NES_DBG_CM, "Received packet: dest=" NIPQUAD_FMT
+		  ":0x%04X src=" NIPQUAD_FMT ":0x%04X\n",
+		  NIPQUAD(iph->daddr), tcph->dest,
+		  NIPQUAD(iph->saddr), tcph->source);
 
 	/* note: this call is going to increment cm_node ref count */
 	cm_node = find_node(cm_core,
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -625,6 +625,15 @@ unsigned int nes_reset_adapter_ne020(str
 			nes_debug(NES_DBG_INIT, "Did not see full soft reset done.\n");
 			return 0;
 		}
+
+		i = 0;
+		while ((nes_read_indexed(nesdev, NES_IDX_INT_CPU_STATUS) != 0x80) && i++ < 10000)
+			mdelay(1);
+		if (i >= 10000) {
+			printk(KERN_ERR PFX "Internal CPU not ready, status = %02X\n",
+			       nes_read_indexed(nesdev, NES_IDX_INT_CPU_STATUS));
+			return 0;
+		}
 	}
 
 	/* port reset */
@@ -673,17 +682,6 @@ unsigned int nes_reset_adapter_ne020(str
 		}
 	}
 
-
-
-	i = 0;
-	while ((nes_read_indexed(nesdev, NES_IDX_INT_CPU_STATUS) != 0x80) && i++ < 10000)
-		mdelay(1);
-	if (i >= 10000) {
-		printk(KERN_ERR PFX "Internal CPU not ready, status = %02X\n",
-				nes_read_indexed(nesdev, NES_IDX_INT_CPU_STATUS));
-		return 0;
-	}
-
 	return port_count;
 }
 

-- 

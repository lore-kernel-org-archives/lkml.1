Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbYD2RZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbYD2RZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbYD2RUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:52001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273AbYD2RUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:51 -0400
Date: Tue, 29 Apr 2008 10:18:28 -0700
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
       Roland Dreier <rolandd@cisco.com>
Subject: [14/37] RDMA/nes: Free IRQ before killing tasklet
Message-ID: <20080429171828.GO14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rdma-nes-free-irq-before-killing-tasklet.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Roland Dreier <rolandd@cisco.com>

commit: 4cd1e5eb3cbe6e0cc934959770b4c60eac6ecf66

Move the free_irq() call in nes_remove() to before the tasklet_kill();
otherwise there is a window after tasklet_kill() where a new interrupt
can be handled and reschedule the tasklet, leading to a use-after-free
crash.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/nes/nes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -751,13 +751,13 @@ static void __devexit nes_remove(struct 
 
 	list_del(&nesdev->list);
 	nes_destroy_cqp(nesdev);
+
+	free_irq(pcidev->irq, nesdev);
 	tasklet_kill(&nesdev->dpc_tasklet);
 
 	/* Deallocate the Adapter Structure */
 	nes_destroy_adapter(nesdev->nesadapter);
 
-	free_irq(pcidev->irq, nesdev);
-
 	if (nesdev->msi_enabled) {
 		pci_disable_msi(pcidev);
 	}

-- 

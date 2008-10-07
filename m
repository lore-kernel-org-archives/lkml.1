Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbYJGBDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbYJGBDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYJGAqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:17 -0400
Received: from mail.suse.de ([195.135.220.2]:47233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509AbYJGAqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:15 -0400
Date: Mon, 6 Oct 2008 17:40:11 -0700
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 62/71] sparc64: Fix OOPS in psycho_pcierr_intr_other().
Message-ID: <20081007004011.GK3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0003-sparc64-Fix-OOPS-in-psycho_pcierr_intr_other.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit f948cc6ab9e61a8e88d70ee9aafc690e6d26f92c ]

We no longer put the top-level PCI controller device into the
PCI layer device list.  So pbm->pci_bus->self is always NULL.

Therefore, use direct PCI config space accesses to get at
the PCI controller's PCI_STATUS register.

Tested by Meelis Roos.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/pci_psycho.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/sparc64/kernel/pci_psycho.c
+++ b/arch/sparc64/kernel/pci_psycho.c
@@ -575,7 +575,7 @@ static irqreturn_t psycho_pcierr_intr_ot
 {
 	unsigned long csr_reg, csr, csr_error_bits;
 	irqreturn_t ret = IRQ_NONE;
-	u16 stat;
+	u16 stat, *addr;
 
 	if (is_pbm_a) {
 		csr_reg = pbm->controller_regs + PSYCHO_PCIA_CTRL;
@@ -597,7 +597,9 @@ static irqreturn_t psycho_pcierr_intr_ot
 			printk("%s: PCI SERR signal asserted.\n", pbm->name);
 		ret = IRQ_HANDLED;
 	}
-	pci_read_config_word(pbm->pci_bus->self, PCI_STATUS, &stat);
+	addr = psycho_pci_config_mkaddr(pbm, pbm->pci_first_busno,
+					0, PCI_STATUS);
+	pci_config_read16(addr, &stat);
 	if (stat & (PCI_STATUS_PARITY |
 		    PCI_STATUS_SIG_TARGET_ABORT |
 		    PCI_STATUS_REC_TARGET_ABORT |
@@ -605,7 +607,7 @@ static irqreturn_t psycho_pcierr_intr_ot
 		    PCI_STATUS_SIG_SYSTEM_ERROR)) {
 		printk("%s: PCI bus error, PCI_STATUS[%04x]\n",
 		       pbm->name, stat);
-		pci_write_config_word(pbm->pci_bus->self, PCI_STATUS, 0xffff);
+		pci_config_write16(addr, 0xffff);
 		ret = IRQ_HANDLED;
 	}
 	return ret;

-- 

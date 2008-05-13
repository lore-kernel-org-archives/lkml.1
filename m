Return-Path: <linux-kernel-owner+w=401wt.eu-S932258AbYEMUQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbYEMUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759326AbYEMUON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:14:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:37903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761985AbYEMUOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:14:11 -0400
Date: Tue, 13 May 2008 13:11:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 10/37] sparc64: Fix wedged irq regression.
Message-ID: <20080513201154.GK31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-wedged-irq-regression.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit: 92aa3573c9cd58fe0bcd1c52c9fd8f5708785917 ]

Kernel bugzilla 10273

As reported by Jos van der Ende, ever since commit
5a606b72a4309a656cd1a19ad137dc5557c4b8ea ("[SPARC64]: Do not ACK an
INO if it is disabled or inprogress.") sun4u interrupts
can get stuck.

What this changset did was add the following conditional to
the various IRQ chip ->enable() handlers on sparc64:

	if (unlikely(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
		return;

which is correct, however it means that special care is needed
in the ->enable() method.

Specifically we must put the interrupt into IDLE state during
an enable, or else it might never be sent out again.

Setting the INO interrupt state to IDLE resets the state machine,
the interrupt input to the INO is retested by the hardware, and
if an interrupt is being signalled by the device, the INO
moves back into TRANSMIT state, and an interrupt vector is sent
to the cpu.

The two sun4v IRQ chip handlers were already doing this properly,
only sun4u got it wrong.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/irq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/sparc64/kernel/irq.c
+++ b/arch/sparc64/kernel/irq.c
@@ -1,6 +1,6 @@
 /* irq.c: UltraSparc IRQ handling/init/registry.
  *
- * Copyright (C) 1997, 2007  David S. Miller  (davem@davemloft.net)
+ * Copyright (C) 1997, 2007, 2008 David S. Miller (davem@davemloft.net)
  * Copyright (C) 1998  Eddie C. Dost    (ecd@skynet.be)
  * Copyright (C) 1998  Jakub Jelinek    (jj@ultra.linux.cz)
  */
@@ -308,6 +308,7 @@ static void sun4u_irq_enable(unsigned in
 			 IMAP_AID_SAFARI | IMAP_NID_SAFARI);
 		val |= tid | IMAP_VALID;
 		upa_writeq(val, imap);
+		upa_writeq(ICLR_IDLE, data->iclr);
 	}
 }
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S969406AbXGaEjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969406AbXGaEjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940766AbXGaEc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:28 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34648 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940538AbXGaEc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:27 -0400
Date: Mon, 30 Jul 2007 21:33:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mgreer@mvista.com, jaylubo@motorola.com,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 21/26] serial: clear proper MPSC interrupt cause bits
Message-ID: <20070731043337.GV3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="serial-clear-proper-mpsc-interrupt-cause-bits.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jay Lubomirski <jaylubo@motorola.com>

The interrupt clearing code in mpsc_sdma_intr_ack() mistakenly clears the
interrupt for both controllers instead of just the one its supposed to.
This can result in the other controller appearing to hang because its
interrupt was effectively lost.

So, don't clear the interrupt cause bits for both MPSC controllers when
clearing the interrupt for one of them.  Just clear the one that is
supposed to be cleared.

Signed-off-by: Jay Lubomirski <jaylubo@motorola.com>
Acked-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/serial/mpsc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.21.6.orig/drivers/serial/mpsc.c
+++ linux-2.6.21.6/drivers/serial/mpsc.c
@@ -502,7 +502,8 @@ mpsc_sdma_intr_ack(struct mpsc_port_info
 
 	if (pi->mirror_regs)
 		pi->shared_regs->SDMA_INTR_CAUSE_m = 0;
-	writel(0, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE);
+	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE +
+	       pi->port.line);
 	return;
 }
 

-- 

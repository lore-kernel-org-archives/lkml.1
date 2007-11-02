Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbXKBRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbXKBRp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXKBRpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:45:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53876 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbXKBRpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:45:15 -0400
Date: Fri, 2 Nov 2007 10:37:48 -0700
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
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 1/9] genirq: cleanup mismerge artifact
Message-ID: <20071102173748.GB6378@kroah.com>
References: <20071102173359.709442489@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="genirq-cleanup-mismerge-artifact.patch"
In-Reply-To: <20071102173733.GA6378@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

patch 496634217e5671ed876a0348e9f5b7165e830b20 in mainline.

Commit 5a43a066b11ac2fe84cf67307f20b83bea390f83: "genirq: Allow fasteoi
handler to retrigger disabled interrupts" was erroneously applied to
handle_level_irq().  This added the irq retrigger / resend functionality
to the level irq handler.

Revert the offending bits.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/chip.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -352,13 +352,10 @@ handle_level_irq(unsigned int irq, struc
 	 * keep it masked and get out of here
 	 */
 	action = desc->action;
-	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
-		desc->status |= IRQ_PENDING;
+	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
 		goto out_unlock;
-	}
 
 	desc->status |= IRQ_INPROGRESS;
-	desc->status &= ~IRQ_PENDING;
 	spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);

-- 

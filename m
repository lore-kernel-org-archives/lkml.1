Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZBJTLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZBJTLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbZBJTDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:50 -0500
Received: from kroah.org ([198.145.64.141]:53858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755577AbZBJTDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:49 -0500
Date: Tue, 10 Feb 2009 11:00:26 -0800
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
       alan@lxorguk.ukuu.org.uk, Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/53] e1000: fix bug with shared interrupt during reset
Message-ID: <20090210190026.GW14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="e1000-fix-bug-with-shared-interrupt-during-reset.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 15b2bee22a0390d951301b53e83df88d0350c499 upstream.

A nasty bug was found where an MTU change (or anything else that caused a
reset) could race with the interrupt code.  The interrupt code was entered
by a shared interrupt during the MTU change.

This change prevents the interrupt code from running while the driver is in
the middle of its reset path.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -31,7 +31,7 @@
 
 char e1000_driver_name[] = "e1000";
 static char e1000_driver_string[] = "Intel(R) PRO/1000 Network Driver";
-#define DRV_VERSION "7.3.20-k3-NAPI"
+#define DRV_VERSION "7.3.21-k3-NAPI"
 const char e1000_driver_version[] = DRV_VERSION;
 static const char e1000_copyright[] = "Copyright (c) 1999-2006 Intel Corporation.";
 
@@ -3712,7 +3712,7 @@ static irqreturn_t e1000_intr(int irq, void *data)
 	struct e1000_hw *hw = &adapter->hw;
 	u32 rctl, icr = er32(ICR);
 
-	if (unlikely(!icr))
+	if (unlikely((!icr) || test_bit(__E1000_RESETTING, &adapter->flags)))
 		return IRQ_NONE;  /* Not our interrupt */
 
 	/* IMS will not auto-mask if INT_ASSERTED is not set, and if it is


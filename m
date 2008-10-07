Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYJGAof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYJGAof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYJGAmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:42:51 -0400
Received: from ns2.suse.de ([195.135.220.15]:60316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205AbYJGAmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:42:50 -0400
Date: Mon, 6 Oct 2008 17:37:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Geoff Levand <geoffrey.levand@am.sony.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Stefan Becker <Stefan.Becker@nokia.com>
Subject: [patch 11/71] USB: fix hcd interrupt disabling
Message-ID: <20081007003756.GL3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-hcd-interrupt-disabling.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Geoff Levand <geoffrey.levand@am.sony.com>

commit 83a798207361cc26385187b2e71efa2b5d75de7f upstream

Commit de85422b94ddb23c021126815ea49414047c13dc, 'USB: fix interrupt
disabling for HCDs with shared interrupt handlers' changed usb_add_hcd()
to strip IRQF_DISABLED from irqflags prior to calling request_irq()
with the justification that such a removal was necessary for shared
interrupts to work properly.  Unfortunately, the change in that commit
unconditionally removes the IRQF_DISABLED flag, causing problems on
platforms that don't use a shared interrupt but require IRQF_DISABLED.
This change adds a check for IRQF_SHARED prior to removing the
IRQF_DISABLED flag.

Fixes the PS3 system startup hang reported with recent Fedora and
OpenSUSE kernels.

Note that this problem is hidden when CONFIG_LOCKDEP=y (ps3_defconfig),
as local_irq_enable_in_hardirq() is defined as a null statement for
that config.

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Stefan Becker <Stefan.Becker@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/hcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1885,7 +1885,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
 		 * with IRQF_SHARED. As usb_hcd_irq() will always disable
 		 * interrupts we can remove it here.
 		 */
-		irqflags &= ~IRQF_DISABLED;
+		if (irqflags & IRQF_SHARED)
+			irqflags &= ~IRQF_DISABLED;
 
 		snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
 				hcd->driver->description, hcd->self.busnum);

-- 

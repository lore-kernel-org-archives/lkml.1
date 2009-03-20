Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbZCTXic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbZCTXic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762299AbZCTXYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:54 -0400
Received: from kroah.org ([198.145.64.141]:48788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762986AbZCTXYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:28 2009
Message-Id: <20090320222928.408831283@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:45 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 35/43] USB: EHCI: expedite unlinks when the root hub is suspended
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-ehci-expedite-unlinks-when-the-root-hub-is-suspended.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 391016f6e2fe3b9979b4c6880a76e5e434d6947c upstream.

This patch (as1225) fixes a bug in ehci-hcd.  The condition for
whether unlinked QHs can become IDLE should not be that the controller
is halted, but rather that the controller isn't running.  In other
words when the root hub is suspended, the hardware doesn't own any
QHs.

This fixes a problem that can show up during hibernation: If a QH is
only partially unlinked when the root hub is frozen, then when the
root hub is thawed the QH won't be in the IDLE state.  As a result it
can't be used properly for new URB submissions.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Brandon Philips <brandon@ifup.org>
Tested-by: Brandon Philips <brandon@ifup.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-q.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1095,7 +1095,8 @@ static void start_unlink_async (struct e
 	prev->qh_next = qh->qh_next;
 	wmb ();
 
-	if (unlikely (ehci_to_hcd(ehci)->state == HC_STATE_HALT)) {
+	/* If the controller isn't running, we don't have to wait for it */
+	if (unlikely(!HC_IS_RUNNING(ehci_to_hcd(ehci)->state))) {
 		/* if (unlikely (qh->reclaim != 0))
 		 *	this will recurse, probably not much
 		 */



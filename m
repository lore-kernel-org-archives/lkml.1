Return-Path: <linux-kernel-owner+w=401wt.eu-S1765857AbYCUXKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765857AbYCUXKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbYCUWwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:52:24 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41323 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161AbYCUWwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:22 -0400
Message-Id: <20080321224433.633957866@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:46 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Misha Zhilin <misha@epiphan.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 56/76] USB: ehci: handle large bulk URBs correctly (again)
Content-Disposition: inline; filename=usb-ehci-handle-large-bulk-urbs-correctly.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Misha Zhilin <misha@epiphan.com>

When use of urb->status in the EHCI driver was reworked last August
(commit 14c04c0f88f228fee1f412be91d6edcb935c78aa), a bug was inserted
in the handling of early completion for bulk transactions that need
more than one qTD (e.g. more than 20KB in one URB).

This patch resolves that problem by ensuring that the early completion
status is preserved until the URB is handed back to its submitter,
instead of resetting it after each qTD.

Signed-off-by: Misha Zhilin <misha@epiphan.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/host/ehci-q.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -315,10 +315,10 @@ qh_completions (struct ehci_hcd *ehci, s
 			if (likely (last->urb != urb)) {
 				ehci_urb_done(ehci, last->urb, last_status);
 				count++;
+				last_status = -EINPROGRESS;
 			}
 			ehci_qtd_free (ehci, last);
 			last = NULL;
-			last_status = -EINPROGRESS;
 		}
 
 		/* ignore urbs submitted during completions we reported */

-- 

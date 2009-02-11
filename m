Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbZBKAi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbZBKAi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbZBKA2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:36 -0500
Received: from kroah.org ([198.145.64.141]:51329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757714AbZBKA2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:33 -0500
Date: Tue, 10 Feb 2009 16:25:20 -0800
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
       alan@lxorguk.ukuu.org.uk, Shaohua Li <shaohua.li@intel.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 31/56] PCI: properly clean up ASPM link state on device
	remove
Message-ID: <20090211002520.GF14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-properly-clean-up-aspm-link-state-on-device-remove.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Alex Chiang <achiang@hp.com>

commit 3419c75e15f82c3ab09bd944fddbde72c9e4b3ea upstream.

We only want to disable ASPM when the last function is removed from
the parent's device list. We determine this by checking to see if
the parent's device list is completely empty.

Unfortunately, we never hit that code because the parent is considered
an upstream port, and never had an ASPM link_state associated with it.

The early check for !link_state causes us to return early, we never
discover that our device list is empty, and thus we never remove the
downstream ports' link_state nodes.

Instead of checking to see if the parent's device list is empty, we can
check to see if we are the last device on the list, and if so, then we
know that we can clean up properly.

Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aspm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -713,9 +713,9 @@ void pcie_aspm_exit_link_state(struct pc
 
 	/*
 	 * All PCIe functions are in one slot, remove one function will remove
-	 * the the whole slot, so just wait
+	 * the whole slot, so just wait until we are the last function left.
 	 */
-	if (!list_empty(&parent->subordinate->devices))
+	if (!list_is_last(&pdev->bus_list, &parent->subordinate->devices))
 		goto out;
 
 	/* All functions are removed, so just disable ASPM for the link */


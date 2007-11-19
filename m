Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbXKSIEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbXKSIEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXKSIDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:03:53 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58562 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbXKSIDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:03:52 -0500
Date: Mon, 19 Nov 2007 09:03:48 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/macintosh/via-pmu.c: Add missing pci_dev_put
Message-ID: <Pine.LNX.4.64.0711190903100.19198@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

There should be a pci_dev_put when breaking out of a loop that iterates
over calls to pci_get_device and similar functions.

In this case, the return under the #else case of #ifdef HACKED_PCI_SAVE
should have a pci_dev_put, just as the return in the case where
HACKED_PCI_SAVE is true does.

This was fixed using the following semantic patch.

// <smpl>
@@
type T;
identifier d;
expression e;
@@

T *d;
...
while ((d = \(pci_get_device\|pci_get_device_reverse\|pci_get_subsys\|pci_get_class\)(..., d)) != NULL)
  {... when != pci_dev_put(d)
       when != e = d
(
    return d;
|
+  pci_dev_put(d);
?  return ...;
)
...}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
--- a/drivers/macintosh/via-pmu.c	2007-11-18 20:43:10.000000000 +0100
+++ b/drivers/macintosh/via-pmu.c	2007-11-19 08:16:44.000000000 +0100
@@ -1896,8 +1896,10 @@ pbook_pci_restore(void)
  			pci_write_config_dword(pd, i<<4, ps->config[i]);
  		pci_write_config_dword(pd, 4, ps->config[1]);
  #else
-		if (npci-- == 0)
+		if (npci-- == 0) {
+			pci_dev_put(pd);
  			return;
+		}
  		ps++;
  		if (ps->command == 0)
  			continue;

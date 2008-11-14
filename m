Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYKNSGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYKNSGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYKNSGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:06:40 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59143 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbYKNSGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:06:39 -0500
Date: Fri, 14 Nov 2008 19:06:36 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@server.perex.cz, tiwai@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] sound/pci/pcxhr/pcxhr.c: introduce missing kfree and
 pci_disable_device
Message-ID: <Pine.LNX.4.64.0811141906050.10023@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.
The error handling code is adjusted to call pci_disable_device(pci); as
well, as done later in the function

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 sound/pci/pcxhr/pcxhr.c       |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index 0e06c6c..73de6e9 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -1229,8 +1229,11 @@ static int __devinit pcxhr_probe(struct pci_dev *pci, const struct pci_device_id
 		return -ENOMEM;
 	}
 
-	if (snd_BUG_ON(pci_id->driver_data >= PCI_ID_LAST))
+	if (snd_BUG_ON(pci_id->driver_data >= PCI_ID_LAST)) {
+		kfree(mgr);
+		pci_disable_device(pci);
 		return -ENODEV;
+	}
 	card_name = pcxhr_board_params[pci_id->driver_data].board_name;
 	mgr->playback_chips = pcxhr_board_params[pci_id->driver_data].playback_chips;
 	mgr->capture_chips  = pcxhr_board_params[pci_id->driver_data].capture_chips;

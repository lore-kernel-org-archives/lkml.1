Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYKWIIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYKWIIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 03:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbYKWIIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 03:08:32 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39569 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbYKWIIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 03:08:30 -0500
Date: Sun, 23 Nov 2008 09:08:28 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] drivers/pci/hotplug: Add missing pci_dev_get
Message-ID: <Pine.LNX.4.64.0811230907370.28343@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

pci_get_slot does a pci_dev_get, so pci_dev_put needs to be called in an
error case.

An alterative would be to move the test_and_set_bit before the call to
pci_get_slot.

The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
local idexpression *n;
statement S1,S2;
expression E,E1;
expression *ptr != NULL;
type T,T1;
@@

(
if (!(n = pci_get_slot(...))) S1
|
n = pci_get_slot(...)
)
<... when != pci_dev_put(n)
    when != if (...) { <+... pci_dev_put(n) ...+> }
    when != true !n  || ...
    when != n = (T)E
    when != E = n
if (!n || ...) S2
...>
(
  return \(0\|<+...n...+>\|ptr\);
|
+ pci_dev_put(n);
return ...;
|
pci_dev_put(n);
|
n = (T1)E1
|
E1 = n
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

 drivers/pci/hotplug/fakephp.c |    1 +
 1 file changed, 1 insertion(+)

diff -u -p a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -324,6 +324,7 @@ static int disable_slot(struct hotplug_s
 
 		if (test_and_set_bit(0, &dslot->removed)) {
 			dbg("Slot already scheduled for removal\n");
+			pci_dev_put(dev);
 			return -ENODEV;
 		}
 

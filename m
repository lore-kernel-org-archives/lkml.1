Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZKULvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZKULvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 06:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbZKULvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 06:51:44 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42582 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbZKULvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 06:51:43 -0500
Date: Sat, 21 Nov 2009 12:51:47 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/8] drivers/usb/host/xhci-mem.c: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0911211251210.23681@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
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
 drivers/usb/host/xhci-mem.c         |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fd05247..33f8157 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -779,14 +779,17 @@ struct xhci_command *xhci_alloc_command(struct xhci_hcd *xhci,
 
 	command->in_ctx =
 		xhci_alloc_container_ctx(xhci, XHCI_CTX_TYPE_INPUT, mem_flags);
-	if (!command->in_ctx)
+	if (!command->in_ctx) {
+		kfree(command);
 		return NULL;
+	}
 
 	if (allocate_completion) {
 		command->completion =
 			kzalloc(sizeof(struct completion), mem_flags);
 		if (!command->completion) {
 			xhci_free_container_ctx(xhci, command->in_ctx);
+			kfree(command);
 			return NULL;
 		}
 		init_completion(command->completion);

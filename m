Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103Ab0AEAtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0AEAtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304Ab0AEAfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:11 -0500
Received: from kroah.org ([198.145.64.141]:34195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0AEAfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Shaun Ruffell <sruffell@digium.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/97] dma-debug: Do not add notifier when dma debugging is disabled.
Date: Mon,  4 Jan 2010 16:32:44 -0800
Message-Id: <1262651630-7354-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaun Ruffell <sruffell@digium.com>

commit f797d9881b62c2ddb1d2e7bd80d87141949c84aa upstream.

If CONFIG_HAVE_DMA_API_DEBUG is defined and "dma_debug=off" is
specified on the kernel command line, when you detach a driver from a
device you can cause the following NULL pointer dereference:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c0580d35>] dma_debug_device_change+0x5d/0x117

The problem is that the dma_debug_device_change notifier function is
added to the bus notifier chain even though the dma_entry_hash array
was never initialized.  If dma debugging is disabled, this patch both
prevents dma_debug_device_change notifiers from being added to the
chain, and additionally ensures that the dma_debug_device_change
notifier function is a no-op.

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dma-debug.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ce6b7ea..dcd43e3 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -676,6 +676,8 @@ static int dma_debug_device_change(struct notifier_block *nb,
 	struct device *dev = data;
 	int count;
 
+	if (global_disable)
+		return;
 
 	switch (action) {
 	case BUS_NOTIFY_UNBOUND_DRIVER:
@@ -697,6 +699,9 @@ void dma_debug_add_bus(struct bus_type *bus)
 {
 	struct notifier_block *nb;
 
+	if (global_disable)
+		return;
+
 	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
 	if (nb == NULL) {
 		pr_err("dma_debug_add_bus: out of memory\n");
-- 
1.6.6


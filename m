Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZLRApz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZLRApz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbZLRApy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:45:54 -0500
Received: from mail.digium.com ([216.207.245.2]:34017 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZLRApx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:45:53 -0500
X-Greylist: delayed 2702 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 19:45:53 EST
Message-ID: <4B2AC624.3080201@digium.com>
Date: Thu, 17 Dec 2009 18:00:36 -0600
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dma-debug: Do not add notifier when dma debugging is disabled.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_HAVE_DMA_API_DEBUG is defined and "dma_debug=off" is
specified on the kernel command line, when you detach a driver from a
device you can cause the following NULL pointer dereference:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c0580d35>] dma_debug_device_change+0x5d/0x117

The problem is that the dma_debug_device_change notifier function is
added to the bus notifier chain even though the dma_entry_hash array
was never initialized.  If dma debugging is disabled, this patch both
prevents dma_debug_device_change notifiers from being added to the
chain, and additionally ensures that the dma_entry_hash array is always
initialized to a valid state.

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
---
 lib/dma-debug.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d9b08e0..a504ead 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -697,6 +697,9 @@ void dma_debug_add_bus(struct bus_type *bus)
 {
 	struct notifier_block *nb;
 
+	if (global_disable)
+		return;
+
 	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
 	if (nb == NULL) {
 		pr_err("dma_debug_add_bus: out of memory\n");
@@ -715,14 +718,14 @@ void dma_debug_init(u32 num_entries)
 {
 	int i;
 
-	if (global_disable)
-		return;
-
 	for (i = 0; i < HASH_SIZE; ++i) {
 		INIT_LIST_HEAD(&dma_entry_hash[i].list);
 		spin_lock_init(&dma_entry_hash[i].lock);
 	}
 
+	if (global_disable)
+		return;
+
 	if (dma_debug_fs_init() != 0) {
 		pr_err("DMA-API: error creating debugfs entries - disabling\n");
 		global_disable = true;
-- 
1.6.5.2


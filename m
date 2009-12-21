Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZLUPWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZLUPWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZLUPWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:22:40 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:36965 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZLUPWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:22:39 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KV0DD4-01-LCP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Shaun Ruffell <sruffell@digium.com>, stable@kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] dma-debug: Do not add notifier when dma debugging is disabled.
Date: Mon, 21 Dec 2009 16:22:08 +0100
Message-ID: <1261408929-6261-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1261408929-6261-1-git-send-email-joerg.roedel@amd.com>
References: <1261408929-6261-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 21 Dec 2009 15:22:13.0397 (UTC) FILETIME=[5F291450:01CA8251]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaun Ruffell <sruffell@digium.com>

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

Cc: stable@kernel.org
Signed-off-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d9b08e0..7399744 100644
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
1.6.5.4



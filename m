Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbYGHXdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbYGHXdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYGHXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:34 -0400
Received: from gw.goop.org ([64.81.55.164]:51208 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbYGHXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 55] xen-netfront: fix xennet_release_tx_bufs()
X-Mercurial-Node: 3d5e385eae19acc79ea97335680023dee7e02fb1
Message-Id: <3d5e385eae19acc79ea9.1215554791@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

After restore on ia64 xen domain, kernel panics as follows.
This patch fixes it.

union skb_entry assumes sizeof(link->skb, pointer) ==
sizeof(list->link, unsigned).
However this isn't true on ia64. So  make link type unsigned long.
And introduced two accesor.

kernel unaligned access to 0xe0000000000000bd, ip=0xa0000001004c2ca0
xenwatch[14]: error during unaligned kernel access
 -1 [1]
Modules linked in:

Pid: 14, CPU 0, comm:             xenwatch
psr : 0000101008422010 ifs : 8000000000000307 ip  : [<a0000001004c2ca0>]    Not tainted (2.6.26-rc4xen-ia64-dirty)
ip is at dev_kfree_skb_irq+0x20/0x1a0
unat: 0000000000000000 pfs : 400000000000040b rsc : 0000000000000007
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 000000000000a941
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001003efb70 b6  : a000000100070e40 b7  : a000000100070e40
f6  : 1003e000000fcb75352b1 f7  : 1003e000000000014ff97
f8  : 1003e00fcb74fc3454d80 f9  : 1003e0000000080000000
f10 : 1003e0000000000001431 f11 : 1003e0000000000989680
r1  : a000000100bfcf80 r2  : e0000000000000bd r3  : 000000000000308c
r8  : 0000000000000000 r9  : e00000000fc31310 r10 : a000000100a13b28
r11 : 0000000000000000 r12 : e00000000fd0fdf0 r13 : e00000000fd08000
r14 : 0000000000000000 r15 : e00000000fcc8000 r16 : 0000000000000009
r17 : e000010000104000 r18 : e000010000104000 r19 : a000000100a13b40
r20 : a0000001009c23f0 r21 : a0000001009fd4d0 r22 : 0000000000004000
r23 : 0000000000000000 r24 : fffffffffff04c10 r25 : 0000000000000002
r26 : 0000000000000000 r27 : 0000000000000000 r28 : e00000000fd08bd4
r29 : a0000001007570b8 r30 : a0000001009e5500 r31 : a0000001009e54a0

Call Trace:
 [<a000000100026000>] show_stack+0x40/0xa0
                                sp=e00000000fd0f670 bsp=e00000000fd08f68
 [<a000000100026a60>] show_regs+0x9a0/0x9e0
                                sp=e00000000fd0f840 bsp=e00000000fd08f10
 [<a000000100037680>] die+0x260/0x3a0
                                sp=e00000000fd0f840 bsp=e00000000fd08ec8
 [<a000000100037810>] die_if_kernel+0x50/0x80
                                sp=e00000000fd0f840 bsp=e00000000fd08e98
 [<a00000010003eb40>] ia64_handle_unaligned+0x2ea0/0x2fc0
                                sp=e00000000fd0f840 bsp=e00000000fd08df0
 [<a00000010001ca30>] ia64_prepare_handle_unaligned+0x30/0x60
                                sp=e00000000fd0fa10 bsp=e00000000fd08df0
 [<a00000010005d100>] paravirt_leave_kernel+0x0/0x40
                                sp=e00000000fd0fc20 bsp=e00000000fd08df0
 [<a0000001004c2ca0>] dev_kfree_skb_irq+0x20/0x1a0
                                sp=e00000000fd0fdf0 bsp=e00000000fd08db8
 [<a0000001003efb70>] xennet_release_tx_bufs+0xd0/0x120
                                sp=e00000000fd0fdf0 bsp=e00000000fd08d78
 [<a0000001003f14c0>] backend_changed+0xc40/0xf80
                                sp=e00000000fd0fdf0 bsp=e00000000fd08d08
 [<a00000010034bd50>] otherend_changed+0x190/0x1c0
                                sp=e00000000fd0fe00 bsp=e00000000fd08cc8
 [<a000000100349530>] xenwatch_thread+0x310/0x3c0
                                sp=e00000000fd0fe00 bsp=e00000000fd08ca0
 [<a0000001000cb040>] kthread+0xe0/0x160
                                sp=e00000000fd0fe30 bsp=e00000000fd08c68
 [<a000000100024450>] kernel_thread_helper+0x30/0x60
                                sp=e00000000fd0fe30 bsp=e00000000fd08c40
 [<a00000010001a8a0>] start_kernel_thread+0x20/0x40
                                sp=e00000000fd0fe30 bsp=e00000000fd08c40
Kernel panic - not syncing: Aiee, killing interrupt handler!

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 drivers/net/xen-netfront.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -92,7 +92,7 @@
 	 */
 	union skb_entry {
 		struct sk_buff *skb;
-		unsigned link;
+		unsigned long link;
 	} tx_skbs[NET_TX_RING_SIZE];
 	grant_ref_t gref_tx_head;
 	grant_ref_t grant_tx_ref[NET_TX_RING_SIZE];
@@ -125,6 +125,17 @@
 	struct xen_netif_extra_info extras[XEN_NETIF_EXTRA_TYPE_MAX - 1];
 };
 
+static void skb_entry_set_link(union skb_entry *list, unsigned short id)
+{
+	list->link = id;
+}
+
+static int skb_entry_is_link(const union skb_entry *list)
+{
+	BUILD_BUG_ON(sizeof(list->skb) != sizeof(list->link));
+	return ((unsigned long)list->skb < PAGE_OFFSET);
+}
+
 /*
  * Access macros for acquiring freeing slots in tx_skbs[].
  */
@@ -132,7 +143,7 @@
 static void add_id_to_freelist(unsigned *head, union skb_entry *list,
 			       unsigned short id)
 {
-	list[id].link = *head;
+	skb_entry_set_link(&list[id], *head);
 	*head = id;
 }
 
@@ -993,7 +1004,7 @@
 
 	for (i = 0; i < NET_TX_RING_SIZE; i++) {
 		/* Skip over entries which are actually freelist references */
-		if ((unsigned long)np->tx_skbs[i].skb < PAGE_OFFSET)
+		if (skb_entry_is_link(&np->tx_skbs[i]))
 			continue;
 
 		skb = np->tx_skbs[i].skb;
@@ -1123,7 +1134,7 @@
 	/* Initialise tx_skbs as a free chain containing every entry. */
 	np->tx_skb_freelist = 0;
 	for (i = 0; i < NET_TX_RING_SIZE; i++) {
-		np->tx_skbs[i].link = i+1;
+		skb_entry_set_link(&np->tx_skbs[i], i+1);
 		np->grant_tx_ref[i] = GRANT_INVALID_REF;
 	}
 



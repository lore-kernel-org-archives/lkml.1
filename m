Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbZLRNPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbZLRNPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZLRNPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:15:12 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:43505
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050AbZLRNPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:15:09 -0500
X-SpamScore: -21
X-BigFish: VPS-21(z34a4jzab9bh1432R98dN1447Rzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUUNGY-01-3I8-02
X-M-MSG: 
Date: Fri, 18 Dec 2009 14:14:58 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Shaun Ruffell <sruffell@digium.com>
CC: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma-debug: Do not add notifier when dma debugging is
 disabled.
Message-ID: <20091218131458.GA14679@amd.com>
References: <4B2AC624.3080201@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B2AC624.3080201@digium.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Dec 2009 13:14:58.0716 (UTC) FILETIME=[194BF5C0:01CA7FE4]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 06:00:36PM -0600, Shaun Ruffell wrote:
> If CONFIG_HAVE_DMA_API_DEBUG is defined and "dma_debug=off" is
> specified on the kernel command line, when you detach a driver from a
> device you can cause the following NULL pointer dereference:
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c0580d35>] dma_debug_device_change+0x5d/0x117
> 
> The problem is that the dma_debug_device_change notifier function is
> added to the bus notifier chain even though the dma_entry_hash array
> was never initialized.  If dma debugging is disabled, this patch both
> prevents dma_debug_device_change notifiers from being added to the
> chain, and additionally ensures that the dma_entry_hash array is always
> initialized to a valid state.

Thanks for the fix. I applied a slightly different version to
dma-debug/fixes branch of my tree. See below for the patch I applied.

>From d9c18bf39cd45ff1e68b9b357eca08b4556d66c1 Mon Sep 17 00:00:00 2001
From: Shaun Ruffell <sruffell@digium.com>
Date: Thu, 17 Dec 2009 18:00:36 -0600
Subject: [PATCH 123/123] dma-debug: Do not add notifier when dma debugging is disabled.

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



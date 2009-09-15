Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbZIOKKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbZIOKKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZIOKKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:10:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbZIOKKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:10:03 -0400
Date: Tue, 15 Sep 2009 12:10:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at
 mm/slub.c:1717
In-Reply-To: <20090915085441.GF23126@kernel.dk>
Message-ID: <alpine.LNX.2.00.0909151202560.17028@wotan.suse.de>
References: <20090915085441.GF23126@kernel.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, Jens Axboe wrote:

> This is new with todays -git:
> 
> BUG: sleeping function called from invalid context at mm/slub.c:1717
> in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper
> Pid: 0, comm: swapper Not tainted 2.6.31 #206
> Call Trace:
>  <IRQ>  [<ffffffff8103eb23>] __might_sleep+0xf3/0x110
>  [<ffffffff810e4d83>] kmem_cache_alloc+0x123/0x170
>  [<ffffffff813306c9>] hid_input_report+0x89/0x3a0
>  [<ffffffffa00cd5f4>] hid_ctrl+0xa4/0x1f0 [usbhid]
>  [<ffffffff8108a4c7>] ? handle_IRQ_event+0xa7/0x1e0
>  [<ffffffffa004da1f>] usb_hcd_giveback_urb+0x3f/0xa0 [usbcore]
>  [<ffffffffa0074ab4>] uhci_giveback_urb+0xb4/0x240 [uhci_hcd]
>  [<ffffffffa00750e7>] uhci_scan_schedule+0x357/0xab0 [uhci_hcd]
>  [<ffffffffa0077a01>] uhci_irq+0x91/0x190 [uhci_hcd]
>  [<ffffffffa004d44e>] usb_hcd_irq+0x2e/0x70 [usbcore]
>  [<ffffffff8108a4c7>] handle_IRQ_event+0xa7/0x1e0
>  [<ffffffff8108c58c>] handle_fasteoi_irq+0x7c/0xf0
>  [<ffffffff8100f176>] handle_irq+0x46/0xa0
>  [<ffffffff8100e49a>] do_IRQ+0x6a/0xf0
>  [<ffffffff8100c853>] ret_from_intr+0x0/0xa
> 
> And I notice there's a HID merge from yesterday, Jiri CC'ed.

Thanks for letting me know. The patch below should fix it.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: fix non-atomic allocation in hid_input_report

'interrupt' variable can't be used to safely determine whether
we are running in atomic context or not, as we might be called from
during control transfer completion through hid_ctrl() in atomic
context with interrupt == 0.

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 342b7d3..ca9bb26 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1089,8 +1089,7 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 		return -1;
 	}
 
-	buf = kmalloc(sizeof(char) * HID_DEBUG_BUFSIZE,
-			interrupt ? GFP_ATOMIC : GFP_KERNEL);
+	buf = kmalloc(sizeof(char) * HID_DEBUG_BUFSIZE, GFP_ATOMIC);
 
 	if (!buf) {
 		report = hid_get_report(report_enum, data);
-- 
1.5.6


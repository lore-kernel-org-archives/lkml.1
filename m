Return-Path: <linux-kernel-owner+w=401wt.eu-S967658AbXEHDDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967658AbXEHDDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 23:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967643AbXEHDDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 23:03:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:11978 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967630AbXEHDDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 23:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pBi8L1VCV1OkyaE71gzQmglubZIxH/JydIseyO/RddVTdYqNpm8rM/E8KxdqsAxmMahBY6qXuwUC0rEMM55gmMtfdCQZxpjSwXSWALBMjwOpf5Bu5lrim86OJEFZziZS1hJi0pp+eXVpXQBX6lT29lvH7OdML4STlfNb94uKk+Y=
Message-ID: <a8f16e2b0705072003m6172df63l199090149edd7612@mail.gmail.com>
Date: Tue, 8 May 2007 07:03:08 +0400
From: "Dan Kruchinin" <dubalom@gmail.com>
To: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH -mm] drivers/usb/core/config.c: kzalloc(0,..)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes such SLUB report(when someone tries to
allocate 0 bytes):
--
May  8 00:19:15 midgard kernel: [   21.933467] BUG: at
include/linux/slub_def.h:88 kmalloc_index()
May  8 00:19:15 midgard kernel: [   21.933470]
[show_registers+410/736] show_trace_log_lvl+0x1a/0x30
May  8 00:19:15 midgard kernel: [   21.933478]
[print_trace_warning_symbol+50/64] show_trace+0x12/0x20
May  8 00:19:15 midgard kernel: [   21.933482]  [fixup_irqs+38/192]
dump_stack+0x16/0x20
May  8 00:19:15 midgard kernel: [   21.933485]  [do_lookup+195/400]
get_slab+0x213/0x230
May  8 00:19:15 midgard kernel: [   21.933489]  [do_lookup+309/400]
__kmalloc_track_caller+0x15/0x40
May  8 00:19:15 midgard kernel: [   21.933493]  [__vunmap+25/240]
__kzalloc+0x19/0x50
May  8 00:19:15 midgard kernel: [   21.933498]  [<df05778e>]
usb_parse_configuration+0x85e/0xe70 [usbcore]
May  8 00:19:15 midgard kernel: [   21.933520]  [<df057fcb>]
usb_get_configuration+0x12b/0x450 [usbcore]
May  8 00:19:15 midgard kernel: [   21.933535]  [<df04ed87>]
usb_new_device+0x17/0x1c0 [usbcore]
May  8 00:19:15 midgard kernel: [   21.933550]  [<df05073a>]
hub_thread+0x79a/0xfd0 [usbcore]
May  8 00:19:15 midgard kernel: [   21.933564]
[run_posix_cpu_timers+1218/2064] kthread+0x42/0x70
May  8 00:19:15 midgard kernel: [   21.933569]  [math_error+87/240]
kernel_thread_helper+0x7/0x10
May  8 00:19:15 midgard kernel: [   21.933572]  =======================
--

The problem was in drivers/usb/core/config.c in function usb_parse_interface:
---
num_ep = num_ep_orig = alt->desc.bNumEndpoints;
...
len = sizeof(struct usb_host_endpoint) * num_ep;
alt->endpoint = kzalloc(len, GFP_KERNEL);
---

num_ep can be 0, as it was in my case, so following patch makes this
situation more obvious
and clear.

--------------
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index bfb3731..4db6b21 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -185,7 +185,10 @@ static int usb_parse_interface(struct device
*ddev, int cfgno,
 		num_ep = USB_MAXENDPOINTS;
 	}

-	len = sizeof(struct usb_host_endpoint) * num_ep;
+	len = sizeof(struct usb_host_endpoint);
+	if (num_ep > 0)
+	  len *= num_ep;
+	
 	alt->endpoint = kzalloc(len, GFP_KERNEL);
 	if (!alt->endpoint)
 		return -ENOMEM;
---------------

Dan Kruchinin.

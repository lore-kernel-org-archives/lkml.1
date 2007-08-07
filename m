Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXHGKWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXHGKWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758398AbXHGKWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:22:33 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:42836 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251AbXHGKWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:22:32 -0400
Date: Tue, 7 Aug 2007 19:21:42 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] usb: r8a66597-hcd: Clean up error path.
Message-ID: <20070807102142.GC11186@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when registration fails we're left with a stray reference to
release_mem_region(), this leads to the following case:

    r8a66597_hcd r8a66597_hcd: irq 13, io base 0x18040000
    drivers/usb/host/r8a66597-hcd.c: register access fail.
    r8a66597_hcd r8a66597_hcd: startup error -6
    r8a66597_hcd r8a66597_hcd: USB bus 1 deregistered
    drivers/usb/host/r8a66597-hcd.c: Failed to add hcd
    Trying to free nonexistent resource <0000000018040000-0000000018040000>

This fixes it up.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 drivers/usb/host/r8a66597-hcd.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
index d60f198..40a1de4 100644
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -2208,8 +2208,6 @@ static int __init r8a66597_probe(struct platform_device *pdev)
 clean_up:
 	if (reg)
 		iounmap(reg);
-	if (res)
-		release_mem_region(res->start, 1);
 
 	return ret;
 }

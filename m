Return-Path: <linux-kernel-owner+w=401wt.eu-S965345AbXDVIIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965345AbXDVIIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965521AbXDVIIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:08:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:45677 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965345AbXDVIIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:08:13 -0400
X-Authenticated: #24128601
X-Provags-ID: V01U2FsdGVkX1/LikJGBqXLFsaDx9mImOL89jKyaFXYtbclY6DRy+
	iJbVJbUBZigq0U
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: No proper shutdown after kernel 2.6.13-rc2
Date: Sun, 22 Apr 2007 10:08:16 +0200
User-Agent: KMail/1.9.5
Cc: dbrownell@users.sourceforge.net
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704221008.16946.sebastian_ml@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

this is an old issue, I reported it to 
http://bugzilla.kernel.org/show_bug.cgi?id=5410 in 2005, but it still 
bothers me. My mouse light (simple Logitech USB mouse) still stays on 
after shutdown with 2.6.21-rc7.

But, headway has been made (a little). It turned out that I don't have a 
jumper on my motherboard that would explain this behaviour (e.g. 
PS2_USB_PWR). Then there's MS Windows which manages to shut off the 
mouse light when it shuts down.

Last but not least I finally managed to find the commit which triggered 
the issue back in 2.6.13-rc2: 

commit edfd6aee1f073ae645bd3e60ef96090fc9f0957b
Author: david-b@pacbell.net <david-b@pacbell.net>
Date:   Wed Jun 29 07:03:10 2005 -0700

    [PATCH] USB: fix ohci merge glitch

    A patch re-organizing some parts of root hub initialization deleted 
the
    code initializing the bus-neutral reboot/shutdown notifier for OHCI.
    This patch just restores that deleted code.

    Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 0375097..68decab 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -673,8 +673,10 @@ retry:

        ohci_dump (ohci, 1);

-       if (ohci_to_hcd(ohci)->self.root_hub == NULL)
+       if (ohci_to_hcd(ohci)->self.root_hub == NULL) {
+               register_reboot_notifier (&ohci->reboot_notifier);
                create_debug_files (ohci);
+       }

        return 0;
 }

I'd really appreciate if someone could attend to this.

Thanks!

Regards
Sebastian

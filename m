Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121Ab0CMAVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:21:46 -0500
Received: from kroah.org ([198.145.64.141]:32796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935013Ab0CMAUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:52 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:13 2010
Message-Id: <20100313001513.270990543@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Edward Shao <laface.tw@gmail.com>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [patch 093/123] USB: xhci: Fix finding extended capabilities registers
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Edward Shao <laface.tw@gmail.com>

commit 05197921ff3dad52d99fd1647974c57d9c28d40e upstream.

According "5.3.6 Capability Parameters (HCCPARAMS)" of xHCI rev0.96 spec,
value of xECP register indicates a relative offset, in 32-bit words,
from Base to the beginning of the first extended capability.
The wrong calculation will cause BIOS handoff fail (not handoff from BIOS)
in some platform with BIOS USB legacy sup support.

Signed-off-by: Edward Shao <laface.tw@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci-ext-caps.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ext-caps.h
+++ b/drivers/usb/host/xhci-ext-caps.h
@@ -101,12 +101,15 @@ static inline int xhci_find_next_cap_off
 
 	next = readl(base + ext_offset);
 
-	if (ext_offset == XHCI_HCC_PARAMS_OFFSET)
+	if (ext_offset == XHCI_HCC_PARAMS_OFFSET) {
 		/* Find the first extended capability */
 		next = XHCI_HCC_EXT_CAPS(next);
-	else
+		ext_offset = 0;
+	} else {
 		/* Find the next extended capability */
 		next = XHCI_EXT_CAPS_NEXT(next);
+	}
+
 	if (!next)
 		return 0;
 	/*



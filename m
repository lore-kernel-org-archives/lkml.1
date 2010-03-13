Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936324Ab0CMBPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:15:32 -0500
Received: from kroah.org ([198.145.64.141]:32796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935019Ab0CMAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:55 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:13 2010
Message-Id: <20100313001513.444798609@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: [patch 095/123] USB: fix crash in uhci_scan_schedule
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Pete Zaitcev <zaitcev@redhat.com>

commit d23356da714595b888686d22cd19061323c09190 upstream.

When hardware is removed on a Stratus, the system may crash like this:

ACPI: PCI interrupt for device 0000:7c:00.1 disabled
Trying to free nonexistent resource <00000000a8000000-00000000afffffff>
Trying to free nonexistent resource <00000000a4800000-00000000a480ffff>
uhci_hcd 0000:7e:1d.0: remove, state 1
usb usb2: USB disconnect, address 1
usb 2-1: USB disconnect, address 2
Unable to handle kernel paging request at 0000000000100100 RIP:
 [<ffffffff88021950>] :uhci_hcd:uhci_scan_schedule+0xa2/0x89c

 #4 [ffff81011de17e50] uhci_scan_schedule at ffffffff88021918
 #5 [ffff81011de17ed0] uhci_irq at ffffffff88023cb8
 #6 [ffff81011de17f10] usb_hcd_irq at ffffffff801f1c1f
 #7 [ffff81011de17f20] handle_IRQ_event at ffffffff8001123b
 #8 [ffff81011de17f50] __do_IRQ at ffffffff800ba749

This occurs because an interrupt scans uhci->skelqh, which is
being freed. We do the right thing: disable the interrupts in the
device, and do not do any processing if the interrupt is shared
with other source, but it's possible that another CPU gets
delayed somewhere (e.g. loops) until we started freeing.

The agreed-upon solution is to wait for interrupts to play out
before proceeding. No other bareers are neceesary.

A backport of this patch was tested on a 2.6.18 based kernel.
Testing of 2.6.32-based kernels is under way, but it takes us
forever (months) to turn this around. So I think it's a good
patch and we should keep it.

Tracked in RH bz#516851

Signed-Off-By: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/uhci-hcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -735,6 +735,7 @@ static void uhci_stop(struct usb_hcd *hc
 		uhci_hc_died(uhci);
 	uhci_scan_schedule(uhci);
 	spin_unlock_irq(&uhci->lock);
+	synchronize_irq(hcd->irq);
 
 	del_timer_sync(&uhci->fsbr_timer);
 	release_uhci(uhci);



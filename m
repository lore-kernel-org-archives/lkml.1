Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbXHUHS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbXHUHS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbXHUHSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:18:48 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:1071 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXHUHSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:18:47 -0400
X-Greylist: delayed 1160 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2007 03:18:47 EDT
Message-ID: <46CA8D4D.70201@miraclelinux.com>
Date: Tue, 21 Aug 2007 15:59:25 +0900
From: Kiyoshi Sasaki <ksasaki@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: on the system with companion host controller, error -71 returns
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.20.233228
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I see below errors in dmesg on ICH6/ICH7 machine:

usb 1-1: device not accepting address 2, error -71
or
usb 1-1: device descriptor read/all, error -71

I'm trying to debug it, but by now I can't make it.
Can you give me your help ?

----

On ICH6/ICH7, in case load sequence is uhci first and ehci second,
each controller is initialized/registered in usb_add_hcd() like below.

uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.3: UHCI Host Controller
ehci_hcd 0000:00:1d.7: EHCI Host Controller

And on ehci_hcd turn, usb_add_hcd() calls ehci_run() to start ehci.
In ehci_run(), it sets Configure Flag (CF) to 1 for enabling full
USB 2.0 functionality.

static int ehci_run (struct usb_hcd *hcd)
{
...
        /*
         * Start, enabling full USB 2.0 functionality ... usb 1.1 devices
         * are explicitly handed to companion controller(s), so no TT is
         * involved with the root hub.  (Except where one is integrated,
         * and there's no companion controller unless maybe for USB OTG.)
         */
        hcd->state = HC_STATE_RUNNING;
        writel (FLAG_CF, &ehci->regs->configured_flag);
...
}

On the other hand, uhci tries to get device information using
hub_set_address() and usb_get_device_descriptor().
These functions send URB, and URB is processed like below.
This is done asynchronously.

- uhci_irq()
  - uhci_scan_schedule()
    - uhci_scan_qh()
      - uhci_result_common()
        - uhci_map_status()

uhci_map_status() checks td_status. And the flag is TD_CTRL_STALLED
|TD_CTRL_CRCTIMEO, and return with error.
So, hub_set_address() and usb_get_device_descriptor() return -71.

After some debugging, I found if hub_set_address() and
usb_get_device_descriptor() is called before CF becomes 1,
no error returns. Conversely, if these are called even just after
CF becomes 1, error -71 returns.
CF becomes 1 means "writel (FLAG_CF, &ehci->regs->configured_flag)".

To avoid this error, my silly idea is

1) before set CF to 1, wait some asynchronous uhci processing
2) load ehci first and uhci second

But for 1), simple msleep() will not work well, and need to
control khubd and so on, so this seems not smart.


Do you have any idea to fix this issue ?

-- 

Kiyoshi Sasaki <ksasaki@miraclelinux.com>

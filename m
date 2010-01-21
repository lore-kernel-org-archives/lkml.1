Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304Ab0AUL0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0AUL0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 06:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198Ab0AUL0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 06:26:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57845 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab0AUL0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 06:26:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=enVSDRoqZUrIeWQAF9dJ3HianS+d6xWpmAWletzO/anzGWgQBMQYgfwwP/EM/3aylM
         Uwvj+RFzIgjP8L1pcnV0Y4egH4Eqm57H8iK4Zu8EFvOVLQzI5eNmrU13lqhwmevTX8jj
         6tEAmc3yHs2IZwjoshRm3oBg6IvEn6o72fZNU=
MIME-Version: 1.0
Date: Thu, 21 Jan 2010 14:26:49 +0300
Message-ID: <48239d391001210326y25986d59hd10d390ef9c8ddea@mail.gmail.com>
Subject: MUSB crash on OMAP3 board with second load of gadget
From: Sergey Lapin <slapinid@gmail.com>
To: linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! I have crashes in MUSB code when working with USB gadget drivers.
Kernel version: linux-omap master d8ebff302ff819587377b123e900e501e4135d86
To reproduce: (USB device cable should be attached).

dd if=/dev/zero of=/tmp/disk bs=1k count=1024
mkdosfs -F 32 /tmp/disk
insmod g_mass_storage  file=/tmp/disk stall=0

Wait till disk is mounted on host, then

rmmod g_mass_storage
insmod g_mass_storage  file=/tmp/disk stall=0

And here we get Oops in include/linux/list.h line 93,
list_del function, which leads us to drivers/usb/musb/musb_gadget.c,
function void musb_g_giveback(
        struct musb_ep          *ep,
        struct usb_request      *request,
        int                     status),
just at the beginning of function.

if we add
pr_debug("list.prev = %p\n", request->list.prev);
pr_debug("list.next = %p\n", request->list.next);

and we see

list.prev = 6b6b6b6b
list.next = 6b6b6b6b

And these are NOT values set during list deletion.

Any ideas where to debug from here? If I just do return from that
function in case
of list.prev = 6b6b6b6b, then there's no crash, but there's no working
USB either.
if I just ignore list_del, I have crash later, where it seems to
execute bad code
from address 0x6b6b6b6a. Please, help!

Thanks a lot,
S.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZGUDdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZGUDdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZGUDds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:33:48 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:49720 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbZGUDdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:33:47 -0400
X-Trace: 229386292/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.77.242/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.77.242
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIEAAbUZEpPRU3y/2dsb2JhbACBUM8KhAwFiU4
X-IronPort-AV: E=Sophos;i="4.43,238,1246834800"; 
   d="scan'208";a="229386292"
Date: Tue, 21 Jul 2009 04:33:38 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>,
       Bob Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: mmotm 2009-07-16-14-32 - sudden OOPS at boot in ACPI code
In-Reply-To: <9078.1248144738@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0907210418420.15680@sister.anvils>
References: <200907162134.n6GLY2kt019816@imap1.linux-foundation.org>
 <9078.1248144738@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 16 Jul 2009 14:34:02 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-07-16-14-32 has been uploaded to
> 
> Dies a horrid death during early boot. Dell Latitude D820, and this graphics:
> 
> 01:00.0 VGA compatible controller: nVidia Corporation G72M [Quadro NVS 110M/GeForce Go 7300] (rev a1)

Oh yes, I was getting just the same with Intel graphics (i915);
but promptly forgot about it once I'd a workaround in place,
and moved on to other things, sorry.

> 
> Traceback (hand-copied from a very crappy cell-phone picture)
> 
> strcmp+0x4/0x1f
> acpi_device+probe+0xac/0x13e
> driver_probe_device+0xc9/0x14e
> __driver_attach+0x58/0x7c
> ? __driver_attach+0x58/0x7c
> ? __driver_attach+0x58/0x7c
> bus_for_each_dev+0x54/0x89
> driver_attach+0x19/0x1b
> bus_add_driver+0xv4/0x1fe
> driver_register+0xb7/0x128
> ? acpi_video_init+0x0/0x17
> acpi_bus_register_driver+0x3e/0x42
> acpi_video_register+0x42/0x6e
> acpi_video_init+0x15/0x17
> do_one_initcall+0x56/0x130
> 
> Analysis shows it's the following code from (inlined) acpi_device_install_notify_handler
> 
> static int acpi_device_install_notify_handler(struct acpi_device *device)
> {
>         acpi_status status;
>         char *hid;
> 
>         hid = acpi_device_hid(device);
>         if (!strcmp(hid, ACPI_BUTTON_HID_POWERF))
> 
> but we never check if hid is non-trash before feeding it to strcmp.  Looks
> like something in this linux-next commit is involved:
> 
> commit ed444824932d2a563858d82ec1ea29b0aa775e91
> Author: Bob Moore <robert.moore@intel.com>
> Date:   Mon Jun 29 13:39:29 2009 +0800
> 
> I suspect something in acpi_get_object_info() is going astray, causing
> acpi_device_set_id() to set the ->pnp.hardware_id to NULL in this code:
> 
>         if (hid) {
>                 device->pnp.hardware_id = ACPI_ALLOCATE_ZEROED(strlen (hid) + 1);
>                 if (device->pnp.hardware_id) {
>                         strcpy(device->pnp.hardware_id, hid);
>                         device->flags.hardware_id = 1;
>                 }
>         } else
>                 device->pnp.hardware_id = NULL;
> 
> The else clause is new in this commit.

I think pnp.hardware_id has changed from being a builtin array to
an allocated pointer: so before there was always a zeroed array to
strcmp against, whereas now there's a NULL pointer if you come to
use acpi_device_install_notify_handler() "too early".

Patch that works for me at the bottom.

> 
> Looking at the old code, it *may* be that the ACPI code on my laptop is just
> busticated and/or there's no _HID method for the graphics card, and the old
> code Just Happened To Work in previous kernels because ->pnp.hardware_id
> wouldn't actually get set *at all* in acpi_device_set_id, so we'd get random
> stale data that was bogus, but didn't give strcmp() indigestion...
> 
> Any wisdom on debugging this further (including how to tell if the ACPI
> tables have a sane _HID method for the graphics card) would be appreciated...
> 
> Or is the correct fix in fact to just add a 'if (!hid) return -EINVAL;' to
> acpi_device_install_notify_handler()?

[PATCH mmotm] acpi: work around NULL hardware_id

Work around NULL pnp.hardware_id in acpi_device_install_notify_handler()
when probing video device.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
Signoff provided to handle the unlikely event that this hack
is actually the right fix!

 drivers/acpi/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm/drivers/acpi/scan.c	2009-07-17 12:53:20.000000000 +0100
+++ linux/drivers/acpi/scan.c	2009-07-17 21:19:10.000000000 +0100
@@ -376,12 +376,12 @@ static int acpi_device_install_notify_ha
 	char *hid;
 
 	hid = acpi_device_hid(device);
-	if (!strcmp(hid, ACPI_BUTTON_HID_POWERF))
+	if (hid && !strcmp(hid, ACPI_BUTTON_HID_POWERF))
 		status =
 		    acpi_install_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
 						     acpi_device_notify_fixed,
 						     device);
-	else if (!strcmp(hid, ACPI_BUTTON_HID_SLEEPF))
+	else if (hid && !strcmp(hid, ACPI_BUTTON_HID_SLEEPF))
 		status =
 		    acpi_install_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
 						     acpi_device_notify_fixed,

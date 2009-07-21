Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZGUCxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZGUCxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZGUCxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:53:49 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50856 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZGUCxs (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:53:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Bob Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: mmotm 2009-07-16-14-32 - sudden OOPS at boot in ACPI code
In-Reply-To: Your message of "Thu, 16 Jul 2009 14:34:02 PDT."
             <200907162134.n6GLY2kt019816@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200907162134.n6GLY2kt019816@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248144738_4185P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Jul 2009 22:52:18 -0400
Message-ID: <9078.1248144738@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248144738_4185P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Jul 2009 14:34:02 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-07-16-14-32 has been uploaded to

Dies a horrid death during early boot. Dell Latitude D820, and this graphics:

01:00.0 VGA compatible controller: nVidia Corporation G72M [Quadro NVS 110M/GeForce Go 7300] (rev a1)

Traceback (hand-copied from a very crappy cell-phone picture)

strcmp+0x4/0x1f
acpi_device+probe+0xac/0x13e
driver_probe_device+0xc9/0x14e
__driver_attach+0x58/0x7c
? __driver_attach+0x58/0x7c
? __driver_attach+0x58/0x7c
bus_for_each_dev+0x54/0x89
driver_attach+0x19/0x1b
bus_add_driver+0xv4/0x1fe
driver_register+0xb7/0x128
? acpi_video_init+0x0/0x17
acpi_bus_register_driver+0x3e/0x42
acpi_video_register+0x42/0x6e
acpi_video_init+0x15/0x17
do_one_initcall+0x56/0x130

Analysis shows it's the following code from (inlined) acpi_device_install_notify_handler

static int acpi_device_install_notify_handler(struct acpi_device *device)
{
        acpi_status status;
        char *hid;

        hid = acpi_device_hid(device);
        if (!strcmp(hid, ACPI_BUTTON_HID_POWERF))

but we never check if hid is non-trash before feeding it to strcmp.  Looks
like something in this linux-next commit is involved:

commit ed444824932d2a563858d82ec1ea29b0aa775e91
Author: Bob Moore <robert.moore@intel.com>
Date:   Mon Jun 29 13:39:29 2009 +0800

I suspect something in acpi_get_object_info() is going astray, causing
acpi_device_set_id() to set the ->pnp.hardware_id to NULL in this code:

        if (hid) {
                device->pnp.hardware_id = ACPI_ALLOCATE_ZEROED(strlen (hid) + 1);
                if (device->pnp.hardware_id) {
                        strcpy(device->pnp.hardware_id, hid);
                        device->flags.hardware_id = 1;
                }
        } else
                device->pnp.hardware_id = NULL;

The else clause is new in this commit.

Looking at the old code, it *may* be that the ACPI code on my laptop is just
busticated and/or there's no _HID method for the graphics card, and the old
code Just Happened To Work in previous kernels because ->pnp.hardware_id
wouldn't actually get set *at all* in acpi_device_set_id, so we'd get random
stale data that was bogus, but didn't give strcmp() indigestion...

Any wisdom on debugging this further (including how to tell if the ACPI
tables have a sane _HID method for the graphics card) would be appreciated...

Or is the correct fix in fact to just add a 'if (!hid) return -EINVAL;' to
acpi_device_install_notify_handler()?



--==_Exmh_1248144738_4185P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKZS1icC3lWbTT17ARAmYFAJ9T+MK3vLcB0K84L338yq5VHbGMqQCg3g/C
PzqP9kdWnkhEBm5ZruLbBbY=
=L948
-----END PGP SIGNATURE-----

--==_Exmh_1248144738_4185P--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbYC1M4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbYC1M4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 08:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbYC1MyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:54:03 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:34537 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000AbYC1MyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:54:00 -0400
Date: Fri, 28 Mar 2008 07:27:59 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 34/35] W1: Documentation/w1/masters/ds2490 update
Message-ID: <20080328122758.GI3613@spacedout.fries.net>
References: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="McTFpSeH7KqpdXA3"
Content-Disposition: inline
In-Reply-To: <200803272343.m2RNhDac017650@SpacedOut.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Fri, 28 Mar 2008 07:27:59 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--McTFpSeH7KqpdXA3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Provide some additional details about the status of the driver.

Signed-off-by: David Fries <david@fries.net>
---
 Documentation/w1/masters/ds2490 |   60 +++++++++++++++++++++++++++++++++++=
++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/Documentation/w1/masters/ds2490 b/Documentation/w1/masters/ds2=
490
index 239f9ae..4b7b8ee 100644
--- a/Documentation/w1/masters/ds2490
+++ b/Documentation/w1/masters/ds2490
@@ -16,3 +16,63 @@ which allows to build USB <-> W1 bridges.
 DS9490(R) is a USB <-> W1 bus master device
 which has 0x81 family ID integrated chip and DS2490
 low-level operational chip.
+
+Notes and limitations.
+- The 5V strong pullup is supported.
+- While the ds2490 supports a hardware search the code doesn't take
+  advantage of it.
+- The hardware will detect when devices are attached to the bus on the
+  next bus (reset?) operation, however only a message is printed as
+  the core w1 code doesn't make use of the information.  Connecting
+  one device tends to give multiple new device notifications.
+- The number of USB bus transactions could be reduced if w1_reset_send
+  was added to the API.  The name is just a suggestion.  It would take
+  a write buffer and a read buffer (along with sizes) as arguments.
+  It would add match rom and rom to the send buffer, reset the bus,
+  and read the result.  The ds2490 block I/O command supports reset,
+  write, read, and strong pullup all in one command.  That would
+  reduce the time and overhead for a set of commands.
+
+  The core w1 functions required to do a temperature conversion are,
+  w1_reset_select_slave, w1_next_pullup, and w1_write_8, which turn
+  around and execute the master functions, reset_bus, write_block,
+  set_pullup, write_byte, set_pullup.  Each ds2490 function will have
+  multiple USB bus transactions, except set_pullup where it only
+  requires transactions if the if the time value is different.  The
+  conversion could be reduced to w1_next_pullup, w1_reset_send which
+  would call set_pullup, reset_send. The reset_send would enable reset
+  and strong pullup (if enabled), write the data buffer, execute the
+  block I/O command, read status, and get data.  Currently I count 11
+  transactions required, this would reduce it to 4.
+- The hardware supports normal, flexable, and overdrive bus
+  communication speeds, but only the normal is supported.
+- The registered w1_bus_master functions don't define error
+  conditions.  If a bus search is in progress and the ds2490 is
+  removed it can produce a good amount of error output before the bus
+  search finishes.
+- The hardware supports detecting some error conditions, such as
+  short, alarming presence on reset, and no presence on reset, but the
+  driver doesn't query those values.
+- The ds2490 specification doesn't cover short bulk in reads in
+  detail, but my observation is if fewer bytes are requested than are
+  available, the bulk read will return an error and the hardware will
+  clear the entire bulk in buffer.  It would be possible to read the
+  maximum buffer size to not run into this error condition, only extra
+  bytes in the buffer is a logic error in the driver.  The code should
+  should match reads and writes as well as data sizes.  Reads and
+  writes are serialized and the status verifies that the chip is idle
+  (and data is available) before the read is executed, so it should
+  not happen.
+- Running x86_64 2.6.24 UHCI under qemu 0.9.0 under x86_64 2.6.22-rc6
+  with a OHCI controller, ds2490 running in the guest would operate
+  normally the first time the module was loaded after qemu attached
+  the ds2490 hardware, but if the module was unloaded, then reloaded
+  most of the time one of the bulk out or in, and usually the bulk in
+  would fail.  qemu sets a 50ms timeout and the bulk in would timeout
+  even when the status shows data available.  A bulk out write would
+  show a successful completion, but the ds2490 status register would
+  show 0 bytes written.  Detaching qemu from the ds2490 hardware and
+  reattaching would clear the problem.  usbmon output in the guest and
+  host did not explain the problem.  My guess is a bug in either qemu
+  or the host OS and more likely the host OS.
+-- 03-06-2008 David Fries <David@Fries.net>
--=20
1.4.4.4

--McTFpSeH7KqpdXA3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFH7OROAI852cse6PARAn7NAJ405oUcBnWM/RocoDxnfBjsjmBK2ACgmESd
NhU+5TibU/Irp3lGEkTUMJE=
=oaV3
-----END PGP SIGNATURE-----

--McTFpSeH7KqpdXA3--

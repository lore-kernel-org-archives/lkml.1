Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529Ab0ARRZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0ARRZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607Ab0ARRZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:25:01 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:53249 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0ARRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:24:58 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Mon, 18 Jan 2010 18:25:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org> <201001171014.44403.oliver@neukum.org> <20100118015844.GA4300@srcf.ucam.org>
In-Reply-To: <20100118015844.GA4300@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TmJVLY+n/lDu5le"
Message-Id: <201001181825.39823.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_TmJVLY+n/lDu5le
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Am Montag, 18. Januar 2010 02:58:44 schrieb Matthew Garrett:
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0
> drivers/usb/serial/usb-serial.c: serial_write - port 0, 1536 byte(s)
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0
> drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
> drivers/usb/serial/usb-serial.c: serial_write - port 0, 1536 byte(s)
> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0

Hi,

it is not conclusive. Can you apply the attached patch and try again?

	Regards
		Oliver

--Boundary-00=_TmJVLY+n/lDu5le
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-additional-debugging.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-additional-debugging.patch"

=46rom 27e54a5d36aba23276d30bd61b962916dca7a946 Mon Sep 17 00:00:00 2001
=46rom: Oliver Neukum <oliver@neukum.org>
Date: Mon, 18 Jan 2010 18:23:09 +0100
Subject: [PATCH] additional debugging

=2D--
 drivers/usb/serial/generic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index f1ea3a3..76e5514 100644
=2D-- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -283,6 +283,8 @@ static int usb_serial_generic_write_start(struct usb_se=
rial_port *port)
=20
 	if (!start_io)
 		return 0;
+=09
+	dbg("%s - starting IO", __func__);
=20
 	data =3D port->write_urb->transfer_buffer;
 	count =3D kfifo_out_locked(&port->write_fifo, data, port->bulk_out_size, =
&port->lock);
@@ -330,7 +332,7 @@ int usb_serial_generic_write(struct tty_struct *tty,
 	struct usb_serial *serial =3D port->serial;
 	int result;
=20
=2D	dbg("%s - port %d", __func__, port->number);
+	dbg("%s - port %d, %d bytes", __func__, port->number, count);
=20
 	if (count =3D=3D 0) {
 		dbg("%s - write request of 0 bytes", __func__);
@@ -346,6 +348,7 @@ int usb_serial_generic_write(struct tty_struct *tty,
 						  buf, count);
=20
 	count =3D kfifo_in_locked(&port->write_fifo, buf, count, &port->lock);
+	dbg("%s - put %d bytes into fifo", __func__, count);
 	result =3D usb_serial_generic_write_start(port);
=20
 	if (result >=3D 0)
=2D-=20
1.6.4.2


--Boundary-00=_TmJVLY+n/lDu5le--

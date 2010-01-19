Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078Ab0ASNTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0ASNTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 08:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163Ab0ASNTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 08:19:50 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:33541 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0ASNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 08:19:49 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Tue, 19 Jan 2010 14:20:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100117025535.GB7045@srcf.ucam.org> <201001181825.39823.oliver@neukum.org> <20100118201416.GA26511@srcf.ucam.org>
In-Reply-To: <20100118201416.GA26511@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dGbVLPFLLlx2qRL"
Message-Id: <201001191420.29652.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_dGbVLPFLLlx2qRL
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Am Montag, 18. Januar 2010 21:14:16 schrieb Matthew Garrett:

> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1565 
> bytes
> drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes 
> into fifo
> drivers/usb/serial/generic.c: usb_serial_generic_read_bulk_callback - 
> port 0

If the FIFO is full we can do nothing. Please try the attached patch.

	Regards
		Oliver

--Boundary-00=_dGbVLPFLLlx2qRL
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-usb-serial-Deal-with-filled-FIFO.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-usb-serial-Deal-with-filled-FIFO.patch"

=46rom d7317bae0772b794a1cc9b832bc3d3e1b3642a13 Mon Sep 17 00:00:00 2001
=46rom: Oliver Neukum <oliver@neukum.org>
Date: Tue, 19 Jan 2010 14:16:41 +0100
Subject: [PATCH] usb:serial:Deal with filled FIFO

Bail out if the FIFO is filled

Signed-off-by: Oliver Neukum <oliver@neukum.org>
=2D--
 drivers/usb/serial/generic.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 76e5514..053f7f1 100644
=2D-- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -349,6 +349,10 @@ int usb_serial_generic_write(struct tty_struct *tty,
=20
 	count =3D kfifo_in_locked(&port->write_fifo, buf, count, &port->lock);
 	dbg("%s - put %d bytes into fifo", __func__, count);
+	if (!count) {
+		dbg("%s - FIFO is full", __func__);
+		return 0;
+	}
 	result =3D usb_serial_generic_write_start(port);
=20
 	if (result >=3D 0)
=2D-=20
1.6.4.2


--Boundary-00=_dGbVLPFLLlx2qRL--

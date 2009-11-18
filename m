Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZKRDLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZKRDLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:11:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZKRDLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:11:00 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42440 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZKRDK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:10:59 -0500
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Johan Hovold <jhovold@gmail.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <20090924154023.GA27480@localhost>
	<20091003140902.38628d8a@lxorguk.ukuu.org.uk>
	<m13a4df19g.fsf@fess.ebiederm.org>
	<200911171941.34781.oliver@neukum.org>
	<m1lji4od0k.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 17 Nov 2009 19:10:48 -0800
In-Reply-To: <m1lji4od0k.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 17 Nov 2009 17\:08\:43 -0800")
Message-ID: <m1fx8co7d3.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH] ftdi_sio:  Keep going when write errors are encountered.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The use of urb->actual_length to update tx_outstanding_bytes
implicitly assumes that the number of bytes actually written is the
same as the number of bytes we tried to write.  On error that
assumption is violated so just use transfer_buffer_length the number
of bytes we intended to write to the device.

If an error occurs we need to fall through and call
usb_serial_port_softint to wake up processes waiting in
tty_wait_until_sent.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/usb/serial/ftdi_sio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9c60d6d..ebcc6d0 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1937,7 +1937,7 @@ static void ftdi_write_bulk_callback(struct urb *urb)
 		return;
 	}
 	/* account for transferred data */
-	countback = urb->actual_length;
+	countback = urb->transfer_buffer_length;
 	data_offset = priv->write_offset;
 	if (data_offset > 0) {
 		/* Subtract the control bytes */
@@ -1950,7 +1950,6 @@ static void ftdi_write_bulk_callback(struct urb *urb)
 
 	if (status) {
 		dbg("nonzero write bulk status received: %d", status);
-		return;
 	}
 
 	usb_serial_port_softint(port);
-- 
1.6.2.5


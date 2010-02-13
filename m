Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab0BMHLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 02:11:43 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:58474 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0BMHLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 02:11:41 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Sat, 13 Feb 2010 08:11:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Anssi Hannula <anssi.hannula@iki.fi>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002122148050.13658-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002122148050.13658-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002130811.36525.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 13. Februar 2010 03:50:04 schrieb Alan Stern:
> On Sat, 13 Feb 2010, Anssi Hannula wrote:
> 
> > On 05.02.2010 23:59, Oliver Neukum wrote:
> > > Am Freitag, 5. Februar 2010 20:58:17 schrieb Matthew Garrett:
> > >> drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
> > >> drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
> > >> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 2048 bytes
> > >> drivers/usb/serial/generic.c: usb_serial_generic_write - put 512 bytes into fifo
> > >> drivers/usb/serial/usb-serial.c: serial_write - port 0, 1536 byte(s)
> > >> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1536 bytes
> > >> drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes into fifo
> > >> drivers/usb/serial/generic.c: usb_serial_generic_write - FIFO is full
> > > 
> > > OK, could you also get an usbmon trace? This would allow a determination
> > > whether the submitted URB doesn't finish for some reason, or whether
> > > no URB is submitted, possibly because a wakeup is missed.
> > 
> > I'm also affected by this regression. Here's an usbmon trace of
> > gobi_loader hanging:
> > http://stuff.onse.fi/gobi2000/gobi-regression.mon.log
> 
> That's odd.  The log shows the final bulk-OUT transfer was cancelled 
> after less than 1 ms.  Is there a timeout value somewhere that is too 
> small by a factor of 1000?

Neither qcserial nor usb-serial implement timeouts.
Is it possible that this is caused by user space closing the handle
causing usb-serial::port_release() to call kill_traffic()?

Anssi, going by your log the last write is quite short and begins
with 342d3030 39202020 20202020 20202020 801d9b80 02000000 3512dcfe 44313032.
Does this match with the last part of the firmware you are transfering?
Could you put an "mdelay(500);" at the beginning of usb-serial::port_release()
and retest?

	Regards
		Oliver



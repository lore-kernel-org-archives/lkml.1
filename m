Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0BMNfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:35:48 -0500
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:41954 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752487Ab0BMNfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:35:46 -0500
X-Spam-Flag: NO
X-Spam-Score: 0
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Sat, 13 Feb 2010 15:35:41 +0200
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-0.rc7.1.1mnb; KDE/4.3.98; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002122148050.13658-100000@netrider.rowland.org> <201002130811.36525.oliver@neukum.org>
In-Reply-To: <201002130811.36525.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002131535.42116.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lauantai 13 helmikuu 2010 09:11:36 Oliver Neukum wrote:
> Am Samstag, 13. Februar 2010 03:50:04 schrieb Alan Stern:
> > On Sat, 13 Feb 2010, Anssi Hannula wrote:
> > > On 05.02.2010 23:59, Oliver Neukum wrote:
> > > > Am Freitag, 5. Februar 2010 20:58:17 schrieb Matthew Garrett:
> > > >> drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
> > > >> drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
> > > >> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0,
> > > >> 2048 bytes drivers/usb/serial/generic.c: usb_serial_generic_write -
> > > >> put 512 bytes into fifo drivers/usb/serial/usb-serial.c:
> > > >> serial_write - port 0, 1536 byte(s) drivers/usb/serial/generic.c:
> > > >> usb_serial_generic_write - port 0, 1536 bytes
> > > >> drivers/usb/serial/generic.c: usb_serial_generic_write - put 0
> > > >> bytes into fifo drivers/usb/serial/generic.c:
> > > >> usb_serial_generic_write - FIFO is full
> > > > 
> > > > OK, could you also get an usbmon trace? This would allow a
> > > > determination whether the submitted URB doesn't finish for some
> > > > reason, or whether no URB is submitted, possibly because a wakeup is
> > > > missed.
> > > 
> > > I'm also affected by this regression. Here's an usbmon trace of
> > > gobi_loader hanging:
> > > http://stuff.onse.fi/gobi2000/gobi-regression.mon.log
> > 
> > That's odd.  The log shows the final bulk-OUT transfer was cancelled
> > after less than 1 ms.  Is there a timeout value somewhere that is too
> > small by a factor of 1000?
> 
> Neither qcserial nor usb-serial implement timeouts.
> Is it possible that this is caused by user space closing the handle
> causing usb-serial::port_release() to call kill_traffic()?
> 
> Anssi, going by your log the last write is quite short and begins
> with 342d3030 39202020 20202020 20202020 801d9b80 02000000 3512dcfe
> 44313032. Does this match with the last part of the firmware you are
> transfering?

Yes. (there are three files, this is the last part of the third file)

> Could you put an "mdelay(500);" at the beginning of
> usb-serial::port_release() and retest?

It seems I can't get that far anymore, it hangs much more early now:
http://stuff.onse.fi/gobi2000/gobi-regression2.mon.log
After interrupting gobi_loader I get a WARNING:
http://stuff.onse.fi/gobi2000/gobi-regression2.warning.log
Trying gobi_loader again immediately, the log is almost empty:
http://stuff.onse.fi/gobi2000/gobi-regression3.mon.log
After reboot I get a similar log as regression2:
http://stuff.onse.fi/gobi2000/gobi-regression4.mon.log

Actually, just now I noticed that the first time I had some extra sleep calls 
before starting the firmware upload in gobi_loader, which caused it to 
successfully finish (i.e. not hang; I guess somehow I didn't notice it when I 
logged the first usbmon.log), but the firmware wasn't still uploaded properly 
(that'd be because of the cancelled transfer I guess).

I'll get back to this later today, including testing with mdelay in 
port_release with the extra sleep calls in gobi_loader.

-- 
Anssi Hannula

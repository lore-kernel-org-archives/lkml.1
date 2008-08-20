Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYHTQG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYHTQG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYHTQGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:06:19 -0400
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:41588
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602AbYHTQGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:06:18 -0400
X-Authority-Analysis: v=1.0 c=1 a=pHc7EGbUY0DHTS-X7LAA:9
 a=fRWjjG95jeRKMkx81DKMnU39r3UA:4 a=LmNr2P7SIc4A:10 a=ss8zFxJ8D50A:10
 a=LY0hPdMaydYA:10
Date: Wed, 20 Aug 2008 12:06:11 -0400
From: Frank Peters <frank.peters@comcast.net>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.26 Breaks USB Fax Modem
Message-Id: <20080820120611.a528bd3d.frank.peters@comcast.net>
In-Reply-To: <200808200739.51486.oliver@neukum.org>
References: <20080819211039.a273679f.frank.peters@comcast.net>
	<200808200739.51486.oliver@neukum.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 07:39:51 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> 
> This is completely new. Please compile 2.6.26 with CONFIG_USB_DEBUG
> and reexamine the log. It should be more verbose.
> 

In menuconfig, I enabled the USB_DEBUG option and then compiled
kernel 2.6.26.2.  The kernel log during a fax transmission is,
to my eyes, still not very revealing.

Before the fax is transmitted, the cdc-acm module is first loaded
with the commands:

modprobe cdc-acm
mount -t usbfs none /proc/bus/usb

Then the fax is sent with HylaFAX software.  (The problem is not
unique to  HylaFAX, however; it will occur with any fax software.)
HylaFAX will initialize the USB modem and then send the fax.  Here
is the kernel log:

Aug 20 10:53:22 (none) kernel: cdc_acm 4-2:2.0: usb_probe_interface
Aug 20 10:53:22 (none) kernel: cdc_acm 4-2:2.0: usb_probe_interface - got id
Aug 20 10:53:22 (none) kernel: cdc_acm 4-2:2.0: ttyACM0: USB ACM device
Aug 20 10:53:22 (none) kernel: usbcore: registered new interface driver cdc_acm
Aug 20 10:53:22 (none) kernel: cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
Aug 20 10:53:42 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 10:54:10 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:01:30 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:01:33 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:01:33 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:03:34 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:03:34 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:03:38 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:03:38 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:09:31 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us

Notice the long gap from 11:03:38 to 11:09:31.  During this time the modem
is hung.  Nothing is happening.  The HylaFAX transmission log shows only an
abrupt break in the data stream:

Aug 20 11:04:18.04: [  717]: <-- data [2]
Aug 20 11:04:18.11: [  717]: <-- data [261]
Aug 20 11:04:18.19: [  717]: <-- data [2]
Aug 20 11:04:18.26: [  717]: <-- data [260]
Aug 20 11:04:18.33: [  717]: <-- data [2]
Aug 20 11:04:18.33: [  717]: <-- data [262]
Aug 20 11:05:18.33: [  717]: MODEM TIMEOUT: writing to modem
Aug 20 11:05:18.33: [  717]: <-- data [2]
Aug 20 11:06:18.33: [  717]: MODEM TIMEOUT: writing to modem

The break occurs at 11:04:18.33.  After a minute a MODEM TIMEOUT
is reported.

To get to this point, however, requires a lot of prior communication
with the modem to establish the parameters and protocol. Somehow,
the modem becomes unresponsive only later in the transmission.

HylaFAX will eventually recover but the modem remains unresponsive.
A reboot is necessary to restore the modem functionality.

The kernel log after this point shows only the same:

Aug 20 11:09:34 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:09:38 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:09:38 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:10:11 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:10:11 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:10:42 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:12:56 (none) kernel: uhci_hcd 0000:00:1a.1: reserve dev 2 ep84-INT, period 128, phase 0, 36 us
Aug 20 11:12:59 (none) kernel: uhci_hcd 0000:00:1a.1: release dev 2 ep84-INT, period 128, phase 0, 36 us

If I immediately reboot the machine with kernel 2.6.25, the same fax
can be sent to the same fax machine with no problem.

>
> Are any processes left hanging in `D' state afterwards?
>

The command "ps ax" shows no process in the "D" state at any time.

I did not report this to the HylaFAX list because it does not
appear to be a fault of HylaFAX or other fax software, but I think
I should indicate this thread to the HylaFAX list.  They may
be able to provide some additional insight about the point of
failure.

Frank Peters


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZDXKOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZDXKOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZDXKOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:14:20 -0400
Received: from langos.euedge.com ([209.190.22.130]:57044 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbZDXKOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:14:19 -0400
Message-ID: <49F190F7.9040106@maroy.hu>
Date: Fri, 24 Apr 2009 12:14:15 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
References: <49EDC44D.90106@maroy.hu> <200904221514.34892.oliver@neukum.org> <49EF1AAC.3080802@maroy.hu> <200904231511.54024.oliver@neukum.org>
In-Reply-To: <200904231511.54024.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

> Please try setting ACM_NW in cdc-acm.h to 1. If that does not help,

doesn't seem to help:

# rmmod cdc_acm
# grep ACM_NW `find . -name cdc-acm.h`
#define ACM_NW  1
	struct acm_wb wb[ACM_NW];
# make && make modules_install
...
# lsmod | grep cdc
# tail -f /var/log/messages
...
Apr 24 12:08:36 tomodachi kernel: [  400.784055] usb 2-1: new full speed
USB device using uhci_hcd and address 3
Apr 24 12:08:36 tomodachi kernel: [  400.948109] usb 2-1: New USB device
found, idVendor=ffff, idProduct=0005
Apr 24 12:08:36 tomodachi kernel: [  400.948113] usb 2-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=3
Apr 24 12:08:36 tomodachi kernel: [  400.948118] usb 2-1: Product: USBSerial
Apr 24 12:08:36 tomodachi kernel: [  400.948121] usb 2-1: Manufacturer:
LPCUSB
Apr 24 12:08:36 tomodachi kernel: [  400.948124] usb 2-1: SerialNumber:
DEADC0DE
Apr 24 12:08:36 tomodachi kernel: [  400.948274] usb 2-1: configuration
#1 chosen from 1 choice
Apr 24 12:08:36 tomodachi kernel: [  400.977961] cdc_acm 2-1:1.0:
ttyACM0: USB ACM device
Apr 24 12:08:36 tomodachi kernel: [  401.001223] usbcore: registered new
interface driver cdc_acm
Apr 24 12:08:36 tomodachi kernel: [  401.001229] cdc_acm: v0.26:USB
Abstract Control Model driver for USB modems and ISDN adapters



and strangely enough, when first running the application, I get:

$ ./asio_serial
opening serial device /dev/ttyACM0
terminate called after throwing an instance of
'boost::exception_detail::clone_impl<boost::exception_detail::error_info_injector<boost::system::system_error>
>'
  what():  No such file or directory
Aborted


on the second run, it hangs at the same poll() call:

$ ./asio_serial
opening serial device /dev/ttyACM0
serial port open: 1
setting serial port parameters
written bytes: 6


the end of the strace of the first run is:

write(2, "opening serial device "..., 22opening serial device ) = 22
write(2, "/dev/ttyACM0"..., 12/dev/ttyACM0)         = 12
write(2, "\n"..., 1
)                    = 1
open("/dev/ttyACM0", O_RDWR|O_NOCTTY|O_NONBLOCK) = -1 ENOENT (No such
file or directory)
futex(0x7f75df826190, FUTEX_WAKE_PRIVATE, 2147483647) = 0
write(2, "terminate called after throwing a"..., 48terminate called
after throwing an instance of ') = 48
write(2, "boost::exception_detail::clone_im"...,
111boost::exception_detail::clone_impl<boost::exception_detail::error_info_injector<boost::system::system_error>
>) = 111
write(2, "'\n"..., 2'
)                   = 2
write(2, "  what():  "..., 11  what():  )          = 11
write(2, "No such file or directory"..., 25No such file or directory) = 25
write(2, "\n"..., 1
)                    = 1
rt_sigprocmask(SIG_UNBLOCK, [ABRT], NULL, 8) = 0
tgkill(10563, 10563, SIGABRT)           = 0
--- SIGABRT (Aborted) @ 0 (0) ---
+++ killed by SIGABRT +++



> please provide an usbmon trace of that modified kernel and 2.6.24.

this is what I get:

# cat /sys/kernel/debug/usbmon/1u
...
ffff81003f351540 2696262407 S Ii:1:008:1 -115:8 8 <
ffff81006c2c1840 2696262434 S Co:1:008:0 s 21 22 0003 0000 0000 0
ffff81006c2c1840 2696262558 C Co:1:008:0 0 0
ffff810035a5e600 2696262648 S Bo:1:008:7 -115 6 = 060a0000 0000
ffff810035a5ee40 2696262668 S Bi:1:008:2 -115 128 <
ffff810035a5ecc0 2696262670 S Bi:1:008:2 -115 128 <
ffff810035a5ed80 2696262671 S Bi:1:008:2 -115 128 <
ffff81006c1fb840 2696262675 S Bi:1:008:2 -115 128 <
ffff81006c1fb480 2696262676 S Bi:1:008:2 -115 128 <
ffff81006c1fbd80 2696262677 S Bi:1:008:2 -115 128 <
ffff81006c1fba80 2696262678 S Bi:1:008:2 -115 128 <
ffff81006c1fbc00 2696262679 S Bi:1:008:2 -115 128 <
ffff81006c1fbf00 2696262680 S Bi:1:008:2 -115 128 <
ffff81006c1fb180 2696262681 S Bi:1:008:2 -115 128 <
ffff81006c1fbcc0 2696262683 S Bi:1:008:2 -115 128 <
ffff81006c1fb540 2696262684 S Bi:1:008:2 -115 128 <
ffff81006c1fb300 2696262685 S Bi:1:008:2 -115 128 <
ffff81006c1fb3c0 2696262685 S Bi:1:008:2 -115 128 <
ffff81006c1fb0c0 2696262686 S Bi:1:008:2 -115 128 <
ffff81003f351780 2696262687 S Bi:1:008:2 -115 128 <
ffff810035a5e600 2696262804 C Bo:1:008:7 0 6 >
ffff810035a5ee40 2696263055 C Bi:1:008:2 0 48 = 300b0000 00005802
00000000 00000000 00000000 00000000 00000000 00000000
ffff810035a5ee40 2696263064 S Bi:1:008:2 -115 128 <
ffff81006c2c1840 2696263122 S Co:1:008:0 s 21 22 0000 0000 0000 0
ffff81006c2c1840 2696263180 C Co:1:008:0 0 0
ffff81003f351540 2696263212 C Ii:1:008:1 -2:8 0
ffff81003f351780 2696263305 C Bi:1:008:2 -2 0
ffff81006c1fb0c0 2696263554 C Bi:1:008:2 -2 0
ffff81006c1fb3c0 2696263679 C Bi:1:008:2 -2 0
ffff81006c1fb300 2696263804 C Bi:1:008:2 -2 0
ffff81006c1fb540 2696263929 C Bi:1:008:2 -2 0
ffff81006c1fbcc0 2696264054 C Bi:1:008:2 -2 0
ffff81006c1fb180 2696264179 C Bi:1:008:2 -2 0
ffff81006c1fbf00 2696264304 C Bi:1:008:2 -2 0
ffff81006c1fbc00 2696264429 C Bi:1:008:2 -2 0
ffff81006c1fba80 2696264554 C Bi:1:008:2 -2 0
ffff81006c1fbd80 2696264679 C Bi:1:008:2 -2 0
ffff81006c1fb480 2696264804 C Bi:1:008:2 -2 0
ffff81006c1fb840 2696264929 C Bi:1:008:2 -2 0
ffff810035a5ed80 2696265054 C Bi:1:008:2 -2 0
ffff810035a5ecc0 2696265179 C Bi:1:008:2 -2 0
ffff810035a5ee40 2696265304 C Bi:1:008:2 -2 0




Akos

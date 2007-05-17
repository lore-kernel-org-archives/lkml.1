Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbXEQONR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbXEQONR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755030AbXEQONA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:13:00 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58445 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbXEQOM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:12:59 -0400
Date: Thu, 17 May 2007 16:10:20 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg KH <greg@kroah.com>
cc: ark3116_driver@auctionant.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] ark3116: receive returns negative
In-Reply-To: <20070517124525.GC20055@kroah.com>
Message-ID: <Pine.LNX.4.61.0705171529570.3231@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705161743250.9570@yvahk01.tjqt.qr>
 <20070517124525.GC20055@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On May 17 2007 05:45, Greg KH wrote:
>> 
>> I seem to have problems with the ark3116 driver from 2.6.18.8. This 
>> is a USB-RS232 cable. Just opening the /dev/ttyUSB0 device gives 
>> (this is the debug output enabled by `modprobe ark3116 debug=1`).
>> 
>> The lines that look suspicious are
>> /serial/ark3116.c: 124 < 1 bytes [0xFFFFFFB0]
>> and
>> /serial/ark3116.c: ark3116_ioctl cmd 0x5401 not supported
>
>Why is this suspicious?  We don't support all ioctls for all usb-serial
>drivers, perhaps this one is just not really needed?

ark3116 supports set_termios (0x5402), but does not get_termios 
(0x5401). Not sure how that affects userspace, though.

The 0xFFFFFFB0 looks like a simple formatting error (ark3116.c line 66)
an explicit cast to (unsigned char)buf[0] or (unsigned int) seems 
required.

>> I have also seen things like "id here < -62 [0x10]", which would 
>> indicate that usb_control_msg() returned something very negative 
>> (-ETIME!?).

The -62 only shows up when the cable is already connected when I 
modprobe ark3116. Reinserting it - and no "-62" shows up.
Maybe this is something normal with USB?

>But does the driver seem to work properly?
>
>> Issuing a write() on an open fd to ttyUSB does not generate any further 
>> debug output. Is the driver even complete/functional?

(I found that I already need to modprobe usbserial with debug=1,
since ark3116 uses usb_serial_generic_write)

>Do you get data through the device properly?

I would have to test with a real serial port. (I do not
have any real port right now, just two cables + adapters.)

What certainly does not work: Connecting two cables to each other, that is,
USB-RS232-GenderChanger-RS232-USB. (1) USB ends connected to the same machine
(2) USB ends connected to different machines. Both (1) and (2) do not work.
The write() seems to succeed, but read() blocks:

# klogconsole -l8 -r0
# ./sertest
[...]
Writing...
drivers/usb/serial/usb-serial.c: serial_write_room - port 0
drivers/usb/serial/generic.c: usb_serial_generic_write_room - port 0
drivers/usb/serial/generic.c: usb_serial_generic_write_room - returns 64
drivers/usb/serial/usb-serial.c: serial_write - port 0, 3 byte(s)
drivers/usb/serial/generic.c: usb_serial_generic_write - port 0
ark3116 ttyUSB0: usb_serial_generic_write - length = 3, data = 66 6f 6f
drivers/usb/serial/generic.c: usb_serial_generic_write_bulk_callback - 
port 0
drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
Reading...
(stops)

Source:
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
int main(void)
{
	char bar[4] = {};
	int s0 = open("/dev/ttyUSB0", O_RDWR);
	int s1 = open("/dev/ttyUSB1", O_RDWR);
	if (s0 < 0 || s1 < 0)
		abort();
	printf("Writing...\n");
	write(s0, "foo", 3);
	printf("Reading...\n");
	read(s1, bar, 3);
	printf("Read: %s\n", bar);
	return 0;
}



	Jan
-- 

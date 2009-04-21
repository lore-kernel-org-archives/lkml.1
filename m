Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZDUNLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZDUNLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZDUNLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:11:45 -0400
Received: from langos.euedge.com ([209.190.22.130]:40639 "EHLO
	langos.euedge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZDUNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:11:44 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2009 09:11:44 EDT
Message-ID: <49EDC44D.90106@maroy.hu>
Date: Tue, 21 Apr 2009 15:04:13 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: cdc-acm driver hangs on poll() call - 2.6.27, works on 2.6.24
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm enocuntering an issue with the cdc-acm USB serial driver. I have an
embedded device that acts as a USB serial device, and is recognized USB
ACM device:

Apr 21 14:59:12 tomodachi kernel: [12207.024066] usb 1-1: new full speed
USB device using uhci_hcd and address 15
Apr 21 14:59:13 tomodachi kernel: [12207.188440] usb 1-1: configuration
#1 chosen from 1 choice
Apr 21 14:59:13 tomodachi kernel: [12207.198678] cdc_acm 1-1:1.0:
ttyACM0: USB ACM device


I'm using a very simple communication protocol with the device. here's
some sample C++ code that just asks a status, and waits for a reply:


#include <iostream>
#include <boost/asio.hpp>

using namespace boost::asio;

static const std::string serial_device("/dev/ttyACM0");

static const unsigned char status_message[] = { 6, 10, 0, 0, 0, 0 };
static unsigned char status_ack_message[64];

int main(int argc, char **argv) {

    io_service  io;
    serial_port sp(io);

    std::cerr << "opening serial device " << serial_device << std::endl;
    sp.open(serial_device);
    std::cerr << "serial port open: " << sp.is_open() << std::endl;

    std::cerr << "setting serial port parameters" << std::endl;
    sp.set_option(serial_port_base::baud_rate(19200));
    sp.set_option(serial_port_base::character_size(8));
    sp.set_option(serial_port_base::flow_control(
                                serial_port_base::flow_control::none));
    sp.set_option(serial_port_base::parity(
                                serial_port_base::parity::none));
    sp.set_option(serial_port_base::stop_bits(
                                serial_port_base::stop_bits::one));

    std::size_t written = write(sp, buffer(status_message));
    std::cerr << "written bytes: " << written << std::endl;

    std::size_t read = sp.read_some(buffer(status_ack_message));
    std::cerr << "read bytes: " << read << std::endl;

    return 0;
}


now, this all works fine on kernel 2.6.24 (ubuntu 8.04, gcc 4.2.4,
kernel 2.6.24-23-generic x86_64):

$ ./asio_serial
opening serial device /dev/ttyACM0
serial port open: 1
setting serial port parameters
written bytes: 6
read bytes: 48

the related strace is:

...
writev(5, [{"\6\n\0\0\0\0", 6}], 1)     = 6
write(2, "written bytes: ", 15written bytes: )         = 15
write(2, "6", 16)                        = 1
write(2, "\n", 1
)                       = 1
readv(5, 0x7fffb6ee8f90, 1)             = -1 EAGAIN (Resource
temporarily unavailable)
poll([{fd=5, events=POLLIN, revents=POLLIN}], 1, -1) = 1
readv(5, [{"0\v\0\0\0\0X\2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
64}], 1) = 48
write(2, "read bytes: ", 12read bytes: )            = 12
write(2, "48", 248)                       = 2
write(2, "\n", 1
)                       = 1
epoll_ctl(3, EPOLL_CTL_DEL, 5, {0, {u32=0, u64=0}}) = 0
close(5)                                = 0
close(3)                                = 0
close(4)                                = 0
exit_group(0)                           = ?
Process 24775 detached


now, if I run the same on 2.6.27 (ubuntu 8.10, kernel 2.6.27-11-generic
x86_64), the above hangs att the poll() call:

$ ./asio_serial
opening serial device /dev/ttyACM0
serial port open: 1
setting serial port parameters
written bytes: 6

the related strace is:

writev(5, [{"\6\n\0\0\0\0", 6}], 1)     = 6
write(2, "written bytes: ", 15written bytes: )         = 15
write(2, "6", 16)                        = 1
write(2, "\n", 1
)                       = 1
readv(5, 0x7fff135ac650, 1)             = -1 EAGAIN (Resource
temporarily unavailable)
poll( <unfinished ...>


and it just hangs there forever.

from the kernel changelog, I saw there were changes made to the cdc-acm
mobule between 2.6.24 and 2.6.27. might those changes by in relation to
the above effect?

any help is appreciated...


Akos

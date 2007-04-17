Return-Path: <linux-kernel-owner+w=401wt.eu-S1031148AbXDQQW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031148AbXDQQW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031151AbXDQQWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:22:25 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:7362 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031148AbXDQQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UC2SzMviTb8wSWr1C3KlqB4EY+UoDCsaCelI5bd5jlgmJlHHrzzZRgrYtrA6kn39LQpVvSFbP+a1bdbUlbcpRUJ0cyJ/J/gzm2xzaeGxJtQJZcOyascQ2aDq5BPBeEd/WnCulsVd+ktZOZMYuD7Hh1vDLKCCcpl81xmrGTgCgWU=
Message-ID: <5486cca80704170922o7edc3020oc3f14f099eab1dee@mail.gmail.com>
Date: Tue, 17 Apr 2007 18:22:22 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: FTDI usb-serial possible bug
Cc: greg@kroah.com
In-Reply-To: <5486cca80704140747u74f92c8bj564618b1cdc09e43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5486cca80704140747u74f92c8bj564618b1cdc09e43@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to the list,

I'm forwarding to lkml this mail that got no answer on linux-usb.
It describes a nasty behavior of the ftdi usb-serial linux driver.

---------- Forwarded message ----------
From: Antonino Ingargiola <tritemio@gmail.com>
Date: Apr 14, 2007 4:47 PM
Subject: FTDI usb-serial possible bug
To: linux-usb-users@lists.sourceforge.net


Hi to the list,

I report a problem found with a device that use the FTDI chip to
communicate data to pc.
I'll try to describe my scenario as well as I can, but please tell me
if you nedd further information.

The device is a counter that sends a string of 9 chars (8 digits and
an '\r') each 10ms, using the virtual serial port created by the OS
driver (the communication parameter are: 115200, 8N1). This device was
built some years ago at our labs, and has been used many times with
windows without problems.

Recently we are trying to use it under Linux. Using python to read
from the serial device I've found that some data were corrupted. The
application involves reading a set on counts (say 100 counts, i.e. 100
8-digit strings terminated by a \r), then wait that the instruments
are positioned (some seconds) and re-do the acquisition. What happens
is that (provided that the pause is > 3 seconds) the 27-th or 28-th
string is quite systematically corrupted (some character is missing,
so the string is lower that 8 digit, or if the \r is missing two
string are concatenated).

I have been able to reproduce the problem with a simple test case both
in bash and in python. Let see below:

    #!/bin/bash
    stty -F /dev/ttyUSB0 115200 -parenb -ixon
    while true; do
        echo "\n  * Reading counter..."
        head -n 100 /dev/ttyUSB0
        sleep 3
    done

and in python:

    #!/usr/bin/env python

    import serial, time

    s = serial.Serial('/dev/ttyUSB0', 115200)
    while True:
        print 'Reading counter ...'
        for i in xrange(100):
            print s.readline(eol='\r')
        time.sleep(3)

With this two test cases I get the 27 or 28 line almost always
corrupted, due to some missing characters.

The same python code under windows (changing only the device name)
gives uncorrupted strings.

The Linux versions tested were fedora core 2 (with its shipped
kernel), ubuntu dapper (with its shipped kernel) and debian etch with
an home-built 2.6.20 kernel. All the Linux versions give the same
result with corrupted data. I've also tried, in python, to open the
device every time I need to read a series of data and then close it
before the sleep, but none changed. Eliminating the sleep from the
test case eliminates the problem.

The same test performed on a real serial port receiving continuous
stream of data (created via software and sent by a second serial port)
does not yield to any corruption problem.

All these elements bring me to think that the problem can reside in
the linux ftdi usb-serial driver, maybe some problem managing the
input buffer .... but here I'm just guessing.

In python using s.inWaiting() in the above example I can see the
number of chars in the input buffer. I've found that the input buffer
has quite almost alway 8 or 17 chars one instruction before the
readline call that returns corrupted data (remember that the line is 9
chars, 8 digits and a \r). I don't know if it means something :).

I'm not very fluent in C (and in C serial programming) so I've not
provided a C test case, I hope this is not a problem (the python and
bash test cases seems significant too, thought).

Ask me if you need further information or if you have any request for
further testing.

Thanks in advance,

Cheers,

  ~ Antonio

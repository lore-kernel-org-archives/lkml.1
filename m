Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbYGPPtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbYGPPtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYGPPtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:49:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:59786 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYGPPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EZK6PMAazzvFM2JARfuVJMms9pouIgqiCxiK7MZQyhP9Fa2ygZoOGkVNcZ2azW5J1G
         5myzapPHky14X/B+98uS9Q8tLU1HEGuJtMRG4aMioL1ZUsdObwQ+b9dndIcx96+wE8ut
         eOYQ7veoMuLxQo9NEQAlKhYtoy1QCayLziNTQ=
Message-ID: <f44001920807160849p679857dbn7bf0fec419229cd6@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:49:10 +0400
From: "Igor Zhbanov" <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: No standard touchscreen driver for Samwell Ruggedbook Tablet PC 800. Which to use?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have Samwell Ruggedbook Tablet PC 800:
http://www.ruggedbook.com.tw/product_view.asp?ID=50

It has 4-wire resistive touchscreen controlled by PIC16F819. Microcontroller
has 10-bit ADC and it seems to be connected to PS/2. (I have no idea what
is inside PIC's ROM.) Under Windows device works well with Wacom Tablet PC
and PanJit TouchSet drivers (the later is not proprietary for this device).

Under Linux I can capture events from /dev/input/event2 device. So I
have written
simple program that dumps data in hexadecimal view.

Data from device comes in packets of 16 bytes long.
First 4 bytes are Unix time stamp, next 4 bytes are millionth's of second
(from 0 to 999999). Both fields are stored in Intel's byteorder.

Since first 8 bytes has the same meaning for all types of events, I
will omit them.
(I will number bytes since 9-th byte - 9-th will be refered as 0-th, etc)

I have seen 4 types of events: X-coordinate, Y-coordinate, unknown (reserved for
Z-coordinate or pressure?) and probably OnClick event.

Coordinates comes in group of 3 events, e.g.:

02 00 00 00 b0 00 00 00 (X = 0xb0)
02 00 01 00 ac ff ff ff (Y = 0xac)
00 00 00 00 00 00 00 00 (Unknown. Reserved for Z-coordinate or pressure?)

Having 0-th byte set to 02 denotes coordinate. 00 in 2-nd byte means
X-coordinate
and 01 means Y. Coordinate itself is stored in 4-th byte. It can be
from 0 to 255.
(In practice, from 15 to 237 - perhaps of screen borders).

Next three bytes can be 0x000000 or 0xffffff. Numbers are changes very quickly
but with some regularity. Perhaps it is  the least significant bit of
coordinate.
I shift 4-th byte 1 bit left and add 1 right bit from 5-th byte to
compute coordinates.
So, I have 9-bit coordinates. The ADC in PIC16F819 is 10-bit, but I don't have
any ideas where developers have lost one bit. ;-)

Also I have seen events like
01 00 12 01 01 00 00 00
or
01 00 12 01 00 00 00 00.

They have 0-th byte set to 01. It looks like OnClick event notification.
First event of that type comes in about of three groups of coordinate events
after touching screen with stylus. And until release you will see about 2-4
that events. 4-th byte can be 00 or 01 and always changes on next event.
So, if you read an event with 4-th byte set to 00, the next event will be
with 4-th byte set to 01 and vice verse. I don't know what is the reason
to have OnClick event on a touchscreen - if coordinates changes then
the screen is touched. ;-)

Now is the main question. Is there a driver suitable for this protocol
or it should be written? Have you seen this protocol in another touchscreen
controllers already?

Thank you.

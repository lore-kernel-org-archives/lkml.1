Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZJPI6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZJPI6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbZJPI6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:58:17 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:51737 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbZJPI6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:58:16 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2009 04:58:16 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=sH70aMxB6Pk66wAaDdC02sJB7jchIqaTcVMHql5VolRnTIocoFLeKkRf/tYcfnZ7Kn
         LF05To2ke4Zz4uqYH3OP+1zBG2ITjaaUaYk0vYdGJYkVAwOgpKCMqppYEq+RSBuNgChJ
         ywwoDRa/r9+U2HCJyRr6tQeszMoRbxutkv2W4=
MIME-Version: 1.0
Date: Fri, 16 Oct 2009 21:50:43 +1300
X-Google-Sender-Auth: 7933a331cb4d0cdf
Message-ID: <a5b9b4700910160150o146a8f21n1c76c14755d64da8@mail.gmail.com>
Subject: Kernel driver with multiple SPI sources
From: Bertrand Roussel <bertrand.roussel@cor-net.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am currently writing a kernel driver for an IMU, this is a basic
driver that is taking infos from
two SPI devices (an adc and a magnetic sensor), that are running on
the same bus, but different with different CS.

I'm having troubles to determine if the architecture I am currently
thinking about is a good way to do things.
In order to write portable code I was thinking in using general kernel
APIs, and came out with something like this:
 _____      ______
|     | <> |  ADC |
|     |    |______|
| IMU |     ______  <> Bus SPI
|     | <> |  MAG |
|_____|    |______|

Each block correspond to a driver:
* IMU is a basic char driver, depending on both ADC and MAG driver,
and that register new spi_device to the spi_master
* ADC and MAG are instances of an spi_driver, with a char driver as an interface

The IMU must take samples from the devices at a fixed rate.
A problem is that to retrieve infos from the MAG for example, a
command must be send first, then there is a delay from
1 to 4ms before the result are available, which is known when a PIN gets high.

Since I'm a beginner in kernel writing, I really don't know if the
approach I took is a good way to do things or not.
If that's not the case, can anyone give me some hints about how I
should consider doing things ?

However, in the case as my approach is right, I am really worried
about the delay part, since I don't want the kernel
to block for 5ms doing nothing a hundred times per second just because
it is reading from the SPI, I was considering
asynchronous IO implementation on the ADC/MAG side.
A timer would generate the sample rate in the IMU driver, tell the
ADC, which would send the command, then return.
On the gpio interrupt, the driver would read the ADC, and return the
result to the IMU. Which would then tell the MAG,
which would send the command, then return. Then gpio interrupt, the
driver read from the MAG, and return the result to
the IMU again, which would then store both results in a buffer, until
an application in user space decide to read it.

I am having trouble writing the Imu <=> Adc and Imu <=> Mag
communication part, did I got it wrong ?

Best regards,
Bertrand

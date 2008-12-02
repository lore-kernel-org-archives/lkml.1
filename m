Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYLBNns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYLBNns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYLBNnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:43:41 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:54644 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYLBNnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:43:39 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <49353B89.6020502@cam.ac.uk>
Date: Tue, 02 Dec 2008 13:43:37 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [Industrial I/O] [0/13] RFC: IIO v3 patchset
References: <4933F291.4020001@cam.ac.uk> <20081201194136.039e201b@lxorguk.ukuu.org.uk>
In-Reply-To: <20081201194136.039e201b@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan,
>> have both functions. The sort of devices we are talking typically
>> communicate over I2C or SPI buses though drivers for rs232 devices etc are
>> definitely on the cards. Basically we are interested in devices where direct
>> memory mapped access is not possible.
> 
> We have I2C and SPI drivers so I assume you will use the lower layers of
> the stacks to do this ?
Yes, in much the same way that for example hwmon is built on top of these
(amongst other interfaces)
> 
>> For discussion of why these don't fit within existing subsystems see 
>> http://lkml.org/lkml/2008/5/20/135 and the rest of the associated thread.
 
> I don't see much there which says why you can't unify all this in a user
> space library.
Indeed, that was an option considered at the time and the majority of that
discussion focused on how to do things in a similar way to existing similar
kernel subsystems.

Perhaps this question needs further clarification.

Much of the stuff provided in this initial patch set could indeed be provided
by a fairly complex user space library.

I get the feeling this rest of this response is going to look pretty familiar.
Though as I have never attempted to code anything other than simple userspace
drivers I suspect others may have more detailed responses.  These are in no
particular order.

I believe the principle argument in favour of user space drivers is that of
enhanced stability as they are unlikely to be able to bring the kernel down.
This advantage is indeed valid here.

The other advantage is that the number of copies required to get data to and
from hardware are reduced.  For the devices considered here a userspace driver
would have to go via one of the chrdev interfaces and neither i2c-dev or
spidev are able to support mmap ed interfaces.

The problems I can forsee (or have encountered) with user space drivers
for this sort of device:
* In many cases the ADCs form part of more complex devices which already
  have a support within the kernel. (e.g. PMICs such as those supported
  by the DA903x mfd driver) and as such any additional interface will
  require at least some kernel parts.  Other places I've seen ADCs that
  I'd like to have available via a consistent interface, include firewire
  and usb cameras (aux ADC's and DAC's are common for controlling pan
  tilt heads etc).  Some of these could be implemented in userspace (and
  quite possibly should be,) but others would require driver changes that
  will effectively equal those of adding direct support for the subsystem
  described in these patches.

* Spidev and i2cdev are fairly restricted interfaces which I have used
  extensively for initial investigation of sensors. The key thing here
  is that almost no devices use purely these interfaces. They include
  interrupt lines etc requiring relatively complex handlers. Thus any
  driver would probably require at least some kernel space element per
  chip anyway. Also worth noting that this tends to be the most complex
  and hence probably error prone part of these drivers.  The spidev
  documentation talks about the limitations of the driver.

  An example of the problems that would be encountered with the current i2c-dev
  implementation within a full driver would be a control register read
  on a VTI SCA3000 (i2c) accelerometer.  This would require an initial 3 byte
  write followed by a 1 byte read.   In kernel space this whole thing
  can be set up in a dma capable buffer and done in one go with copies out
  to userspace only needed if the value is meant to be read by the user.

* Need to provide kernel space interfaces. This actually fulls under the RFC
  question of what the scope of this subsystem should be. For example,
  things like battery chargers, free fall detectors etc frequently use
  generic components of the types that IIO will include. The systems that
  use these sometimes require kernel level access which a userspace driver
  clearly cannot supply.

* Performance: Thinks like time stamping of data ready signals needs to be
  as near as possible to the source interrupt.  As for the complex question
  of which is optimal for the ring buffering functionality, this would need
  thorough optimization of both approaches before it could be addressed.
  I'm not aware of any similar comparisons but would be grateful if anyone
  could direct me to any they know of.  It is also worth noting here that many
  applications that will use the ring buffered interface will never actually
  read the contents of the buffer as they are interested in only restricted
  regions of data (based on some external trigger).

In conclusion, I'd be interested in the long run in the possibility of
moving all the above functionality into userspace but at the moment don't
believe it to be the sensible option here.
The alternative of would be to provide only those drivers that would
benefit from a kernel space driver within this subsystem.
This would lose the advantages to be gained from a consistent interface.
This could in turn be made transparent via a userspace library but only
at the cost of unnecessary complexity.

> 
> For RS232/423/.. devices you can go this path if you want (but I would
> keep it all in userspace anyway) as you can use a line discipline to sit
> on top of the port and provide another interface (eg the way PPP does)

An interesting suggestion. The main reason I'd be interested in bringing
these into the kernel is to do with the handling of additional interrupt
lines (which a number of similar devices have).

Thanks for the comments,

--
Jonathan Cameron


 


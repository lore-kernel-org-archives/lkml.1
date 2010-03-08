Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0CHJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:58:25 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:51250 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0CHJ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:58:22 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B94CAAE.3040404@cam.ac.uk>
Date: Mon, 08 Mar 2010 10:00:14 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, linux-iio@vger.kernel.org
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk> <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com> <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain> <20100303184132.GA11471@core.coreip.homeip.net> <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain> <20100303190753.GB11471@core.coreip.homeip.net> <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com> <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain> <20100307204213.GB17727@core.coreip.homeip.net>
In-Reply-To: <20100307204213.GB17727@core.coreip.homeip.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/10 20:42, Dmitry Torokhov wrote:
> On Wed, Mar 03, 2010 at 01:51:07PM -0800, Linus Torvalds wrote:
>>
>>
>> On Wed, 3 Mar 2010, Dima Zavin wrote:
>>>
>>> Actually, accelerometers fit into that model fine. They have some
>>> variable number of absolute axes (3, 6, etc.).
>>
>> In fact, they obviouslya also do end up being used exactly like joysticks 
>> in real life, and joysticks are commonly starting to have accelerometers 
>> in them (ie any modern game console controller).
>>
>> So treating an accelerometer like a joystick - regardless of whether it 
>> happens to be internal to the device or happens to be external in a 
>> separate controller - is not all that far-fetched anyway.
>>
> 
> But the point is that not every accelerometer is a joystick. We have
> hdaps and friends that have accelerometers inside but that is not their
> main purpose (they do export a secondary joystick-like interface and
> that is fine), and I am pretty sure that there are other users of
> accelerometers in various systems.
> 
> I am retty sure that once we settle on the proper interface for such
> sensors we should be able to write a bridge to input layer so they can
> be easily used as [human] input devices in cases whether it is desired.
> 
I agree, this should certainly be possible.

In IIO's case (as that is what I am familiar with), polled input devices
would effectively supply a software trigger that would in turn lead to
the device pushing data into an IIO buffer. In this case the buffer would
just be a direct hook into input.  At the moment, the only complex case
I can think of is passing events (in IIO terminology, these are things
like crossing of thresholds) as they are not pushed out via an interface
that currently has any hooks for in kernel use.  It should be easy enough
to add such hooks though.  Devices where the data flow is interrupt driven
effectively supply their own trigger anyway and are even simpler to handle.

The one remaining thing I'm trying to work out is whether to support switching
the buffer type at runtime (rather fiddly) or just make it a compile time option
(probably what will happen first in any case).

We'll also need some userspace magic to set up the linkage but that should be
fairly straight forward. 1) Request an input-iio-bridge (this will probably
involve also identifying what sort of data is coming in so as to add the
relevant 'header' type information to the input events, 2) Link up the poll
route (done by name) 3) link up the buffer route (also done by name) 4) Attach
the currently non existent 'event' hooks between the two event systems (again
this will need to deal with translation and attaching the 'header' information
that input expects.)

So not too bad. I'll hack together a proof of concept together at some point.

Jonathan

I've cc'd linux-iio to see if anyone else has thoughts on how we would do it.


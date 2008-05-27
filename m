Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbYE0TBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbYE0TBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbYE0TBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:01:13 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:34450 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbYE0TBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:01:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=HdHRwU56E49etnppKNBi8dhIgymCosVpmTT6uJZ00XmUdY1M6Lw6SZwIaT9xdPDVSD9l51GE/zlgF/Y2wiCKKs2JMtnuy6bX2h+Eb0BTU81I/Z/jIzrIRvu5RXvjtegeudVyUKe6RSJ9dlewqeX/vaNkMh9zLFBCA6uRv7JHAsI=
Date: Tue, 27 May 2008 15:01:07 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ben Dooks <ben@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>, spi-devel-general@lists.sourceforge.net,
       Jonathan Cameron <Jonathan.Cameron@gmail.com>,
       linux-kernel@vger.kernel.org, LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [spi-devel-general] Accelerometer, Gyros and ADC's etc within
	the kernel.
Message-ID: <20080527140348.ZZRA012@mailhub.coreip.homeip.net>
References: <4832A211.4040206@gmail.com> <20080520132817.03fb74ea@hyperion.delvare> <20080521093520.ZZRA012@mailhub.coreip.homeip.net> <20080527171656.GA870@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527171656.GA870@trinity.fluff.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Tue, May 27, 2008 at 06:16:56PM +0100, Ben Dooks wrote:
> > 
> > I don't think that input subsystem woudl be the best choice. While we
> > do support the event-driven mechanism for delivering information to
> > userspace input is mostly oriented for human interface devices, not
> > general data acquisition. If anything input_dev is too fat. Another
> > thing is that input layer anonymizes input devices, makes them
> > capability-oriented. I.e. we dont really care what model of joystick
> > we have, we want something that reports ABS_X, ABS_Y, BTN_FIRE and
> > userpsace can use it whether it a simple analog joystick or something
> > fancy and USB connected. For your purposes you probably do want to know
> > what the device is and what exactly being sampled/measured.
> 
> Can you explain to me how the input system anonymizes things? I thought
> it was quite easy to read the name of the device? You could easily add
> a symlink from the driver's device binding in sysfs to the relevant
> input device as well.
> 

Yes, it is possible to read the name of the device, but I could see
with names like "Thermal probe blah" it may not be unique enough. Of
course input core also exports phys, sysfs and uniq attributes so
there are certainly possibilities for using it.

OTOH input_dev is quite fat and oriented for human interface. It could
made work if you create one device per sensor but devices with X
sensorts per one device (that provide related readings, like a generic
state) would be cludgy... Accelerometers could use ABS_X, ABS_Y.. but
what about other devices? ABS_RAW1, ABS_RAW2? And here we run into the
conceptual problem, as I see it - in input we try to keep meaning of
the event independent from the device it generated. We dont care what
generated ABS_X, ABS_Y, BTN_FIRE - it could be a joystick, gamepad,
something similar. A program can use it if it knows how handle the
above events.  The ABS_RAWx would mean different things for every
sensor... That's what I meant by anonymizing - the application
does not really care about the particular device and where and how it
is connected, but only about its capabilities.

Another thing is that (at least now) input supresses duplicate events,
which may be undesirable for generic data acquisition device.

I suppose it could be made work. I guess the size of input_dev is my
main concern. If you hyave something with hundreds of sensors
input_dev might be too expensive.

> Also, why would you not want all your accelerometers grouped into a set
> of accelerometers? If your application software just searches all input
> devices for anything reporting itself as an accelerometer, then it would
> get the right result... 

I never said I would not want them to be grouped together.

-- 
Dmitry

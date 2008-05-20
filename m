Return-Path: <linux-kernel-owner+w=401wt.eu-S1764989AbYETL2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764989AbYETL2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYETL20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:28:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30626 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbYETL2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:28:25 -0400
Date: Tue, 20 May 2008 13:28:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Accelerometer, Gyros and ADC's etc within the kernel.
Message-ID: <20080520132817.03fb74ea@hyperion.delvare>
In-Reply-To: <4832A211.4040206@gmail.com>
References: <4832A211.4040206@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Tue, 20 May 2008 11:04:01 +0100, Jonathan Cameron wrote:
> This email is basically a request for opinions on how and where such sensors
> should be integrated into the kernel.
> 
> To set the scene...
> 
> Increasing numbers of embedded devices are being supplied attached MEMS
> devices (www.xbow.com imote2 etc). Along with more traditional sensors such
> as ADC's not being used for hardware monitoring, these do not really 
> seem to
> fit with in an particular subsystem of the kernel.  A previous 
> discussion on
> lkml in 2006 considered the accelerometers to be found within some laptop
> hard drives, but I haven't been able to track down any more general 
> discussions
> of such non hardware monitoring sensors.
> 
> The obvious possibilities are:
> 
> * To place the various drivers within the spi / i2c etc subsystems as 
> relevant.

Bad idea. Grouping drivers by connectivity is almost always the wrong
thing to do, as it means that different persons will maintain them and
they have all chances to diverge. You really want to group drivers by
functionality. On top of that, I am busy enough maintaining the i2c
core and bus drivers without having more i2c device drivers added to my
plate. These days I am trying to _empty_ drivers/i2c/chips, if anything.

> * To place within the hwmon subsystem as this is probably closest.
> (there is already at least one straight ADC driver in hwmon)

Probably not the wisest choice, if nothing else, because the hwmon
maintainer is already overloaded. And I don't think that these devices
have much in common with the traditional hardware monitoring components
anyway.

I'm not sure what "straight ADC driver" you are referring to, but
anything which measures a voltage and exports the reading to user-space
is, well, a voltage sensor, and thus fix within hwmon. If the same chip
is used for a higher-level, dedicated function then we would probably
have a separate driver for it, outside of hwmon.

> * To create a new subsystem, or perhaps merely sysfs class to contain these
>   elements.

Would be OK. Or:

* Place these within the input subsystem. You might want to discuss
this with the input subsystem maintainer Dmitry Torokhov (Cc'd). The
Wii remote is essentially a joystick, and joysticks belong to the input
subsystem.

> Typical requirements within an application include simply polling for 
> current
> readings, and using device triggered interrupts to grab data 
> continuously to a
> ring buffer, for collection by suitable userspace code.  Obviously it 
> would be
> desirable to standardize sysfs controls for various calibration 
> parameters as
> much as possible across the various devices.
> 
> Any other suggestions welcome!

This all sounds quite different from our hwmon drivers. Our hwmon
drivers read all the sensor values at once and cache the readings for a
couple seconds, so you can't get an instant reading at any time, and
they also don't support interrupts in general.

-- 
Jean Delvare

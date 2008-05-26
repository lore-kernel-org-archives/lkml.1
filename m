Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYEZQXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYEZQXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYEZQXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:23:36 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:33224 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYEZQXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:23:35 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <483AE40C.60204@gmail.com>
Date: Mon, 26 May 2008 17:23:40 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [spi-devel-general] Accelerometer,	Gyros and ADC's etc within
 the kernel.
References: <4832A211.4040206@gmail.com>	<20080520132817.03fb74ea@hyperion.delvare> <200805211752.15670.david-b@pacbell.net> <48353E45.2080903@cam.ac.uk>
In-Reply-To: <48353E45.2080903@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

This email is intended to summarize the results of the discussions over
the last week or so and to open up to further comments on the way foward.

The original question was related to garnering opinions on how and where to
support devices such as accelerometers, gyros, general purpose ADCs (and
possibly DACs).  Typical interfaces are SPI and I2C, rates varying from 10Hz
to many kHz.  Real time and buffered access needed depending on application.

Conclusions:

 1.  The hwmon subsystem is unsuitable as it is intended to provide
relatively low frequency cached updates of sensor readings.

2. Definitely a bad idea to simply put such drivers in the relevant bus
subsystems due to unmaintainability and probable long term interface
divergence due to differing maintainers.

3. Whilst input subsystem is probably the only place that these sorts
of device could be currently included this would come at the cost of
input_dev being too fat and undesirable anonymization of the devices

4. Some stuff to be learned from comedi project (www.comedi.org).
Based on a quick browse of their documentation it looks like there
may be  stuff to learn on what sort of userspace interfaces are interesting
but the drivers themselves are (as Matt originally stated) io-port based.

5. General consensus seems to be on a new subsytem (we'll bash out a
suitable name later - for now I don't want a name effectively guiding
the functionality!)

What's next

Obviously the exact functionality of this subsystem is going to be somewhat
up in the air until we have a wide range of devices supported.

The minimum needed seems to be a control interface to configure the devices
and some level of event interface (similar to input subsystem) to 
indicate to
userspace programs that something of interest to them has occured.
As configuration of the devices is a relatively infrequent event
(at least in the applications I work with), it seems to me that a 
suitable sys
interface, under a new class would provide this.

Types of parameter:

Chip related:
read/write -- Offsets, gains, sensor biases.
read only -- Factory set versions of the above, version numbers etc.

Mode related:
Some chips will operative in buffered and unbuffered modes.
Things like single ended vs differential modes on ADCs.

Interface related:
Like the input subsystem, things like parameters of an associated character
device, and the type of events this may return.  This would allow different
complexities of event depending on what is going on.  Down the line this 
may
allow the turning off and on of individual events as appropriate. For 
example,
if no-one is interested in an interrupt event such as freefall detection 
of an
accelerometer then depending on hardware support we may be a) able to turn
it off and free the relevant interrupt, or b) simply free the relevant 
interrupt
and ignore the event.

Simple read of current value:
As the devices will not always be generating interrupts, it probably 
also makes
sense to have interfaces here to get the current values of readings.   
Either this
will be from a cached value in an interrupt providing device, or 
actually initialise
a read from the device if appropriate.

The other interface element would be a stripped down /dev/ device 
similar to those
used by the input subsystem.  However, it may make sense to have an 
independent one
of these for each and every chip present?  Does it make sense to ever 
aggregate these,
or should this effectively be left to select calls in the userspace 
code?  There is also an
issue here of whether we want to group similar devices.  I.e. should we 
group all
accelerometers? My personal view is, not at the moment as it would 
complicate the
handling of devices combining several types of sensor.

The fun bit of this subsystem will be in how buffering of incoming data 
is accomplished.
As an example, lets say we want a 100Hz set of readings from the device. 
Several
possibilities exist:

a) The device itself has a ring buffer (the VTI accelerometers are an 
example of this). 
If this is the case, how would people suggest we go about reading from 
the ring buffer in
the event of an interrupt (typically 3/4 full).  We could have a the 
kernel module interpret
this interrupt and effectively fill a ring buffer in the kernel from the 
hardware one.  This
is efficient on interrupts and the kernel based ring buffer could have a 
size controllable
through the sys interface. 

b) The device triggers an interrupt on each 'data ready' after sampling 
some analog
measurement.  Do we generate an event on each of these? (seems like 
overkill to me)
or again use a ring buffer in the kernel to store the results and 
perhaps send an event
out after a (sysfs interface controlled) number of readings.  If a near 
real-time app is
wanting the data, then this would be set to zero to indicate need to 
send an event on each
reading. The ST LIS3L02DQ accelerometer falls into this category.  
Complexities here
are concerned with the need to look directly at the relevant gpio value 
in order to establish
whether another even has occured before the bottom half of the interrupt 
has run. See
the LIS3L02DQ driver I posted to the spi-devel mailing list for an example.

c) The device samples only on a request over the bus.  Either these 
could only be read
from via the sysfs interface or an event sent through the dev character 
device. 
Also feasible would be a board specific element of the platform_data, 
perhaps specifying
functions to initialize a hardware periodic clock interrupt or similar
(I've done this before, but it was clunky - at high rates you frequently 
miss interrupts.)
The MAX123x and MAX1363 ADCs fall into this category.

Obviously the challenge in all this is to keep the number of interrupts 
and indeed events (in
the input subsystem sense of sending to userspace via a char device) to 
a minimum.

For other issues such as time stamping, whilst vital, to a certain 
extent may need to be
handled within largely within the individual drivers (due to the 
different types of read above).
Clearly the subsystem should provide helper functions for this wherever 
possible.

All comments welcome and thanks to everyone who contributed to the 
original discussion.


--

Jonathan Cameron

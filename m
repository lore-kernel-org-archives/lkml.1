Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZERLha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZERLha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZERLhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:37:17 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:36453 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbZERLhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:37:14 -0400
X-Greylist: delayed 5144 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2009 07:37:13 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A114862.8030104@cam.ac.uk>
Date: Mon, 18 May 2009 11:37:06 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: felipe.balbi@nokia.com
CC: ext Kim Kyuwon <chammoru@gmail.com>,
       ext Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Kim Kyuwon <q1.kim@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       "Gross, Mark" <mark.gross@intel.com>,
       jketreno <jketreno@linux.intel.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com> <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com> <20090515200235.GA11829@nokia.com> <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com> <20090518091236.GH4443@nokia.com> <4A11344B.3000405@cam.ac.uk> <20090518103130.GK4443@nokia.com>
In-Reply-To: <20090518103130.GK4443@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> Hi,
> 
> On Mon, May 18, 2009 at 12:11:23PM +0200, ext Jonathan Cameron wrote:
>> Hi All,
>>
>> Firstly sorry for lack of response, my email filters hid this in a
>> folder I don't read often!
>>
>> I've copied in a few other people I've discussed similar things with
>> in the past. (sorry if guys if you were getting this via the mailing
>> list anyway!)
>>
>> To give you my background, I'm generally interested in sensors
>> attached to mote's (ultra small linux machines) which tend not to
>> have user interfaces as such and hence supporting these things for
>> input is for a matter of interest rather than requirements. 
> 
> You're right here...
> 
>> Whether it makes sense to write unified drivers for my types of uses
>> and input is still an open question.
> 
> I guess iio could provide 'links' to other subsystems where applicable.
> 
>> If you are interested in iio, there's a git tree at
>> http://www.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
> 
> cloning :-p
Not entirely sure that's up to date. I'll check, though I'm going
top be out of the office for the next couple of days.

I'll regenerate the tree sometime next week as it's gotten to the point
where there are lots of minor fixes to code that was never reviewed
in the first place. As a temporary stop gap, I've pushed my development
tree to the 'mess' branch.
If you want to see it in used in anger, take a look at the imote2-linux
tree:
http://www.kernel.org/pub/scm/linux/kernel/git/jic23/imote2.git
which is using the current version up to a few comment clean ups.
(board config as relevant is in arch/arm/mach-pxa/imote2.c)
Currently that's my only user, but the userbase of that have been
doing a fine job of finding bugs!

>> and a draft of a white paper at:
>>
>> www-sigproc.eng.cam.ac.uk/~jic23/iio.pdf
> 
> Printed
Enjoy the typo's (really ought to have spell checked that ;)
> 
>> This was very much one of the thinks IIO was designed to address.
>> One thing to keep in mind is that the framework
>> was not intended to replace input / hwmon if they are the appropriate places
>> for a given driver. In fact one of the conclusions of the discussions linked
>> above was that, in cases where an accelerometer (or other sensor) serves
>> different purposes in different devices it may make sense to actually provide
>> more than one kernel driver. (obviously sharing code where appropriate.
> 
> why not one kernel driver exporting the device through different
> subsystems ?? Otherwise we'd need to fake it's a multifunction device,
> right ?!?
I'm actually beginning to wonder if going down that route might not be the right
way to go.  Some elements of the IIO approach already effectively do this. For
example the lis3l02dq driver provides an iio:device which handles stuff like the
general interrupts (threshold detection etc) and an iio:trigger that is driven from
the data ready signal (allows you to trigger other sensors at the 'same' time as
the accelerometer).  The other option is to have drivers with a lot of Kconfig
options.  We don't want to require input / hwmon support be built into the kernel
if they aren't relevant to the given platform.
>> There have been a few off list discussions about how to provide a 'query' type
>> function so as to allow very different sensors to be used transparently by user
>> space.  HID was suggested, but to my mind isn't necessarily the way to go. I'm
>> very much of the view that the kernel should expose enough parameters for userspace
>> to be able to figure out the 'calibration' type stuff.  This would be in a similar
>> fashion to that used by hwmon.  I'm not sure I've gotten in right in IIO.
>>
>> If things are chip specific then it's simply a case of discussing naming / parameter
>> conventions on the relevant list and keeping definitions in driver. When they start
>> turning up on lots of chips then they get moved into a 'device type header'
> 
> right
> 
>> Agreed.  If you know a given accelerometer is only going to be used for
>> input then that's where the driver belongs.  However, these chips are
>> generally capable of a lot more and it tends to be annoying specific.
>> Take for example things like calibration offsets, and for the really fun
>> cases on chip event driven ring buffers?  These really don't fit into
>> your classic input cases.
> 
> but that'll never be the case. It can be used as input only in my device
> but what about yours ? That's why we need ways to make the driver as
> generic as possible so it can be used for several applications.

Yes, I entirely agree.

>> I'd also argue the problem here is that you are going to end up with a
>> large class of similar devices.  If you start directly adding accelerometers
>> to Input then the same arguement applies to magnetometers, bend sensors,
>> gyroscopes etc.  Also beware that many accelerometers are going to be wired
>> up to adc's (rather than providing digital outputs) so you'll need some
>> framework to specify this connectivity. (open area in IIO to and the moment).
> 
> sure, I agree with you here.
It may be that we need something along the lines of how ASoC handles connectivity,
but that's complex to say the least and may be massive overkill.

It would certainly ramp up the learning curve needed to write a driver.

>>> So let accelerometer drivers use both APIs of hwmon and input
>>>> subsystems(hwmon_device_register, input_register_device,
>>>> input_register_polled_device). Acutally this is what many
>>>> accelerometer drivers in current Linux kernel are doing, so we don't
>>>> have to do much.
>>>>
>>>> Let's
>>>> 1) Introduce a new maintainer of accelerometer (Felipe?).
>>>> 2) Move accelerometer drivers in current Linux kernel to /driver/accelerometer.
>>>> 3) If we find the common functions of accelerometer or have idea about
>>>> new API or Macro, let's make at driver/accelerometer/acccelerometer.c,
>>>> input/linux/acccelerometer.h file or modify input.h little.
>>>> 4) Add every new accelerometer into /driver/accelerometer..
>>  > How about extending these to several kinds of sensors ??
>> Yup, lots out there - and lots of them don't fit into your nice clean categories.
>>  Why not having
>>> a sensor framework that abstracts the creating of the input_dev for
>>> accelerometer ?
>> In my view too limited.  (which is where IIO came from in the first place!)
>> Just because their primary use in your applications is input doesn't mean
>> that's going to be the case in future.
> 
> well, I'm thinking mostly about accelerometers, mostly. But same comment
> applies to magnetometers, those can't be exported through input, that
> one doesn't make sense at all, so how to export it ? and when that's
> defined, make iio export helper functions for registering such devices..
Actually I'd argue that a magnetometer is no worse than an accelerometer.
In the low acceleration case (which assumed by most games) and low magnetic
distortion case (probably fair in many apps). The acceleration points down,
whilst the magnetic field points in a different direction. If you really want
orientation info, then one of the standard ways to get an estimate is to
pair 3d accelerometer with 3d magnetometer.  Still that's not terribly relevant
to this discussion!

Anyhow, two options for exporting this.  Either we do it via sysfs (probably
polled) or via a character device under /dev/...

Not entirely sure what makes best sense in an 'input' style case.
IIO currently uses chardev's for event passing where events are not normal
data cases. Chardev's are also used for ring buffer access (take into account
that increasingly sensors are providing some internal buffering to cut down
the load on the host cpu). n.b. Events in input tend to correspond to 'we have
a new reading and it is x' as well as button presses.

In an input situation you tend to want a single chrdev from which to read a
class of data (hence aggregation that occurs in input) whilst caring little
about what sensor produced it whereas for the apps I was targeting, knowing
which sensor is providing the data is vital hence a given device has up to
(typcially) 3 chrdevs.  1 is for hardware events (threshold detectors etc),
1 for ring buffer events (50% full etc) and 1 for ring buffer access.
(note this required dynamic allocation / deallocation of chrdevs)  It
may make sense to add a 4th which corresponds much more closely to that provided
by input and will block until a reading is available.  Obviously this only
works if the device either uses an internal clock, or some other trigger
source is used (e.g. periodic triggers) to prevent userspace from driving
the device to be read more often that is sensible.

Lots of fun and games!

Glad interest in this stuff is picking up.  From the iio perspective, I'm
in the process of expanding the driver set considerably which should help
pin down a few of the open questions about interfaces.

When looking at the code, it is crucial to remember that not all devices
will be expected to make use of all of the facilities it provides. Minimal
driver support is designed to be as slim as possible.

Jonathan



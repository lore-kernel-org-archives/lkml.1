Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZEUMJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZEUMJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 08:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZEUMJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 08:09:27 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:35568 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZEUMJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 08:09:26 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A153E3E.8090509@cam.ac.uk>
Date: Thu, 21 May 2009 11:42:54 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kim Kyuwon <q1.kim@samsung.com>
CC: felipe.balbi@nokia.com, Kim Kyuwon <chammoru@gmail.com>,
       ext Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Jean Delvare <khali@linux-fr.org>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       "Gross, Mark" <mark.gross@intel.com>,
       jketreno <jketreno@linux.intel.com>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>
Subject: Re: [RFC] Add Input IOCTL for accelerometer devices
References: <20090515131636.GE4443@nokia.com> <5d5443650905151106v2fe7ad1ci6c966463a991e732@mail.gmail.com> <45cc95260905151230j5485995dpbbd882dc91b25339@mail.gmail.com> <20090515200235.GA11829@nokia.com> <4d34a0a70905180045u6619773dt1563fe38b13d46fb@mail.gmail.com> <20090518091236.GH4443@nokia.com> <4A11344B.3000405@cam.ac.uk> <4A125265.6040509@samsung.com>
In-Reply-To: <4A125265.6040509@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyuwon, 


Kim Kyuwon wrote:
> Hello Jonathan,
> 
> Jonathan Cameron wrote:
>>>>> Yeah, let's try to define the best way to expose accelerometers with
>>>>> linux kernel and avoid a sysfs hell. Better sooner than later.
>>>> Felipe,
>>>> Can I ask why did you say "avoid a sysfs hell"?. I have thought Kernel
>>>> developers prefer sysfs to IOCTL lately.
>>> For sure sysfs is prefered, but I meant that without a proper
>>> abstraction or definition of how to export the device, each device
>>> driver write will export sysfs nodes as they want and that's really bad
>>> since we create the 'userland interface'. If it's messed up from the
>>> beginning, it's gonna be like that for ages.
>> This was very much one of the thinks IIO was designed to address.
>> One thing to keep in mind is that the framework
>> was not intended to replace input / hwmon if they are the appropriate
>> places
>> for a given driver. In fact one of the conclusions of the discussions
>> linked
>> above was that, in cases where an accelerometer (or other sensor) serves
>> different purposes in different devices it may make sense to actually
>> provide
>> more than one kernel driver. (obviously sharing code where appropriate.
> 
> I can't understand this:
> "in cases where an accelerometer (or other sensor) serves different
> purposes in different devices it may make sense to actually provide more
> than one kernel driver. (obviously sharing code where appropriate."
> Was the conclusion "Make a framework(iio) which can do various functions?"
No, the conclusion was to wait and see if this is practical. It was kept in
mind during the several iterations of design of IIO, but the focus of
development was always high performance capture and handling all the facilities
of these highly variable sensors as consistently as possible.

I guess now we are in a position to see if it is indeed practical to add input
support. 

> 
>>>> input_allocate_polled_device, ...) and macros(ABS_X,  ABS_Y, ...)of
>>>> Input subsystem are useful to accelerometer too. If we create another
>>>> APIs and Macros for accelerometers, I think It's another duplicate
>>>> work and result.
>> beware of the fact that x,y,z aren't exactly cleanly defined for a given
>> sensor!
>>> for sure
>> Agreed.  If you know a given accelerometer is only going to be used for
>> input then that's where the driver belongs.  However, these chips are
>> generally capable of a lot more and it tends to be annoying specific.
>> Take for example things like calibration offsets, and for the really fun
>> cases on chip event driven ring buffers?  These really don't fit into
>> your classic input cases.
> 
> I can't understand why you inserted ring buffers related stuffs in iio.
>  Please let me understand in easy words. And please note that in
> /Documentation/SubmittingPatches
Because the hardware I have uses hardware ring buffers e.g. VTI SCA3000 series,
analog adxl345.  More and more sensors are moving this way as without a true
real time os, it's the only way of ensuring high data rate data is available
for sophisticated almost real time processing.  You can't afford to have gaps
in your data.

 Also, for my primary application (fast, consistent capture
from a number of different sensors) this is the simplest design that provides
the performance needed.  We spent a lot of time trying to do this in other
ways.
> 
> 644 4) Don't over-design.
> 645
> 646 Don't try to anticipate nebulous future cases which may or may not
> 647 be useful:  "Make it as simple as you can, and no simpler."

The are useful. I'm using them in real applications every day.  It might not
be your use case but it is a number of other peoples (some of whom are cc'd
above).

The absolutely crucial thing about the design is that if you don't want ring
buffers, then don't use them (by which I mean don't compile them in - it's a
modular design so if you don't want them you don't have to have them.)
In the first instance I probably wouldn't be pushing that element into the kernel.
As you are illustrating this is controversial and needs a thorough discussion.

At that point the whole system reduces to  much simpler core which handles
the sysfs interface registration and management of chrdevs associated with events.
At this level it's fairly similar to input, but without the event aggregation and
with things like event escalation and dynamic chrdev allocation.

>>>> In conclusion,
>>>> We need the inheritance concept in the object-oriented programming.
>>>> Accelerometer device sometimes can be hwmon device, sometimes input
>>>> device.
>> I'd also argue the problem here is that you are going to end up with a
>> large class of similar devices.  If you start directly adding
>> accelerometers
>> to Input then the same arguement applies to magnetometers, bend sensors,
>> gyroscopes etc.
> 
> I already answer this issue in previous mail that I sent.
> 
>> Also beware that many accelerometers are going to be wired
>> up to adc's (rather than providing digital outputs) so you'll need some
>> framework to specify this connectivity. (open area in IIO to and the
>> moment).
> 
> I can't understand. Why we should make accelerometer(or sensor)
> framework relate to ADC?
There are a couple of reasons:
1) Accelerometers are effectively analog sensors wired up to an ADC. As such
they share a lot of common features.

2) Many real accelerometer rigs out there actually use a pair of chips,
so as far as Linux is concerned you are talking to an adc not the accelerometer
on the other side. Handling this case is still an open issue and it was to this
that I was referring above.
  
> My two accelerometer are not in this cases. 
Indeed not.  But many others are and here we are talking about a general
framework.
> If really sensors are related to ADC, it's better make this as library or
> application.
That is an open question.  There are cases where it would have to be done
in kernel (where both the accelerometer and the adc have separate control
interfaces). 

 Why don't we to be simple. Please let me understand in easy
> words.
> 
> Let me ask a few question in conclusion.
Firstly thanks for sending this driver, its always enlightening to see
how people have handled such a device.  Out of interest, have you
posted this to the input list?  I'd be interested to see what their
comments are.

> 1) Does your iio subsystem have all functions which attached kxsd9
> driver has? i.e.
> a. works in polling mode
Yes,
> b. works in interrupt mode
No, but only because I was utilizing it as an example of a minimalist driver.
See the lis3l02dq driver in the git tree for how it would be extended.

Firstly, beware, the interrupt case for this chip is very different to the more
common cases where the interrupt in question indicates the availability of a new
reading.

As a more general comment, I'd also argue that the reading you
take on interrupt is irrelevant. The event was the threshold pass, not the
value of the reading. It should be up to userspace to decide if it cares what
the reading is and if it does, it has a polling mode with which to read it.
As I read the data sheet, the device isn't storing the accelerations at
interrupt, so the value you are reading is not relevant to the event at all, but
typically will be another reading.

I like the code you have for bringing it up from low power mode to grab a current
value and then go back to sleep. I haven't seen this functionality in many chips.

There are a couple of ways that it could be handled.
1) Register the MOTLat event to be passed up to userspace and let userspace take
   a reading via the normal poll modes. (pretty much what would happen in input)

2) Configure this as and IIO trigger which would allow it to be used to 'trigger'
   the reading of a number of other sensors as well as the acceleration.

It should be possible to support both of these but as per your earlier comment
about not adding features until they are needed, I'd advocate only supporting the
first option until the someone needs the second.

> c. provide an interface to user space in order setting a few parameters
> and read x, y, z variances.
Yes, via sysfs.
 
> 2) How long will it take to your iio subsystem is merged into mainline?
Not sure - I still don't have enough reviewers. As far as I'm concerned, bar
changes relating to reviews it's been ready for merging for a couple of
months.  Since the last posting that got almost no responses the only changes
have been minor changes and comment clean ups.

My intention is to shortly seek advice on how to go about doing this, but
my current feeling is that it will have to be done in stages.  The idea
is that each stage will involve a relatively small code base and hence
be easier for reviewers to handle.  The white paper was written to assist
with this process by providing an overview of how everything links together
without reviewers having to read the full code.

1) The core functionality.   This gives us something very close to input with
the principal changes as described above.

2) A set of example drivers

At this point we will have a common framework against which to merge new drivers.

3) The advanced features (triggering and ring buffering)

4) The drivers for devices requiring 3.
 
> I have quick review of you iio subsytem. Sorry but I think it' somewhat
> complicated and have a lot of functions which are still not needed.
By you - I repeat that I have been using this system in anger for about 6
months now.  I only know of one bit of functionality in there that I'm not
currently using (the first of the trigger lists) and that is simply because
I haven't completed the driver that uses it as yet and dropping it would be
a trivial change.
> And
> it seems like your coding style doesn't look like Linux coding style
> that I'm familiar with.
As far as I know the code absolutely conforms to every coding style
convention of the kernel.  The version in the 'mess' branch has a few comment
clean ups as a result of checking the kernel doc comments.  If you have
specific examples please send them on and I'll be happy to clean them up.
> 
> I just hope we can add some accelerometer feature into mainline kernel
> as soon as possible ;)
I agree.  The stop gap solution (which a number drivers have taken) is to put
them in drivers/misc on the basis that when we do have an agreed system we can
then move them over at a later date.  I have already offered to do the
conversions for a number of such drivers when iio gets merged.

Jonathan

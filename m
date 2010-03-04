Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0CDLRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 06:17:06 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:60090 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab0CDLRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 06:17:03 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B8F9727.6080907@cam.ac.uk>
Date: Thu, 04 Mar 2010 11:19:03 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dima Zavin <dmitriyz@google.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
References: <4B8C1867.7040201@cam.ac.uk>  <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>  <alpine.LFD.2.00.1003030859360.3627@localhost.localdomain>  <20100303184132.GA11471@core.coreip.homeip.net>  <alpine.LFD.2.00.1003031045390.3599@localhost.localdomain>  <20100303190753.GB11471@core.coreip.homeip.net> <404ea8001003031338j34847961jd8a7114bbc45603a@mail.gmail.com> <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003031348510.3599@localhost.localdomain>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> On Wed, 3 Mar 2010, Dima Zavin wrote:
>>
>> Actually, accelerometers fit into that model fine. They have some
>> variable number of absolute axes (3, 6, etc.).
> 
> In fact, they obviouslya also do end up being used exactly like joysticks 
> in real life, and joysticks are commonly starting to have accelerometers 
> in them (ie any modern game console controller).
> 
> So treating an accelerometer like a joystick - regardless of whether it 
> happens to be internal to the device or happens to be external in a 
> separate controller - is not all that far-fetched anyway.
True enough if you want relatively low rate data either polled or from an
internally clocked accelerometer. So yes, if your application is input and
you are using an accelerometer for such a job, then it makes sense to be in
input.  That is exactly why Dmitry has taken some accelerometers in there.
It isn't true if you are dealing with higher spec devices.  There are devices
out there that will throw data at many KHz with lot of different channels,
these are totally different from what input was designed for.  The deepest
discussions of these points that I know of are those that IIO grew out of:
http://lkml.org/lkml/2008/5/20/135 onwards.

These in conjunction with ADC's etc were why we got into writing IIO in the first
place + the entirely reasonable point that they fell out of the scope of input
and hwmon.

Anyhow, the way this conversation is going there appear to be several options
and we need to make a decision before anyone wastes much more time.

1) ALS as is. It's extremely light weight and can always be merged with a better
  option at a later date. If people prefer we can always stick it in a subdirectory
  called sensors or similar.  Perhaps move hwmon in there as well.

2) Input.  I agree with Dmitry here.  These devices are not within the scope as it
  currently exists.  It can be done and there have been numerous discussions about
  doing so in the past (with various sensor types) and each time it has been decided
  that it isn't the right option.  Perhaps opinion on this has changed?

3) Leave as is. Perhaps move all such drivers to misc and introduce some documentation
   in an attempt to standardize the interface they export.  To all intents and purposes
   this is the core of als anyway.  What we loose is a consistent location and device
   naming for userspace usage.

4) Move them into IIO.   They are within the scope we are covering.  I agreed
  with the ALS subsystem when it was proposed as it was clean small and ready now
  not because I particularly wanted them out of IIO (there is still one there.)
 
Two comments on option 4:
a) If we do it now rather than taking one of the other options and moving them later,
   then we are moving two perfectly good drivers out of the main tree into staging.
   Doesn't matter to me, may to others.
b) If anyone comes back later and says, 'IIO is a massively overweight subsystem for
   such simple drivers', then I reserve the right to get rather somewhat annoyed.
   We have always kept the core driver requirement (that needed for these drivers)
   as slim as possible.  Of course suggestions on how to make it slimmer without
   breaking other functionality are welcome.

Please can anyone who feels like suggesting another general sensors subsystem
at least taking a look at IIO (and keeping in mind we are in the middle of a big
API cleanup).  If you disagree with how we have done things, then contribute
to the discussions and they may change.

Thanks,

Jonathan

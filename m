Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbXIRIjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbXIRIjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXIRIjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:39:48 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:39570 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbXIRIjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:39:46 -0400
X-Greylist: delayed 1197 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 04:39:46 EDT
Message-ID: <46EF8A1F.7040309@foks.8m.com>
Date: Tue, 18 Sep 2007 04:19:43 -0400
From: Jelle Foks <jelle@foks.8m.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Alan Cox <alan@redhat.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
References: <46C1BCC5.9090709@amd.com> <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com> <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com> <20070913131353.GB26972@linuxtv.org> <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com> <46E95C54.4060502@gmail.com> <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com> <46E99F36.8090809@hauppauge.com> <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com> <20070914135237.GB19311@devserv.devel.redhat.com> <d9def9db0709140918m4eff0fe9if01c3383a3a5c3ce@mail.gmail.com>
In-Reply-To: <d9def9db0709140918m4eff0fe9if01c3383a3a5c3ce@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> On 9/14/07, Alan Cox <alan@redhat.com> wrote:
>> On Fri, Sep 14, 2007 at 01:17:05AM +0200, Markus Rechberger wrote:
>>> what stops vendors of using the current existing code to achieve that
>>> goal. They could provide binary drivers with the existing API.
>> If you feel lucky about the GPL
>>
>>> What stops companies to intercept the ioctl calls and overriding some
>>> I2C commands?
>> The GPL - derivative work is the boundary not code linkage. Possibly a
>> userspace
>> tuner hack would probably fit this too. Especially if a specific vendor is
>> producing both bits together and trying to claim they are independant.
>>
>>> How about proprietary video formats, would you also place the decoding
>>> algorithms in kernel  just to force companies to release their code
>>> for it?
>> No, I would assume they'd provide a proprietary conversion library that
>> no nobody would use (just like their hw). We keep format conversion firmly
>> seperated from hardware I/O processing.
>>
> 
> In general there are known formats available, the drawback is that every TV
> application deals with it in a non-unified way at the moment, meaning alot
> code duplication in userspace since there's no library available at the moment
> which does the videoconversion from one to another format. Such a library is
> beeing developed at the moment which gets plugged infront of accessing
> the devicenodes.

IMHO...

The reason why there is no single 'format conversion library' that
everybody uses is because of the large differences between requirements
for such a thing. The line between 'format conversion' and things such
as a video codec, or image processing is very vague. For example: Some
apps just want compressed video format output. Would video compression
be part of such a 'format conversion library'? If so, then which
compressed video formats? Proprietary ones too? If not all formats that
exist are supported, it would not be complete for some or many apps, and
maybe not even useful at all (because integrating any necessary
pixel-format conversion into the compression routines may be more
efficient than making multiple passes over the data with separate
libraries). Will the library include resizing? If so, which resampling
algorithms? Then how about rotation? Then maybe geometrical mapping
(games could want that)? Will the library be able to adjust
brightness/contrast/saturation in software? If so, then what about noise
filtering (which algorithms?), etc... perhaps the library should go all
the way, bind to port 80 and serve-up a live video stream
'youtube-style'? ok, now that would definitely go too far...

The question is: Where exactly to put the boundary?

My point is that format conversion is not a video capture driver issue.
Sure, it is convenient for apps to be able to use standard libraries
that perform certain functions with optimized code, etc, but for the
purpose of capturing video (media) it's not always necessary to convert
the output into something different before the data is useful for an app.

Certain format conversions can be done very efficiently inside video
cards, for example, and an app may prefer to use that. If a video card
has such functionality, access to it should be part of its driver.

Applications needing format conversions would benefit tremendously from
a good, powerful, flexible, efficient, etc, library that removes the
necessity for each application to choose between using a video-card
accelerator, or MMX code, or SSE code, or another method to do the work.
Maybe it should allow applications to request a 'media stream' in a
given format and container, with conversion automagically happening when
needed, as efficiently as possible (or at the requested quality level).

But that doesn't mean that that library should be an integrated part of
the video capture interface. The boundary of the 'media capture
interface' driver should be on the data, as delivered by the video
capture interface.

The reason is that the 'best' way to do format conversions depend on the
application requirements (what formats can the app use directly?), on
the available hardware (is there an accelerator that can help?), and on
the quality expectation or system issues (is the CPU the bottleneck or
is the USB bus saturated? Do we request JPEG from the webcam and
decompress into YUV, or do we request the RAW bayer from the
high-quality image sensor and convert that into YUV?). Choices, choises...

That means that IMHO, to prevent having runaway complexity plus chasing
a moving target, format conversion should definitely not be embedded in
the API to access video capture hardware, unless the hardware itself
offers format conversion functions (for example, as it does now, by
allowing choice of the output format, but only for formats that the
hardware itself supports directly).

> Although in the long run I'm looking forward to reuse the userspace tuners with
> such a library infront of everything by using i2c-dev.
> This would also make it easy to reuse the sample code of several companies,
> without having to cut out several features of the drivers and to rewrite them
> to an inkernel format.

It may make things 'easy' if it makes it easy to use existing (?) code
from other sources, but that's not a reason why such an interface is
technically superior. For example, 'ndiswrapper' makes it very easy to
use certain wireless card drivers, but that doesn't mean (by far) that
ndiswrapper's method results in the best wireless card drivers for Linux.

It sounds to me that your approach is more similar to ndiswrapper, for
practical reasons 'this is how I can make it work with less effort' than
it is similar to a full-blown Linux driver 'this is the best way to make
a reliable and efficient driver for this kind of hardware'. Linux
_users_ may need to use ndiswrapper right now, but Linux itself needs
real drivers, not a compromise.

Just my 2cts...

Jelle.

> 
> Markus
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 



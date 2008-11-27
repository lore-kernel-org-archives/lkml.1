Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbYK0EZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbYK0EZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 23:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYK0EZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 23:25:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:27596 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYK0EZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 23:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RU30t6/FGULv2ThIGYP6wJ7vxw6ozQGHUpWjPYKMc7glPlT8ny8hQMoop96PAiFBPW
         ZEQ2MH4VrlPUHVyFMjEocYmh10XM14Q2UO6BgMPRUNsEWfCjtrvXsxOlwaISU6MXZ0Ji
         7ZNopdx5I53y0+A7U8NtBiKpnj6APk9rWjsWA=
Message-ID: <d9def9db0811262025v5d1b0df4h3855cb6023be2cf7@mail.gmail.com>
Date: Thu, 27 Nov 2008 05:25:36 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Aidan Thornton" <makosoft@googlemail.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <c8b4dbe10811261112w6cbbec73mb468870f206d9f97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <20081022220903.GA15278@kroah.com>
	 <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
	 <c8b4dbe10811261112w6cbbec73mb468870f206d9f97@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 8:12 PM, Aidan Thornton <makosoft@googlemail.com> wrote:
> On 10/22/08, Markus Rechberger <mrechberger@gmail.com> wrote:
>> On Thu, Oct 23, 2008 at 12:09 AM, Greg KH <greg@kroah.com> wrote:
>>> On Wed, Oct 22, 2008 at 11:14:36PM +0200, Markus Rechberger wrote:
>>>>     em2880-dvb:
>>>>     * supporting the digital part of Empia based devices, which
>>>> includes ATSC, ISDB-T and DVB-T
>>>
>>> <snip>
>>>
>>> Doesn't this driver duplicate some of the existing devices we already
>>> support with the current in-kernel driver?  If so, why not just add the
>>> new device support to the existing driver instead of duplicating
>>> everything?
>>>
>>> This is going to cause a big problem for distros as they will not know
>>> which to enable, so they will probably just disable this one, which is
>>> what I don't think you want to have happen :(
>>>
>>
>> the current driver doesn't support most devices which are in there,
>> also the alsa
>> audio driver can easily crash the whole system. (It's my code so I
>> know what was wrong there).
>>
>> The core video code is already too much off, the VBI code added alot
>> complexity
>> to it it does frame slicing on the fly.
>>
>> Those devices ship VBI+VIDEO within 1 datastream, VBI and Video aren't
>> that different
>> in the system. both interfaces provide framebuffers through a mmap'ed
>> interface.
>> If all the VBI buffers are filled the data has to be sliced off in any
>> case while providing
>> the same bottom data ot the Video interface
>
> Hi,
>
> Just to check, your driver does handle this correctly now, right? Last
> time I checked, it was a buggy mess with severely broken locking that
> caused a kernel panic half the time when recording whith MythTV (and
> indeed, had been for years). It looks, at a glance, like this may have
> been fixed, but since I never quite managed to pin down the exact
> cause, I can't say for sure.
>

the exact cause was that the vbi buffer handling was connected with
the video buffer handling
back then. It crashed at certain scenarios.
VBI has been reworked completely since then, also the offsets. It's a
hardcoded em28xx - videodecoder setup.

> (The code is, alas, still somewhat ugly compared to the existing
> videobuf-based code in the in-kernel driver - it should be possible to
> add VBI support to that fairly cleanly and easily. I actually
> attempted this a while back, but ran into issues due to not having
> access to the datasheets. Of course, the fact that Markus works there
> and is actively aggressive to any Linux driver development that
> doesn't go through him.)
>
>> http://mcentral.de/hg/~mrec/em28xx-new/shortlog (there are more than
>> 200 changelog entries
>> what happened in detail).
>>
>> The development has been split off (first due limitations in the
>> kernel, afterwards due ..., and finally
>> due the restriction that all that has to work without a framework
>> upgrade on the eeePC).
>
> This doesn't exactly inspire confidence; it seems to basically mean
> you forked or rewrote existing drivers rather than just using code
> that was already there.
>

well I initially worked on that driver since 2005(!) and at least
helped more than
thousand users to get their devices work.

>> diffing the 2 available drivers shows up that only the core is twice
>> as big as the one which is currently
>> in the driver (the result of 2-3 years asynchronous development).
>
> Actually, part of the reason for this is probably that there's a
> massive bunch of video buffer handling code in your driver that mostly
> repeats stuff handled by the videobuf module in the in-kernel driver.
> (Admittedly, your does slightly more in that it handles raw VBI, but
> as I've said it should be possible to do that cleanly and in a smaller
> amount of code using videobuf.)
>
>> The driver is currently also tested with signal generators (different
>> inputs, and different video standards).
>>
>> Very likely the best would be to replace the available driver with it
>> but I don't care, alot people use and have been using the driver from
>> mcentral.de for a long time, development has always been opensource
>> there too.
>
> Just not necessarily open source under a GPL compliant license, as I recall.
>

I pointed out a couple of times that the license is no issue with the
exported sources.

> As I've said before, it'd be really nice if you'd make an effort to
> actually integrate your changes, but this looks like more of the same
> old mess.
>

The driver has been exported so far, that's all I'll ever offer. In
future to avoid those clashes I'll
simply use the i2c-dev framework which is commonly available and
allows to control
those chips from userland without any extra module. We already have a
player which
is optimized for those devices and also properly supports that interface.

I simply don't have the time for those games anymore, and those people
here who have personal
issues with me and/or my work don't pay my monthly bills, neither do
they have any clue how that
driver is used with some systems of certain customers. I constantly
deliver full solutions, and not
driver code only. Neither am I limited to Linux only.

Markus

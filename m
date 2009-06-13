Return-Path: <linux-kernel-owner+w=401wt.eu-S1760406AbZFMKG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760406AbZFMKG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZFMKGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:06:18 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:49210 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbZFMKGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=okgg+9gP9jvDGkymCAd7WLMk+qX83gWStshs+9qd3RYMtv1Sif0/elkt1w2zqHXi0P
         VoDe4DJPVC5hmHFEUcnMNwcllH2Qc+mGeUbNf3z75qa22Zl/WdaISY5u7BiG0DErD5gx
         JSFDlNiScvGUV4TtCegGdomA2XuNZnu6H8sBg=
MIME-Version: 1.0
In-Reply-To: <4A337251.7010705@tuffmail.co.uk>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
	 <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com>
	 <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com>
	 <4A337251.7010705@tuffmail.co.uk>
Date: Sat, 13 Jun 2009 12:06:18 +0200
Message-ID: <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via 
	the input layer
From: Corentin Chary <corentin.chary@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Darren Salt <linux@youmustbejoking.demon.co.uk>,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 11:33 AM, Alan
Jenkins<alan-jenkins@tuffmail.co.uk> wrote:
> Corentin Chary wrote:
>>
>> On Mon, Jun 8, 2009 at 5:24 PM, Alan
>> Jenkins<sourcejedi.lkml@googlemail.com> wrote:
>>
>>>
>>> On 4/4/09, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>>
>>>>
>>>> On Fri, Apr 03, 2009 at 06:57:50PM +0100, Darren Salt wrote:
>>>>
>>>>>
>>>>> This maps the brightness control events to one of two keys, either
>>>>> KEY_BRIGHTNESSDOWN or KEY_BRIGHTNESSUP, as needed.
>>>>>
>>>>> Some mapping has to be done due to the fact that the BIOS reports them
>>>>> as
>>>>> <base value> + <current brightness index>; the selection is done
>>>>> according
>>>>> to
>>>>> the sign of the change in brightness (if this is 0, no keypress is
>>>>> reported).
>>>>>
>>>>> (Ref.
>>>>>
>>>>> http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2009-April/002001.html)
>>>>>
>>>>> Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
>>>>>
>>>>
>>>> The reason I didn't do this is that the Eee changes the input brightness
>>>> in hardware, which means reporting it via the input layer as well can
>>>> cause a single keypress to raise the brightness by two steps - one in
>>>> hardware and one triggered by userland's response to the key press. I'd
>>>> be a little bit wary of this causing problems.
>>>>
>>>> On the other hand, the default behaviour of the acpi video driver is to
>>>> change the brightness itself and then also to send the even to
>>>> userspace, so I guess if it was going to break things it probably would
>>>> have done already...
>>>>
>>>
>>> Actually, I think userspace has learnt to hack around it but it
>>> doesn't work perfectly.  I would like to request that this change be
>>> reverted, or otherwise improved.
>>>
>>> Before this patch (2.6.29.4), gnome-power-manager doesn't interfere
>>> with the brightness keys, and they work smoothly.
>>>
>>> After this patch (2.6.30-rc7), g-p-m produces a "nice" popup in the
>>> middle of my tiny netbook screen.  Unfortunately it can't be disabled,
>>> but that's not your fault :-).  The brightness controls generally work
>>> ok.  It doesn't jump two steps in response to one brightness keypress.
>>>  But:
>>>
>>> 1) If I'm thrashing the SSD.  I get jerky after-effects, where g-p-m
>>> seems to take too long to "catch up" with the brightness change.
>>>
>>
>> There is the same "lag" problem with sound :/
>>
>
> Yeah :/.  At it's worst, it isn't a pure "lag".  It's a bit harder to
> explain.  The firmware still changes the brightness immediately.  It seems
> that when g-p-m gets delayed, it responds _wrongly_. It doesn't realize that
> the firmware already changed the brightness, so it changes the brightness
> again.
>
> That's why I think this is a bad "feature".  User-space is working around
> it, but the workaround isn't reliable.  I think the proper solution is that
> if userspace wants to respond to firmware-initiated brightness changes, it
> should listen for uevents on the brightness class device.
>
> You can see the problem most clearly by pressing the brightness keys in
> quick succession e.g. 3 times in a row, and see 3+3 brightness changes.  I
> reproduced this with
>
> 1) 2 writers:
>   F=1; while true do dd if=/dev/zero of=$F bs=1M count=1 conv=sync; done &
>   F=2; while true do dd if=/dev/zero of=$F bs=1M count=1 conv=sync; done &
>
> 2) 1 reader:
>   dd if=/dev/sda of=/dev/null
>
> 3) Drop caches before pressing the brightness keys
>   echo 1 > /sys/proc/vm/drop_caches
>
>
>>> 2) If I go all the way down from full (holding down the "brightness
>>> down" key), and then back up a few steps.  I get a noticable flash
>>> where the brightness looks to go up two steps, then down one.  It's
>>> probably most noticable here because the step change between the
>>> lowest and the second lowest brightness is much more visible than any
>>> of the other steps.
>>>
>>>
>>
>> I tried to install gnome-power-manager to test that, but there is no
>> "popup".
>> What do I have to install to test that ? entire gnome desktop :/ ?
>>
>> Thanks
>>
>
> That's weird.  I'm running it from KDE here (g-p-m package version 2.22.1-4
> on debian stable).  I'm pretty sure the only other GNOME app I have
> installed is Pidgin.  I would know if I had much more installed, because I'm
> often running short of disk space :-).
>
> Maybe you have a newer version, that doesn't try to do such unreliable
> things?
>
> Thanks for your time
> Alan
>
Hum .. running g-p-m as root, I can get the popup, strange
Version: 2.24.2-2ubuntu8
Ok I can reproduce that.

I want to check if we can't fix g-p-m before reverting the patch. If
there is no way to fix it, I'll revert.

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org

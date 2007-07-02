Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbXGBLlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbXGBLlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 07:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXGBLk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 07:40:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:12299 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbXGBLk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 07:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=o3Mr3BLokmpUoasa1VlaHdsHKmpCChuz1dKoP9aUpYhah7lopSKo2U2INOwNsIp/Lqlr5Lxl1Wk3489N5yGTWU1+3Lto0psiAnNvgLA46ymfs+na5XI3dcE+yuiwz1bLULR41uYMwNO3rH2M0zInp1JGrC1NxP3NSVUDbQD5VlM=
Message-ID: <4688E495.6010004@gmail.com>
Date: Mon, 02 Jul 2007 15:42:13 +0400
From: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [linux-usb-devel] [PATCH] PXA27x UDC driver.
References: <20070628103619.GW13886@enneenne.com> <200706281453.23414.david-b@pacbell.net> <4684CAF7.9050201@gmail.com> <200706300646.14399.david-b@pacbell.net>
In-Reply-To: <200706300646.14399.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Friday 29 June 2007, Dmitry Krivoschekov wrote:
>> David Brownell wrote:
>>> On Thursday 28 June 2007, Rodolfo Giometti wrote:
>>>
>>>> As suggest by Leo let me propose to you my new patch for PXA27x UDC
>>>> support.
>>>>
>>>> Please, let me know what I have to do for kernel inclusion. :)
>>> Let's start with *JUST* a driver, not trying to update everything
>>> else in the USB Gadget stack so that it looks like it's designed
>>> specifically to handle all of Intel's design botches related to
>>> endpoint config ... and work worse for essentially everything else.
>>>
>>> (Unlike pretty much every other vendor, Intel wanted hardware config
>>> management. It was unusably buggy in pxa21x/25x/26x, and not much
>>> better in pxa27x.)
>>>
>>>
>>> So in technical terms, and to repeat what I've said before: just
>>> configure it to act more like a PXA 25x chip (no altsettings) and
>>> get it so it passes all the tests [1], modulo errata which have no
>>> workarounds
>> Other options are:
>>
>>     1. pre-program endpoints so the setting covers all gadget
>>        configurations, it seems it's feasible. The only appreciable
>>        change is, CDC Ethernet config number should be 3 instead of 1.
>>        It should not break anything.
>
> ISTR looking at this in some detail a few years back, and
> concluding that it wouldn't quite work.  That was before
> started to hear back from people that the pxa27x hardware
> didn't really match its documentation, too ...
>
>
>>     2. Implement a FAKE call of GET_CONFIGURATION command so upon
>>        gadget binding you can issue the command and program endpoints
>>        according to the received gadget configuration.
>
> That would involve *multiple* such fake calls.  Not the most
> elegant of solutions, but ISTR using it in some other context.
>
> But again, that presumes sane hardware, or at least hardware
> that matches the docs.  And people who've looked at this in
> more pain than I have are consistent in telling me that pxa27x
> endpoint configuration has problems that the docs and errata
> do not describe.  (If it were just one person, rather than four
> different developers, I'd be somewhat skeptical.)  Hence my
> eventual conclusion (and advice) to just stop trying to use
> that misfeature.
>

Actually it's nor a feature nor a misfeature, i.e. you can't just
disable it, so you can't stop using it. The only default
endpoint is ep0, other endpoints need to be configured. So,
if you want to use some static endpoints setting, you will
have to program this configuration and you can't avoid
endpoint configuration stage. That is, you may always
run into that configuration problems. Thankfully,
personally I haven't faced the problems. I used number 1 option
plus some logic that reshuffle ep list so appropriate
endpoints to be chosen by usb_ep_autoconfig(). It's not
a perfect solution but, it worked at least with three gadgets
g_ether, g_serial, g_file_storage. To be honest I dislike
the solution but it seems it's the only way to avoid changing
of gadget files.

If I could change gadget files, probably I'd modify gadgets
..._bind calls so on pxa27x  they  don't use usb_ep_autoconfig
but just pass USB descriptor to device driver but device
driver, in turn, configures the controller according to
the descriptor.


>  
>> Also, considering that PXA3XX processors include PXA27x-compatible
>> USB device controller it makes sense to develop a driver that
>> will support both processor families. Hopefully PXA3XX arch
>> support will be merged some day (the arch support has been already
>> submitted here, but I don't know about its current status).
>
> Has someone actually signed up to develop and maintain such a
> controller driver?  If so, that would be a Fine Thing, but not
> one I've heard rumored before.  I've assumed that the best we'd
> have is someone (Rodolfo?!) finally cleaning up a pxa27x version
> so it could be merged.
>
>
If it was just a cleanup I think we would have the driver long time
ago. Unless we decide to make some appropriate changes to gadget files,
I doubt we will see the driver in mainline kernel.


Regards,
Dmitry



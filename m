Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYCaRGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYCaRGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYCaRGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:06:06 -0400
Received: from rtr.ca ([76.10.145.34]:2155 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbYCaRGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:06:04 -0400
Message-ID: <47F119FA.2030604@rtr.ca>
Date: Mon, 31 Mar 2008 13:06:02 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <200803311704.37256.oliver@neukum.org> <47F0FD8E.4090005@rtr.ca> <200803311837.30129.oliver@neukum.org> <47F1196E.9090509@rtr.ca>
In-Reply-To: <47F1196E.9090509@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Oliver Neukum wrote:
>> Am Montag, 31. März 2008 17:04:46 schrieb Mark Lord:
>>> Oliver Neukum wrote:
>>>> Am Montag, 31. März 2008 16:39:33 schrieb Mark Lord:
>>>>
>>>>> One thing I just tried, was to unload all USB stuff before suspend,
>>>>> and reload on resume -- just stuck the commands into my 
>>>>> suspend/resume script.
>>>>>
>>>>> The machine has been 100% rock solid since then.
>>>>> So I think that definitely implicates USB.
>>>> Yes. What happens if you unload only usbhid at that time?
>>> ..
>>>
>>> Mmm.. interesting choice, there.  I'll try that.
>>>
>>> There is another quirk on this machine that might confuse
>>> software that's not robust:  the internal Bluetooth adapter
>>> is USB connected, and I normally have it disabled (BIOS hotkey).
>>> So it normally is "not present".
>>>
>>> But on any power-on / resume, it briefly powers up and becomes 
>>> "present",
>>> and, after a second or two, the BIOS powers it down again, "not 
>>> present".
>>>
>>> Just long enough for software to notice it and try talking to it.
>>> If that software is not carefully coded, it might get confused.
>>>
>>> This has not been a problem before, but perhaps with the new USB 
>>> autosuspend code?
>>
>> hci_usb doesn't have any autosuspend code.
>>
>>>>> Still want USB_SUSPEND=n ?  Please explain.
>>>> It looks like you are hanging in the kthread for autosuspending.
>>>> Compiling that out should confirm it.
>>> ..
>>>
>>> Okay, and once we see that it works fine:  then what?
>>
>> We'll combine that information with the result of only removing usbhid
>> and arrive at a pretty good idea where in the kernel the hang occurs.
>> There are only two functions that touch autosuspend in the usbhid code.
>> So if it works with usbhid unloaded, either of them should be to blame.
> ..
> 
> Thanks!
> 
> It does still hang with *usbhid* unloaded,
> but not if all USB stuff is unloaded.
> I'm still working my way through the rest of the suggestions here,
> and USB_DEBUG=n is next.
..

Correction.. USB_SUSPEND=n is next.
 
> I have figured out a way to make this much more reproducible now:
> When suspended, the notebook does not supply +5V over USB.
> But with a voltmeter, I discovered that there is sufficient capacitance
> on the USB +5V, that it takes many minutes for the voltage to decay
> from 5.1V down to near 0V.
> 
> Resuming while the voltage is still relatively high, generally works.
> Resuming after the voltage drops to near zero, always fails (with USB 
> modules loaded).
> 
> So I've put a 2Kohm resistor across the USB +5V lines,
> forcing it to decay to zero within about 5 seconds.
> This helps a lot for debugging here.
> 
> It probably also provides a vital clue as to what is wrong.
> Resume seems to generally work when the USB devices maintain
> some amount of standby power, and always fails when they don't.
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


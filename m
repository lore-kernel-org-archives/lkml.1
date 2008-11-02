Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYKBLPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYKBLPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 06:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYKBLPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 06:15:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:44248 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYKBLPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 06:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=n+luvPuKv48+uhKzyhwzp17WCPKscl8aOYmHkMwuhvmzWGfLToPAvrSIh74xf35wD+
         uXVCWSrC//aHxWT/OJD9w7ivaBviQOQhLqREoZCrHRcFNAhRYFnq6UgQPoEmFeM20ecL
         CQfHL9TlMRfuVRC4f77jfGaEB+JOyj3S66hPY=
Message-ID: <490D8C4E.3010201@tuffmail.co.uk>
Date: Sun, 02 Nov 2008 11:17:34 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net>
In-Reply-To: <20081102040008.GB29606@khazad-dum.debian.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> On Fri, 31 Oct 2008, Alan Jenkins wrote:
>   
>>> Documentation/rfkill.txt implied otherwise
>>>       
>
> Then we need to make it more clear.
>
>   
>>>     You should:
>>>         - rfkill_allocate()
>>>         - modify rfkill fields (flags, name)
>>>         - modify state to the current hardware state (THIS IS THE ONLY TIME
>>>           YOU CAN ACCESS state DIRECTLY)
>>>         - rfkill_register()
>>>       
>
> At which point rfkill core will KICK your device to the state it wants it to
> be, so if you lied on the state, you are screwed. I mean it.
>
> You want rfkill_set_default(), and only because it is a platform driver
> storing state across shutdown.
>
>   
>>> Admittedly it doesn't say "and I promise not to gratuitously override
>>> the state on registration".  Buti t seems weird though, to override the
>>> value on registration 
>>>       
>
> No, it is EXACTLY what it should do.  It is setting policy for a class of
> switches (actually, controllers. Call it a switch and you confuse it with
> input devices).  It is not "enabling the radio" by default, it is setting
> the radio rfkill controllers to the same state that all other rfkill
> controllers on radios of that type currently are at.
>
> And there is rfkill_set_default() for *platform* drivers to influence that,
> when the platform has a better idea of the proper initial radio rfkill
> state.
>
>   
>> Ah, I see.  Wrong end - of course the *rfkill device* doesn't have
>> useful state.  The persistent state belongs to the *rfkill switch* - it
>> could even be a physical switch.
>>     
>
> Of course it has useful state. Set it to whatever the rfkill controller
> state really IS at that point.  And it HAS persistent state, but the core
> will govern it to match the system-wide policy.
>
>   
>> And now it's clear what was missing from the conversion to rfkill:
>>
>>     2. Input device switches (sources of EV_SW events) DO store their
>>     current state
>>     (so you *must* initialize it by issuing a gratuitous input layer
>>     event on
>>     driver start-up and also when resuming from sleep)
>>     
>
> No.
>
> You *ARE* to send gratuitous input layer events for SWITCHES quite often,
> e.g. on every call to the switche's connect() handler, and also often after
> system-wide stuff like resume (when state could have changed without you
> being able to notice it) because you *HAVE* to tell the input layer which is
> the initial/real state of the switch.  If this is not clear, the input layer
> needs some doc tweaking. Please feel free to send a patch to Dmitry.
>
> But that has nothing to do with the rfkill core.  You MUST NEVER try to
> change rfkill core state through the input layer from inside the kernel.
> NEVER.
>
> rfkill_input is NOT part of the rfkill core, and rfkill_input is the ONLY
> thing that cares about input events that match one of the "rfkill" input
> events.  And it *is* optional.
>   

Thanks for beating the clue into me. Part of the problem was I thought 
the "toggle wireless" key on my keyboard somehow counted as a "switch" 
input - but it doesn't, it's clearly just a normal "button" input.


Did you have any thoughts on the hibernation case? It's possible for the 
rfkill state to change while hibernated. You can boot into a different 
OS, or change it in the BIOS setup screen. At present the rfkill core 
overrides the change on resume.

Personally I don't care. Hibernation plus dual-boot or BIOS setup can 
already break in lots of exciting ways.

But I wonder if there are laptops where the BIOS handles rfkill by 
default, but the OS takes over on boot. Thinkpads? Then you could toggle 
the rfkill without going into the BIOS setup screen.

Actually, I think you could also do it if the resume kernel loads e.g. 
eeepc-laptop before it loads the hibernation image. That's the strongest 
argument I can think of.

Thanks
Alan

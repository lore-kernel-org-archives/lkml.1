Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbXBLA7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbXBLA7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932594AbXBLA7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:59:54 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:9764 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbXBLA7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:59:53 -0500
Date: Sun, 11 Feb 2007 18:59:24 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
In-reply-to: <fa.AaJ/ugmiUmPO8uC+y1rS9JLuuMc@ifi.uio.no>
To: Tilman Schmidt <tilman@imap.cc>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: nigel@nigel.suspend2.net
Message-id: <45CFBBEC.2090407@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
 <fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no>
 <fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no>
 <fa.O1YH4k5KtBGCNs5i2yB17bPvPGw@ifi.uio.no>
 <fa.RfzClbTP/7B79AoEbQLNj3ABfIk@ifi.uio.no>
 <fa.AaJ/ugmiUmPO8uC+y1rS9JLuuMc@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
>>>> If your device requires power management, and you know it requires power
>>>> management, why not just implement power management? [...]
>>> Like it or not, power management is far from trivial, and people
>>> writing device drivers have limited resources. [...]
>> It's not that complex. All we're really talking about is a bit of extra
>> code to cleanup and configure hardware state; things that the driver
>> author already knows how to do. S3 might require a bit more
>> initialisation if firmware needs to be reloaded or more extensive
>> configuration needs to be done, but if there's firmware to be loaded,
>> there is a reasonably good probability that we loaded it from Linux to
>> start with anyway.
> 
> You are assuming a perfect world where driver authors have complete
> knowledge of their devices. In reality, many drivers (including
> those I have the mixed pleasure of maintaining) are based at least
> in part on reverse engineering, and managing power states may well
> fall into the domain of things not yet sufficiently reverse
> engineered.
> 
>>> Also, in your argument you neglected a few cases:
>>> - What if my device does not require power management?
>> Then you as a generic routine that does nothing but return success
>> (potentially shared with other drivers that are in the same situation).
> 
> But if I just write an empty routine like that I open myself up to
> criticism along the lines of "writing dummy routines just in order
> to shut up kernel warnings". BTDT.

Well, it couldn't actually be an empty routine (at least not for a PCI 
device), since the generic PCI suspend/resume handling doesn't get 
called if you have suspend/resume functions defined, so you'd have to do 
the pci_save_state, pci_disable_device, pci_set_power_state, etc. in 
there at least. Using empty functions would prevent those from being 
called and result in your PCI config space contain crap after resuming, 
which can break the whole system.

That's a bit messy, actually.. I know we can't just do that stuff 
unconditionally in the PCI layer since some devices blow up if you 
disable them, which we normally do, etc. We should just have some 
generic function you can stick in the .suspend slot that just says "I 
know how to suspend, but don't need anything more than the generic 
handling". And if you do need more than that (which is almost always the 
case), you can just call that from your own function and then add what 
you need, instead of duplicating the code a million times (sometimes in 
an incomplete/incorrect fashion) like we do now.

>>> - What if I don't know whether my device requires power management?
>> The questions are straight forward: Is there hardware state that needs
>> to be configured if you've just booted the computer and nothing else has
>> touched it? If so, that needs to be done in a resume method. Do you need
>> to clean up state prior to doing the things in the resume method, or
>> otherwise do things to quiesce the driver? If so, they will need to be
>> done in the suspend method. The result will be roughly similar to what
>> you do for module load/unload, except maybe less complete in some cases.
> 
> I don't doubt your basic assessment. However it doesn't translate that
> easily into a real implementation. In my case, I maintain a USB driver,
> so I have to deal with USB specifics of suspend/resume which happen not
> to be that well documented. My driver provides an isdn4linux device but
> isdn4linux knows nothing about suspend/resume so I am on my own on how
> to reconcile the two. The device itself, though in turn far from trivial,
> is actually the least of my worries.

That is one good excuse for not implementing it - the driver is part of 
a framework which does not handle suspend/resume itself. (The current 
FireWire stack is another case like this.) This is the kind of situation 
where I would say the driver should just define a suspend function that 
returns -ENOSYS and then the user would know they have to remove that 
module, etc. before suspending (there is at least some distro script 
support for doing that automatically based on a config file), since it 
hasn't a hope of working after resume until the framework is updated to 
support suspending.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


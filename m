Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbYCEBNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbYCEBNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYCEBMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:12:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51125 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYCEBMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:12:22 -0500
Message-ID: <47CDF339.3060304@jp.fujitsu.com>
Date: Wed, 05 Mar 2008 10:11:21 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de> <20080304230937.GD3694@ldl.fc.hp.com>
In-Reply-To: <20080304230937.GD3694@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

Sorry for the delay in responding.

> It wasn't the IBM machine that was breaking; it was Fujitsu. They
> were returning an error code (the numerical value 1023) when I
> called the _SUN method on a slot object that existed in the ACPI
> namespace but was not present (as reported by the _STA method).
> 
> By the time I got that error report, I'd already dropped the
> duplicate name detection code, and was letting the kobject
> infrastructure warn about duplicate names because for my test
> cases, refcounting was a better solution.
> 
> [Kenji-san from Fujitsu seemed to be ok with the progress I'd
> made at the time, he can speak up if he's changed his mind ;)]

Unfortunatelly, I have not tried the new version of slot detection
driver because of the lack of test environment. Maybe we need more
several days to wait for test environment. 

BTW, does the new one fixes the issue I reported before? I could not
find it in the changelog. IIRC, this issue was difficult to solve
because the root cause of this issue is from the difference of
interpretation of ACPI spec between HP and Fujitsu (I still don't
think it's a good idea to evaluate _SUN for the device object whose
_STA is 0).

Anyway, Fujitsu servers which suffer from this issue doesn't need
the slot detection driver because its PCI slots are all hot-pluggable
and it already has /sys/bus/pci/slots/XXXX directory for all PCI
slots. So one of the workaround is to not use slot detection driver.
But when I tried it before, it was automatically loaded at boot up
time and then I got strange slot named '1023' and many warning
messages (stack traces).

Thanks,
Kenji Kaneshige



Alex Chiang wrote:
> * Greg KH <gregkh@suse.de>:
>> On Tue, Mar 04, 2008 at 10:18:28AM -0800, Jesse Barnes wrote:
>>> On Monday, March 03, 2008 9:49 pm Greg KH wrote:
>>>> On Sat, Mar 01, 2008 at 07:43:07AM -0700, Matthew Wilcox wrote:
>>>>> On Fri, Feb 29, 2008 at 09:25:42PM -0800, Greg KH wrote:
>>>>>> What is the guarantee that the names of these slots are correct and do
>>>>>> not happen to be the same as the hotpluggable ones?
>>>>> That would be a bug -- and yes, bugs happen, and we have to deal with
>>>>> them.
>>>> My main concern is that BIOS vendors will not fix these bugs, as no
>>>> other OS cares/does this kind of thing today.  The ammount of bad
>>>> information out there might be quite large, and I think this was
>>>> confirmed by some initial testing of IBM systems, right?
>>> Yeah, but there's a flip side to this too:  if no one uses the data, no one 
>>> will complain when it's wrong.  If Linux starts making it easy to see this 
>>> stuff, there's a chance system vendors will start taking an extra 5 min. 
>>> before shipment to make sure that the BIOS info is up to date...
>>>
>>> OTOH, I'm not sure which is worse, bad data or no data.
>> bad data is worse.
>>
>> And then there's the machines with duplicate slot names, how does this
>> code handle PCI slots with that?  I think some of the IBM machines had
>> non-hotplug slots named the same as the hotplug slots, right?
> 
> At one point, I had some code in there to stick the names of the
> slots into a linked list and walk through it to try and detect
> duplicate slot names, but after a few iterations, the cases I was
> dealing with, it turned out to be easier to refcount them.
> 
> [my machines did not have colliding names between hp and non-hp
> slots, it was more like seeing the same SxFy object appear
> multiple times in the namespace and trying to create them
> multiple times.]
> 
> It wasn't the IBM machine that was breaking; it was Fujitsu. They
> were returning an error code (the numerical value 1023) when I
> called the _SUN method on a slot object that existed in the ACPI
> namespace but was not present (as reported by the _STA method).
> 
> By the time I got that error report, I'd already dropped the
> duplicate name detection code, and was letting the kobject
> infrastructure warn about duplicate names because for my test
> cases, refcounting was a better solution.
> 
> [Kenji-san from Fujitsu seemed to be ok with the progress I'd
> made at the time, he can speak up if he's changed his mind ;)]
> 
> But even that is not the error case you're describing, where
> there is clear name collision of two physical slots in the
> machine, one being hotplug, the other non-hotplug.
> 
> Maybe I would have to add some duplicate name detection code back
> in there but...
> 
>> This stuff needs a _lot_ of testing on a lot of different
>> machines, and a sane way to fall-back if there are errors to
>> ensure that working machines don't break.
>>
>> And then there's the issue with userspace programs only expecting
>> hotplugable slots in the slots/ directory...
> 
> Yes -- totally agreed. And I'd like to see actual examples of
> name collisions or userspace breakage to get a better idea of how
> to handle real world problems rather than writing some crummy
> code based on what my limited imagination can think of.
> 
> So how to get this test coverage? -mm? linux-next?
> 
> Thanks.
> 
> /ac
> 
> 
> 



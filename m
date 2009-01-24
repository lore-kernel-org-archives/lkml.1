Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbZAXN45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbZAXN45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 08:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZAXN4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 08:56:48 -0500
Received: from mail-ew0-f10.google.com ([209.85.219.10]:60547 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZAXN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 08:56:47 -0500
X-Greylist: delayed 9949 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jan 2009 08:56:46 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ltbMpRhF/VDStduMhurUACkYP12ldtq8QU1KESygYsoB/rs4o+x9N5QhEWMYu5a7El
         i+a0bp1RWd3THoOgWqIXZi8BWnPAwo07oQ64Hz8B+BfkYCC2XIpCWWF7pyeQ5k2yCTci
         +chIVf+QEx7LN6SM5g8TpStd/bJI1ehHzrbX0=
Message-ID: <497B1F21.3080908@tuffmail.co.uk>
Date: Sat, 24 Jan 2009 14:01:05 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@suse.cz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: BISECTED: 2.6.29-rc2 regression: hibernation hang on eeepc-701
References: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com> <200901232306.33309.rjw@sisk.pl> <497AF845.2000002@tuffmail.co.uk> <200901241443.14930.rjw@sisk.pl>
In-Reply-To: <200901241443.14930.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday 24 January 2009, Alan Jenkins wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>> On Friday 23 January 2009, Alan Jenkins wrote:
>>>   
>>>       
>>>> Rafael J. Wysocki wrote:
>>>>     
>>>>         
>>>>> On Thursday 22 January 2009, Alan Jenkins wrote:
>>>>>   
>>>>>       
>>>>>           
>>>>>> Rafael J. Wysocki wrote:
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>>> On Thursday 22 January 2009, Alan Jenkins wrote:
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>>>> Alan Jenkins wrote:
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>>>> Hibernation hangs just after writing the image.  With s2disk I can see
>>>>>>>>> this from the console messages.  The same hang happens with kernel
>>>>>>>>> swsusp ('echo disk | sudo tee /sys/power/state'), and I can see that
>>>>>>>>> the image has been written from the HDD led.
>>>>>>>>>
>>>>>>>>> In either case, I can still hard-power-off and resume from hibernation.
>>>>>>>>>
>>>>>>>>> It doesn't hang if I use the shutdown method (either 'echo shutdown |
>>>>>>>>> sudo tee /sys/power/disk' or  's2disk -P "shutdown method=shutdown"').
>>>>>>>>>   
>>>>>>>>>       
>>>>>>>>>           
>>>>>>>>>               
>>>>>>>>>                   
>>>>>>>> I've bisected this to commit 571ff7584bb9e05fca0eb79752ae55a46faf3a98. 
>>>>>>>> It doesn't revert cleanly from RC2.
>>>>>>>>
>>>>>>>> I think it's distinct from the other two reported suspend regressions. 
>>>>>>>> I'm not using acpi-cpufreq, and the issue doesn't affect resume.
>>>>>>>>     
>>>>>>>>         
>>>>>>>>             
>>>>>>>>                 
>>>>>>> It looks distinct.
>>>>>>>
>>>>>>> Do you suspend this box to RAM and does it work?
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>> Yes, I do use STR on it occasionally, and it still works in RC2.
>>>>>>
>>>>>>     
>>>>>>         
>>>>>>             
>>>>>>> Please retest with the appended patch applied.
>>>>>>>   
>>>>>>>       
>>>>>>>           
>>>>>>>               
>>>>>> That fixes it.
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> OK, it won't hurt to apply it.
>>>>>
>>>>> Still, the hardware or the BIOS in your box seems to be broken, or both, so I'd
>>>>> like to debug it a bit more if you don't mind.
>>>>>
>>>>> Can you please test the patch below instead of the previous one?
>>>>>   
>>>>>       
>>>>>           
>>>> It hangs at the same point as the unpatched RC2.  As before, it doesn't
>>>> hang if I use "shutdown" instead of "platform".
>>>>
>>>> Going by sysfs, I have 4 PCI devices without a kernel driver.
>>>>
>>>> 8086:2592   Mobile 915 Express Graphics Controller
>>>> 8086:2792   Mobile 915 Express Graphics Controller (driven by X)
>>>> 8086:2448   82801 Mobile PCI Bridge
>>>> 8086:2641   82801FBM (ICH6M) LPC Interface Bridge
>>>>     
>>>>         
>>> The bridges shouldn't be affected, so I bet on the graphics.
>>>
>>> It seems that the BIOS doesn't expect it to be in D3 while entering S4,
>>> although it apparently doesn't mind it to be in D3 while entering S3.
>>>
>>> I blame the Asus BIOS writers. ;-)
>>>   
>>>       
>> Wouldn't Windows normally put it into D3?
>>     
>
> It need not put it into D3hot if it's going to remove power from it.
>
>   
>> There are many reports of successful hibernation under Windows on this
>> hardware.  The motivation being that S3 drains the battery in <24 hours.
>> (Fewer people hibernate on linux because you only have a 4G SSD, so a swap
>> partition wastes a lot of space, and most installers can't set up swap
>> files).
>>
>> Also it sounds like it would break when the linux kernel mode setting 
>> driver is used.
>>     
>
> Why would it break?  This is the last phase of hibernation, right before
> powering off things.
>   

If I have a kernel mode-setting driver, won't that bind to the graphics 
device?  Then the device would be power managed, so it would trigger the 
same problem.

I guess I can test this rather than speculating.  If my concern is 
valid, then using intelfb should have the same effect.

> However, since we didn't power manage devices
> without drivers during hibernation before the patch that broke it for you, I
> think we can safely go back to doing this.
>   



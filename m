Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYGVFuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYGVFuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760981AbYGVFs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:48:26 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:43938 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760969AbYGVFsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:48:24 -0400
Message-ID: <488574CF.7010501@suse.de>
Date: Tue, 22 Jul 2008 09:49:03 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Michal Hocko <mstsxfx@gmail.com>
CC: power@bughost.org, arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Why is /sys/class/power_supply/CMB1/energy_now not exported?
References: <20080721041213.GA3491@dhcp35.suse.cz> <48841AE3.3000004@suse.de> <20080721165921.GB3491@dhcp35.suse.cz> <4884F98F.4060903@suse.de> <20080722030412.GA5969@dhcp35.suse.cz>
In-Reply-To: <20080722030412.GA5969@dhcp35.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like you use current_now as power, not multiplying it by voltage.
You should either not multiply anything, then you have similar units -- charge and current,
or multiply _both_ by voltage_now, then again you have similar units -- power and energy.
In these both cases you'll have hours or remaining capacity.

Michal Hocko wrote:
> [fixing bad linux kernel mailing list email address - sorry, but gmail's
> thrown mailing delivery error to the spam]
> 
> On Tue, Jul 22, 2008 at 01:03:11AM +0400, Alexey Starikovskiy wrote:
>> Hi Michal,
> 
> Hi Alexey,
> 
>> the charge_now part of your patch seems to be correct, but the
>> calculation is somehow broken --
> 
> I have made some experiments and the result is quite surprising to me.
> It seems that this problem is somehow related to Debian distribution
> kernel, because I wasn't able to reproduce it with the Vanilla kernel (I
> had to screw something up last time when I have checked that and
> reported in the original message).
> 
> I have tried 3 configurations:
> * 2.6.25 - Vanilla kernel with config-2.6.25 config and result output in
>   powertop-2.6.25-good
> * 2.6.25-2 - Debian distribution kernel with config-2.6.25-2 config and
>   powertop-2.6.25-2-bad output
> * 2.6.26 - Vanilla kernel with config-2.6.26 config and result output in
>   powertop-2.6.26-good
> 
> with the following scenario (powertop patched with attached
> charge-read.patch):
> * wait for /sys/class/power_class/CMB1/status FULL on AC
> * get values from all files in ..CMB1 to output file
> * unplug AC
> * run powertop
> * get values from all files in CMB1 again to the same file
> * get output of power consumption to the output file
> 
> 
>              |  2.6.25          2.6.25-2        2.6.26
> ===========================================================================
> voltage_now  |  12222000        12206000        12218000
> charge_now   |  4850000         4850000         4850000
> current_now  |  1398000         1334000         1313000
> ---------------------------------------------------------------------------
> reported     |  16.6            1.4             16.3
> consumption  |
> ---------------------------------------------------------------------------
> calculated   |  24.5            3.63            3.69
> consumption  |
> ===========================================================================
> 
> Charge value is stable for all 3 configurations and current_now is
> 2.5.25 > 2.6.25-2 > 2.6.26 so I would expect that reported consumption
> is for 2.6.25-2 would be somewhere between values for good
> configurations. 
> 
> If I use your calculation (charge_now/current_now), than the results are
> even more confusing, because 2.6.26 are similar to 2.6.25-2 (but reported
> value is like I would expect).
> 
> Someone has an idea what could be wrong?
> 
>> This is what we have:
>> ./voltage_min_design
>> 10800000
>> ./voltage_now
>> 11900000
>> ./current_now
>> 1609000
>> ./charge_full_design
>> 5200000
>> ./charge_full
>> 4996000
>> ./charge_now
>> 4600000
>>
>> if we do charge_now/current_now, we'll get: 2.86 (hours) or 2 hours 52 
>> minutes.
>> let's now calculate power consumption:
>> voltage_now * current_now = 11900000 * 1609000 / 10^12 = 19.15 W
>> and last, let's calculate remaining battery energy:
>> voltage_now * charge_now = 11900000 * 4600000 / 10^12 = 54.74 Wh
>> and once again, remaining time:
>> 54.74 / 19.15 = 2.86
>>
>> Regards,
>> Alex.
>>
>> Michal Hocko wrote:
>>> [CCing powertop mailing list]
>>>
>>> On Mon, Jul 21, 2008 at 09:13:07AM +0400, Alexey Starikovskiy wrote:
>>>> Hi Michal,
>>> Hi Alexey,
>>>
>>>> Battery can return either energy (voltage*charge) or just charge.
>>>> In your case it returns only charge. You need to multiply by voltage to
>>>> get energy.
>>> Thanks for your information. I was confused that both (CHARGE_ and
>>> ENERGY_) cases were handled by the same value but didn't realize that
>>> the value itself may come from different source.
>>>
>>> Based on your suggestion, I am attaching patch for current powertop
>>> which reads charge_now if energy_now is not present.
>>>
>>> I am not sure whether this is correct, testing on my laptop shows weird
>>> values for current consumption:
>>> Power usage (ACPI estimate): 1.4W (40.7 hours) (long term: 24.4W,/2.3h)
>>>
>>> Even long term value seems to not correspond with the value exported by
>>> KPowersafe which shows 3:18 at this moment. 
>>>
>>> Is there something wrong in the patch or it is just my battery exporting
>>> bad values? Current values from sys are attached too.
>>>
>>>> Regards,
>>>> Alex.
>>>>
>>>>
>>>> Michal Hocko wrote:
>>>>> Hi,
>>>>>
>>>>> I am trying to use powertop on my computer, but I am not able to get
>>>>> power consumption (powertop complains with "no ACPI power usage estimate
>>>>> available").
>>>>>
>>>>> After powertop code reading it seems that problem is that it expects
>>>>> %subj file to be present what is not a case for my Fujitsu Siemens
>>>>> Lifebook S71110 notbebook:
>>>>>
>>>>> /sys/class/power_supply/CMB1 $ find -type f
>>>>> ./uevent
>>>>> ./power/wakeup
>>>>> ./type
>>>>> ./status
>>>>> ./present
>>>>> ./technology
>>>>> ./voltage_min_design
>>>>> ./voltage_now
>>>>> ./current_now
>>>>> ./charge_full_design
>>>>> ./charge_full
>>>>> ./charge_now
>>>>> ./model_name
>>>>> ./manufacturer
>>>>> ./serial_number
>>>>> ./alarm
>>>>>
>>>>> I can see only charge_* files but no energy_* one. 
>>>>>
>>>>> Documentation/power/power_supply_class.txt notes that ENERGY_* and
>>>>> CHARGE_* attributes shouldn't be mixed because of different measurements
>>>>> units.
>>>>>
>>>>> However, It looks like battery module doesn't make any difference when
>>>>> reading values for ENERGY_ and CHARGE_ attributes:
>>>>> drivers/acpi/battery.c:
>>>>> acpi_battery_get_property
>>>>> [...]
>>>>>         case POWER_SUPPLY_PROP_CHARGE_NOW:
>>>>>         case POWER_SUPPLY_PROP_ENERGY_NOW:
>>>>>                 val->intval = battery->capacity_now * 1000;
>>>>>                 break;
>>>>> [...]
>>>>>
>>>>> So the question is, why this file is not exported when the module can
>>>>> provide its value?
>>>>>
>>>>> If this is correct and it somehow depends on BIOS, how should powertop
>>>>> handle such a case when only charge_* files are available?
>>>>>
>>>>> I am using Debian distribution 2.6.25 kernel (but the same issue is
>>>>> present also in Vanilla 2.6.26 kernel).
>>>>>
>>>>> Let me know, if you need some more information.
>>>>>
>>>>> Thanks for any hint and
>>>>> best regards
> 


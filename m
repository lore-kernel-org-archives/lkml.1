Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZJFRFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZJFRFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbZJFRFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:05:52 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:58649 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbZJFRFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DKjEobEjwjf0Y2fevptaMBz4euddv5nPejS1u0TUEGQ4nI9qA44oK/+uUpOFcNDIiw
         gFI1c4otfWpOEbcfEBO3jq3+5Rt0cxC/MFN67MI8fT8T8rNdB1bYGss3ybc1sUDE7iqx
         bk3Lr1oAtcbC7flc/Jmz0ZO+OGT+SWKVzmfZE=
MIME-Version: 1.0
In-Reply-To: <4AC93B45.8090707@suse.de>
References: <1254669853.26496.0.camel@carter>
	 <ca2dc2820910041046i47a1c3dhba82266bb14a440c@mail.gmail.com>
	 <4AC8F02B.6080209@suse.de> <200910042246.23712.rjw@sisk.pl>
	 <4AC91578.2020807@suse.de>
	 <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com>
	 <4AC923F4.9050100@suse.de>
	 <ca2dc2820910041653o29d4b253n69270d231e56e447@mail.gmail.com>
	 <4AC93B45.8090707@suse.de>
Date: Tue, 6 Oct 2009 19:05:13 +0200
Message-ID: <ca2dc2820910061005k2beae176lece9792bb15cda90@mail.gmail.com>
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 2:18 AM, Alexey Starikovskiy
<astarikovskiy@suse.de> wrote:
> Miguel Ojeda ÐÉÛÅÔ:
>>
>> On Mon, Oct 5, 2009 at 12:38 AM, Alexey Starikovskiy
>> <astarikovskiy@suse.de> wrote:
>>>
>>> Miguel Ojeda ÐÉÛÅÔ:
>>>>
>>>> On Sun, Oct 4, 2009 at 11:36 PM, Alexey Starikovskiy
>>>> <astarikovskiy@suse.de> wrote:
>>>>>
>>>>> Hi Rafael,
>>>>>
>>>>> This is not my rule, it was/is the rule of power device class. If you
>>>>> do
>>>>> not
>>>>> agree to it, please change
>>>>> appropriate documentation.
>>>>
>>>> Oh, I did not know that. Thank you for pointing it out. I think you
>>>> are refering to:
>>>>
>>>> š158Q: Suppose, my battery monitoring chip/firmware does not provides
>>>> capacity
>>>> š159 š in percents, but provides charge_{now,full,empty}. Should I
>>>> calculate
>>>> š160 š percentage capacity manually, inside the driver, and register
>>>> CAPACITY
>>>> š161 š attribute? The same question about time_to_empty/time_to_full.
>>>> š162A: Most likely, no. This class is designed to export properties
>>>> which
>>>> are
>>>> š163 š directly measurable by the specific hardware available.
>>>> š164
>>>> š165 š Inferring not available properties using some heuristics or
>>>> mathematical
>>>> š166 š model is not subject of work for a battery driver. Such
>>>> functionality
>>>> š167 š should be factored out, and in fact, apm_power, the driver to
>>>> serve
>>>> š168 š legacy APM API on top of power supply class, uses a simple
>>>> heuristic of
>>>> š169 š approximating remaining battery capacity based on its charge,
>>>> current,
>>>> š170 š voltage and so on. But full-fledged battery model is likely not
>>>> subject
>>>> š171 š for kernel at all, as it would require floating point calculation
>>>> to deal
>>>> š172 š with things like differential equations and Kalman filters. This
>>>> is
>>>> š173 š better be handled by batteryd/libbattery, yet to be written.
>>>>
>>>> We are not calculating anything new just by the pleasure of doing it,
>>>> we are correcting a wrong value provided by the hardware.
>>>
>>> You are guessing that normal battery can not jump charge value, and on
>>> this
>>> assumption you
>>> cap charge_now with last full_charge. Immediate problem is that
>>> full_charge
>>> is not fixed value,
>>> this is why it is separated from design_full_charge.
>>> During battery life full_charge may go down and up, depending on outside
>>> temperature, battery discharge (full or partial).
>>> I've seen batteries on some new machines reporting full charge of more
>>> than
>>> design charge.
>>> Obviously, your patch will fail in some of the above situations.
>>
>> I don't see why. The patch compares against full_charge every time
>> (which is updated as you say), not against design_full_charge.
>>
>> 1. full_charge > design_full_charge => OK, design_full_charge is not
>> involved in the min() operation.
>> 2. full_charge goes down => If charge_now > full_charge then hardware
>> is wrong and we should read full_charge. OK.
>> 3. full_charge goes up => Same.
>
> full_charge_capacity is the value of last full charge. It will be updated to
> current full charge, when the charging is complete. It may end up lower or
> greater than
> previous value.
> Comparing current charge with the last full charge may correctly give you
>>100%.

Then maybe we can write something like...

val->intval = acpi_battery_is_charged(battery)
	? min(battery->capacity_now, battery->full_charge_capacity) * 1000
	: battery->capacity_now * 1000;

So we only use the min() operation when it is fully charged (returning
to 100%) without losing information when charging.

The problem is that percentage may jump from >100% to 100% in
batteries whose full capacity increase, but I think that is OK, since
when completely charged, the >100% is the new 100%.

In "broken" batteries (is it broken finally? or is it expected
behaviour?) like mine the old problem will be corrected, as it was
only present in the charged state.

Still other special cases may appear. What do you think?

> Now we have a decision to make -- do we update full charge to be greater
> than charge now,
> or do we update charge now to be lower than full charge.
>>
>> So, maybe the battery works as you suggested; still, the kernel should
>> provide a common meaning to its interfaces. If some batteries report
>> full_charge when in "charged" state and others report
>> design_full_charge, then the kernel should convert all of them into
>> one unique convention, or there is no sane way to write userspace
>> applications.
>
> I still want to receive raw data from driver, and have 1 level of
> interpreters.
> As I understand, there is HAL, which may do interpretations for you and keep
> it in single location.

AFAIK, the battery plugins I checked read /proc or /sys directly. I
will check other battery plugins too.

>>>
>>> Regards,
>>> Alex.
>>>
>
>

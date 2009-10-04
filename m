Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZJDXx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZJDXx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZJDXxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:53:55 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:58017 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZJDXxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TMtcmpjWL486ELChNV6zBSlQE/POo+Z7pSH1lYVoXYS9b4tu8ureDpznhN/VXykps6
         afHGTt+SqpoV6kF9BaECoSma3V5WSlrHy7Yhoi2Wgu6iMsCoUbqIgN6cJOfX/+A/k8s4
         iGPZ6QlyOajHGoGp/ozg52KAyPudKDrbkgaSo=
MIME-Version: 1.0
In-Reply-To: <4AC923F4.9050100@suse.de>
References: <1254669853.26496.0.camel@carter>
	 <ca2dc2820910041046i47a1c3dhba82266bb14a440c@mail.gmail.com>
	 <4AC8F02B.6080209@suse.de> <200910042246.23712.rjw@sisk.pl>
	 <4AC91578.2020807@suse.de>
	 <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com>
	 <4AC923F4.9050100@suse.de>
Date: Mon, 5 Oct 2009 01:53:16 +0200
Message-ID: <ca2dc2820910041653o29d4b253n69270d231e56e447@mail.gmail.com>
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 12:38 AM, Alexey Starikovskiy
<astarikovskiy@suse.de> wrote:
> Miguel Ojeda пишет:
>>
>> On Sun, Oct 4, 2009 at 11:36 PM, Alexey Starikovskiy
>> <astarikovskiy@suse.de> wrote:
>>>
>>> Hi Rafael,
>>>
>>> This is not my rule, it was/is the rule of power device class. If you do
>>> not
>>> agree to it, please change
>>> appropriate documentation.
>>
>> Oh, I did not know that. Thank you for pointing it out. I think you
>> are refering to:
>>
>>  158Q: Suppose, my battery monitoring chip/firmware does not provides
>> capacity
>>  159   in percents, but provides charge_{now,full,empty}. Should I
>> calculate
>>  160   percentage capacity manually, inside the driver, and register
>> CAPACITY
>>  161   attribute? The same question about time_to_empty/time_to_full.
>>  162A: Most likely, no. This class is designed to export properties which
>> are
>>  163   directly measurable by the specific hardware available.
>>  164
>>  165   Inferring not available properties using some heuristics or
>> mathematical
>>  166   model is not subject of work for a battery driver. Such
>> functionality
>>  167   should be factored out, and in fact, apm_power, the driver to serve
>>  168   legacy APM API on top of power supply class, uses a simple
>> heuristic of
>>  169   approximating remaining battery capacity based on its charge,
>> current,
>>  170   voltage and so on. But full-fledged battery model is likely not
>> subject
>>  171   for kernel at all, as it would require floating point calculation
>> to deal
>>  172   with things like differential equations and Kalman filters. This is
>>  173   better be handled by batteryd/libbattery, yet to be written.
>>
>> We are not calculating anything new just by the pleasure of doing it,
>> we are correcting a wrong value provided by the hardware.
>
> You are guessing that normal battery can not jump charge value, and on this
> assumption you
> cap charge_now with last full_charge. Immediate problem is that full_charge
> is not fixed value,
> this is why it is separated from design_full_charge.
> During battery life full_charge may go down and up, depending on outside
> temperature, battery discharge (full or partial).
> I've seen batteries on some new machines reporting full charge of more than
> design charge.
> Obviously, your patch will fail in some of the above situations.

I don't see why. The patch compares against full_charge every time
(which is updated as you say), not against design_full_charge.

1. full_charge > design_full_charge => OK, design_full_charge is not
involved in the min() operation.
2. full_charge goes down => If charge_now > full_charge then hardware
is wrong and we should read full_charge. OK.
3. full_charge goes up => Same.

 What do you mean by failing in such situations? My point is that,
AFAIK charge_now shouldn't be higher than full_charge *. The patch
does not care about design_full_charge, neither the original code.

* I do not know about some overcharging issues that Henrique mentioned.

> Currently, reading from the driver is "last resort" to get un-interpreted
> value, if you have any doubts on it. With
> your patch, this is gone, and user space will have to interpret results of
> kernel interpreter.
>
> Return to the "bug still exists". We are referring to the value, which can
> not be measured directly with any known device.
> Thus, it may be completely sane that battery manufacturer provides you with
> some charge curve, but knows only two values on it
> which he may trust -- point where he can not get any power out of it
> (complete discharge) and point where he can not put any additional charge
> into the battery (due to various stop conditions (battery temperature being
> one)). In such a case manufacturer may choose to adjust charge curve to end
> up always at design_full_charge point, no matter how much of adjustment this
> requires.

I understand that and you may be right; however, AFAIK, a userspace
application has no way to know that it should compare against
full_charge every time _except_ when in "charged" state, has it? Is
there any kind of protocol/documentation that establish what an
userspace application should do?

The battery reports correctly full_charge in order to compare with
charge_now (and as I checked, some userspace plugins always check
against that full_charge, not design_full_charge, which seems to be
the logical thing to do, who cares what the design full charge level
was when reporting the actual charge level?).

>
> Do you have the same jump from >100% to 99% on discharge?

Yes: When in "charged" state, the battery reports a fixed value
(desing_full_charge, it is always the same). In "charging" or
"discharging" it correctly reports the current charge. It also
correctly reports full_charge, not matter what state.

So, maybe the battery works as you suggested; still, the kernel should
provide a common meaning to its interfaces. If some batteries report
full_charge when in "charged" state and others report
design_full_charge, then the kernel should convert all of them into
one unique convention, or there is no sane way to write userspace
applications.

>
> Regards,
> Alex.
>

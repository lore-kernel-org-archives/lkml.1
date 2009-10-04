Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZJDWjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZJDWjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 18:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZJDWjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 18:39:24 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:43556 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754568AbZJDWjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 18:39:23 -0400
Message-ID: <4AC923F4.9050100@suse.de>
Date: Mon, 05 Oct 2009 02:38:44 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
References: <1254669853.26496.0.camel@carter>	 <ca2dc2820910041046i47a1c3dhba82266bb14a440c@mail.gmail.com>	 <4AC8F02B.6080209@suse.de> <200910042246.23712.rjw@sisk.pl>	 <4AC91578.2020807@suse.de> <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com>
In-Reply-To: <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ojeda пишет:
> On Sun, Oct 4, 2009 at 11:36 PM, Alexey Starikovskiy
> <astarikovskiy@suse.de> wrote:
>> Hi Rafael,
>>
>> This is not my rule, it was/is the rule of power device class. If you do not
>> agree to it, please change
>> appropriate documentation.
> 
> Oh, I did not know that. Thank you for pointing it out. I think you
> are refering to:
> 
>  158Q: Suppose, my battery monitoring chip/firmware does not provides capacity
>  159   in percents, but provides charge_{now,full,empty}. Should I calculate
>  160   percentage capacity manually, inside the driver, and register CAPACITY
>  161   attribute? The same question about time_to_empty/time_to_full.
>  162A: Most likely, no. This class is designed to export properties which are
>  163   directly measurable by the specific hardware available.
>  164
>  165   Inferring not available properties using some heuristics or mathematical
>  166   model is not subject of work for a battery driver. Such functionality
>  167   should be factored out, and in fact, apm_power, the driver to serve
>  168   legacy APM API on top of power supply class, uses a simple heuristic of
>  169   approximating remaining battery capacity based on its charge, current,
>  170   voltage and so on. But full-fledged battery model is likely not subject
>  171   for kernel at all, as it would require floating point calculation to deal
>  172   with things like differential equations and Kalman filters. This is
>  173   better be handled by batteryd/libbattery, yet to be written.
> 
> We are not calculating anything new just by the pleasure of doing it,
> we are correcting a wrong value provided by the hardware.

You are guessing that normal battery can not jump charge value, and on this assumption you
cap charge_now with last full_charge. Immediate problem is that full_charge is not fixed value,
this is why it is separated from design_full_charge.
During battery life full_charge may go down and up, depending on outside temperature, battery discharge (full or partial).
I've seen batteries on some new machines reporting full charge of more than design charge.
Obviously, your patch will fail in some of the above situations.
Currently, reading from the driver is "last resort" to get un-interpreted value, if you have any doubts on it. With
your patch, this is gone, and user space will have to interpret results of kernel interpreter.

Return to the "bug still exists". We are referring to the value, which can not be measured directly with any known device.
Thus, it may be completely sane that battery manufacturer provides you with some charge curve, but knows only two values on it
which he may trust -- point where he can not get any power out of it (complete discharge) and point where he can not put any additional charge into the battery (due to various stop conditions (battery temperature being one)). In such a case manufacturer may choose to adjust charge curve to end up always at design_full_charge point, no matter how much of adjustment this requires.

Do you have the same jump from >100% to 99% on discharge?

Regards,
Alex.

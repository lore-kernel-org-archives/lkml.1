Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYAGNDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYAGNDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbYAGNDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:03:44 -0500
Received: from smtp02.mtu.ru ([62.5.255.49]:63750 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbYAGNDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:03:43 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: acpi/apm events as inputs: how to handle?
To: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2008 16:03:39 +0300
References: <477B5FD8.5070503@msgid.tls.msk.ru> <200801052105.03068.dtor@insightbb.com> <47820224.2020902@msgid.tls.msk.ru>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20080107130332.5973A2D6BF@smtp02.mtu.ru>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:

> Dmitry Torokhov wrote:
>> Hi Michael,
> 
> Hello!
> 
> []
>> There are keyboards (USB, PS2) with Sleep and Suspend buttons
>> that are not related to ACPI nor APM. We had 2 options - add
>> an input handler that would translate input events into ACPI
>> events and feed /proc/acpi/event[*] or go other way around and
>> use input layer for delivering suspend and sleep requests for
>> all types of keyboards/buttons, including ACPI buttons. The
>> secons option is better because userspace solution using input
>> layer will not be tied to a particular technology (ACPI) and
>> can be used on other platforms as well.
> 
> Aha, this makes sense.
> And it brings a few questions, too.
> 
> As far as I can see, there's little information about how to
> actually use the input interface.  Let's suppose I'm about to
> write an application (a daemon) that should replace acpid --
> it's handling of the said buttons (power and sleep).  How to
> find the right devices?  Should it use /dev/input/event* or
> something else?  How about handling hot-plugged devices like
> new (and removed) keyboards? (And yes, my keyboard has a sleep
> button.)
> 

Well, you use event device in any case; as for finding right one - I guess
you look at device capabilities and filter what you need ...

{pts/0}%
cat /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/capabilities/key
100000 0 0 0

you could also check name but I guess it is unreliable

{pts/0}% cat /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/name
Power Button (FF)

Then you have your event device:

{pts/0}% ll -d /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1
drwxr-xr-x 3 root root 0 2008-01-07
15:32 /sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1/

the problem that you *really* have - nobody prevents user from using udev to
renaming /dev/input/event1 away into anything (s)he likes. Of course you
could do

{pts/0}%
udevinfo --query=name --path /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1
input/event1

.. but at some point we have to commit to support this interface forever.

> And by the way, what INPUT can one expect from a PC speaker?
> input: PC Speaker as /devices/platform/pcspkr/input/input0
> 

I ask myself about LNXVIDEO as well.

/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:13/LNXVIDEO:00/input/input3/event3/



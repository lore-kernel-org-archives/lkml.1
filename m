Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZGaRYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZGaRYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZGaRYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:24:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:64515 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbZGaRYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:24:00 -0400
Message-ID: <4A73284B.6030903@windriver.com>
Date: Fri, 31 Jul 2009 12:22:19 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
References: <Pine.LNX.4.44L0.0907311135030.3152-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907311135030.3152-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2009 17:22:20.0272 (UTC) FILETIME=[75B8AF00:01CA1203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Fri, 31 Jul 2009, Jason Wessel wrote:
>
>> If the EHCI debug port is initialized and in use, the EHCI host
>> controller driver must follow two rules.
>>
>> 1) If the EHCI host driver issues a controller reset, the debug
>>    controller driver re-initialization must get called after the reset
>>    is completed.
>>
>> 2) The EHCI host driver should ignore any requests to the physical
>>    EHCI debug port when the EHCI debug port is in use.
>>
>> The code to check for the debug port was moved from ehci_pci_reinit()
>> to ehci_pci_setup because it must get called prior to ehci_reset()
>> which will clear the debug port registers.
>> --- a/drivers/usb/host/ehci-hub.c
>> +++ b/drivers/usb/host/ehci-hub.c
>> @@ -816,6 +816,15 @@ static int ehci_hub_control (
>>      case SetPortFeature:
>>          selector = wIndex >> 8;
>>          wIndex &= 0xff;
>> +        if (unlikely(ehci->debug)) {
>
> Don't you need a similar test for ClearPortFeature?  Or does that not
> matter?

I guess it depends if the user space tries to poke it, and then
perhaps yes.  Do you know if that would be the case?

The rejection of the SetPortFeature at this level prevents the generic
hub code from activating the port, in so far as all my tests cases
show.

Given that it won't hurt anything to have the same code in the
ClearPortFeature I can put it in.

>
>> +            /* If the debug port is active any port
>> +             * feature requests should get denied */
>> +            if ((readl(&ehci->debug->control) & DBGP_ENABLED) &&
>> +                wIndex == HCS_DEBUG_PORT(ehci->hcs_params)) {
>
> The order of the two tests here should be reversed, to avoid an
> unnecessary I/O access in the common case.
>

Yes.  I agree here.


>> +                retval = -ENODEV;
>> +                goto error_exit;
>
> This is the wrong return value.  You should return -EPIPE, i.e., goto
> error instead of error_exit.


Do you have some insight as to how to account for the not using the
port another way?  If I return -EPIPE, vs -ENODEV.  The kernel code
does very different things.  I chose -ENODEV based on the results
below.

With -ENODEV the kernel emits the following when trying to probe the
usb port with the dbgp device.


hub 2-0:1.0: cannot reset port 1 (err = -19)
hub 2-0:1.0: cannot reset port 1 (err = -19)
hub 2-0:1.0: cannot reset port 1 (err = -19)
hub 2-0:1.0: cannot reset port 1 (err = -19)
hub 2-0:1.0: unable to enumerate USB device on port 1


With returning -EPIPE you get this result.

hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
USB Serial support registered for generic
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: cannot reset port 1 (err = -32)
hub 2-0:1.0: Cannot enable port 1.  Maybe the USB cable is bad?
hub 2-0:1.0: unable to enumerate USB device on port 1


I was looking for the easiest maintainable approach to disabling the
physical port from getting reset by the HCD hub driver, which does
different things depending on the error code that is passed back.

Knowing what happens with -EPIPE, would you still prefer it to be
changed that way?  Another possibility here is to implement the
restriction on the port reset another way, if you have any
suggestions.

In general folks may not need to use earlyprintk=dbpg,keep too often,
but it sure is nice when it works because you can use it as a full
console monitoring device after the /sbin/init handoff, including
debugging USB printk's because the usb debug controller driver is
completely separate.


Jason.



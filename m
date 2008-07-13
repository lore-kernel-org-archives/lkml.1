Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYGMUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYGMUL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYGMULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:11:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYGMULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:11:47 -0400
Message-ID: <487A617B.80707@firstfloor.org>
Date: Sun, 13 Jul 2008 22:11:39 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <200807132115.08230.rjw@sisk.pl>
In-Reply-To: <200807132115.08230.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 13 of July 2008, Andi Kleen wrote:
>> Andy Lutomirski wrote:
>>> Matthew Garrett wrote:
>>>> On Sun, Jul 13, 2008 at 11:15:24AM +0200, Ingo Molnar wrote:
>>>>
>>>>> we still need to find the HAL quirk and disable it, right?
>>>> Not without understanding what the cause is. If the video BIOS calls
>>>> are generically broken, then we have a problem.
>>>>
>>> The HAL quirk is the very first one here:
>>>
>>> http://gitweb.freedesktop.org/?p=hal-info.git;a=blob;f=fdi/information/10freedesktop/20-video-quirk-pm-lenovo.fdi
>>>
>>>
>>> I removed it from the HAL config and suspending w/ the hardware button
>>> works fine now with -rc9-wl and on Ubuntu's stock .24 kernel.
>> Hmm, but the change was not supposed to break the s3 bios. Something
>> fishy is going on. It sounds like the s3 bios relies on some earlier
>> segment register setup.
> 
> Well, we changed the (visible) parts of the segment registers before anyway.
> 
> This means that it could only depend on the hidden parts.  However, in that
> case if it depended on the hidden part of SS, our stack would be broken,

We're in real mode for now nd should not care about the hidden state.

> so
> the quirk wouldn't work (it uses 'call' to run a BIOS routine).  In turn, if it
> depended on the hidden part of DS, our data register would be broken, so the
> resume code itself wouldn't work.
> 
> This means it could only depend on the hidden part of ES.
>  
>> If true this means the segment register reset would need to be moved
>> later after S3 bios ran.
> 
> We can't do that.  If SS contains garbage, the BIOS call itself will reboot
> the box and if DS contains garbage, well ...

But it's apparently not garbage for the s3 bios. So somehow the "garbage"
needs to be kept impact until the S3 BIOS ran.

>> Saving/restoring is unfortunately not possible because we cannot save/restore
>> the hidden state loaded from the GDT earlier. 
>>
>> This is unfortunately a little tricky with the new C wakeup code.
>>
>>> I'll file the obvious bug report against HAL, but it might annoy users
>>> if new kernel + old HAL = broken system, 
>> It's the bad side effect of HAL effectively being an out of tree kernel
>> driver (that just by chance happens to run in user space). Really
>> all these s3 quirks at least should be in the kernel.
>>
>> We can't really do much about that now, but longer term it might be useful
>> to invent some mechanism to tell HAL to disable specific quirks from
>> the kernel.
> 
> They are in the kernel.  In fact, there's a sysctl to switch them on/off and
> that's what HAL uses, AFAICS.

The quirk is clearly in user space in hal.

> 
> Apparently, you can tell HAL not to do that by editing one of its files.


Sure, but the kernel can hardly edit someone's configuration files.

-Andi



Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZDNRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZDNRaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbZDNR2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:28:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60088 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757818AbZDNR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TCLyFUvNr0nLacc6LjDmws+NdQHfyRt4M7otbeDZlwvCgeyhv1qiD1R3ZNQsFwTkoD
         h+xrqbD/rWAqsC4fKKJeORRsGfW6u5viitE/sfvUk5wm9FFkEq91n1/QJnzQr5FVNpiN
         a54kVz5GhXp4hHy5L6sjECUbZqhj802UKb8rI=
Message-ID: <49E4C7AB.3090605@tuffmail.co.uk>
Date: Tue, 14 Apr 2009 18:28:11 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "Moore, Robert" <robert.moore@intel.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
References: <49E065CF.6040408@tuffmail.co.uk> <200904140948.37633.bjorn.helgaas@hp.com> <4911F71203A09E4D9981D27F9D8308581D3722EB@orsmsx503.amr.corp.intel.com> <200904141056.14159.bjorn.helgaas@hp.com> <4911F71203A09E4D9981D27F9D8308581D372489@orsmsx503.amr.corp.intel.com>
In-Reply-To: <4911F71203A09E4D9981D27F9D8308581D372489@orsmsx503.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I guess the problem is that the other ACPI modules execute methods
which also need to access the EC.  And it's the EC that causes them to
be serialized against the battery module.

Moore, Robert wrote:
> Your understanding is correct. 
>
> The only interesting thing that happens when executing the battery methods like _STA, _BIF, and _BST is that the EC is usually involved - and this can be slow. Note that the AML interpreter is unlocked before accessing an EC operation region.
>
>   
>> -----Original Message-----
>> From: Bjorn Helgaas [mailto:bjorn.helgaas@hp.com]
>> Sent: Tuesday, April 14, 2009 9:56 AM
>> To: Moore, Robert
>> Cc: Arjan van de Ven; Alan Jenkins; linux-acpi@vger.kernel.org; linux-
>> kernel; Kernel Testers List; Pallipadi, Venkatesh
>> Subject: Re: [BISECTED] EEE PC hangs when booting off battery
>>
>> On Tuesday 14 April 2009 09:55:58 am Moore, Robert wrote:
>>     
>>> In fact, ACPI methods can execute concurrently -- constrained by the ACPI
>>>       
>> specification itself. The "big lock" is released before anything that will
>> block for a significant amount of time, allowing other methods to run.
>>
>> We had a discussion about this a couple years ago:
>>  http://www.mail-archive.com/linux-acpi%40vger.kernel.org/msg06976.html
>>
>> Here's my understanding (please correct me if I'm wrong):
>>
>> - The ACPI CA holds a mutex while executing an AML method (see
>>  acpi_ex_enter_interpreter()).
>>
>> - When an AML method blocks, the ACPI CA releases the mutex, which
>>  allows another AML method to run while the first is blocked.
>>
>> - Because of the mutex, at most one AML method can be executing at
>>  any given time.  Others may have started, but they are blocked
>>  until the current method completes or blocks itself.
>>
>> - The undocumented "acpi_serialize" option makes the ACPI CA hold
>>  the mutex for the entire duration of a method, even while a method
>>  is blocked.
>>
>> Based on that, my guess about the battery init being slow because of
>> a long-running AML method might be incorrect, although I suppose
>> it's still possible to write AML busy-loops that never block.
>>
>> I'd really like to understand what's making it slow.  The only
>> thing that looks at all unusual in acpi_battery_add() is
>> acpi_battery_update(), and that evaluates _STA and _BIF and
>> not much else.
>>
>> Arjan, do you have any more information?  Is the battery driver
>> slow on all laptops?  If not, where did you see the problem?  Do
>> you have a DSDT for them?
>>
>> Bjorn
>>
>>     
>>>> -----Original Message-----
>>>> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>>>> owner@vger.kernel.org] On Behalf Of Bjorn Helgaas
>>>> Sent: Tuesday, April 14, 2009 8:49 AM
>>>> To: Arjan van de Ven
>>>> Cc: Alan Jenkins; linux-acpi@vger.kernel.org; linux-kernel; Kernel
>>>>         
>> Testers
>>     
>>>> List; Pallipadi, Venkatesh
>>>> Subject: Re: [BISECTED] EEE PC hangs when booting off battery
>>>>
>>>> On Tuesday 14 April 2009 09:17:28 am Arjan van de Ven wrote:
>>>>         
>>>>> On Tue, 14 Apr 2009 08:59:01 -0600
>>>>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>>>>
>>>>>           
>>>>>> I can't help with the real problem of why the asynchronous battery
>>>>>> init causes the hang.
>>>>>>             
>>>>> that got fixed already for the module case.
>>>>>           
>>>> But apparently still broken for the builtin case?  I think Alan is
>>>> running pretty new bits -- he said "latest git" on April 11.
>>>>
>>>>         
>>>>>> But I do object to the magic makefile ordering change in that
>>>>>>             
>> commit.
>>     
>>>>>> Nobody reading the makefile can tell why battery is down at the end,
>>>>>> and moving it apparently slows down boot significantly.
>>>>>>             
>>>>> for all cases I've seen it actually speeds it up, because the battery
>>>>> now runs concurrently with the disk probe.
>>>>>           
>>>> I understand; I just meant that if somebody moves it back where it
>>>> was, we'll mysteriously lose the speedup you got.  Maybe a comment
>>>> in the makefile would be a short-term solution.
>>>>
>>>>         
>>>>>> So the
>>>>>> ordering change just feels like a band-aid that covers up a place
>>>>>> where ACPI could be improved.
>>>>>>             
>>>>> the reason for the move is that both the battery and other pieces take
>>>>> the big acpi lock; which defeats the parallelism. So the battery needs
>>>>> to happen at the end instead.
>>>>>           
>>>> Yep.  But I don't think it's anything about the Linux battery driver
>>>> itself that makes it slow.  I think it's more likely that some of the
>>>> ACPI methods it executes happen to be slow.  And that could afflict
>>>> *any* driver, depending on the whim of a BIOS writer.
>>>>
>>>> My guess is that if we could run ACPI methods concurrently and avoid
>>>> that big lock, the ordering wouldn't matter.  I know we probably can't
>>>> do that any time soon, but I think it's good to make the problem
>>>> visible at least with a "we need this magic order because ACPI doesn't
>>>> support concurrent method execution" sort of comment.
>>>>
>>>> Bjorn
>>>>         


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXL0SI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXL0SI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXL0SIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:08:19 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20989 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbXL0SIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:08:18 -0500
Date: Thu, 27 Dec 2007 12:07:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Suspend code ordering (again)
In-reply-to: <fa.XycBwhGuyvtVl/QW5HONqLwOags@ifi.uio.no>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Message-id: <4773E9EE.40107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no>
 <fa.WvaVh83zJOh/eZUrjQOZy4J8JFk@ifi.uio.no>
 <fa.VsyhBr+FAHB0bTb9poSZS80xN/0@ifi.uio.no>
 <fa.XycBwhGuyvtVl/QW5HONqLwOags@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday, 26 of December 2007, Linus Torvalds wrote:
>> On Tue, 25 Dec 2007, Rafael J. Wysocki wrote:
>>> the ACPI specification between versions 1.0x and 2.0.  Namely, while ACPI
>>> 2.0 and later wants us to put devices into low power states before calling
>>> _PTS, ACPI 1.0x wants us to do that after calling _PTS.  Since we're following
>>> the 2.0 and later specifications right now, we're not doing the right thing for
>>> the (strictly) ACPI 1.0x-compliant systems.
>>>
>>> We ought to be able to fix things on the high level, by calling _PTS earlier on
>>> systems that claim to be ACPI 1.0x-compliant.  That will require us to modify
>>> the generic susped code quite a bit and will need to be tested for some time.
>> That's insane. Are you really saying that ACPI wants totally different 
>> orderings for different versions of the spec?
> 
> Yes, I am.
> 
>> And does Windows really do that?
> 
> I don't know.
> 
>> Please don't make lots of modifications to the generic suspend code. The 
>> only thing that is worth doing is to just have a firmware callback before 
>> the "device_suspend()" thing (and then on a ACPI-1.0 system, call _PTS 
>> *there*), and on an ACPI-2.0 system, call _PTS *after* device_suspend().
> 
> Yes, that's what I'm going to do, but I need to untangle some ACPI code for
> this purpose.
> 
>> Still, the fact is, some (most, I think) drivers *should* put themselves 
>> into D3 only in "late_suspend()", so if ACPI-2.0 really expects _PTS to be 
>> called after that, we're just screwed.
> 
> Well, section 9.1.6 of ACPI 2.0 specifies the suspend ordering directly and
> says exactly that _PTS is to be executed after putting devices into respective
> D states.

I would not take those sections as gospel, they're really an example 
only. It's quite possible that Windows does not follow that ordering.

Also, as was pointed out, pre-Vista versions of Windows follow ACPI 1.0 
and Vista follows 3.0, so 2.0 doesn't really matter since BIOS people 
won't test against it. 1.0 specifies that _PTS is to be called before 
suspending devices and 3.0 says that the AML must not depend on any 
specific device power state, so in both cases it should be safe to call 
_PTS before suspending, no?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


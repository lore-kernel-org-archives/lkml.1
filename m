Return-Path: <linux-kernel-owner+w=401wt.eu-S932870AbYJKSPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbYJKSPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762351AbYJKSP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:15:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:22090 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762257AbYJKSP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=aK+OcDU1AtCKTB9oLkp7khsGVrDOm7ZrPdgyn8UaUV4tQO9AJNVMjbhGhToKmx8gMx
         LhYqU67w2/Qruj512auDdE90RiAa5nVIwJdv8w5DZZigg64Bflz9dfR3II22ZNOyoI81
         OoS9h6WiuyyTlPLimmbfNrChJHB07Cmp7dgoo=
Message-ID: <48F0ED3A.9010001@tuffmail.co.uk>
Date: Sat, 11 Oct 2008 19:15:22 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi-test tree on eeepc: EC error message on second resume
References: <48F0DB0C.7060201@tuffmail.co.uk> <200810111909.48897.rjw@sisk.pl> <48F0DE8C.6040309@tuffmail.co.uk> <200810111953.04610.rjw@sisk.pl>
In-Reply-To: <200810111953.04610.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 11 of October 2008, Alan Jenkins wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>> On Saturday, 11 of October 2008, Alan Jenkins wrote:
>>>   
>>>       
>>>> I've just run an acpi-test kernel on my EeePC and noticed a new issue. 
>>>> It seems to be caused (or revealed) by the EC interrupt transaction patch.
>>>>
>>>> On the second suspend/resume cycle, I see a kernel error message.
>>>>
>>>> [   78.747707] ACPI: Waking up from system sleep state S3
>>>> [   79.330001] ACPI: EC: input buffer not empty, aborting transaction
>>>> [   79.423327] ACPI: EC: non-query interrupt received, switching to
>>>> interrupt mode
>>>>
>>>> I still don't see any issues in the code.  I'll try getting a DEBUG
>>>> trace to see the EC interrupts.  Any other suggestions?
>>>>     
>>>>         
>>> Not really, but is this reproducible?  I mean, does it happen always on the
>>> second resume and does it happen on every next resume after the first one?
>>>
>>> Thanks,
>>> Rafael
>>>   
>>>       
>> Ah.  No, I spoke to soon.  It happened on the second resume the first
>> two times I tried it.  But this third time with DEBUG enabled, it
>> happened on the first suspend/resume.
>>
>> And it doesn't happen on all subsequent resumes either.  I've had one
>> suspend/resume without the error, just after a suspend/resume with the
>> error.
>>
>> So it's not deterministic, but it is easy to reproduce.
>>     
>
> I can't reproduce this on any hardware available to me, so far.
>
> Is this related to any other problem, like things not working etc.?
>   

Nope, just an error message.  Though I do worry that "random EC
transaction aborts during resume" could hit something important
somewhere, sometime.

I think I found the problem.  The "input buffer empty" wait depends on
"interrupt mode" to work properly, and we don't immediately enable the
interrupt on resume.  The wait should have a polling fallback anyway, to
be consistent with the other transaction waits.

Alan

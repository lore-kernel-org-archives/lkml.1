Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbZBFOqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbZBFOqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZBFOqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:46:36 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:33500 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBFOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SIbTG8Tgmez1T/XGtDDANZteoMc3a35BnaBX1H1KpozIHg3ZLuR/VBatX1GgmpILGI
         MdhBuss6p9b1c4DTzSaEuRLVL8trDNc1xMv4TdsgWXmxaNOQIax5XoAPfDGPYxM29sup
         Ja168N5SeQ+Z6ssTfxI+ncEfgiVac8zI9JV2w=
Message-ID: <498C4D47.4040201@gmail.com>
Date: Fri, 06 Feb 2009 08:46:31 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: Regression on VIA C3 motherboard, commit: 66f2173e2
References: <498A93E5.2080509@candelatech.com> <498B8547.1010803@gmail.com> <498BD448.80102@candelatech.com>
In-Reply-To: <498BD448.80102@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear wrote:
> Robert Hancock wrote:
>> Ben Greear wrote:
>>> I have a via motherboard with C3 processor and some real-tek NICs.  I 
>>> noticed
>>> when using the top-of-tree that performance on it sucked (30Mbps v/s 
>>> 54Mbps
>>> network throughput in one pertinent test).
>>>
>>> After several hours of bisecting, I see this as the culprit:
>>>
>>> 7b37b5fd9ba32c0c5afc3537eed7e7466f2173e2 is first bad commit
>>> commit 7b37b5fd9ba32c0c5afc3537eed7e7466f2173e2
>>> Author: Len Brown <len.brown@intel.com>
>>> Date:   Tue Dec 23 01:47:42 2008 -0500
>>>
>>>    ACPI: disable MPS when NO APIC-table found
>>>      When ACPI is asked to find an MADT (APIC table)
>>>    and fails, then ACPI expects to run in PIC mode.
>>>      However, if an MP Table is was found, IRQs will be
>>>    registered as if an IOAPIC is being used, even
>>>    though ACPI is configuring interrupt links links for PIC mode.
>>>      In this scenario, disable MPS so that IRQs
>>>    are registered in PIC mode, consistent with ACPI.
>>>      http://bugzilla.kernel.org/show_bug.cgi?id=12257
>>>      Signed-off-by: Len Brown <len.brown@intel.com>
>>>
>>> :040000 040000 86ce74daee3a9fe6ff21ef7f8fb364af23ec0c1e 
>>> 364933dfec0df34e63b1aeff6aff4092d421886b M      arch
>>>
>>>
>>> In addition, I see this warning in my logs, which is likely the symptom:
>>>
>>> ACPI Exception (tbxface-0627): AE_NO_ACPI_TABLES, While loading 
>>> namespace from ACPI tables ]
>>> ACPI: Unable to load the System Description Tables
>>
>> You're getting this on boot:
>>
>> ACPI Error (tbxfroot-0218): A valid RSDP was not found [20080926]
>>
>> That essentially means ACPI isn't working at all, I think. Did 
>> previous kernels produce this error? Do you have ACPI disabled in the 
>> BIOS or something?
>>
> Er, yes...I have ACPI disabled in the BIOS.  I seem to recall now that 
> it worked around
> some instability, but it's been a few years since we set that up.   
> Still, it was working
> fine before, and fine again when I comment out the change in this commit 
> (and another
> change to force the 'tsc' to be considered stable).
> 
> The same error message happens as far back as 2.6.25 at least.

It seems like this is a slightly different case than the patch is trying 
to address. It's talking about just the MADT not being found, when in 
your case we have no ACPI at all.

However, I should point out that in general, disabling ACPI tends to be 
a bad idea, since it tends to bring out untested code paths both in the 
kernel and in the BIOS/hardware. (For one thing it means you can't use 
the PM timer, which is likely why your system is falling back to jiffies 
timing.)

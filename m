Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYCLKzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYCLKzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYCLKzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:55:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37172 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYCLKzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:55:21 -0400
Message-ID: <47D7B561.4070505@jp.fujitsu.com>
Date: Wed, 12 Mar 2008 19:50:09 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
CC: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       warthog19@eaglescrag.net, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
References: <20080229002341.GA21420@ldl.fc.hp.com>	<20080301144307.GD24386@parisc-linux.org>	<20080304054927.GA15566@suse.de>	<200803041018.29035.jbarnes@virtuousgeek.org>	<20080304193036.GB5534@suse.de>	<20080304230937.GD3694@ldl.fc.hp.com>	<47CDF339.3060304@jp.fujitsu.com>	<20080305202052.GN3694@ldl.fc.hp.com>	<47D684D0.6060200@jp.fujitsu.com> <20080311110403.7db9527c@appleyard>
In-Reply-To: <20080311110403.7db9527c@appleyard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> My interpretation of this is that if Alex's driver scans the Fujitsu
> machine and calls _STA on one of the slots and gets Bit 0 (present) and
> Bit 3 (functioning) set, then it is ok to enumerate it's children and
> evaluate _ADR and _SUN for the children.  If they are returning 1023,
> that would mean you should not evaluate the children of that object
> since the functional bit is not set.  Is this correct?

Yes, it is one of the reason we should evaluate _STA before evaluating
_STA. Maybe you're referring '1023' as a _STA value on Fujitsu server,
but it is _SUN value. If a driver evaluate _SUN even if its corresponding
_STA is 0, Fujitsu firmware returns '1023' as a _SUN value. The reason why
Fujitsu firmware is doing so is because ACPI doesn't provide a way to
return errors in this situation.

> If that is the case, I would say that Alex's driver needs to obey the
> spec - or else if the this is allowed in an earlier version of the spec
> then he needs to check for the version of the spec that was implemented
> and make some different rules for that.

Yes. I thought it's a goot idea too. But it doesn't work because ACPI2.0
based HP's machines also want Alex's driver to ignore _STA.

Thanks,
Kenji Kaneshige


Kristen Carlson Accardi wrote:
> On Tue, 11 Mar 2008 22:10:40 +0900
> Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> 
>> Hi Alex-san,
>>
>> Alex Chiang wrote:
>>>>> It wasn't the IBM machine that was breaking; it was Fujitsu. They
>>>>> were returning an error code (the numerical value 1023) when I
>>>>> called the _SUN method on a slot object that existed in the ACPI
>>>>> namespace but was not present (as reported by the _STA method).
>>>>> By the time I got that error report, I'd already dropped the
>>>>> duplicate name detection code, and was letting the kobject
>>>>> infrastructure warn about duplicate names because for my test
>>>>> cases, refcounting was a better solution.
>>>>> [Kenji-san from Fujitsu seemed to be ok with the progress I'd
>>>>> made at the time, he can speak up if he's changed his mind ;)]
>>>> Unfortunatelly, I have not tried the new version of slot detection
>>>> driver because of the lack of test environment. Maybe we need more
>>>> several days to wait for test environment. 
>>>> BTW, does the new one fixes the issue I reported before? I could
>>>> not find it in the changelog. IIRC, this issue was difficult to
>>>> solve because the root cause of this issue is from the difference
>>>> of interpretation of ACPI spec between HP and Fujitsu (I still
>>>> don't think it's a good idea to evaluate _SUN for the device
>>>> object whose _STA is 0).
>>> It looks like we disagree on how to interpret the spec (IBM
>>> machines interpret the spec the same way HP machines do).
>>>
> 
> OK, let me see if I can understand what the issue is here.  Please
> correct me if I'm wrong.  The debate is about whether or not it is
> legitimate to call _SUN if _STA indicates that the device is not
> present and functional.  I've checked ACPI 3.0b, and from what I've
> read, you may not evaluate _SUN until _INI is called.  And _INI should
> not be called unless _STA indicates that a device is present and
> functional.
> 
> "OSPM evaluates the _STA object before it evaluates a device _INI
> method. The return values of the Present and Functioning bits
> determines whether _INI should be evaluated and whether children of the
> device should be enumerated and initialized. See section 6.5.1, “_INI
> (Init)”."
> 
> My interpretation of this is that if Alex's driver scans the Fujitsu
> machine and calls _STA on one of the slots and gets Bit 0 (present) and
> Bit 3 (functioning) set, then it is ok to enumerate it's children and
> evaluate _ADR and _SUN for the children.  If they are returning 1023,
> that would mean you should not evaluate the children of that object
> since the functional bit is not set.  Is this correct?
> 
> If that is the case, I would say that Alex's driver needs to obey the
> spec - or else if the this is allowed in an earlier version of the spec
> then he needs to check for the version of the spec that was implemented
> and make some different rules for that.
> 
> Thanks for the clarification,
> Kristen
> 
> 
> 



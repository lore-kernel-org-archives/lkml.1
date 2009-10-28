Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbZJ1ITJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbZJ1ITJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932660AbZJ1ITI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:19:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35836 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbZJ1ITG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:19:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE7FE5F.4000402@jp.fujitsu.com>
Date: Wed, 28 Oct 2009 17:18:39 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Mike Travis <travis@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com> <4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com> <4AE7D59D.9070307@linux.intel.com> <4AE7E40F.20602@jp.fujitsu.com> <4AE7E931.6040703@linux.intel.com>
In-Reply-To: <4AE7E931.6040703@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto wrote:
>> Without disabling, what can we do on MCE with no bank?
> 
> Nothing, but is it really worth adding a special case?

If question were:
  - is it really worth to support this special environment,
    "MCE-capable but no MCE banks" ?
then I'd like to say no.

So I suggested to disable MCE on this uncertain environment.
Or we will end up adding more codes for special cases...

>> I found that do_machine_check() does nothing if banks==0 ... it is better
>> to let system to panic with "Machine check from unknown source"?
> 
> IMHO yes. In this case the system must be very confused and panic is the
> best you can do. Otherwise it won't do anything interesting anyways.

Agreed, but this is also a special case.
Not depending on the real number of banks, confused system could fail to
get the value from memory... Humm, in theory MCE handler must be
implemented carefully, but I bet the confused value will not be always 0,
... is it worth to do?

>>>> Hum, I suppose the line for CPU 0 was slightly different from others,
>>>> because SHD means "this bank is shared bank and controlled by other".
>>>> Maybe:
>>>>  CPU 0 MCA banks CMCI:0 CMCI:1 CMCI:2 CMCI:3 CMCI:5 ... CMCI:21
>>>>
>>>> But I agree that we could some work for this messages...
>>>> Is it better to change the message level to debug from info?
>>> Can be made INFO yes, but I would prefer not removing them
>>> from the dmesg for now.
>>>
>>> Perhaps they could be also compressed a bit like SRAT.
>>
>> Like SRAT?  I could not catch the meaning ... For example?
> 
> See the recent patches from David Rientjes in the same original thread.

I found it, thanks.

So I suppose your idea is like:
  CPU 0 MCA banks CMCI:{0-3,5-9,12-21} POLL:{4,10,11}
  CPU 1 MCA banks SHD:{0,1,6-9,12-21} CMCI:{2,3,5} POLL:{4,10,11}
right?

IMHO the format I suggested is better to read, as far as banks is
not so big number.
  CPU 0 MCA banks map : CCCC PCCC CCPP CCCC CCCC CC
  CPU 1 MCA banks map : ssCC PCss ssPP ssss ssss ss


Thanks,
H.Seto


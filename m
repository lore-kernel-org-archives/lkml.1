Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYCaH4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYCaH4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYCaH4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:56:09 -0400
Received: from relay.gothnet.se ([82.193.160.251]:3188 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753589AbYCaH4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:56:08 -0400
Message-ID: <47F098E8.1050605@tungstengraphics.com>
Date: Mon, 31 Mar 2008 09:55:20 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org>
In-Reply-To: <87myof8ief.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Dave Airlie <airlied@redhat.com> writes:
>   
>>  
>> +#define CPA_FLUSHTLB 1
>> +#define CPA_ARRAY 2
>>     
>
> I don't think CPA_ARRAY should be a separate case. Rather single
> page flushing should be an array with only a single entry. pageattr
> is already very complex, no need to make add more special cases.
>   
>> +
>> +		/*
>> +		 * Only flush present addresses:
>> +		 */
>> +		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
>> +			clflush_cache_range((void *) *addr, PAGE_SIZE);
>>     
>
> Also it is doubtful clflush really makes sense on a large array. Just
> doing wbinvd might be faster then. Or perhaps better supporting Self-Snoop
> should be revisited, that would at least eliminate it on most Intel 
> CPUs.
>
>   
I agree that wbinvd() seems to be faster on large arrays on the 
processors I've tested. But isn't there a severe latency problem with 
that instruction, that makes people really want to avoid it in all 
possible cases?

Also I think we need to clarify the semantics of the c_p_a 
functionality. Right now both AGP and DRM relies on c_p_a  doing an 
explicit cache flush. Otherwise the data won't appear on the device side 
of the aperture.
If we use self-snoop, the AGP and DRM drivers can't rely on this flush 
being performed, and they have to do the flush themselves, and for 
non-self-snooping processors, the flush needs to be done twice?

/Thomas

> -Andi
>   




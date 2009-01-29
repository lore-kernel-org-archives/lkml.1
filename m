Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZA2WuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZA2WuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:50:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZA2Wtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:49:52 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:63421 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZA2Wtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:49:52 -0500
Message-ID: <4982324B.3050706@oracle.com>
Date: Thu, 29 Jan 2009 14:48:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Maksim Yevmenkin <maksim.yevmenkin@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 	file segments
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>	 <1233259410.2315.75.camel@lts-notebook>	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
In-Reply-To: <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4982324F.02C4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maksim Yevmenkin wrote:
> On Thu, Jan 29, 2009 at 12:48 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, 29 Jan 2009, Linus Torvalds wrote:
>>> THIS PATCH IS TOTALLY UNTESTED!
>> Well, it boots. FWIW. I've not really tested anything interesting with it,
>> but any potential breakage is at least not catastrophic and immediate.
>>
>>> diff --git a/mm/mmap.c b/mm/mmap.c
>>> index 8d95902..3f78ead 100644
>>> --- a/mm/mmap.c
>>> +++ b/mm/mmap.c
>>> @@ -769,6 +769,10 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>>>       if (vm_flags & VM_SPECIAL)
>>>               return NULL;
>>>
>>> +     /* Anonymous shared mappings are unsharable */
>>> +     if ((vm_flags & VM_SHARED) && !file)
>>> +             return NULL;
>>> +
>> .. and I think this part of it is actually unnecessary, because what
>> happens is that a shared anon mapping is turned into a shmem mapping when
>> it is inserted, and that actually ends up allocating a file for it. So the
>> vma->vm_file for anon mappings will not match a NULL file pointer
>> _anyway_, so there's no way it would end up merging.
>>
>> So my patch can be further simplified, I think, to just the following.
>> Even more total lines removed.
>>
>> I still want somebody else to look at and think about it, though.
> 
> Just to confirm. This patch also appear to fix the immediate issue for us.

Is there a (small) test program available?

Thanks,
-- 
~Randy

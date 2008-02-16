Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYBPT4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYBPT4P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYBPTz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:55:58 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:54200
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYBPTz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:55:58 -0500
Message-ID: <47B73F81.7090907@qumranet.com>
Date: Sat, 16 Feb 2008 21:54:41 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 3/6] mmu_notifier: invalidate_page callbacks
References: <20080215064859.384203497@sgi.com> <20080215064932.918191502@sgi.com> <20080215193736.9d6e7da3.akpm@linux-foundation.org> <Pine.LNX.4.64.0802161121130.25573@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802161121130.25573@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 15 Feb 2008, Andrew Morton wrote:
>
>   
>>> @@ -287,7 +288,8 @@ static int page_referenced_one(struct pa
>>>  	if (vma->vm_flags & VM_LOCKED) {
>>>  		referenced++;
>>>  		*mapcount = 1;	/* break early from loop */
>>> -	} else if (ptep_clear_flush_young(vma, address, pte))
>>> +	} else if (ptep_clear_flush_young(vma, address, pte) |
>>> +		   mmu_notifier_age_page(mm, address))
>>>  		referenced++;
>>>       
>> The "|" is obviously deliberate.  But no explanation is provided telling us
>> why we still call the callback if ptep_clear_flush_young() said the page
>> was recently referenced.  People who read your code will want to understand
>> this.
>>     
>
> Andrea?
>
>   

I'm not Andrea, but the way I read it, ptep_clear_flush_young() and 
->age_page() each have two effects: check whether the page has been 
referenced and clear the referenced bit.  || would retain the semantics 
of the check but lose the clearing.  | does the right thing.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.


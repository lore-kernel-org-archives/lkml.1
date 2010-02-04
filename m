Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab0BDNlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 08:41:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140Ab0BDNk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 08:40:59 -0500
Message-ID: <4B6ACE5B.9080601@redhat.com>
Date: Thu, 04 Feb 2010 08:40:43 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: jdike@addtoit.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, aarcange@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH] emulate accessed bit for EPT
References: <20100203161103.11e2b572@annuminas.surriel.com> <20100204041212.GI19641@balbir.in.ibm.com>
In-Reply-To: <20100204041212.GI19641@balbir.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 11:12 PM, Balbir Singh wrote:
> * Rik van Riel<riel@redhat.com>  [2010-02-03 16:11:03]:
>
>> Currently KVM pretends that pages with EPT mappings never got
>> accessed.  This has some side effects in the VM, like swapping
>> out actively used guest pages and needlessly breaking up actively
>> used hugepages.
>>
>> We can avoid those very costly side effects by emulating the
>> accessed bit for EPT PTEs, which should only be slightly costly
>> because pages pass through page_referenced infrequently.

> Quite a clever implementation, one side effect is that one would see a
> larger number of minor faults with EPT enabled and an increase in
> allocation/frees of rmap entries, but that can be easily explained.

I suspect it won't be very many. I have been monitoring
/proc/meminfo on my system while testing this patch, and
it is quite typical that the size of the inactive anon
list does not change for minutes at a time.

In other words, no pages are moved onto or off of the
inactive anon list for several minutes. That corresponds
to a very small number of minor faults introduced by my
patch.

Of course, when the system is swapping, we will have more
minor faults.  However, minor faults should be less of a
performance issue than major faults :)

-- 
All rights reversed.

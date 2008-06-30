Return-Path: <linux-kernel-owner+w=401wt.eu-S1756359AbYF3DsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbYF3DsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 23:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYF3DsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 23:48:05 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:41642 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYF3DsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 23:48:03 -0400
Message-ID: <4868572B.5070006@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2008 09:16:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 3/5] Replacement policy on heap overfull
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop> <20080627151838.31664.51492.sendpatchset@balbir-laptop> <6599ad830806270837t5f9df61cn665a88d3dd8746d4@mail.gmail.com>
In-Reply-To: <6599ad830806270837t5f9df61cn665a88d3dd8746d4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Jun 27, 2008 at 8:18 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>> This patch adds a policy parameter to heap_insert. While inserting an element
>> if the heap is full, the policy determines which element to replace.
>> The default earlier is now obtained by passing the policy as HEAP_REP_TOP.
>> The new HEAP_REP_LEAF policy, replaces a leaf node (the last element).
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> ---
>>
>>  include/linux/prio_heap.h |    9 ++++++++-
>>  kernel/cgroup.c           |    2 +-
>>  lib/prio_heap.c           |   31 +++++++++++++++++++++++--------
>>  3 files changed, 32 insertions(+), 10 deletions(-)
>>
>> diff -puN include/linux/prio_heap.h~prio_heap_replace_leaf include/linux/prio_heap.h
>> --- linux-2.6.26-rc5/include/linux/prio_heap.h~prio_heap_replace_leaf   2008-06-27 20:43:09.000000000 +0530
>> +++ linux-2.6.26-rc5-balbir/include/linux/prio_heap.h   2008-06-27 20:43:09.000000000 +0530
>> @@ -22,6 +22,11 @@ struct ptr_heap {
>>        int (*gt)(void *, void *);
>>  };
>>
>> +enum heap_replacement_policy {
>> +       HEAP_REP_LEAF,
>> +       HEAP_REP_TOP,
>> +};
> 
> Maybe "drop" rather than "replace"? HEAP_REP_TOP doesn't replace the
> top element if you insert a new higher element, it drops the top.
> 
> How about HEAP_DROP_LEAF and HEAP_DROP_MAX? You could also provide a
> HEAP_DROP_MIN with the caveat that it would take linear time.
> 
> Add comments here about what these mean?
> 

Sure, will do

>> +       if (policy == HEAP_REP_TOP)
> 
> switch() here?
> 

Can switch over

>> +               if (heap->gt(p, ptrs[0]))
>> +                       return p;
>> +
>> +       if (policy == HEAP_REP_LEAF) {
>> +               /* Heap insertion */
>> +               int pos = heap->size - 1;
>> +               res = ptrs[pos];
>> +               heap_insert_at(heap, p, pos);
>> +               return res;
>> +       }
>>
>>        /* Replace the current max and heapify */
>>        res = ptrs[0];
> 
> This should probably be in the arm dealing with
> HEAP_REP_TOP/HEAP_DROP_MAX since we only get here in that case.

I can do that, I'll need to rearrange the code and merge the condition above
with the ->gt check into HEAP_DROP_MAX

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

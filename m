Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYC1NDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYC1NDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbYC1M6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 08:58:34 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:46883 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282AbYC1M6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 08:58:32 -0400
Message-ID: <47ECEA8F.5060505@linux.vnet.ibm.com>
Date: Fri, 28 Mar 2008 18:24:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@linux.vnet.ibm.com, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v2)
References: <20080328082316.6961.29044.sendpatchset@localhost.localdomain> <6599ad830803280401r68d30e91waaea8eb1de36eb52@mail.gmail.com> <47ECE662.3060506@linux.vnet.ibm.com>
In-Reply-To: <47ECE662.3060506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Paul Menage wrote:
>> On Fri, Mar 28, 2008 at 1:23 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>  diff -puN include/linux/mm_types.h~memory-controller-add-mm-owner include/linux/mm_types.h
>>>  --- linux-2.6.25-rc5/include/linux/mm_types.h~memory-controller-add-mm-owner    2008-03-28 09:30:47.000000000 +0530
>>>  +++ linux-2.6.25-rc5-balbir/include/linux/mm_types.h    2008-03-28 12:26:59.000000000 +0530
>>>  @@ -227,8 +227,10 @@ struct mm_struct {
>>>         /* aio bits */
>>>         rwlock_t                ioctx_list_lock;
>>>         struct kioctx           *ioctx_list;
>>>  -#ifdef CONFIG_CGROUP_MEM_RES_CTLR
>>>  -       struct mem_cgroup *mem_cgroup;
>>>  +#ifdef CONFIG_MM_OWNER
>>>  +       spinlock_t owner_lock;
>>>  +       struct task_struct *owner;      /* The thread group leader that */
>>>  +                                       /* owns the mm_struct.          */
>>>   #endif
>> I'm not convinced that we need the spinlock. Just use the simple rule
>> that you can only modify mm->owner if:
>>
>> - mm->owner points to current
>> - the new owner is a user of mm
> 
> This will always hold, otherwise it cannot be the new owner :)
> 
>> - you hold task_lock() for the new owner (which is necessary anyway to
>> ensure that the new owner's mm doesn't change while you're updating
>> mm->owner)
>>

Thinking more, I don't think it makes sense for us to overload task_lock() to do
the mm->owner handling (we don't want to mix lock domains). task_lock() is used
for several things

1. We don't want to make task_lock() rules more complicated by having it protect
an mm member to save space
2. We don't want more contention on task_lock()

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

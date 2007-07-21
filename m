Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbXGURMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbXGURMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 13:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXGURLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 13:11:54 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:56703 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbXGURLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 13:11:53 -0400
Message-ID: <46A23E49.3050304@linux.vnet.ibm.com>
Date: Sat, 21 Jul 2007 22:41:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Containers <containers@lists.osdl.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, Dave Hansen <haveblue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][-mm PATCH 4/8] Memory controller memory accounting (v3)
References: <20070720082352.20752.37209.sendpatchset@balbir-laptop> <20070720082440.20752.67223.sendpatchset@balbir-laptop> <6599ad830707201403n6a364514y601996145fa3714c@mail.gmail.com>
In-Reply-To: <6599ad830707201403n6a364514y601996145fa3714c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 7/20/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> +void __always_inline unlock_meta_page(struct page *page)
>> +{
>> +       bit_spin_unlock(PG_metapage, &page->flags);
>> +}
> 
> Maybe add a BUG_ON(!test_bit(PG_metapage, &page->flags)) at least for
> development?
> 

I'd rather make that a VM_BUG_ON, but that's a good suggestion

>> +       mem = rcu_dereference(mm->mem_container);
>> +       /*
>> +        * For every charge from the container, increment reference
>> +        * count
>> +        */
>> +       css_get(&mem->css);
>> +       rcu_read_unlock();
> 
> It's not clear to me that this is safe.
> 
> If
> 
>> +
>> +       /*
>> +        * If we created the meta_page, we should free it on exceeding
>> +        * the container limit.
>> +        */
>> +       if (res_counter_charge(&mem->res, 1)) {
>> +               css_put(&mem->css);
>> +               goto free_mp;
>> +       }
>> +
>> +       lock_meta_page(page);
>> +       /*
>> +        * Check if somebody else beat us to allocating the meta_page
>> +        */
>> +       if (page_get_meta_page(page)) {
> 
> I think you need to add something like
> 
>  kfree(mp);
>  mp = page_get_meta_page(page);
> 
> otherwise you're going to leak the new but unneeded metapage.
> 

Yes, good catch! I am surprised I did not check for that.

>> +               atomic_inc(&mp->ref_cnt);
>> +               res_counter_uncharge(&mem->res, 1);
>> +               goto done;
>> +       }
>> +
>> +       atomic_set(&mp->ref_cnt, 1);
>> +       mp->mem_container = mem;
>> +       mp->page = page;
>> +       page_assign_meta_page(page, mp);
> 
> Would it make sense to have the "mp->page = page" be part of
> page_assign_meta_page() for consistency?
> 

Yes, that could be done easily.

>> +err:
>> +       unlock_meta_page(page);
>> +       return -ENOMEM;
> 
> The only jump to err: is from a location where the metapage is already
> unlocked. Maybe scrap err: and just do a return -ENOMEM when the
> allocation fails?
> 

Sounds good, let me revisit the code.

>> +out_uncharge:
>> +       mem_container_uncharge(page_get_meta_page(page));
> 
> Wanting to call mem_container_uncharge() on a page and hence having to
> call page_get_meta_page() seems to be more common than wanting to call
> it on a meta page that you already have available. Maybe make
> mem_container_uncharge() be a wrapper that take a struct page and does
> something like mem_container_uncharge_mp(page_get_meta_page(page))
> where mem_container_uncharge_mp() is the raw meta-page version?
> 


Yes.. right! Will do, I'll write a wrapper.

> Paul


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

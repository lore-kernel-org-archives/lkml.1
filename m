Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZHUCpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZHUCpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 22:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZHUCpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 22:45:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:17919 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbZHUCpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 22:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hpdZ0MY96dGOgS6UEd/ZzfdJBiFYUprJfBoB9RV2132o8JKs0QdB3nYAhOHDO9LmyN
         y9fMzC7CUzl6v6UkvLawIGz7ZbwRuHYiTFdY0NxajHbMy1RnjE9qQYcvy26DVLUMseuo
         ZVtsNgXdtoxQhZu62rQ+cgti5G+dQpywzy7qQ=
Date: Fri, 21 Aug 2009 10:47:36 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, linux-mm@kvack.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 8/8] kexec: allow to shrink reserved memory
Message-ID: <20090821024736.GB4447@cr0.nay.redhat.com>
References: <4A8A4ABB.70003@redhat.com> <20090818172552.779d0768.kamezawa.hiroyu@jp.fujitsu.com> <4A8A83F4.6010408@redhat.com> <20090819085703.ccf9992a.kamezawa.hiroyu@jp.fujitsu.com> <4A8B6649.3080103@redhat.com> <20090819171346.aadfeb2c.kamezawa.hiroyu@jp.fujitsu.com> <4A8D144C.5050005@redhat.com> <20090821093452.ead96b2d.kamezawa.hiroyu@jp.fujitsu.com> <20090821015927.GA4447@cr0.nay.redhat.com> <20090821110309.2d5ffb62.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821110309.2d5ffb62.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 11:03:09AM +0900, KAMEZAWA Hiroyuki wrote:
>On Fri, 21 Aug 2009 09:59:27 +0800
>Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Fri, Aug 21, 2009 at 09:34:52AM +0900, KAMEZAWA Hiroyuki wrote:
>> >On Thu, 20 Aug 2009 17:15:56 +0800
>> >Amerigo Wang <amwang@redhat.com> wrote:
>> >    
>> >> > The, problem is whether memmap is there or not. That's all.
>> >> > plz see init sequence and check there are memmap.
>> >> > If memory-for-crash is obtained via bootmem,
>> >> > Don't you try to free memory hole ?
>> >> >   
>> >> 
>> >> Hi,
>> >> 
>> >> It looks like that mem_map has 'struct page' for the reserved memory, I 
>> >> checked my "early_node_map[] active PFN ranges" output, the reserved 
>> >> memory area for crash kernel is right in one range. Am I missing 
>> >> something here?
>> >> 
>> >> I don't know why that oops comes out, maybe because of no PTE for thoese 
>> >> pages?
>> >> 
>> >Hmm ? Could you show me the code you use ?
>> 
>> (Sorry that I reply to you with my gmail, my work email can't send out
>> this message, probably because one of the destinations is broken...
>> I am the same person, don't be confused. :-)
>> 
>> Sure. Below is it:
>> 
>> +    for (addr = end + 1; addr < crashk_res.end; addr += PAGE_SIZE) {
>> +        printk(KERN_DEBUG "PFN is valid? %d\n", pfn_valid(addr>>PAGE_SHIFT));
>> +        ClearPageReserved(virt_to_page(addr));
>> +        init_page_count(virt_to_page(addr));
>> +        free_page(addr);
>> +        totalram_pages++;
>> +    }
>> 
>> 
>> pfn_valid() returns 1, and oops happens at ClearPageReserved().
>> ('addr' is right between crashk_res.start and crashk_res.end)
>
>Confused, 
>  if    pfn_valid(addr >> PAGE_SHIFT) == true 
>
>you should do
>	ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
>
>because addr is physical address, not virtual.
>I guess crashk_res.end is physical address....

Excellent! You are right!

In fact, when I read the kexec code at the first time, I thought
'crashk_res' should hold physical address too, but after reading
more code I dropped that idea, so I am wrong. :-/

I will resend the whole patchset soon. It works now!

Thanks for your nice help, Hiroyuki!


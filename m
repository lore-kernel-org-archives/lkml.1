Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYKMKit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYKMKit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYKMKih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:38:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYKMKif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:38:35 -0500
Message-ID: <491C038F.5020007@redhat.com>
Date: Thu, 13 Nov 2008 12:38:07 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Izik Eidus <izik@qumranet.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, chrisw@redhat.com,
       izike@qumranet.com
Subject: Re: [PATCH 2/4] Add replace_page(), change the mapping of pte from
 one page into another
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>	<1226409701-14831-2-git-send-email-ieidus@redhat.com>	<1226409701-14831-3-git-send-email-ieidus@redhat.com>	<20081111114555.eb808843.akpm@linux-foundation.org>	<4919F1C0.2050009@redhat.com>	<Pine.LNX.4.64.0811111520590.27767@quilx.com>	<4919F7EE.3070501@redhat.com>	<Pine.LNX.4.64.0811111527500.27767@quilx.com>	<20081111222421.GL10818@random.random>	<20081112111931.0e40c27d.kamezawa.hiroyu@jp.fujitsu.com>	<491AAA84.5040801@redhat.com>	<491AB9D0.7060802@qumranet.com> <20081113151129.35c17962.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081113151129.35c17962.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ציטוט KAMEZAWA Hiroyuki:
> Thank you for answers.
>
> On Wed, 12 Nov 2008 13:11:12 +0200
> Izik Eidus <izik@qumranet.com> wrote:
>
>   
>> Avi Kivity wrote:
>>     
>>> KAMEZAWA Hiroyuki wrote:
>>>       
>>>> Can I make a question ? (I'm working for memory cgroup.)
>>>>
>>>> Now, we do charge to anonymous page when
>>>>   - charge(+1) when it's mapped firstly (mapcount 0->1)
>>>>   - uncharge(-1) it's fully unmapped (mapcount 1->0) vir 
>>>> page_remove_rmap().
>>>>
>>>> My quesion is
>>>>  - PageKSM pages are not necessary to be tracked by memory cgroup ?
>>>>         
>> When we reaplacing page using page_replace() we have:
>> oldpage - > anonymous page that is going to be replaced by newpage
>> newpage -> kernel allocated page (KsmPage)
>> so about oldpage we are calling page_remove_rmap() that will notify cgroup
>> and about newpage it wont be count inside cgroup beacuse it is file rmap 
>> page
>> (we are calling to page_add_file_rmap), so right now PageKSM wont ever 
>> be tracked by cgroup.
>>
>>     
> If not in radix-tree, it's not tracked.
> (But we don't want to track non-LRU pages which are not freeable.)
>   

Yes.

>
>   
>>>>  - Can we know that "the page is just replaced and we don't necessary 
>>>> to do
>>>>    charge/uncharge".
>>>>         
>> The caller of page_replace does know it, the only problem is that 
>> page_remove_rmap()
>> automaticly change the cgroup for anonymous pages,
>> if we want it not to change the cgroup, we can:
>> increase the cgroup count before page_remove (but in that case what 
>> happen if we reach to the limit???)
>> give parameter to page_remove_rmap() that we dont want the cgroup to be 
>> changed.
>>     
>
> Hmm, current mem cgroup works via page_cgroup struct to track pages.
>
>    page <-> page_cgroup has one-to-one relation ship.
>
> So, "exchanging page" itself causes trouble. But I may be able to provide
> necessary hooks to you as I did in page migraiton.
>   

But if we dont track KsmPages, and we call to page_remove_rmap() on the 
anonymous page that we
replace, why would it be a problem?
(should everything be correct in that case???)

>   
>>>>  - annonymous page from KSM is worth to be tracked by memory cgroup ?
>>>>    (IOW, it's on LRU and can be swapped-out ?)
>>>>         
>> KSM have no anonymous pages (it share anonymous pages into KsmPAGE -> 
>> kernel allocated page without mapping)
>> so it isnt in LRU and it cannt be swapped, only when KsmPAGEs will be 
>> break by do_wp_page() the duplication will be able to swap.
>>
>>     
> Ok, thank you for confirmation.
>
>   
>>>>   
>>>>         
>>> My feeling is that shared pages should be accounted as if they were 
>>> not shared; that is, a share page should be accounted for each process 
>>> that shares it.  Perhaps sharing within a cgroup should be counted as 
>>> 1 page for all the ptes pointing to it.
>>>
>>>
>>>       
>
> If KSM pages are on radix-tree, it will be accounted automatically.
> Now, we have "Unevictable" LRU and mlocked() pages are smartly isolated into its
> own LRU. So, just doing
>
>  - inode's radix-tree
>  - make all pages mlocked.
>  - provide special page fault handler for your purpose
>   

Well in this version that i am going to merge the pages arent going to 
be swappable,
Latter after Ksm will get merged we will make the KsmPages swappable...
so i think working with cgroups would be effective / useful only when 
KsmPages will start be swappable...
Do you agree?
(What i am saying is that right now lets dont count the KsmPages inside 
the cgroup, lets do it when KsmPages
will be swappable)

If you feel this pages should be counted in the cgroup i have no problem 
to do it via hooks like page migration is doing.

thanks.

> is simple one. But ok, whatever implementation you'll do, I have to check it
> and consider whether it should be tracked or not. Then, add codes to memcg to
> track it or ignore it or comments on your patches ;)
>
> It's helpful to add me to CC: when you post this set again.
>   

Sure will.

> Thanks,
> -Kame
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


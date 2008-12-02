Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbYLBG4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYLBG4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 01:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYLBG43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 01:56:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbYLBG42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 01:56:28 -0500
Message-ID: <4934DC34.7090406@cn.fujitsu.com>
Date: Tue, 02 Dec 2008 14:56:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] cgroup: fix pre_destroy and semantics of css->refcnt
References: <20081201145907.e6d63d61.kamezawa.hiroyu@jp.fujitsu.com>	<20081201150208.6b24506b.kamezawa.hiroyu@jp.fujitsu.com>	<4934D27B.4020904@cn.fujitsu.com> <20081202152129.d795da96.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081202152129.d795da96.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 02 Dec 2008 14:15:23 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> KAMEZAWA Hiroyuki wrote:
>>> Now, final check of refcnt is done after pre_destroy(), so rmdir() can fail
>>> after pre_destroy().
>>> memcg set mem->obsolete to be 1 at pre_destroy and this is buggy..
>>>
>>> Several ways to fix this can be considered. This is an idea.
>>>
>> I don't see what's the difference with css_under_removal() in this patch and
>> cgroup_is_removed() which is currently available.
>>
>> CGRP_REMOVED flag is set in cgroup_rmdir() when it's confirmed that rmdir can
>> be sucessfully performed.
>>
>> So mem->obsolete can be replaced with:
>>
>> bool mem_cgroup_is_obsolete(struct mem_cgroup *mem)
>> {
>> 	return cgroup_is_removed(mem->css.cgroup);
>> }
>>
>> Or am I missing something?
>>
> Yes.
> 	1. "cgroup" and "css" object are different object.
> 	2. css object may not be freed at destroy() (as current memcg does.)
> 
> Some of css objects cannot be freed even when there are no tasks because
> of reference from some persistent object or temporal refcnt.
> 

I just noticed mem_cgroup has its own refcnt now. The memcg code has changed
dramatically that I don't catch up with it. Thx for the explanation.

But I have another doubt:

void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
{
	struct mem_cgroup *memcg;

	memcg = __mem_cgroup_uncharge_common(page,
					MEM_CGROUP_CHARGE_TYPE_SWAPOUT);
	/* record memcg information */
	if (do_swap_account && memcg) {
		swap_cgroup_record(ent, memcg);
		mem_cgroup_get(memcg);
	}
}

In the above code, is it possible that memcg is freed before mem_cgroup_get()
increases memcg->refcnt?

> Please consider css_under_removal() as a kind of css_tryget() which doesn't
> increase any refcnt.
> 
> Thanks,
> -Kame
> 


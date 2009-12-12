Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbZLLNLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbZLLNLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 08:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbZLLNL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 08:11:28 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:49542 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZLLNL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 08:11:27 -0500
MIME-Version: 1.0
In-Reply-To: <20091212121902.e95f9561.d-nishimura@mtf.biglobe.ne.jp>
References: <cover.1260571675.git.kirill@shutemov.name>
	 <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	 <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	 <747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	 <9e6e8d687224c6cbc54281f7c3d07983f701f93d.1260571675.git.kirill@shutemov.name>
	 <20091212121902.e95f9561.d-nishimura@mtf.biglobe.ne.jp>
Date: Sat, 12 Dec 2009 15:11:33 +0200
Message-ID: <cc557aab0912120511r7c83e97di3f97d2bb5eae326c@mail.gmail.com>
Subject: Re: [PATCH RFC v2 4/4] memcg: implement memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: nishimura@mxp.nes.nec.co.jp
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 5:19 AM, Daisuke Nishimura
<d-nishimura@mtf.biglobe.ne.jp> wrote:
>> @@ -56,6 +61,7 @@ static int really_do_swap_account __initdata = 1; /* for remember boot option*/
>>
>>  static DEFINE_MUTEX(memcg_tasklist); /* can be hold under cgroup_mutex */
> This mutex has already removed in current mmotm.
> Please write a patch for memcg based on mmot.

Ok.

>
>>  #define SOFTLIMIT_EVENTS_THRESH (1000)
>> +#define THRESHOLDS_EVENTS_THRESH (100)
>>
>>  /*
>>   * Statistics for memory cgroup.
>
> (snip)
>
>> @@ -1363,6 +1395,11 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>>       if (mem_cgroup_soft_limit_check(mem))
>>               mem_cgroup_update_tree(mem, page);
>>  done:
>> +     if (mem_cgroup_threshold_check(mem)) {
>> +             mem_cgroup_threshold(mem, false);
>> +             if (do_swap_account)
>> +                     mem_cgroup_threshold(mem, true);
>> +     }
>>       return 0;
>>  nomem:
>>       css_put(&mem->css);
>> @@ -1906,6 +1943,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
>>
>>       if (mem_cgroup_soft_limit_check(mem))
>>               mem_cgroup_update_tree(mem, page);
>> +     if (mem_cgroup_threshold_check(mem)) {
>> +             mem_cgroup_threshold(mem, false);
>> +             if (do_swap_account)
>> +                     mem_cgroup_threshold(mem, true);
>> +     }
>>       /* at swapout, this memcg will be accessed to record to swap */
>>       if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
>>               css_put(&mem->css);
> Can "if (do_swap_account)" check be moved into mem_cgroup_threshold ?

Ok, I'll move it. It will affect performance of
mem_cgroup_invalidate_thresholds(),
but I don't think that it's important.

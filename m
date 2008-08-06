Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYHFNql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYHFNql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYHFNqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:46:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33057 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYHFNq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:46:29 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <16255819.1218030343593.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 6 Aug 2008 22:45:43 +0900 (JST)
To: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into two parts
Cc: kamezawa.hiroyu@jp.fujitsu.com, ryov@valinux.co.jp,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org
In-Reply-To: <20080806.204339.76736223.taka@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <20080806.204339.76736223.taka@valinux.co.jp>
 <20080804.175707.104036289.ryov@valinux.co.jp>
	<20080804.175748.189722512.ryov@valinux.co.jp>
	<20080806165421.f76edd47.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
>> > This patch splits the cgroup memory subsystem into two parts.
>> > One is for tracking pages to find out the owners. The other is
>> > for controlling how much amount of memory should be assigned to
>> > each cgroup.
>> > 
>> > With this patch, you can use the page tracking mechanism even if
>> > the memory subsystem is off.
>> > 
>> > Based on 2.6.27-rc1-mm1
>> > Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
>> > Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
>> > 
>> 
>> Plese CC me or Balbir or Pavel (See Maintainer list) when you try this ;)
>> 
>> After this patch, the total structure is
>> 
>>  page <-> page_cgroup <-> bio_cgroup.
>>  (multiple bio_cgroup can be attached to page_cgroup)
>>
>> Does this pointer chain will add
>>   - significant performance regression or
>>   - new race condtions 
>> ?
>
>I don't think it will cause significant performance loss, because
>the link between a page and a page_cgroup has already existed, which
>the memory resource controller prepared. Bio_cgroup uses this as it is,
>and does nothing about this.
>
>And the link between page_cgroup and bio_cgroup isn't protected
>by any additional spin-locks, since the associated bio_cgroup is
>guaranteed to exist as long as the bio_cgroup owns pages.
>
Hmm, I think page_cgroup's cost is visible when
1. a page is changed to be in-use state. (fault or radixt-tree-insert)
2. a page is changed to be out-of-use state (fault or radixt-tree-removal)
3. memcg hit its limit or global LRU reclaim runs.

"1" and "2" can be catched as 5% loss of exec throuput. 
"3" is not measured (because LRU walk itself is heavy.)

What new chances to access page_cgroup you'll add ?
I'll have to take into account them.

>I've just noticed that most of overhead comes from the spin-locks
>when reclaiming the pages inside mem_cgroups and the spin-locks to
>protect the links between pages and page_cgroups.
Overhead between page <-> page_cgroup lock is cannot be catched by
lock_stat now.Do you have numbers ?
But ok, there are too many locks ;(

>The latter overhead comes from the policy your team has chosen
>that page_cgroup structures are allocated on demand. I still feel
>this approach doesn't make any sense because linux kernel tries to
>make use of most of the pages as far as it can, so most of them
>have to be assigned its related page_cgroup. It would make us happy
>if page_cgroups are allocated at the booting time.
>
Now, multi-sizer-page-cache is discussed for a long time. If it's our
direction, on-demand page_cgroup make sense.


>> For example, adding a simple function.
>> ==
>> int get_page_io_id(struct page *)
>>  - returns a I/O cgroup ID for this page. If ID is not found, -1 is returne
d.
>>    ID is not guaranteed to be valid value. (ID can be obsolete)
>> ==
>> And just storing cgroup ID to page_cgroup at page allocation.
>> Then, making bio_cgroup independent from page_cgroup and 
>> get ID if avialble and avoid too much pointer walking.
>
>I don't think there are any diffrences between a poiter and ID.
>I think this ID is just a encoded version of the pointer.
>
ID can be obsolete, pointer is not. memory cgroup has to take care of
bio cgroup's race condition ? (About race conditions, it's already complicated
enough)

To be honest, I think adding a new (4 or 8 bytes) page struct and record infor
mation of bio-control is more straightforward approach. Buy as you might
think, "there is no room"

Thanks,
-Kame


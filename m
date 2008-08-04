Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbYHDXwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbYHDXwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 19:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763172AbYHDXwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 19:52:25 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:22132 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763064AbYHDXwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sz8Eczlr3SqiirJUxZfF44b+Idh3qizCPviS3VkFCFaJYIsEZ2iRm7X960QPrY/TNT
         Jwhp4WjHtnLrPe4JwG0zlQ9jSBwjcvJ0M9InbDXPa7w2+vHOHURo1P+UC+eJom5Qw8YC
         ADmS9SPa6p3oAwGgqy/CGWmqrQRVOM9oLkn+s=
Message-ID: <28c262360808041652o2c832e92h6ed3c2302bb023dc@mail.gmail.com>
Date: Tue, 5 Aug 2008 08:52:21 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Race condition between putback_lru_page and mem_cgroup_move_list
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, "Rik van Riel" <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489741F8.2080104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <28c262360808040736u7f364fc0p28d7ceea7303a626@mail.gmail.com>
	 <1217863870.7065.62.camel@lts-notebook>
	 <2f11576a0808040937y70f274e0j32f6b9c98b0f992d@mail.gmail.com>
	 <489741F8.2080104@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m74NqoIG015906

On Tue, Aug 5, 2008 at 2:52 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:> KOSAKI Motohiro wrote:>> Hi>>>>>> I think this is a race condition if mem_cgroup_move_lists's comment isn't right.>>>> I am not sure that it was already known problem.>>>>>>>> mem_cgroup_move_lists assume the appropriate zone's lru lock is already held.>>>> but putback_lru_page calls mem_cgroup_move_lists without holding lru_lock.>>> Hmmm, the comment on mem_cgroup_move_lists() does say this.  Although,>>> reading thru' the code, I can't see why it requires this.  But then it's>>> Monday, here...>>>> I also think zone's lru lock is unnecessary.>> So, I guess below "it" indicate lock_page_cgroup, not zone lru lock.>>>> We need zone LRU lock, since the reclaim paths hold them. Not sure if I
Could you explan why you need lru_lock more exact ?I think it is need by race condition with global reclaim.Are there any other cause ?
> understand why you call zone's LRU lock unnecessary, could you elaborate please?>>>  >> But we cannot safely get to page_cgroup without it, so just try_lock it:>>>> if my assumption is true, comment modifying is better.>>>>>>>> Repeatedly, spin_[un/lock]_irq use in mem_cgroup_move_list have a big overhead>>>> while doing list iteration.>>>>>>>> Do we have to use pagevec ?>>> This shouldn't be necessary, IMO.  putback_lru_page() is used as>>> follows:>>>>>> 1) in vmscan.c [shrink_*_list()] when an unevictable page is>>> encountered.  This should be relatively rare.  Once vmscan sees an>>> unevictable page, it parks it on the unevictable lru list where it>>> [vmscan] won't see the page again until it becomes reclaimable.>>>>>> 2) as a replacement for move_to_lru() in page migration as the inverse>>> to isolate_lru_page().  We did this to catch patches that became>>> unevictable or, more importantly, evictable while page migration held>>> them isolated.  move_to_lru() already grabbed and released the zone lru>>> lock on each page migrated.>>>>>> 3) In m[un]lock_vma_page() and clear_page_mlock(), new with in the>>> "mlocked pages are unevictable" series.  This one can result in a storm>>> of zone lru traffic--e.g., mlock()ing or munlocking() a large segment or>>> mlockall() of a task with a lot of mapped address space.  Again, this is>>> probably a very rare event--unless you're stressing [stressing over?]>>> mlock(), as I've been doing :)--and often involves a major fault [page>>> allocation], per page anyway.>>>>>> Iï»¿ originally did have a pagevec for the unevictable lru but it>>> complicated ensuring that we don't strand evictable pages on the>>> unevictable list.  See the retry logic in putback_lru_page().>>>>>> As for the !UNEVICTABLE_LRU version, the only place this should be>>> called is from page migration as none of the other call sites are>>> compiled in or reachable when !UNEVICTABLE_LRU.>>>>>> Thoughts?>>>> I think both opinion is correct.>> unevictable lru related code doesn't require pagevec.>>>> but mem_cgroup_move_lists is used by active/inactive list transition too.>> then, pagevec is necessary for keeping reclaim throuput.>>>> It's on my TODO list. I hope to get to it soon.>>> Kim-san, Thank you nice point out!>> I queued this fix to my TODO list.>>> -->        Warm Regards,>        Balbir Singh>        Linux Technology Center>        IBM, ISTL>>


-- Kinds regards,MinChan Kimÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

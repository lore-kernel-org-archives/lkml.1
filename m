Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYGAIRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYGAIRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbYGAIQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:16:46 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:32965 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYGAIQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o4HD6Wm11d2vB/kbg4n7g99YS7pIITTPaQ6eAmIY52FWv8h5zy6PFIOneEeF87HgOl
         9ArxgDGnKdQekQSpi90/aw421AvyQWp0wNhtxij/YG+A2BT9dSlSQEa6KqU6B+FW3mzu
         pinG4fZuwZ2GO1KuN2Z3FuYkKUoDzerj595lw=
Message-ID: <28c262360807010116x4be78fd6t7525695891cb4d3c@mail.gmail.com>
Date: Tue, 1 Jul 2008 17:16:43 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] split_lru: fix pagevec_move_tail() doesn't treat unevictable page
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
In-Reply-To: <20080701163601.37FB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701155749.37F8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <28c262360807010034m7438f1e3yc28daae9978150b6@mail.gmail.com>
	 <20080701163601.37FB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 4:56 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi Kim-san,
>
> Thank you for good question.

Thanks for good explaining.
I guess your scenario have a possibility.

If I don't have a test HPC, I will dig in source. :)

>> > even under writebacking, page can move to unevictable list.
>> > so shouldn't pagevec_move_tail() check unevictable?
>> >
>> Hi, Kosaki-san.
>>
>> I can't understand this race situation.
>> How the page can move to unevictable list while it is under writeback?
>>
>> Could you explain for me ? :)
>
> Actually, I added below assertion and tested on stress workload.
> then system crashed after 4H runnings.
>
> ----------------------------------------------
> static void pagevec_move_tail(struct pagevec *pvec)
> {
> (snip)
>                if (PageLRU(page) && !PageActive(page)) {
>                        int lru = page_is_file_cache(page);
>                        list_move_tail(&page->lru, &zone->lru[lru].list);
>                        BUG_ON(page_lru(page) != lru);  // !!here
>                        pgmoved++;
>                }
>        }
> ----------------------------------------------------
>
> So, I guess below race exist (but I hope Rik's review)
>
>
>    CPU1                                       CPU2
> ==================================================================
> 1. rotate_reclaimable_page()
> 2. PageUnevictable(page) return 0
> 3. local_irq_save()
> 4. pagevec_move_tail()
>                                       SetPageUnevictable()   //mlock?
>                                       move to unevictable list
> 5. spin_lock(&zone->lru_lock);
> 6. list_move_tail(); (move to inactive list)
>
> then page have PageUnevictable() and is chained inactive lru.
> Or, I misunderstand it?
>
>
> abstraction of related function
> ------------------------------------------------------------
> void  rotate_reclaimable_page(struct page *page)
> {
>        if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
>            !PageUnevictable(page) && PageLRU(page)) {
>                local_irq_save(flags);
>                pagevec_move_tail(pvec);
>                local_irq_restore(flags);
>        }
> }
>
> pagevec_move_tail(){
>        spin_lock(&zone->lru_lock);
>        if (PageLRU(page) && !PageActive(page)) {
>                list_move_tail(&page->lru, &zone->lru[lru].list);
>        }
>        spin_unlock(&zone->lru_lock);
> }
>
>
>
>
>



-- 
Kinds regards,
MinChan Kim

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYGAH5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYGAH5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYGAH5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:57:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36241 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYGAH5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:57:10 -0400
Date: Tue, 01 Jul 2008 16:56:25 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] split_lru: fix pagevec_move_tail() doesn't treat unevictable page
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
In-Reply-To: <28c262360807010034m7438f1e3yc28daae9978150b6@mail.gmail.com>
References: <20080701155749.37F8.KOSAKI.MOTOHIRO@jp.fujitsu.com> <28c262360807010034m7438f1e3yc28daae9978150b6@mail.gmail.com>
Message-Id: <20080701163601.37FB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim-san,

Thank you for good question.

> > even under writebacking, page can move to unevictable list.
> > so shouldn't pagevec_move_tail() check unevictable?
> >
> Hi, Kosaki-san.
> 
> I can't understand this race situation.
> How the page can move to unevictable list while it is under writeback?
> 
> Could you explain for me ? :)

Actually, I added below assertion and tested on stress workload.
then system crashed after 4H runnings.

----------------------------------------------
static void pagevec_move_tail(struct pagevec *pvec)
{
(snip)
                if (PageLRU(page) && !PageActive(page)) {
                        int lru = page_is_file_cache(page);
                        list_move_tail(&page->lru, &zone->lru[lru].list);
                        BUG_ON(page_lru(page) != lru);  // !!here
                        pgmoved++;
                }
        }
----------------------------------------------------

So, I guess below race exist (but I hope Rik's review)


    CPU1                                       CPU2
==================================================================
1. rotate_reclaimable_page()
2. PageUnevictable(page) return 0
3. local_irq_save()
4. pagevec_move_tail()
                                       SetPageUnevictable()   //mlock?
                                       move to unevictable list
5. spin_lock(&zone->lru_lock);
6. list_move_tail(); (move to inactive list)

then page have PageUnevictable() and is chained inactive lru.
Or, I misunderstand it?


abstraction of related function
------------------------------------------------------------
void  rotate_reclaimable_page(struct page *page)
{
        if (!PageLocked(page) && !PageDirty(page) && !PageActive(page) &&
            !PageUnevictable(page) && PageLRU(page)) {
                local_irq_save(flags);
                pagevec_move_tail(pvec);
                local_irq_restore(flags);
        }
}

pagevec_move_tail(){
	spin_lock(&zone->lru_lock);
	if (PageLRU(page) && !PageActive(page)) {
		list_move_tail(&page->lru, &zone->lru[lru].list);
	}
	spin_unlock(&zone->lru_lock);
}





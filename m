Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYLDEzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYLDEzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLDEze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:55:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58105 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYLDEzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:55:33 -0500
Date: Thu, 4 Dec 2008 13:54:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "wassim dagash" <wassim.dagash@gmail.com>, linux-kernel@vger.kernel.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: KSWAPD Algorithm
Message-Id: <20081204135441.dc95ffc7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87prk9xqg0.fsf@basil.nowhere.org>
References: <cb94e63d0812022302m341fcdf5wffbca0ec12db426b@mail.gmail.com>
	<87prk9xqg0.fsf@basil.nowhere.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 15:51:11 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> "wassim dagash" <wassim.dagash@gmail.com> writes:
> 
> > Hi All,
> > Description:
> > I countered a weird problem with kswapd:
> > it runs in some infinite loop trying to swap until order 10 of zone
> > highmem is OK, While zone higmem (as I understand) has nothing to do
> > with contiguous physical memory (cause there is no 1-1 mapping) which
> > means kswapd will continue to try to balance order 10 of zone highmem
> > forever (or until someone release a very large chunk of highmem).
> > Can anyone please explain me the algorithm of kswapd and why it tries
> > to balance order 10 of zone higmem ?
> 
> hugetlbfs requires large continuous mappings even in highmem
> to map 2MB pages or similar to user space.
> However order 10 seems pretty high, normally that's only order 8
> on a i386 system.
> 

Reading Kosaki's explanation, it seems

  - order-10 allocation occurs at ZONE_NORMAL.

  - kswapd is kicked with order=10.
	wakeup_kswaps(zone, 10) -> pgdat->kswapd_max_order = 10.
  
  - kswapd(balance_pgdat()) does 
	if (!zone_watermark_ok(zone, order, zone->pages_high, end_zone, 0))
			all_zones_ok = 0;
    And this "zone" is all zone, i.e. DMA, NORMAL, HIGHMEM.

    Then, loop again,

	if (!all_zones_ok) {
		cond_resched();

		try_to_freeze();

		goto loop_again;
	}

Maybe...

-Kame


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYBGIKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYBGIKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYBGIJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:09:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42251 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbYBGIJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:09:49 -0500
Date: Thu, 7 Feb 2008 09:09:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: fix page table size
Message-ID: <20080207080930.GB28631@elte.hu>
References: <200802061246.43413.yinghai.lu@sun.com> <200802061501.26533.yinghai.lu@sun.com> <20080206231226.GA6417@elte.hu> <200802062022.44069.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802062022.44069.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: fix page table size

> Entering add_active_range(0, 1048576, 67239936) 2 entries of 3200 used
> end_pfn_map = 67239936
> Kernel panic - not syncing: Overlapping early reservations 8000-109fff 
> PGTABLE to 9bc00-9dbff EBDA
> 
> change back the logic. we DO need extra space for pmds when 
> direct_gbpages is not there.

> @@ -370,7 +370,7 @@ static void __init find_early_table_space(unsigned long end)
>  
>  	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
>  	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
> -	if (direct_gbpages) {
> +	if (!direct_gbpages) {

thanks Yinghai, applied!

I'm wondering why this bug didnt trigger more widely. It seems to me it 
needs some serious amount of RAM to trigger this bug - correct?

btw., it would be nice to have some "lots of RAM simulation" debugging 
code which would just _fake_ a really large e820 map and would in the 
end throw away the 'fake' pages later during bootup. Perhaps tell the 
early allocator to never allocate into these fake areas [via an struct 
e820 entry flag], but all our sizing code and the boot bitmaps, etc. 
would be sized accordingly, as if we had this much RAM - and we'd 
trigger these nuances. We could put this into a new "fakemem=128GB" boot 
option and hence we could boot with fakemem=128GB on a 2GB box and could 
at least hope to be able to boot [with some serious amount of RAM wasted 
on over-sized pagetables, allocator bitmaps and mem_map[]]. Hm?

	Ingo

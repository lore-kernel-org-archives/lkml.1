Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZDTMZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZDTMZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZDTMY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:24:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57071 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbZDTMYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:24:55 -0400
Date: Tue, 7 Apr 2009 10:06:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
Message-ID: <20090407080632.GG1408@ucw.cz>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090417063007.GB4593@kernel.dk> <49E83DC4.8040207@tuffmail.co.uk> <20090417091321.GP4593@kernel.dk> <alpine.LFD.2.00.0904170813550.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904170813550.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> And the thing is, swsusp_save() really does do odd things. For example, to 
> get rid of unnecessary memory, it does "drain_local_pages()", where the 
> "local" is "local cpu". Why does it do that? Likely nobody knows.

I do :-). atomic image copying needs to copy any and all used pages,
and needs to know beforehand how many to copy. local pages  are
strange in this area, so we just get rid of them to simplify stuff.

> For example, there is a magic "PAGES_FOR_IO" #define, which is somewhat 
> arbitrarily set to 4MB worth of pages. Where did that number come from? 
> Who knows? But that's the number the code uses for the _initial_
> check of 

I picked that up out of thin air. Intent there is to make sure small
(<100K, lets say) allocations will work during suspend.

> And the thing is, that "swsusp_shrink_memory()" is just full of 
> heuristics. There's no hard numbers there. It doesn't seem to wait for 
> writeout, it just does the equivalent of "shrink_list()" and 
> "shrink_slab()", but it seems to have been basically cribbed half-way 
> from the regular "try to free memory", without really doing it all.

akpm designed shrink_memory(). Long time ago it was just while (1)
kmalloc() loop. It should be waiting. Andrew?

> Just as an example: it does that "zone_is_all_unreclaimable()" logic that 
> expects kswapd to mark things reclaimable again, but it doesn't seem to 
> actually ever wait for kswapd or pdflush. It also seems to set 
> "swappiness" to zero etc. Maybe it's all intentional, but it does mean 
> that it uses some shared heuristics with the "real" VM, but uses them 
> differently.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

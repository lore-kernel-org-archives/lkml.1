Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbXIEBhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbXIEBhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 21:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbXIEBhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 21:37:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbXIEBhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 21:37:37 -0400
Message-ID: <46DE085F.2040306@redhat.com>
Date: Tue, 04 Sep 2007 21:37:35 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel 2.6.22: what IS the VM doing?
References: <20070830115429.w2puzet5sllhccdk@m.safari.iki.fi>
In-Reply-To: <20070830115429.w2puzet5sllhccdk@m.safari.iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sami Farin wrote:
> Using SMP kernel 2.6.22.6pre-CFS-v20.5 on Pentium D (IA-32).
> I think this bug (or whatever you want to call it) got triggered
> when you first allocate several megabytes of memory in a kernel module
> and then free them, and then run e.g. X and when memory gets tight,
> you end up with this situation...
> 
> Top 2 /proc/vmstat Biggest Winners:
> 
> pgrefill_normal:49900/second
> pgrefill_high:20810/second

That means the pageout code was scanning about 70000 pages
per second on your system during peak stress.  You may have
run into a scalability problem in the Linux kernel, where it
wants to clear the referenced bit off all the anonymous pages
before swapping something out.

To make matters worse, that unlucky page gets chosen because
it was the page where kswapd started scanning.  It has little
to do with being the least recently used page, because every
anonymous page tends to have its referenced bit set by the time
we start scanning.

On truly enormous systems, say with 256GB of memory, kswapd
sometimes needs to scan hundreds of thousands or even millions
of pages before finding something to swap out.  Not fun.

> Did I forget to include some info???
> Oh, and I need to reboot in order to get usable system
> when this bug happens.

Is the system trying to evict pages like crazy when your
system becomes unusable?

If so, I wonder if kswapd is simply doing the wrong thing
and trying to evict data from all zones, simply because the
highmem zone is low on free pages...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.

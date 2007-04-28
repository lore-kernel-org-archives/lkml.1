Return-Path: <linux-kernel-owner+w=401wt.eu-S1030802AbXD1Gcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030802AbXD1Gcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030989AbXD1Gcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:32:41 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:41563 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030802AbXD1Gcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:32:39 -0400
Date: Sat, 28 Apr 2007 08:32:38 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704280824420.2502@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Linus Torvalds wrote:

>
>
> On Fri, 27 Apr 2007, Mike Galbraith wrote:
>>
>> As subject states, my GUI is going away for extended periods of time
>> when my very full and likely highly fragmented (how to find out)
>> filesystem is under heavy write load.  While write is under way, if
>> amarok (mp3 player) is running, no song change will occur until write is
>> finished, and the GUI can go _entirely_ comatose for very long periods.
>> Usually, it will come back to life after write is finished, but
>> occasionally, a complete GUI restart is necessary.
>
> One thing to try out (and dammit, I should make it the default now in
> 2.6.21) is to just make the dirty limits much lower. We've been talking
> about this for ages, I think this might be the right time to do it.
>
> Especially with lots of memory, allowing 40% of that memory to be dirty is
> just insane (even if we limit it to "just" 40% of the normal memory zone.
> That can be gigabytes. And no amount of IO scheduling will make it
> pleasant to try to handle the situation where that much memory is dirty.

What about using different dirtypage limits for different processes?

--- i.e. every process has dirtypage activity counter, that is increased 
when it dirties a page and decreased over time. Compute the limit for 
process as some inverse of this counter --- so that processes that dirtied 
a lot of pages will be blocked at lower limit and processes that dirtied 
few pages will be blocked at higher limit.

The main problem is that if the user extracts tar archive, tar eventually 
blocks on writeback I/O --- O.K. But if bash attempts to write one page to 
.bash_history file at the same time, it blocks too --- bad, the user is 
annoyed.

(I don't have time to write and test it, it is just an idea --- I found 
these writeback lockups of the whole system annoying too)

Mikulas

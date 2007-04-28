Return-Path: <linux-kernel-owner+w=401wt.eu-S1163402AbXD1SI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163402AbXD1SI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163377AbXD1SAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:00:55 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:58075 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163335AbXD1Rzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:55:36 -0400
Date: Sat, 28 Apr 2007 19:55:34 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704281937110.14529@artax.karlin.mff.cuni.cz>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
 <Pine.LNX.4.64.0704280824420.2502@artax.karlin.mff.cuni.cz>
 <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Linus Torvalds wrote:

>> The main problem is that if the user extracts tar archive, tar eventually
>> blocks on writeback I/O --- O.K. But if bash attempts to write one page to
>> .bash_history file at the same time, it blocks too --- bad, the user is
>> annoyed.
>
> Right, but it's actually very unlikely. Think about it: the person who
> extracts the tar-archive is perhaps dirtying a thousand pages, while the
> .bash_history writeback is doing a single one. Which process do you think
> is going to hit the "oops, we went over the limit" case 99.9% of the time?

Both. See balance_dirty_pages --- you loop there if
global_page_state(NR_FILE_DIRTY) + global_page_state(NR_UNSTABLE_NFS) + 
global_page_state(NR_WRITEBACK) is over limit.

So tar gets there first, start writeback, blocks. Innocent process calling 
one small write() gets there too (while writeback has not yet finished), 
sees that the expression is over limit and blocks too.

Really, you go to ballance_dirty_pages with 1/8 probability, so small 
writers will block with that probability --- better than blocking always, 
but still annoying.

> The _really_ annoying problem is when you just have absolutely tons of
> memory dirty, and you start doing the writeback: if you saturate the IO
> queues totally, it simply doesn't matter _who_ starts the writeback,
> because anybody who needs to do any IO at all (not necessarily writing) is
> going to be blocked.

I saw this writeback problem on machine that had a lot of memory (1G), 
internal fast disk where the distribution was installed and very slow 
external SCSI disk (6MB/s or so). When I did heavy write on the external 
disk and writeback started, the computer almost completely locked up --- 
any process trying to write anything to the fast disk blocked until 
writeback on the slow disk finishes.
(that machine had some old RHEL kernel and it is not mine so I can't test 
new kernels on it --- but the above fragment of code shows that the 
problem still exists today)

Mikulas


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZDDQJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZDDQJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZDDQJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:09:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285AbZDDQJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:09:25 -0400
Date: Sat, 4 Apr 2009 09:06:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
In-Reply-To: <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904040901330.3915@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu>
 <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Apr 2009, Linus Torvalds wrote:

> 
> 
> On Sat, 4 Apr 2009, Jens Axboe wrote:
> > 
> > Big nack on this patch. Ted, this is EXACTLY where I told you we saw big
> > write regressions (sqlite performance drops by a factor of 4-5). Do a
> > git log on fs/buffer.c and see the original patch (which does what your
> > patch does) and the later revert. No idea why you are now suggestion
> > making that exact change?!
> 
> Jens, if I can re-create the 'fsync' times (I haven't yet), then the 
> default scheduler _will_ be switched to AS.

Btw, that patch is "obviously correct".

That write we're submitting is very much a synchronous write. After all, 
the code is literally

	ret = submit_bh(WRITE, bh);
	wait_on_buffer(bh);

and it just doesn't get any more synchronous than that. If we don't start 
the IO immediately (since we're _waiting_ for it immediately), we're 
broken. 

Now, if we need to fix some mysql throughput issue as a result, then I'd 
suggest that we look at whether "sync_dirty_buffer()" is sometimes called 
when it doesn't need to be od (b) whether perhaps the unplugging behavior 
is simply buggy in some other way.

But Ted's patch makes so much sense on a purely conceptual level, that 
when you look at the patch, you should almost not even need to see the 
performance numbers to know it's right. But together with the numbers Ted 
posted, it's a total no-brainer. CFQ is clearly broken here, and it's 
pretty clear that apparently CFQ has been tuned (improperly) purely for 
throughput.

			Linus

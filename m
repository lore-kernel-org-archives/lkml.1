Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZDDWP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZDDWP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 18:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZDDWPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 18:15:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbZDDWPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 18:15:45 -0400
Date: Sat, 4 Apr 2009 15:13:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [GIT PULL] Ext3 latency fixes
In-Reply-To: <20090404135719.GA9812@mit.edu>
Message-ID: <alpine.LFD.2.00.0904041448090.4023@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain> <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
 <20090404135719.GA9812@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Apr 2009, Theodore Tso wrote:
> 
> Using ext3 data=writeback, your "write big (2GB) file and sync" as the
> background workload, and fsync-tester, I was able to reduce the
> latency down to under 1 second...

Hmm. I can certainly see a very noticeable improvement.

I could still see 1-2s fsync() delays for my MUA test (and seem to have 
seen a 4s one once too). But most were all 'quite noticeable stutters', 
and very seldom do they go into the 'ooh, that's really painful' stage.

And yes, anticipatory seems to be quite noticeably better than cfq here. 
With cfq I got a few two-second delays on 'ftruncate()' too (probably 
because of your new serialization code?), and the longest fsync() delay 
was over 7 seconds. That was definitely solidly in the "painful" category.

(Jens - my test-case is not the exact same fsycn() test that Ted uses: 
it's really just me being in my MUA editing an email, and doing that 

	while : ; do time sh -c "dd if=/dev/zero of=bigfile bs=8M count=256 ; sync; rm bigfile"; done

in another window. My MUA does these save-files ever minute or so, and 
does a 'fsync()' after writing that (small) file. If the fsync() takes 
more than half a second, I can definitely notice. If it takes 1-2 seconds, 
it's a big stutter, where keyboard auto-repeat when moving around really 
hurts (ie I don't see how it moves).

If it takes 5+ seconds, it feels really bad, and as if the whole email 
client had just died. 

Yeah, it's a nasty test. 

		Linus

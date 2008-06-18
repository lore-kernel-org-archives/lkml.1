Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYFRDO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYFRDO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 23:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYFRDOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 23:14:18 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57902 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079AbYFRDOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 23:14:17 -0400
Date: Wed, 18 Jun 2008 13:14:06 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
	bisected, reproducable)
Message-ID: <20080618031406.GA4326@brong.net>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806171415060.2907@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 02:20:49PM -0700, Linus Torvalds wrote:
> On Tue, 17 Jun 2008, Linus Torvalds wrote:
> > 
> > Hmm. Something like this *may* salvage it.
> > 
> > Untested, so far (I'll reboot and test soon enough), but even if it fixes 
> > things, it's not really very good. 
> 
> Ok, so I just rebooted with this, and it does indeed fix the bug.
> 
> I'd be happier with a more complete fix (ie being byte-accurate and 
> actually doing the partial copy when it hits a fault in the middle), but 
> this seems to be the minimal fix, and at least fixes the totally bogus 
> return values from the x86-64 __copy_user*() functions.
> 
> Not that I checked that I got _all_ cases correct (and maybe there are 
> other versions of __copy_user that I missed entirely), but Bron's 
> test-case at least seems to work properly for me now.
> 
> Bron? If you have a more complete test-suite (ie the real-world case that 
> made you find this), it would be good to verify the whole thing. 

Ok - I pulled the latest linus-2.6 git, and discovered 
the patch was already in there, so I just built and
rebooted (git 952f4a0a9b27e6dbd5d32e330b3f609ebfa0b061).

Confirmed - fixed in both the test code and the cyr_dbtool 
test case I was using previously (I would have posted that 
instead, but building cyrus is a bit of pain.  You need 
bdb and sasl and all sorts of extraneous crap - and 
cyrusdb_skiplist.c depends on about half of Cyrus' 
infrastructure, so I couldn't just pull it out by itself)

For my sins, I appear to be becoming the world expert on 
that particular file.  I've debugged skiplist bugs many 
times over, and completely rewritten the locking code.  
It really does some pretty evil things - the memory accesses
look something like this:

[file...................]
[mmap^....^.^........^^..................................]
[file...................++++++++++++]
[mmap^....^.^........^^.^^ ^      ^^.....................]

Where (^) is the bits that get accessed.  All reads are via
the mmap, all writes are done with retry_write or 
retry_writev (Cyrus library functions that keep hammering
until all the bytes are written)

I was suspecting as early as Friday night (we've been 
debugging this one for a few days now!) that it was page 
break related, because the bug only seemed to be appearing
on seen databases with really long seen lists (they're in 
ranged integer format like 1:5,7:9,12,14:22,24:...).  

It didn't help that at first we were only finding out about
cases where the corruption hit exactly on the "navigational
components", hence breaking the skiplist logic.  And then 
the backpointer writes would scribble all over the corrupt 
area as well, so that made it even stranger to debug!


OK - so I'll report this issue to the Cyrus mailing list.
Warn people not to run on kernels 2.6.23 -> 2.6.25.7 with
x86_64 kernels.  At least not without the skanky little
patch that I'm planning to post:

int magic = 0;
for (i = 0; i < maplen; i++) magic ^= mapbase[i];

Since I've tested that as a viable workaround!

Bron.

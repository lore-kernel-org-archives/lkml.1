Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbYDOTtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbYDOTtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYDOTtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:49:24 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55753 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472AbYDOTtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:49:23 -0400
Date: Tue, 15 Apr 2008 15:49:22 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080415194922.GT7385@csclub.uwaterloo.ca>
References: <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz> <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca> <20080415085740.GA7603@atrey.karlin.mff.cuni.cz> <20080415153221.GD7387@csclub.uwaterloo.ca> <20080415173430.GB4994@elf.ucw.cz> <20080415182453.GR7385@csclub.uwaterloo.ca> <20080415191238.GC4994@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415191238.GC4994@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 09:12:38PM +0200, Pavel Machek wrote:
> It does not say "repositions the offset to the random number" nor
> "under certain conditions repositions the offsets" nor "it repositions
> the offset unless you are unlucky and hit kernel race". More
> seriously, it does not contain note "not safe from multithreaded
> programs" nor "multithreaded behaviour is undefined".

And if you debug it on a 64bit system then it won't be able to do that.
So not exactly a useful thing to try, and even trying 1000 times you are
unlikely to hit it, so you can't know for sure unless you happen to be
lucky and hit it.

> So this pretty clearly is application bug.

> Really? I see an application to detecting if I'm being debugged. Try
> to hit the race 1000 times, if you hit it, you are probably not
> debugged (because debugger would be very likely to make that race hard
> to hit). Will only work on multicores, but...

If lseek not being atomic breaks your application, then your application
would be broken already.  Any weird debug detection you might be able to
do using the fact is isn't atomic could I suppose be considered a kernel
bug if you think being able to do such detection is a bug.  Nothing
prevents the debuger from preloading an override to the access to lseek
that uses it's own locks to make the call atomic and hence prevent such
use.

So other than that, is there any case in which lseek being not atomic
can cause an application to break if it wasn't already broken (due to
having a race condition by trying to do 2 or more seeks on the same file
handle at the same time)?  If not, I think adding any kind of locking to
seek in the kernel (which would I think have to cause a slight slow
down) is a bad move.  But hey that's just my opinion. :)  I won't be
upset either way.

> [Plus, there's "strace seen it writing to either offset A or offset B,
> but I see the data at offset C, WTF?]

Most likely it would also be a program where you see it randomly seek to
A and write or seek to A then B then write depending on how it happens
to get scheduled when you run it.  Already the program is clearly doing
something unreliable.  And C only happens to vary from B if A and B
differ in the upper 32 bits of the file position.

> I'm not saying this kernel bug is likely to hit in practice. It is
> still a kernel bug.
> 
> Is the slowdown of lseek worth getting rid of this minor bug? Not
> sure, probably yes.

I think a slow down is the worse choice.  Adding a note to the
documentation saying that "By the way, on 32bit systems the seek call is
not atomic for 64bit file offsets, so if you happen to issue two at the
same time to the same file pointer to offsets that differ in the upper
32bits, then the result of the seek might not be either of A or B but
will contain the upper 32bits of either A or B and the lower 32bits of
ether A or B.  You should of course use locking for your file access to
ensure you know where your threads end up writing so this should be a
non issue."

-- 
Len Sorensen

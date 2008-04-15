Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYDOTMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYDOTMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYDOTMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:12:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58479 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYDOTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:12:07 -0400
Date: Tue, 15 Apr 2008 21:12:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jan Kara <jack@suse.cz>, Bodo Eggert <7eggert@gmx.de>,
       Diego Calleja <diegocg@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Michal Hocko <mhocko@suse.cz>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080415191238.GC4994@elf.ucw.cz>
References: <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca> <20080414165354.GF15824@duck.suse.cz> <20080414170613.GI7385@csclub.uwaterloo.ca> <20080414190308.GJ15824@duck.suse.cz> <20080414192928.GM7385@csclub.uwaterloo.ca> <20080415085740.GA7603@atrey.karlin.mff.cuni.cz> <20080415153221.GD7387@csclub.uwaterloo.ca> <20080415173430.GB4994@elf.ucw.cz> <20080415182453.GR7385@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415182453.GR7385@csclub.uwaterloo.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, kernel bugs are confusing ;-).
> 
> I only see an application bug so far.

Really?

>       The lseek() function repositions the offset of the open file
> associated with
>       the file descriptor fildes to the argument offset according to
>the directive
>       whence as follows:

It does not say "repositions the offset to the random number" nor
"under certain conditions repositions the offsets" nor "it repositions
the offset unless you are unlucky and hit kernel race". More
seriously, it does not contain note "not safe from multithreaded
programs" nor "multithreaded behaviour is undefined".

So this pretty clearly is application bug.

> > The "application" could be malware trying to confuse debugger, for
> > example.
> 
> If you can't do it on demand (which I can't see any way to do) then I
> don't think malware can take advantage of it.

Really? I see an application to detecting if I'm being debugged. Try
to hit the race 1000 times, if you hit it, you are probably not
debugged (because debugger would be very likely to make that race hard
to hit). Will only work on multicores, but...

[Plus, there's "strace seen it writing to either offset A or offset B,
but I see the data at offset C, WTF?]

> > The "application" could be something you are trying to debug.
> 
> True, but even without this behaviour doing seeks and read/writes from
> multiple threads without locking will already show plenty of problems
> even if you somehow manage to hit this issue, and not only that you have
> to have threads writing to different 4GB aligned chunks of the file
> cause a problem, since otherwise they would all be setting the top bits
> the same.  I would hope anyone doing multithreaded work on a file that
> big would like to avoid the locking issue by using pread and pwrite
> instead in which case there is no problem either.

I'm not saying this kernel bug is likely to hit in practice. It is
still a kernel bug.

Is the slowdown of lseek worth getting rid of this minor bug? Not
sure, probably yes.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

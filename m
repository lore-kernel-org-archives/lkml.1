Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYLCECz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYLCECz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYLCECq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:02:46 -0500
Received: from ivent.com.au ([125.7.48.1]:33550 "EHLO picard.ivent.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYLCECp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:02:45 -0500
Subject: Re: New Security Features, Please Comment
From: Geoffrey McRae <geoff@rabidhost.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <73639.1228272932@turing-police.cc.vt.edu>
References: <1228260494.24232.21.camel@compy.ivent.com.au>
	 <20081203005338.6472db7a@lxorguk.ukuu.org.uk>
	 <1228268657.6679.4.camel@lappy.spacevs.com>
	 <73639.1228272932@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 15:02:39 +1100
Message-Id: <1228276959.6679.27.camel@lappy.spacevs.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - picard.ivent.com.au
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rabidhost.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 21:55 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 03 Dec 2008 12:44:17 +1100, Geoffrey McRae said:
> 
> > I would welcome more information as to how this can break applications
> > as I am very new to kernel hacking and would like to solve this
> > performance vs security problem once and for all.
> 
> A *lot* of software has implicit assumptions - for instance, that your process
> UID remains constant unless you intentionally did a setuid() call.
> 
> Read Henry Spencer's (now ancient but still educational) write-up on *some* of
> the things that can happen to set-UID programs:
> 
> http://www.daemon-systems.org/man/setuid.7.html
> 
> Now consider that *any* program that gets its UID suddenly changed on it
> just became vulnerable to all that stuff that Henry writes about.
> 
> News flash - most programmers who wrote code thinking it would run as the
> same userid the whole time don't do checks for all the sort of stuff that
> Henry warns about when programs suddenly get invoked with more privilege
> than they were designed to handle.
> 

This is with the assumption that you are forking a child an calling
execv, if the program is written in the first place to take advantage of
this, and the issues with having a uid changed all of a sudden, there
should be little impact.

My initial concept is to implement a HTTP server that is designed from
the ground up to use this new functionallity. Each server that has been
pre-forked will just sit there until the parent sets its uid/gid and
hands it the request to handle.

> Then there's the opposite case - somebody manages to trick you into nuking the
> permissions on the right process-ID but wrong executable. Hilarity ensues when
> the process is running with *less* privilege than it expected. Go and read up
> on how Sendmail failed back around 2000, and understand *why* it failed. Just
> google for 'sendmail CAP_SETUID' and start reading. Then think what happens if
> somebody manages to get PHP to exec() some other binary (a set-UID one) and
> it's busy running when you whack its UID.

It is impossible to change the uid of a process that is not the
immediate child of the parent with these functions as a security
precaution, and even if a process manages to get its uid/gid changed,
the enable_setpresuid function limits the uid/gids that it can be set
to, so when implemented properly, the worst that can happen is another
users files get nuked on the machine, which is the exact problem I am
trying to stop from occuring.

Because the parent app drops all its privlages after enabling the
setpresuid, it can not be abused to gain root access either.

> 
> That's just off the top of my head.
> 
> Then go look at kernel/sys.c and read the comments just before the functions
> sys_setpgid(), sys_setregid(), and sys_setuid(), and figure out how the
> saved uid enters into things....
> 
> There be serious and nasty dragons in there...
> 

I knew there would be implications of implementing this, thats why I put
the code, and the question out there.

I know there is still the issue of the process holding open a file
descriptor that was owned by the old user, but I am sure that could be
solved by itterating the processes file descriptors and closing any that
the process will no longer have access to.

If the program crashes because it expects the fd to still be open, then
too bad, it should not have held it open, and IMHO is a bug as the
process should not have held it open when it is going to be re-used.

I am determined to not just add these calls to the kernel, but to make
them secure, and write programs that use them safely.

If there are concerns with things, please suggest fixes to make it
secure, or point out where the concerns are so I can investigate
possible solutions to the problem. I am sure the overhead of doing extra
security checks in the new functions will not be anywhere near that of
re-forking a process.

-geoff


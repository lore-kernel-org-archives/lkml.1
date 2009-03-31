Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZCaLvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZCaLvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZCaLvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:51:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZCaLvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:51:14 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Tue, 31 Mar 2009 22:51:08 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18898.940.517750.737258@notabene.brown>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
In-Reply-To: message from Theodore Tso on Thursday March 26
References: <20090324041249.1133efb6.akpm@linux-foundation.org>
	<20090325123744.GK23439@duck.suse.cz>
	<20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday March 26, tytso@mit.edu wrote:
> Ingo,
.....
> 
> > Oh, and while at it - also a job control complaint. I tried to 
> > Ctrl-C the above script:
> > 
> > I had to hit Ctrl-C numerous times before Bash would honor it. This 
> > to is a very common thing on large SMP systems.
> 
> Well, the script you sent runs the compile in the background.  It did:
> 
> >   while :; do
> >     date
> >     make mrproper      2>/dev/null >/dev/null
> >     make defconfig     2>/dev/null >/dev/null
> >     make -j32 bzImage  2>/dev/null >/dev/null
> >   done &
>          ^^
> 
> So there would have been nothing to ^C; I assume you were running this
> with a variant that didn't have the ampersand, which would have run
> the whole shell pipeline in a detached background process?
> 
> In any case, the workaround for this is to ^Z the script, and then
> "kill %" it.
> 
> I'm pretty sure this is actually a bash problem.  When you send a
> Ctrl-C, it sends a SIGINT to all of the members of the tty's
> foreground process group.  Under some circumstances, bash sets the
> signal handler for SIGINT to be SIGIGN.  I haven't looked at this
> super closely (it would require diving into the bash sources), but you
> can see it if you attach an strace to the bash shell driving a script
> such as
> 
> #!/bin/bash
> 
> while /bin/true; do
>       date
>       sleep 60
> done &
> 
> If you do a "ps axo pid,ppid,pgrp,args", you'll see that the bash and
> the sleep 60 have the same process group.  If you emulate hitting ^C
> by sending a SIGINT to pid of the shell, you'll see that it ignores
> it.  Sleep also seems to be ignoring the SIGINT when run in the
> background; but it does honor SIGINT in the foreground --- I didn't
> have time to dig into that.
> 
> In any case, bash appears to SIGIGN the INT signal if there is a child
> process running, and only takes the ^C if bash itself is actually
> "running" the shell script.  For example, if you run the command
> "date;sleep 10;date;sleep 10;date", the ^C only interrupts the sleep
> command.  It doesn't stop the series of commands which bash is
> running.

This is something that is really hard to get right.

If the shell is running a program when SIGINT arrives, it needs to
wait until the program exits, and then try to decide if the program
died because of the signal, or actually caught the signal (from the
user's perspective), did something useful, and then chose to exit.

If the program's exit status shows that it died due to SIGINT, it is
easy to know what to do.  But lots of non-trivial programs, probably
including 'make' catch SIGINT, do some quick cleanup and then exit.
In that case the shell has a hard time deciding what to do.

I wrote a job-controlling shell many years ago and I think the
heuristic I came up with was that if the process exited with the
SIGINT status, or with a non-zero error status in less that 3 seconds
after the signal actually arrived, then react to the signal and abort
any script.  However it the process takes longer to exit or returns a
zero exit status, assume that it was interactive and handled the
interrupt to the user's satisfaction, and continue with any script.


I don't know what bash does, and it is possible that it could do a
better job.  But it is a problem for which there is no straight
forward solution (a bit like filesystem data safety it would seem :-)

NeilBrown

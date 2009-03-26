Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZCZLiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZCZLiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 07:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZCZLhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 07:37:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:35203 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbZCZLhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 07:37:52 -0400
Date: Thu, 26 Mar 2009 07:37:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326113705.GV32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
References: <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326090630.GA9369@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Interesting.  I wonder if the problem is the journal is cycling fast
enough that it is checkpointing all the time.  If so, it could be that
a bigger-sized journal might help.  Can you try this as an experiment?
Mount the filesystem using ext4, with the mount option nodelalloc.
With an filesystem formatted as ext3, and with delayed allocation
disabled, it should behave mostly the same as ext3; try and make sure
you're still seeing the same problems.

Then could you grab /proc/fs/jbd2/<dev>:8/history and
/proc/fs/jbd2/<dev>:8/info while running your test workload?

Also, can you send me the output of "dumpe2fs -h /dev/sdXX | grep Journal"?

> Oh, and while at it - also a job control complaint. I tried to 
> Ctrl-C the above script:
> 
> I had to hit Ctrl-C numerous times before Bash would honor it. This 
> to is a very common thing on large SMP systems.

Well, the script you sent runs the compile in the background.  It did:

>   while :; do
>     date
>     make mrproper      2>/dev/null >/dev/null
>     make defconfig     2>/dev/null >/dev/null
>     make -j32 bzImage  2>/dev/null >/dev/null
>   done &
         ^^

So there would have been nothing to ^C; I assume you were running this
with a variant that didn't have the ampersand, which would have run
the whole shell pipeline in a detached background process?

In any case, the workaround for this is to ^Z the script, and then
"kill %" it.

I'm pretty sure this is actually a bash problem.  When you send a
Ctrl-C, it sends a SIGINT to all of the members of the tty's
foreground process group.  Under some circumstances, bash sets the
signal handler for SIGINT to be SIGIGN.  I haven't looked at this
super closely (it would require diving into the bash sources), but you
can see it if you attach an strace to the bash shell driving a script
such as

#!/bin/bash

while /bin/true; do
      date
      sleep 60
done &

If you do a "ps axo pid,ppid,pgrp,args", you'll see that the bash and
the sleep 60 have the same process group.  If you emulate hitting ^C
by sending a SIGINT to pid of the shell, you'll see that it ignores
it.  Sleep also seems to be ignoring the SIGINT when run in the
background; but it does honor SIGINT in the foreground --- I didn't
have time to dig into that.

In any case, bash appears to SIGIGN the INT signal if there is a child
process running, and only takes the ^C if bash itself is actually
"running" the shell script.  For example, if you run the command
"date;sleep 10;date;sleep 10;date", the ^C only interrupts the sleep
command.  It doesn't stop the series of commands which bash is
running.

						- Ted


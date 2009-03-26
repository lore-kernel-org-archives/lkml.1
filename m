Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZCZMqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZCZMqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZCZMqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:46:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51533 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbZCZMqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:46:34 -0400
Date: Thu, 26 Mar 2009 13:44:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
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
Message-ID: <20090326124453.GA16499@elte.hu>
References: <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20090326113705.GV32307@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Theodore Tso <tytso@mit.edu> wrote:

> >   while :; do
> >     date
> >     make mrproper      2>/dev/null >/dev/null
> >     make defconfig     2>/dev/null >/dev/null
> >     make -j32 bzImage  2>/dev/null >/dev/null
> >   done &
>          ^^
> 
> So there would have been nothing to ^C; I assume you were running 
> this with a variant that didn't have the ampersand, which would 
> have run the whole shell pipeline in a detached background 
> process?

That was just the example - the real script did not go into the 
background so it was Ctrl-C-able. I've attached it.

> In any case, the workaround for this is to ^Z the script, and then 
> "kill %" it.
> 
> I'm pretty sure this is actually a bash problem.  When you send a 
> Ctrl-C, it sends a SIGINT to all of the members of the tty's 
> foreground process group.  Under some circumstances, bash sets the 
> signal handler for SIGINT to be SIGIGN.  I haven't looked at this 
> super closely (it would require diving into the bash sources), but 
> you can see it if you attach an strace to the bash shell driving a 
> script such as
> 
> #!/bin/bash
> 
> while /bin/true; do
>       date
>       sleep 60
> done &
> 
> If you do a "ps axo pid,ppid,pgrp,args", you'll see that the bash 
> and the sleep 60 have the same process group.  If you emulate 
> hitting ^C by sending a SIGINT to pid of the shell, you'll see 
> that it ignores it.  Sleep also seems to be ignoring the SIGINT 
> when run in the background; but it does honor SIGINT in the 
> foreground --- I didn't have time to dig into that.
> 
> In any case, bash appears to SIGIGN the INT signal if there is a 
> child process running, and only takes the ^C if bash itself is 
> actually "running" the shell script.  For example, if you run the 
> command "date;sleep 10;date;sleep 10;date", the ^C only interrupts 
> the sleep command.  It doesn't stop the series of commands which 
> bash is running.

It happens all the time - and it does look like a Bash bug. I 
reported it to the Bash maintainer one or two years ago. He said
he does not see it as he's using MacOS X. Can dig into archives if 
needed.

	Ingo

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=compile-test


  #
  # Cool down caches as much as possible:
  #
  sync
  echo 3 > /proc/sys/vm/drop_caches

  #
  # Kernel developer builds his kernel workload:
  #
  while :; do
    date
    make mrproper      2>/dev/null >/dev/null
    make defconfig     2>/dev/null >/dev/null
    make -j32 bzImage  2>/dev/null >/dev/null
  done


--/04w6evG8XlLl3ft--

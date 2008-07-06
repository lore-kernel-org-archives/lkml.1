Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYGFSt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYGFSt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 14:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbYGFStV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 14:49:21 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35676 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbYGFStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 14:49:20 -0400
Message-ID: <487113AC.7000300@skyrush.com>
Date: Sun, 06 Jul 2008 12:49:16 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Tim Connors <tim.w.connors@gmail.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Alan Cox <alan@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: tty session leader issue [cause now known!] (was Re: 2.6.25.3:
 su gets stuck for root)
References: <48438126.3080308@t-online.de>  <20080604171056.GB17875@devserv.devel.redhat.com>  <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>  <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>  <485323C5.4030002@skyrush.com>  <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>  <48540343.4010200@skyrush.com>  <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com>  <48542F75.5070605@skyrush.com> <19f34abd0806141426o7ba13f91h6720db3609146e16@mail.gmail.com> <486BC30C.6010705@skyrush.com> <alpine.DEB.1.10.0807062353450.30385@scuzzie.rather.puzzling.org>
In-Reply-To: <alpine.DEB.1.10.0807062353450.30385@scuzzie.rather.puzzling.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Connors wrote:
> On Wed, 2 Jul 2008, Joe Peterson wrote:
> 
>> I have done some more investigation on this problem, and I am posting
>> here my results in hope that someone can point me in the right direction
>> for further investigation...
>>
>> Summary: during the initialization of a new bash shell, the terminal
>> foreground process group often reverts back to that of the parent of the
>> bash shell (after being set *to* the bash shell pgrp by bash),
>> prohibiting commands like stty from being run by the init scripts.  The
>> result is that the execution of these commands will hang until killed,
>> causing the bash prompt to not appear.  Adding a delay in the script
>> (using sleep) increases the chance of this having time to happen.

I have done more investigation, and I now know the cause of the
bash/stty problem.  It appears to be a race condition in bash (well,
between two different bash shells, actually).  I saw a post from a while
back about something similar by Ingo Molnar, so I have copied him here too.

Here is the ps tree of the test case where stty has hung:

 4704 ?        S      0:00  \_ xterm
 4706 pts/3    Ss     0:00  |   \_ -bash
 4739 pts/3    S      0:00  |       \_ su
 4742 pts/3    S      0:00  |           \_ bash
 4746 pts/3    S+     0:00  |               \_ su foo
 4747 pts/3    S      0:00  |                   \_ bash
 4752 pts/3    T      0:00  |                       \_ stty -ixany

What should happen is: when "su foo" (4746) is run, it spawns a bash
shell (4747) that then makes itself the session leader when it
initializes its job control.  The stty command (in the child bash's
.bashrc) will then be able to work (and not hang).

However, the hang happens when the parent bash (4742) interferes by
reverting the tty session leader back to its child (the "su foo"
process: 4746) shortly after the child bash (4747) becomes the leader.
The parent does this when it calls
execute_command_internal()->stop_pipeline()->give_terminal_to().  This
seems to happen at a slightly random time, making the issue intermittent
- it depends which one wins the race.

In summary, when the bug does *not* occur, here is the approximate
sequence (note I am :

1) parent bash (4742) runs 'su foo' (4746)
2) parent bash sets tty leader to 'su' (4746)
3) child bash (4747) initializes and sets itself to be the leader
4) stty command in .bashrc runs successfully

When the bug occurs, here is the sequence:

1) parent bash (4742) runs 'su foo' (4746)
2) child bash (4747) initializes and sets itself to be the leader
3) parent bash sets tty leader *back* to 'su' (4746)
4) stty command runs and fails/hangs because its parent is not leader

The various calls to tcsetpgrp() that do this are interleaved from the
two bash processes, and sometimes the parent does it slightly *after*
the child bash initializes job control - that's when the problem happens.

I have not looked further to find a solution (but it's a great start to
know the cause...!).  Any further help is welcome.

> The 6 year old inspiron 4000 gets stuck at stty erase ^? .  Randomly, but
> most of the time.
> 
> All of my machines exhibit the ctrl-C being slower than ctrl-Z discussed
> elswhere (I've almost developed a habit of typing ctrl-Z kill %1 <RET>).
> Although even ctrl-Z recently has been reluctant to always work.  I wonder
> if this is the cause of dpkg recently not responding to ctrl-Z's? (debian
> bug #486222).  dpkg does respond to kill -STOP

I doubt that this is related.  See the following thread for more info on
this:

	http://marc.info/?l=linux-kernel&m=121528829718840&w=2

> ctrl-s doesn't always work anymore.  Again, what prompted me to write this
> email, was I couldn't pause dpkg.  It's particularly unreliable at
> stopping scrolling messages at bootup, and if I press it at the wrong time
> at bootup (not a specific place - it can be starting up any number of
> scripts), something deadlocks and won't resume upon a ctrl-q.
> alt-sysrq-k is enough to kill whatever has deadlocked.  I have a feeling,
> but don't want to test on this system right now, that pressing scroll-lock
> as opposed to ctrl-q once unlocked such a stuck display.

Hmm, not sure; I have not seen that behavior.

> In summary, something in tty is certainly screwed.  Does anyone see a
> connection between all of these?

I doubt there is a connection between the bash issue and what you are
seeing with ctrl-C/ctrl-S, etc.

					-Joe

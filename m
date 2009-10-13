Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZJMAR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZJMAR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbZJMARZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:17:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756626AbZJMARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:17:24 -0400
Date: Mon, 12 Oct 2009 17:16:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nix <nix@esperi.org.uk>
cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?= 
	<fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <87ljjgfcbu.fsf@spindle.srvr.nix>
Message-ID: <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Oct 2009, Nix wrote:
> On 12 Oct 2009, Justin P. Mattock uttered the following:
> 
> > Not sure where this stands. Right now all three machines I have seem  to be having no issues with the kayboard
> > (xserver 1.6.*) I can go and build the latest xserver(1.7) to see if I  hit something.
> [...]
> >> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14388
> >> Subject        : keyboard under X with 2.6.31
> >> Submitter    : Frédéric L. W. Meunier <fredlwm@gmail.com>
> >> Date        : 2009-10-07 20:19 (5 days old)
> >> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e043e42bdb66885b3ac10d27a01ccb9972e2b0a3
> >> References    : http://marc.info/?l=linux-kernel&m=125494753228217&w=4
> 
> I have been seeing problems precisely like those described (sometimes
> the keyboard dies, sometimes it gets 'stuck' with a key held down, until
> I switch TTYs, which generally means killing X as I'm not aware of an
> easy way to switch VTs using only the mouse), since I moved to 2.6.31

The particular commit that was bisected to should really not matter for X, 
except perhaps from a timing standpoint.

The problem it fixed was in pty's, and X doesn't use them much if at all 
(various X _programs_ may, of course, but the symptoms don't sound like 
it's just a particular X app that has issues, but more of a generic X 
keyboard handling thing)

But for non-pty's, there should be no semantic changes from that commit 
outside of some general tty timing differences by doing that 
tty_flush_to_ldisc() at new points.

I could fairly easily imagine that some timing difference does expose 
another longer-standing problem in either the kernel or X itself. So the 
bisection isn't necessarily wrong, it's just not likely telling us what 
the real problem is.

Of course, maybe there is some race condition in the tty_buffer.c code. We 
_used_ to not call flush_to_ldisc() except through the workqueue code, so 
races would not be seen in normal circumstances. Now that flush_to_ldisc() 
could easily get called both synchronously from tty_read()/tty_poll(), 
while also being hit from the workqueues.

Alan, Ogawa-san, do either of you see some problem in tty_buffer.c, 
perhaps?

		Linus



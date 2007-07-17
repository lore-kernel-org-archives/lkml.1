Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbXGQXPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbXGQXPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760254AbXGQXPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:15:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:51492 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754947AbXGQXPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:05 -0400
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 18 Jul 2007 01:15:04 +0200
From: "Michael Kerrisk" <mtk-manpages@gmx.net>
Message-ID: <20070717231504.257750@gmx.net>
MIME-Version: 1.0
Subject: Re: timerfd(2) draft man page plus questions
To: Davide Libenzi <davidel@xmailserver.org>
X-Authenticated: #24879014
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+4rEMWtw247D6MYbvUDm5HVvOdvKE1cqMFRcCuwD
 5ULQ7WjcnSDUjo2ZUIBef+BQxkKzAG8fSQ3Q== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: TH+qccYdbGInTN/pFmVnoB9vcmZ1ZtyF
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

A further thought: if one added the extra argument to retrieve
the previous timer settings then it might be desirable to
permit:

timerfd(ufd, 0, 0, NULL, &olditimerspec)

to retrieve the time until next expiration without changing
the timer settings.  Analogous functionality is provided by
getitimer() and clock_gettime() in the historical API.

Cheers,

Michael


-------- Original-Nachricht --------
Datum: Wed, 18 Jul 2007 00:35:56 +0200
Von: "Michael Kerrisk" <mtk-manpages@gmx.net>
An: Davide Libenzi <davidel@xmailserver.org>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Betreff: Re: timerfd(2) draft man page plus questions

> > > > 1. timer_settime() and setitimer() both permit the caller to obtain 
> > > > the old value of the timer when modifying an existing timer.  Why 
> > > > doesn't timerfd() provide this functionality?
> > > 
> > > I don't know ;) Would it be any useful?
> > 
> > Well given that the two older APIs both provide this
> > functionality, it seems that it is desired in applications. It 
> > is a shame that the new API doesn't have this.  It could be 
> > added (I'm inclined to say, it should be): the only problem
> > is that the syscall is now out in the wild, so a change at
> > this point would not be ABI compatible.  However, it only just 
> > got into the wild (and hasn't made it into glibc yet), so now
> > would be a good time to fix it, if you are agreeable, and the
> > kernel gatekeepers are prepared to tolerate the ABI change.
> 
> But the old status of the timer is the union of clickid, flags and utmr. 
> So, in theory, the whole set should be returned back, forcing a pretty 
> drastic API change.

You have a point there.  The POSIX timer functions split these 
things out:

a) timer_create() creates a timer, and it there that the caller
   specifies a clockid (which can't be changed for the life of
   this timer).

b) timer_settime() arms (starts) the timer, and it's there that
   flags and timer value/interval are set.  Those settings can be
   changed in a further call to timer_settime().  This call also 
   returns the previous value/interval of the timer (but not the
   flags).

> IMHO, given that is not really clear what the real advantages would be in 
> the API change, I'd rather prefer to leave the current one.

Well, I think there is a clear advantage, as evidenced by the fact
that all of the historical APIs do allow the previous timer 
settings to be retrieved.  They did not do this for 
nothing, and a design pattern such as:

1. set timer to go of at time X
2. modify timer to go off at earlier time Z; return previous 
   timer settings (Z)
3. When timer Z expires, restore timer Y

is certainly useful sometimes.

The question is whether there does need to be a "drastic" 
API change:

a) You could say that clockid is immutable (i.e., can only be
   set if (ufd == -1)), which would eliminate the need
   to return its previous value.  (This is effectively what
   happens with a POSIX timer.)

b) There is no need to return the previous flags setting: 
   the POSIX timer functions (i.e., timer_settime()) do not 
   do this. Instead, timer_settime() always returns the 
   time until the next expiration would have occurred, 
   even if the TIMER_ABSTIME flag was specified when
   the timer was set.

With these design assumptions, the only thing that would need 
to be added would be an argument used to return the time
until the previous timer would have expired + its interval.

Cheers,

Michael
-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7 

Want to help with man page maintenance?  
Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages , 
read the HOWTOHELP file and grep the source 
files for 'FIXME'.


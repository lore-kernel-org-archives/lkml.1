Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbXDNTQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbXDNTQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbXDNTQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:16:49 -0400
Received: from 1wt.eu ([62.212.114.60]:1906 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbXDNTQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:16:48 -0400
Date: Sat, 14 Apr 2007 21:01:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414190148.GA2844@1wt.eu>
References: <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070414132732.GA22103@1wt.eu> <20070414161927.GD3099@elte.hu> <m1abxanahn.fsf@ebiederm.dsl.xmission.com> <20070414172920.GA2433@1wt.eu> <m1647yn956.fsf@ebiederm.dsl.xmission.com> <20070414175433.GA17527@elte.hu> <20070414181854.GA5826@1wt.eu> <m1wt0elrzk.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wt0elrzk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 12:40:15PM -0600, Eric W. Biederman wrote:
> Willy Tarreau <w@1wt.eu> writes:
> 
> > On Sat, Apr 14, 2007 at 07:54:33PM +0200, Ingo Molnar wrote:
> >> 
> >> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> 
> >> > > Thinking about it, I don't know if there are calls to schedule() 
> >> > > while switching from tty1 to tty2. Alt-F2 had no effect anymore, and 
> >> > > "chvt 2" simply blocked. It would have been possible that a 
> >> > > schedule() call somewhere got starved due to the load, I don't know.
> >> > 
> >> > It looks like there is a call to schedule_work.
> >> 
> >> so this goes over keventd, right?
> >> 
> >> > There are two pieces of the path. If you are switching in and out of a 
> >> > tty controlled by something like X.  User space has to grant 
> >> > permission before the operation happens.  Where there isn't a gate 
> >> > keeper I know it is cheaper but I don't know by how much, I suspect 
> >> > there is still a schedule happening in there.
> >> 
> >> Could keventd perhaps be starved? Willy, to exclude this possibility, 
> >> could you perhaps chrt keventd to RT priority? If events/0 is PID 5 then 
> >> the command to set it to SCHED_FIFO:50 would be:
> >> 
> >>   chrt -f -p 50 5
> >> 
> >> but ... events/0 is reniced to -5 by default, so it should definitely 
> >> not be starved.
> >
> > Well, since I merged the fair-fork patch, I cannot reproduce (in fact,
> > bash forks 1000 processes, then progressively execs scheddos, but it
> > takes some time). So I'm rebuilding right now. But I think that Linus
> > has an interesting clue about GPM and notification before switching
> > the terminal. I think it was enabled in console mode. I don't know
> > how that translates to frozen xterms, but let's attack the problems
> > one at a time.
> 
> I think it is a good clue.  However the intention of the mechanism is
> that only processes that change the video mode on a VT are supposed to
> use it.  So I really don't think gpm is the culprit.  However it easily could
> be something else that has similar characteristics.
> 
> I just realized we do have proof that schedule_work is actually working
> because SAK works, and we can't sanely do SAK from interrupt context
> so we call schedule work.

Eric,

I can say that Linus, Ingo and you all got on the right track.
I could reproduce, I got a hung tty around 1400 running processes.
Fortunately, it was the one with the root shell which was reniced
to -19.

I could strace chvt 2 :

20:44:23.761117 open("/dev/tty", O_RDONLY) = 3 <0.004000>
20:44:23.765117 ioctl(3, KDGKBTYPE, 0xbfa305a3) = 0 <0.024002>
20:44:23.789119 ioctl(3, VIDIOC_G_COMP or VT_ACTIVATE, 0x3) = 0 <0.000000>
20:44:23.789119 ioctl(3, VIDIOC_S_COMP or VT_WAITACTIVE <unfinished ...>

Then I applied Ingo's suggestion about changing keventd prio :

root@pcw:~# ps auxw|grep event
root         8  0.0  0.0     0    0 ?        SW<  20:31   0:00 [events/0]
root         9  0.0  0.0     0    0 ?        RW<  20:31   0:00 [events/1]

root@pcw:~# rtprio -s 1 -p 50 8 9     (I don't have chrt but it does the same)

My VT immediately switched as soon as I hit Enter. Everything's
working fine again now. So the good news is that it's not a bug
in the tty code, nor a deadlock.

Now, maybe keventd should get a higher prio ? It seems worrying to
me that it may starve when it seems so much sensible.

Also, that may explain why I couldn't reproduce with the fork patch.
Since all new processes got no runtime at first, their impact on
existing ones must have been lower. But I think that if I had waited
longer, I would have had the problem again (though I did not see it
even under a load of 7800).

Regards,
Willy


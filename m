Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYKZTgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYKZTgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYKZTgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:36:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:59732 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbYKZTgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:36:35 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Nov 2008 11:36:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Tejun Heo <htejun@gmail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] poll: allow f_op->poll to sleep, take#5
In-Reply-To: <492CEF04.6070100@gmail.com>
Message-ID: <alpine.DEB.1.10.0811252313420.32523@alien.or.mcafeemobile.com>
References: <20081125173032.GA21539@redhat.com> <492CD1AB.3000802@kernel.org> <492CD358.2020603@gmail.com> <alpine.DEB.1.10.0811252148540.32523@alien.or.mcafeemobile.com> <492CEF04.6070100@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Tejun Heo wrote:

> Hello,
> 
> Davide Libenzi wrote:
> > Look, pollwake() does:
> > 
> > w1) WR triggered (1)
> > w2) WMB
> > w3) WR task->state (RUNNING)
> > 
> > While poll_schedule_timeout() does:
> > 
> > s1) WR task->state (TASK_INTERRUPTIBLE)
> > s2) MB
> > s3) RD triggered
> > s4) IF0 => RD task->state (if !RUNNING -> sleep)
> s5) after waking up, WR triggered to zero
> 
> > The only risk is that w3 preceed s1, so that we go to sleep even though a 
> > wakeup has been issued. But if w3 is visible, w1 is visible too, that 
> > means that 'triggered' is visible in s3 (there's a MB in s2). So we skip 
> > the schedule_hrtimeout_range(). So IMO you need no barriers on 'triggered'.
> > If you feel you need barriers, do you mind explaning a sequence of events 
> > that makes a barrier-free version break?
> 
> s5 from the previous iteration could happen after w1 during the next
> iteration and the test in s4 of the next iteration will miss the
> event, so the event could get lost on the iterations which is not the
> first one, no?

Hmmm, I just noticed that the set_current_state(TASK_INTERRUPTIBLE) at the 
beginning of the ->poll() loop has been dropped (and it makes sense since 
now ->poll() can sleep). So the iterations after the first becomes the 
interesting ones.
Device side, via wakeup():

w1) WR dev->events
w2) WR triggered (1)
w3) WMB
w4) WR task->state (RUNNING)

On the poller side:
 
s1) WR task->state (TASK_INTERRUPTIBLE)
s2) MB
s3) RD triggered
s4) IF0 => RD task->state (if !RUNNING -> sleep)
s5) WR triggered (0)
s6) RD dev->events

Now, it is very likely that after w1 there is some full mb, since the 
events (AKA internal manipulation of the device/file structure) happens 
inside a spinlocked region. So, if the write at s5 is actually able to 
override the one at w2, the dev->events set at w1 are likely going to be 
visible at the immediately next ->poll() loop.
To be sure though, independently from the device/file event setting 
behavior, IMO we need ...
Device side:

w1) WR dev->events
w2) MB
w3) WR triggered (1)
w4) WMB
w5) WR task->state (RUNNING)

Poller side:
 
s1) WR task->state (TASK_INTERRUPTIBLE)
s2) MB
s3) RD triggered
s4) IF0 => RD task->state (if !RUNNING -> sleep)
s5) WR triggered (0)
s6) MB
s7) RD dev->events

That is, an MB before w3 (triggered=1) and a set_mb(triggered,0) at 
s5+s6. The spinlock on the queue taken before entering pollwake() is not 
enough to guarantee the required ordering, since a LOCK is no guarantee 
that operations before it are visible after the LOCK.
Without the MB at w2, it could happen [w3, s5, s7, w1] that will make us 
miss the event *and* sleep.



- Davide



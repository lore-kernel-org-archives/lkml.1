Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZAOLoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZAOLoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZAOLoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:44:30 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:26394 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751834AbZAOLoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:44:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LUkDmHRpwKYU5K9UFz22xiNneAdtvpNZ889+KLt06GUfZBUqOtyOLKdPGC3gHXpg1azkmankf1UVqsfSc25Pbmy/yDGNXkDDZz4iw4UtImRxdMs0fZz/dZ1qQ1eAmhPF0BINEFKaoywdrAyVkjZ6uE3B8qHS/WDhzSoZUo7SahY=  ;
X-YMail-OSG: YwZ59DMVM1lRxAsazu6MIZVuymZ56Jg4Qzh7_veADs6lReHb1CbhSaJRTZ0S1My6vnlBiSy6glMi7car4.F.tqXNAJWlcw69HwVZ6vIwjGZcbv2ycPJNgM6ETt8hdjd1TEe8dyw_ahGWveBfJbEDEoYJE3JNLStStztubRQyzK2TTR05bjADp9m10XKCkw0cqlwjc4gu8IwYFKZjo5SR8do1_UY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
Date: Thu, 15 Jan 2009 22:44:06 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20090113122455.GA24824@dhcp35.suse.cz> <200901152153.42159.nickpiggin@yahoo.com.au> <20090115112640.GF22850@elte.hu>
In-Reply-To: <20090115112640.GF22850@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901152244.07267.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 22:26:40 Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Thursday 15 January 2009 21:00:13 Ingo Molnar wrote:
> > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > On Tuesday 13 January 2009 23:34:25 Ingo Molnar wrote:
> > > > > * Michal Hocko <mhocko@suse.cz> wrote:
> > > > > > Hi,
> > > > > > I am not sure whether someone has already reported this, but
> > > > > > I can see the following early boot WARNING with the 2.6.29-rc1
> > > > > > kernel in the serial console output:
> > > > > >
> > > > > > ------------[ cut here ]------------
> > > > > > WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
> > > > >
> > > > > That one should be fixed in tip/master and it is in the to-Linus
> > > > > queue of fixes:
> > > > >
> > > > >   http://people.redhat.com/mingo/tip.git/README
> > > > >
> > > > > it's this commit:
> > > > >
> > > > >   01e3eb8: Revert "sched: improve preempt debugging"
> > > > >
> > > > > if you want to cherry-pick the fix.
> > > >
> > > > OK, but I still don't think this is the actual problem, but there is
> > > > something amiss in the init code being exposed by it.
> > >
> > > the warnings triggered after a softirq, and there's already
> > > preempt-leak checks in the softirq code - so we can exclude that.
> > >
> > > a hardirq might have leaked a preempt count - but that would have quite
> > > bad effects [with quick atomic check asserts in schedule()], wouldnt
> > > it? So i tend to think that this is a false positive.
> > >
> > > One problem i can think of (and which i outlined in the revert commit
> > > log) is that if a hardirq hits this window in lock_kernel():
> > >
> > > void __lockfunc lock_kernel(void)
> > > {
> > >         int depth = current->lock_depth+1;
> > >                                            <-------------- HERE
> >
> > current->lock_depth is not yet modified at this point.
> >
> > >         if (likely(!depth))
> > >                 __lock_kernel();
> >
> > And here we increment preempt_count when taking the BKL, but we
> > has not yet modified current->lock_depth, so preempt debugging
> > will proceed with no impact of my patch at this point, regardless
> > of what interrupts are taken.
> >
> > So there is a race window, but it is to err on the safe side and
> > not trigger a false report.
> >
> > >         current->lock_depth = depth;
> > > }
> >
> > At this point, the BKL addition to preempt_count will be taken into
> > account in underflow checking of subsequent preempt counters.
>
> indeed, and the unlock path looks good too.
>
> > > then we have kernel_locked() already true (it checks lock_depth), but
> > > the preempt count is not elevated yet via __lock_kernel(). So if we
> > > return from the hardirq [and run into softirqs that end with a
> > > preempt_enable() - a pure hardirq exit has no preempt debug check]
> > > we'll incorrectly think that there's a preempt leak going on.
> >
> > I don't think so. And anyway BKL is taken very early in boot and not
> > released for a long time, so I don't think it is possible for these
> > kinds of races to trigger here anyway.
> >
> > So I really think it still is a bug or some other misunderstanding we
> > have. I'd prefer to try to fix it or at least discover why it is
> > happening.
>
> yes - but the thing was reported a month ago, it went then upstream and
> re-reported and re-bisected - so time ran out to debug it and we reverted
> it. We can re-apply it if you have a good theory about what happened.

OK, but don't shoot the messenger ;) I don't know that code very
well... I was hoping someone else might jump in and fix it.

A few printks around could shed light on what preempt_count and
lock_depth is doing.


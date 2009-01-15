Return-Path: <linux-kernel-owner+w=401wt.eu-S1763462AbZAOKyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763462AbZAOKyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759133AbZAOKyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:54:06 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:29859 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755165AbZAOKyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:54:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=QB19vRVk9JaX0mzx34yjNRJUdWDXxZdFdu/TC0NccA2BVklcbO81wttA4aB+6POUgS+uSPGi9/BqYwI9BGRhQDIQDvl3jxcQs970DOtWreSDroO9GeRdNoylzRIer+dVJ+tKVHHcFlP0FL4RBUrfcRsEZPazGDbO8g2adfZphvg=  ;
X-YMail-OSG: VCV5_.MVM1khCC4ZYvPl0hqGOqtiT44e0TD9krhkxnLdy.qtGtUccza3wT2SDpL8DH2enw69WMb64npKzPn0QYVZBURypmVgimvxZVUer1b2bu3QzH4PzsudMCD2XwdT1xF1Gbb0qHF0o7qCiA9HTpZiNLeGRqCDTUCnoyaJtwLfRud0Blg_8RcXLpO7YFG_sFZRAQEE_3Cg.btD57TMMGK760k-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
Date: Thu, 15 Jan 2009 21:53:41 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20090113122455.GA24824@dhcp35.suse.cz> <200901151754.58311.nickpiggin@yahoo.com.au> <20090115100013.GE5833@elte.hu>
In-Reply-To: <20090115100013.GE5833@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901152153.42159.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 21:00:13 Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 13 January 2009 23:34:25 Ingo Molnar wrote:
> > > * Michal Hocko <mhocko@suse.cz> wrote:
> > > > Hi,
> > > > I am not sure whether someone has already reported this, but
> > > > I can see the following early boot WARNING with the 2.6.29-rc1 kernel
> > > > in the serial console output:
> > > >
> > > > ------------[ cut here ]------------
> > > > WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
> > >
> > > That one should be fixed in tip/master and it is in the to-Linus queue
> > > of fixes:
> > >
> > >   http://people.redhat.com/mingo/tip.git/README
> > >
> > > it's this commit:
> > >
> > >   01e3eb8: Revert "sched: improve preempt debugging"
> > >
> > > if you want to cherry-pick the fix.
> >
> > OK, but I still don't think this is the actual problem, but there is
> > something amiss in the init code being exposed by it.
>
> the warnings triggered after a softirq, and there's already preempt-leak
> checks in the softirq code - so we can exclude that.
>
> a hardirq might have leaked a preempt count - but that would have quite
> bad effects [with quick atomic check asserts in schedule()], wouldnt it?
> So i tend to think that this is a false positive.
>
> One problem i can think of (and which i outlined in the revert commit log)
> is that if a hardirq hits this window in lock_kernel():
>
> void __lockfunc lock_kernel(void)
> {
>         int depth = current->lock_depth+1;
>                                            <-------------- HERE

current->lock_depth is not yet modified at this point.

>         if (likely(!depth))
>                 __lock_kernel();

And here we increment preempt_count when taking the BKL, but we
has not yet modified current->lock_depth, so preempt debugging
will proceed with no impact of my patch at this point, regardless
of what interrupts are taken.

So there is a race window, but it is to err on the safe side and
not trigger a false report.

>         current->lock_depth = depth;
> }

At this point, the BKL addition to preempt_count will be taken into
account in underflow checking of subsequent preempt counters.


> then we have kernel_locked() already true (it checks lock_depth), but the
> preempt count is not elevated yet via __lock_kernel(). So if we return
> from the hardirq [and run into softirqs that end with a preempt_enable() -
> a pure hardirq exit has no preempt debug check] we'll incorrectly think
> that there's a preempt leak going on.

I don't think so. And anyway BKL is taken very early in boot and not
released for a long time, so I don't think it is possible for these
kinds of races to trigger here anyway.

So I really think it still is a bug or some other misunderstanding we
have. I'd prefer to try to fix it or at least discover why it is happening.



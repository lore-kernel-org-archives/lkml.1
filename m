Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYFMHqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYFMHqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYFMHqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:46:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYFMHqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:46:04 -0400
Date: Fri, 13 Jun 2008 00:33:26 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
cc: 7eggert@gmx.de, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jakub Jozwicki <jozwicki@aster.pl>, linux-kernel@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: sched_yield() on 2.6.25
In-Reply-To: <c384c5ea0806111545g6e6128bek519ce6022a301339@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0806130006530.8419@be10.lrz>
References: <aCBfw-3Cv-23@gated-at.bofh.it> <aCBfw-3Cv-21@gated-at.bofh.it>
  <aCJd6-3IF-11@gated-at.bofh.it> <aCRaM-8cM-33@gated-at.bofh.it> 
 <20080611152807.0682218F62@be1.lrz> <c384c5ea0806111545g6e6128bek519ce6022a301339@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+eLGA2gOl1x+LEveAvSmJqbZpSzGMoGXgrcfG
 8qbbB5rT5L8beYpGCSA422SCX9RCtdWUwMyodse2iLDbdV1tHJ
 3g+QPJMjPTEBqmeEZ12Jg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Leon Woestenberg wrote:
> On Wed, Jun 11, 2008 at 5:28 PM, Bodo Eggert <7eggert@gmx.de> wrote:
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >> On Mon, 2008-06-09 at 08:37 +0200, Jakub Jozwicki wrote:

> >>> From the man sched_yield:
> >>>
> >>> A  process  can  relinquish  the  processor  voluntarily without blocking by
> >>> calling sched_yield().  The process will then be moved to the  end  of  the
> >>> queue  for  its static priority and a new process gets to run.
> >>>
> >>> and also IEEE/Open Group:
> >>> http://www.opengroup.org/onlinepubs/000095399/functions/sched_yield.html
> >>
> >> Yeah, except that is for Real-Time scheduling classes, SCHED_OTHER
> >> doesn't have static priority queues.
> >>
> >> SCHED_OTHER doesn't have a specified implementation - so relying on it
> >> to do anything specific is well outside the scope of definition.
> >
> > OTOH, it's sane not to schedule exactly the thread which just tried
> > to say "I can't do any sane work, please run another thread.
> >
> That's not the definition of sched_yield(). See the earlier emails,
> and the quote above.
> 
> As the code after sched_yield() has to be executed the thread will be
> rescheduled soon (or even immediately) anyway.

The code after yield() is most likely to not run successfully (and as a
result will return to the yield call) unless some time passes, and this
time can pass while another process gets the CPU. It might even depend on
another process to change the system state.

Besides that, "Schedule another process, if you can" is part of the 
semantics of yield. The code after yield should therefore be expected to 
NOT be the very next code to run.

If you can't do that, it's fine, the process will abuse some more innocent 
electrons for busy waiting, but if you can support this yield() semantics, 
the system will perform much better. Won't it?

> The users not understanding the limited scope where sched_yield()
> behaves deterministicly, seem to think that _yield() will yield() AND
> lower the thread's dynamic priority for SCHED_OTHER. Is downgrading
> the dynamic priority a behavioral option?

I expect it to be. It may cause lower-nice-level processes to run,
but the (lack of) definition allows it.

> On the other hand, I don't think anything should encourage the use of
> sched_yield() outside of the rare SCHED_FIFO/RR case.

I agree that sleeping should be prefered, but if you really have to 
busy-wait for the next thread, you'll want yield() semantics.

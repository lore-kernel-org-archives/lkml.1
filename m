Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbYCXSQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbYCXSQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbYCXSQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:16:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbYCXSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:16:20 -0400
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
References: <20080324122424.671168000@chello.nl>
	 <alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 19:15:47 +0100
Message-Id: <1206382547.6437.131.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-24 at 10:58 -0700, Linus Torvalds wrote:
> 
> On Mon, 24 Mar 2008, Peter Zijlstra wrote:
> > 
> > As to the regression reported by Marcin; what happens is that we invoke
> > printk() while holding the xtime lock for writing. printk() will call
> > wake_up_klogd() which tries to enqueue klogd on some rq.
> > 
> > The known deadlock here is calling printk() while holding rq->lock, which
> > would then try to recusively lock the rq again when trying to wake klogd.
> 
> Ok.
> 
> Right now, however, I think that for 2.6.25 I'll just remove the printk. 
> 
> And for the long haul, I really don't think the solution is 
> "printk_nowakup()", because this is going to happen again when somebody 
> doesn't realize the code is called with the rq lock held, and it's going 
> to be a bitch to debug.

Yeah, we get the printk vs rq->lock thing on regular basis, the xtime
lock is new.

If the NMI watchdog works its rather easy to debug.

> I just don't think this is maintainable. 

I'm afraid I'll have to agree.

How about I use the lockdep infrastructure to check if printk() is
invoked whole holding either xtime or rq lock, and then avoid calling
wake_up_klogd(). That way, we at least get sane debug output when the
lock debugging infrastructure is enabled?

As for removing the printk(), Thomas, do you see any other sane way to
relay that information?




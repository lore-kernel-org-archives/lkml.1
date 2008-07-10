Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYGJWnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYGJWnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 18:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYGJWne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 18:43:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYGJWnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 18:43:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: Linus Torvalds's message of  Thursday, 10 July 2008 15:06:51 -0700 <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080710215039.2A143154218@magilla.localdomain>
	<alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org>
X-Windows: the cutting edge of obsolescence.
Message-Id: <20080710224256.AD038154218@magilla.localdomain>
Date: Thu, 10 Jul 2008 15:42:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But if you really want that behaviour, then re-introducing the loop would 
> likely be the better approach (or should be combined), since I think you 
> effectively just re-introduced it (at a much bigger granularity).

I don't think so.  Firstly, TIF_SIGPENDING is not the only flag in
question.  There are other reasons to re-enter do_notify_resume().
If those are set during signal processing et al, they should take
effect before going back to user mode.

Second, there is always a race.  Anywhere after the last time the
siglock was held inside do_signal(), there can be an interrupt that
sets TIF_SIGPENDING (or other _TIF_DO_NOTIFY_MASK flags).  If you go
on to return to user mode, then it can be a long time before the new
signal is actually delivered (til the next tick).  

It really is necessary to check all the _TIF_WORK_MASK flags with
interrupts disabled, last thing.  I just don't see how any short
cuts here can be robust.  It's simple, it's right, and it's what all
the other paths (and all other arch code I've ever noticed) do.

Since it's necessary to have robust checks in the final part of the
assembly code path anyway, and stacked signals are rare, there is
just no special reason to have a loop in do_signal().  In the common
case it every time retakes the siglock again when unnecessary, with
bad SMP performance effects; optimizing that with a signal_pending()
check just shows why it's simpler not to have a loop.  Frankly, I'm
glad we don't have one because it would fix only the scenario that
has a test case that's real easy to write, and leave lying all the
much more hairy ones that will cause someone to spend days and days
some day later tearing his hair out.


Thanks,
Roland

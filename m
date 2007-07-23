Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbXGWGjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbXGWGjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXGWGi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:38:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872AbXGWGi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:38:57 -0400
Date: Sun, 22 Jul 2007 23:38:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org
Subject: Re: Problems with timerfd()
Message-Id: <20070722233826.20efa6e5.akpm@linux-foundation.org>
In-Reply-To: <46A44B7D.3030700@gmx.net>
References: <46A44B7D.3030700@gmx.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 08:32:29 +0200 Michael Kerrisk <mtk-manpages@gmx.net> wrote:

> Andrew,
> 
> The timerfd() syscall went into 2.6.22.  While writing the man page for
> this syscall I've found some notable limitations of the interface, and I am
> wondering whether you and Linus would consider having this interface fixed
> for 2.6.23.
> 
> On the one hand, these fixes would be an ABI change, which is of course
> bad.  (However, as noted below, you have already accepted one of the ABI
> changes that I suggested into -mm, after Davide submitted a patch.)
> 
> On the other hand, the interface has not yet made its way into a glibc
> release, and the change will not break applications.  (The 2.6.22 version
> of the interface would just be "broken".)

I think if the need is sufficient we can do this: fix it in 2.6.23 and in
2.6.22.x.  That means that there will be a few broken-on-new-glibc kernels
out in the wild, but very few I suspect.

> Details of my suggested changes are below.  A complication in all of this
> is that on Friday, while I was part way though discussing this with Davide,
> he went on vacation for a month and is likely to have only limited email
> access during that time.  (See my further thoughts about what to do while
> Davide is away at the end of this mail message.)  Our last communication,
> after Davide had expressed reluctance about making some of the interface
> changes, was a more extensive note from me describing the problems of the
> interface.
> 
> The problems of the 2.6.22 timerfd() interface are as follows:
> 
> Problem 1
> ---------
> 
> The value returned by read(2)ing from a timerfd file descriptor is the
> number of timer overruns.  In 2.6.22, this value is 4 bytes, limiting the
> overrun count  to 2^32.  Consider an application where the timer frequency
> was 100 kHz (feasible in the not-too-distant future, I would guess), then
> the overrun counter would cycle after ~40000 seconds (~11 hours).
> Furthermore returning 4 bytes from the read() is inconsistent with eventfd
> file descriptors, which return 8 byte integers from a read().
> 
> Davide has already submitted a patch to you to make read() from a timerfd
> file descriptor return an 8 byte integer, and I understand it to have been
> accepted into -mm.

argh.  Nobody told me it was an ABI change!  We'll need to consider merging
make-timerfd-return-a-u64-and-fix-the-__put_user.patch into 2.6.22.x as
well.


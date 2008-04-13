Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYDMOXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYDMOXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 10:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYDMOW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 10:22:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:32869 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYDMOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 10:22:58 -0400
Date: Sun, 13 Apr 2008 08:22:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080413142241.GR11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com> <e2e108260804130655x4d9d694alc3feb3f623264a75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260804130655x4d9d694alc3feb3f623264a75@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 03:55:45PM +0200, Bart Van Assche wrote:
> On Sat, Apr 12, 2008 at 9:53 PM, Roland Dreier <rdreier@cisco.com> wrote:
> >  Just make sure you don't forget the history of completions...  As
> >  Linus said long ago (http://lwn.net/2001/0802/a/lt-completions.php3):
> >
> >   In case anybody cares, the race was that Linux semaphores only protect the
> >   accesses _inside_ the semaphore, while the accesses by the semaphores
> >   themselves can "race" in the internal implementation. That helps make an
> >   efficient implementation, but it means that the race was:
> >
> >             cpu #1                       cpu #2
> >
> >             DECLARE_MUTEX_LOCKED(sem);
> >             ..
> >             down(&sem);                   up(&sem);
> >             return;
> >                                           wake_up(&sem.wait) /*BOOM*/
> 
> Thanks for bringing this back to attention -- I wasn't aware of the
> message you cited.
> 
> My opinion about the above race is that this race has nothing to do
> with the semaphore concept, but that the race is caused by the way in
> which the semaphore object is used. Using any object after it has been
> destroyed is asking for trouble.

I think you need to re-read more carefully.

The users of the semaphore were doing nothing wrong.  They were not
using the object after it was destroyed.

The i386 implementation of the semaphore was calling wake_up() after
setting the counter to allow cpu #0 to proceed.  That was faster for the
common case, but had this problem.  completions were careful not to do
that, and the semaphore implementation I wrote doesn't do that either.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

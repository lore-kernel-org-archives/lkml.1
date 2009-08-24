Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZHXXxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZHXXxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZHXXw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:52:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbZHXXw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:52:56 -0400
Date: Mon, 24 Aug 2009 16:51:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000008
In-Reply-To: <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0908241632060.3824@localhost.localdomain>
References: <m163cjhwa4.fsf@fess.ebiederm.org> <m1skfnggrb.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0908241530070.3824@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Aug 2009, Linus Torvalds wrote:
> 
> Untested. VERY untested. Just going by "that looks odd".

Btw, one issue here is that we at least sometimes do tty_ldisc_halt() 
under the tty->ldisc_mutex.  Now that's fine - as long as we never take 
that lock inside any delayed work - because then the delayed work itself 
may need the lock we hold in order to complete, and now the 
'cancel_delayed_work_sync()' thing might deadlock.

And sadly, we do end up having 'do_tty_hangup()' as a workqueue entry, and 
that one does tty_ldisc_hangp, and that one in turn does take 
tty->ldisc_mutex.

So it looks like either we can't use the 'sync()' version, or we should 
never hold the ldisc_mutex while doing that tty_ldisc_halt(). Because 
waiting for the workqueue while holding the mutex looks like it could 
deadlock. It's probably very rare, but whatever.

Still, it would be good for people to test whether that patch makes the 
problem go away. Just to see if the issue really is a race between 
"tty_ldisc_halt()" and an ldisc being active on another CPU right then. 

But I wanted to let people know that the patch is clearly not the "last 
word" on this. It's a useful thing to try, but we need something better.

And it looks like we've hit that problem before, which is probably why it 
didn't use sync. several of the callers of 'tty_ldisc_halt()' do a 
flush_scheduled_work() afterwards, outside the ldisc_mutex. Of course, the 
sane one (tty_ldisc_release()) does a tty_ldisc_halt() even before taking 
the mutex lock.

			Linus

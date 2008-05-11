Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYEKLsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYEKLsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYEKLsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:48:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59123 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbYEKLsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:48:20 -0400
Date: Sun, 11 May 2008 05:48:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>, Sven Wegener <sven.wegener@stealer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511114803.GA8289@parisc-linux.org>
References: <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511110306.GP19219@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 05:03:06AM -0600, Matthew Wilcox wrote:
> This might be the problem that causes the missing wakeups.  If you have a
> semaphore with n=2, and four processes calling down(), tasks A and B
> acquire the semaphore and tasks C and D go to sleep.  Task A calls up()
[...]
> Sven, can you try this with your workload?  I suspect this might be it
> because XFS does use semaphores with n>1.

This is exactly it.  Or rather, it's even simpler.  Three tasks
involved; A and B call xlog_state_get_iclog_space() and end up calling
psema(&log->l_flushsema) [down() by any other name -- the semaphore is
initialised to 0; it's really a completion].  Then task C calls
xlog_state_do_callback() which does:

        while (flushcnt--)
                vsema(&log->l_flushsema);

[vsema is AKA up()]

It assumes this wakes up both A and B ... but it won't with Ingo's code;
it'll wake up A twice.

So I deem my fix "proven by thought experiment".  I haven't tried
booting it or anything.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

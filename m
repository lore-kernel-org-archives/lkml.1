Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbYEKN1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbYEKN1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 09:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYEKN0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 09:26:53 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46150 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYEKN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 09:26:53 -0400
Date: Sun, 11 May 2008 07:26:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511132636.GA22878@parisc-linux.org>
References: <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511130226.GR19219@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 07:02:26AM -0600, Matthew Wilcox wrote:
> > +	list_move_tail(&waiter->list, &sem->wait_list);
> 
> Seems like extra cache line dirtying for no real gain over my solution.

Actually, let me just go into this a little further.

In principle, you'd think that we'd want to wake up all the tasks
possible as soon as possible.  In practice, Dave Chinner has said that
the l_flushsema introduces a thundering herd (a few hundred tasks can
build up behind it on systems such as Columbia apparently) that then
run into a bottleneck as soon as they're unleashed.

Current XFS CVS has a fix from myself and Christoph that gets rid of the
l_flushsema and replaces it with a staggered wakeup of each task that's
waiting as the previously woken task clears the critical section.

Obviously, generic up() can't possibly do as well, but by staggering
the release of tasks from __down_common(), we mitigate the herd somewhat.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

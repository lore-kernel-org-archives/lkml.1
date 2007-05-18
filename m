Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbXERAUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbXERAUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 20:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXERATy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 20:19:54 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:41081
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbXERATy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 20:19:54 -0400
Date: Thu, 17 May 2007 17:18:41 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, "Bill Huey (hui)" <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [patch] CFS scheduler, -v12
Message-ID: <20070518001841.GA21140@gnuppy.monkey.org>
References: <20070513153853.GA19846@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513153853.GA19846@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 05:38:53PM +0200, Ingo Molnar wrote:
> Even a simple 3D app like glxgears does a sys_sched_yield() for every 
> frame it generates (!) on certain 3D cards, which in essence punishes 
> any scheduler that implements sys_sched_yield() in a sane manner. This 
> interaction of CFS's yield implementation with this user-space bug could 
> be the main reason why some testers reported SD to be handling 3D games 
> better than CFS. (SD uses a yield implementation similar to the vanilla 
> scheduler.)
> 
> So i've added a yield workaround to -v12, which makes it work similar to 
> how the vanilla scheduler and SD does it. (Xorg has been notified and 
> this bug should be fixed there too. This took some time to debug because 
> the 3D driver i'm using for testing does not use sys_sched_yield().) The 
> workaround is activated by default so -v12 should work 'out of the box'.

This is an incorrect analysis. OpenGL has the ability to "yield" after
every frame specifically for SGI IRIX (React/Pro) frame scheduler (driven
by the system vertical retrace interrupt) so that it can free up CPU
resources for other tasks to run. The problem here is that the yield
behavior is treated generally instead of specifically to a particular
proportion scheduler policy.

The correct solution is for the app to use a directed yield and a policy
that can directly support it so that OpenGL can guaratee a frame rate
governed by CPU bandwidth allocated by the scheduler.

Will is working on such a mechanism now.

bill


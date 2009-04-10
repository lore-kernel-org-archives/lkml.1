Return-Path: <linux-kernel-owner+w=401wt.eu-S1761996AbZDJPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbZDJPER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZDJPED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:04:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39412 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927AbZDJPEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:04:01 -0400
Date: Fri, 10 Apr 2009 16:03:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, hugh@veritas.com, jmorris@namei.org,
       akpm@linux-foundation.org
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
Message-ID: <20090410150353.GL26366@ZenIV.linux.org.uk>
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp> <20090410142203.GA6719@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410142203.GA6719@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 07:22:03AM -0700, Paul E. McKenney wrote:

> Hmmmm...  This indicates that CPU 1 was spinning in the kernel for
> a long time.  At 250 HZ, 32,565 jiffies is 130 seconds, or just over
> two -minutes-.  Ouch!!!
> 
> The interrupt happened on the stalled CPU, so we know that interrupts
> were enabled.  Because we have CONFIG_PREEMPT_NONE=y, there is no
> preemption, so preemption need not be disabled.  This could be due
> to lock contention, or even a simple infinite loop.
> 
> The timer interrupt (apic_timer_interrupt) occurred in either
> __bprm_mm_init(), __get_user_4(), count(), or do_execve().  There
> have been some recent changes around check_unsafe_exec() -- any
> possibility that these introduced excessive lock contention or
> an infinite loop?  Ditto for the recent security fixes?

Oh, joy... the loop in there is this:
        for (t = next_thread(p); t != p; t = next_thread(t)) {
                if (t->fs == p->fs)
                        n_fs++;
        }
I find it hard to believe that it can take two minutes, though.

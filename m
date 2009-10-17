Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZJQWjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZJQWjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 18:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZJQWjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 18:39:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZJQWjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 18:39:04 -0400
Date: Sun, 18 Oct 2009 00:39:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, Clark Williams <williams@redhat.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: -rt dbench scalabiltiy issue
Message-ID: <20091017223902.GA29439@wotan.suse.de>
References: <1255723519.5135.121.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255723519.5135.121.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 01:05:19PM -0700, john stultz wrote:
> 2.6.31.2-rt13-nick on ramfs:
>     46.51%         dbench  [kernel]                  [k] _atomic_spin_lock_irqsave
>                 |          
>                 |--86.95%-- rt_spin_lock_slowlock
>                 |          rt_spin_lock
>                 |          |          
>                 |          |--50.08%-- dput
>                 |          |          |          
>                 |          |          |--56.92%-- __link_path_walk
>                 |          |          |          
>                 |          |           --43.08%-- path_put
>                 |          |          
>                 |          |--49.12%-- path_get
>                 |          |          |          
>                 |          |          |--63.22%-- path_walk
>                 |          |          |          
>                 |          |          |--36.73%-- path_init
>                 |          
>                 |--12.59%-- rt_spin_lock_slowunlock
>                 |          rt_spin_unlock
>                 |          |          
>                 |          |--49.86%-- path_get
>                 |          |          |          
>                 |          |          |--58.15%-- path_init
>                 |          |          |          |          
> ...
> 
> 
> So the net of this is: Nick's patches helped some but not that much in
> ramfs filesystems, and hurt ext3 performance w/ -rt.
> 
> Maybe I just mis-applied the patches? I'll admit I'm unfamiliar with the
> dcache code, and converting the patches to the -rt tree was not always
> straight forward.

The above are dentry->d_lock, and they are rom path walking. It has
become more pronounced because I use d_lock to protect d_count rather
than an atomic_t (which saves on atomic ops).

But the patchset you have converted it missing the store-free path wailk
patches which will get rid of most of this. The next thing you hit is
glibc reading /proc/mounts to implement statvfs :( If you turn that call
into statfs you'll get a little further (but we need to improve statfs
support for glibc so it doesn't need those hacks).

And then you run into something else, I'd say d_lock again for creating
and unlinking things, but I didn't get a chance to profile it yet.

> Ingo, Nick, Thomas: Any thoughts or comments here? Am I reading perf's
> results incorrectly? Any idea why with Nick's patch the contention in
> dput() hurts ext3 so much worse then in the ramfs case?

ext3 may be doing more dentry refcounting which is hitting the spin
lock. I _could_ be persuaded to turn it back to an atomic_t, however
I will want to wait until other things like the path walking is more
mature which should take a lot of pressure off it.

Also... dbench throughput in exchange for adding an extra atomic at
dput-time is... not a good idea. We would need some more important
workloads I think (even a real samba serving netbench would be
preferable).



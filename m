Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbZLMBPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbZLMBPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbZLMBPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:15:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49875 "HELO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756475AbZLMBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:15:17 -0500
Date: Sat, 12 Dec 2009 09:26:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
References: <20091211232805.GA10652@kroah.com> <20091212084611.GA28266@elte.hu> <20091212013927.58d386d1.akpm@linux-foundation.org> <20091212101032.GB25286@elte.hu> <20091212023603.93768833.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Dec 2009, Linus Torvalds wrote:
> > 
> > I'm surprised that lockdep didn't notice that ab/ba I thought I saw. 
> > Maybe the do_tty_hangup()->tty_fasync() never happens.
> 
> The kernel lock cannot have any ABBA deadlocks.
> 
> If somebody blocks on another lock (after getting the kernel lock), the 
> kernel lock will be dropped. So no ABBA.

Oh, but it turns out that while there cannot be any ABBA deadlocks with 
sleeping locks, what the tty code does is invalid for _another_ reason: 
file_list_lock() is a spinlock. And that's a no-no.

You cannot take the kernel lock inside a spinlock. Ordering doesn't 
matter, there's no ABBA issues - it's simply invalid _regardless_ of any 
other use of that lock. 

I think we could possibly add a "__might_sleep()" to _lock_kernel(). It 
doesn't really sleep, but it's invalid to take the kernel lock in an 
atomic region, so __might_sleep() might be the right thing anyway.

			Linus

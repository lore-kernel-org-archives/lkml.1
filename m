Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYHMUIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYHMUIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYHMUI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:08:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbYHMUI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:08:29 -0400
Date: Wed, 13 Aug 2008 13:07:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ebiederm@xmission.com, ying.huang@intel.com, pavel@ucw.cz,
       nigel@nigel.suspend2.net, rjw@sisk.pl, vgoyal@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
 0) in kernel_kexec()
Message-Id: <20080813130749.c406ab6c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808131247320.3462@nehalem.linux-foundation.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com>
	<alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org>
	<m1r68shjhb.fsf@frodo.ebiederm.org>
	<20080813124406.21091eae.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0808131247320.3462@nehalem.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 12:50:57 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 13 Aug 2008, Andrew Morton wrote:
> > - * in interrupt context :)
> > + * Return true if we acquired the lock
> >   */
> > -static int kexec_lock;
> > +static inline bool kexec_trylock(void)
> > +{
> > +	return !test_and_set_bit(0, &kexec_bitlock);
> 
> Nope. That needs to be an "unsigned long".

It is.

> But more importantl, why not just make it a lock in the first place?
> 
> 	static DEFINE_SPINLOCK(kexec_lock);
> 
> 	#define kexec_trylock() spin_trylock(&kexec_lock)
> 	#define kexec_unlock() spin_unlock(&kexec_lock)
> 
> and then you get it all right and clear and obvious.

Used a bitop to preserve the runtime checking in there.  spin_unlock()
doesn't return the previous lockedness.

Presumably lockdep will whine about spun_unlock(unlocked_lock) though.

> Yeah, and I didn't check whether there is anything that is supposed to be 
> able to sleep. If there is, use a mutex instead of a spinlock, of course.

Yes, it does sleepy things inside the lock.


A bitop seems a better fit to me.  We never spin on that lock (it
always uses test_and_set), so why use a "spin"lock?

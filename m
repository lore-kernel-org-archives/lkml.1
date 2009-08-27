Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbZH0Gvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbZH0Gvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 02:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZH0Gvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 02:51:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZH0Gvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 02:51:49 -0400
Date: Thu, 27 Aug 2009 12:21:02 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kvm@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       miltonm@bga.com, qemu-devel@nongnu.org, borntraeger@de.ibm.com,
       brueckner@linux.vnet.ibm.com, virtualization@lists.linux-foundation.org,
       alan@linux.intel.com
Subject: Re: [Qemu-devel] Re: Extending virtio_console to support multiple
	ports
Message-ID: <20090827065102.GA3218@amit-x200.redhat.com>
References: <1251181044-3696-1-git-send-email-amit.shah@redhat.com> <20090826112718.GA11117@amit-x200.redhat.com> <20090826154552.GA31910@amit-x200.redhat.com> <1251346023.20467.21.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251346023.20467.21.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Aug 27 2009 [14:07:03], Benjamin Herrenschmidt wrote:
> On Wed, 2009-08-26 at 21:15 +0530, Amit Shah wrote:
> 
> > 
> > > - Convert hvc's usage of spinlocks to mutexes. I've no idea how this
> > >   will play out; I'm no expert here. But I did try doing this and so far
> > >   it all looks OK. No lockups, lockdep warnings, nothing. I have full
> > >   debugging enabled. But this doesn't mean it's right.
> > 
> > So just to test this further I added the capability to have more than
> > one hvc console spawn from virtio_console, created two consoles and did
> > a 'cat' of a file in each of the virtio-consoles. It's been running for
> > half an hour now without any badness. No spew in debug logs too.
> > 
> > I also checked the code in hvc_console.c that takes the spin_locks.
> > Nothing there that runs from (or needs to run from) interrupt context.
> > So the change to mutexes does seem reasonable. Also, the spinlock code
> > was added really long back -- git blame shows Linus' first git commit
> > introduced them in the git history, so it's pure legacy baggage.
> 
> Two things here:
> 
>  - First you seem to have completely missed the fact that hvc_poll() can
> be called from interrupt time :-) Look at hvc_irq.c which is used by

Right! That's the obvious one.

> some backends. Maybe that can be "fixed" by deferring to a work queue,
> though it's nice to have the keyboard input have somewhat of a higher
> priority than anything else here.

Hm, to maintain the current behaviour of poll() returning some
poll_mask, the poll_mask could be made into an atomic variable with
khvcd() updating it. But to have read at a higher priority than the
other stuff, I don't quite see yet how that can be done.

> So unless that's fixed, or I missed something, that's a big NACK for
> now.
> 
>  - Then, are we certain that there's no case where the tty layer will
> call us with some lock held or in an atomic context ? To be honest, I've

The other routines are open(), close(), write(), etc., and other kernel
context (hvc_instantiate() and the khvcd thread).

> totally lost track of the locking rules in tty land lately so it might
> well be ok, but something to verify.

Yes.

Thanks for the response!

		Amit

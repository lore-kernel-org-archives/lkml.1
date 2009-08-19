Return-Path: <linux-kernel-owner+w=401wt.eu-S1751371AbZHSJii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbZHSJii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZHSJii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:38:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:52165 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZHSJih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:38:37 -0400
Subject: Re: [PATCH] spinlock: __raw_spin_is_locked() should return true
 for UP
From: Peter Zijlstra <peterz@infradead.org>
To: Olivier Galibert <galibert@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, linuxppc-dev@ozlabs.org
In-Reply-To: <20090819093145.GA53298@dspnet.fr.eu.org>
References: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org>
	 <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain>
	 <alpine.DEB.2.00.0908181931180.28398@gandalf.stny.rr.com>
	 <alpine.LFD.2.01.0908181640120.3158@localhost.localdomain>
	 <alpine.DEB.2.00.0908182003430.18648@gandalf.stny.rr.com>
	 <BB2762BC-C760-4D4C-BDCF-76EFD3E1B18D@kernel.crashing.org>
	 <alpine.LFD.2.01.0908181937400.3158@localhost.localdomain>
	 <20090819093145.GA53298@dspnet.fr.eu.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Aug 2009 11:38:21 +0200
Message-Id: <1250674701.7583.333.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 11:31 +0200, Olivier Galibert wrote:
> On Tue, Aug 18, 2009 at 07:40:16PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Tue, 18 Aug 2009, Kumar Gala wrote:
> > > 
> > > I agree its a little too easy to abuse spin_is_locked.  However we should be
> > > consistent between spin_is_locked on UP between with and without
> > > CONFIG_DEBUG_SPINLOCK enabled.
> > 
> > No we shouldn't.
> > 
> > With CONFIG_DEBUG_SPINLOCK, you have an actual lock variable for debugging 
> > purposes, so spin_is_locked() can clearly return a _valid_ answer, and 
> > should do so.
> > 
> > Without DEBUG_SPINLOCK, there isn't any answer to return.
> > 
> > So there's no way we can or should be consistent. In one case an answer 
> > exists, in another one the answer is meaningless and doesn't exist.
> 
> I always thought behaviour should be consistent between code with
> debugging on and code without.  Otherwise you may end up with cases of
> "it starts working when I turn on debugging" which are a pain to fix.
> Has something changed?
> 
> Or in other words, do you think lockdep should try solving deadlocks
> instead of just reporting them for instance?

The point is spin_is_locked() is a broken interface in that respect. Its
plain impossible to give the right answer.


Suppose there's code doing:

  /*
   * Ensure we don't have foo lock taken, because that would cause
   * lock inversion under bar lock.
   */
  BUG_ON(spin_is_locked(&foo));
  spin_lock(&bar);

and other code doing:

  /*
   * Ensure we've got foo locked because it protects bar
   */
  BUG_ON(!spin_is_locked(&foo));
  bar = fancy;

What value should you return when locks don't exist (which is the case
for UP)?


There simply is no right answer other than: don't use spin_is_locked().

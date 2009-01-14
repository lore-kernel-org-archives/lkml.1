Return-Path: <linux-kernel-owner+w=401wt.eu-S1764550AbZANQrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764550AbZANQrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764209AbZANQrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:47:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:56787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761484AbZANQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:47:34 -0500
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <496B7EBC.6020208@redhat.com>
References: <1231774622.4371.96.camel@laptop>  <496B6C23.8000808@redhat.com>
	 <1231780388.4371.185.camel@laptop>  <496B7EBC.6020208@redhat.com>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 17:46:39 +0100
Message-Id: <1231951599.14825.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 19:32 +0200, Avi Kivity wrote:
> Peter Zijlstra wrote:
> > Spinlocks can use 'pure' MCS locks.
> >   
> 
> How about this, then.  In mutex_lock(), keep wait_lock locked and only 
> release it when scheduling out.  Waiter spinning naturally follows.  If 
> spinlocks are cache friendly (are they today?) 

(no they're not, Nick's ticket locks still spin on a shared cacheline
IIRC -- the MCS locks mentioned could fix this)

> we inherit that.  If 
> there is no contention on the mutex, then we don't need to reacquire the 
> wait_lock on mutex_unlock() (not that the atomic op is that expensive 
> these days).

That might actually work, although we'd have to move the
__mutex_slowpath_needs_to_unlock() branch outside wait_lock otherwise
we'll deadlock :-)

It might be worth trying this if we get serious fairness issues with the
current construct.


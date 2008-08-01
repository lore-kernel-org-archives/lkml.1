Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYHAUuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYHAUuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYHAUuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:50:06 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59373 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752796AbYHAUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:50:05 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH] lockdep: lock_set_subclass - reset a held lock's
	subclass
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <489350AE.1030609@goop.org>
References: <20080731.155504.167792984.davem@davemloft.net>
	 <20080801.011122.32782916.davem@davemloft.net>
	 <20080801090100.GA25142@elte.hu>
	 <20080801.021348.233313767.davem@davemloft.net>
	 <1217588920.9686.6.camel@twins>  <489350AE.1030609@goop.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 22:49:56 +0200
Message-Id: <1217623796.9016.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 11:06 -0700, Jeremy Fitzhardinge wrote:
> Peter Zijlstra wrote:
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Subject: lockdep: lock_set_subclass - reset a held lock's subclass
> >
> > this can be used to reset a held lock's subclass, for arbitrary-depth
> > iterated data structures such as trees or lists which have per-node
> > locks.
> >   
> 
> Hey, can I use this to suppress the spurious lockdep warnings I get when 
> I try to hold more than one pte lock at once?

No, you still cannot hold more than 48 locks at any one time, and this
somewhat horrible annotation only works if you don't generate double
classes in the same chain.

What it can do is:

  L1
   L2
    U1
     L3
      U2
       etc..

What you do is:

  spin_lock(L1)
   spin_lock_nested(L2, 1)
    spin_unlock(L1);
    lockdep_set_subclass(L2, 0); // because L1, who was 0 isn't there anymore
     spin_lock_nested(L3, 1);
      spin_unlock(L2);
      lockdep_set_subclass(L2, 0); // blah blah..
       etc...




Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZCKOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZCKOnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZCKOnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:43:31 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56070 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZCKOna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:43:30 -0400
Date: Wed, 11 Mar 2009 07:43:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Dmitriy V'jukov" <dvyukov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SRCU: Number of outstanding callbacks
Message-ID: <20090311144327.GA7086@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <loom.20090311T104615-980@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20090311T104615-980@post.gmane.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:48:24AM +0000, Dmitriy V'jukov wrote:
> I've read Paul McKenney's article about SRCU:
> http://lwn.net/Articles/202847
> 
> And I am curious as to why only single outstanding SRCU callback per
> thread is allowed. The problem with RCU is that it allows basically
> unbounded number of outstanding callbacks, so why just not bound
> number of outstanding callbacks in SRCU? Memory blocks are frequently
> quite small, so that subsystem can tolerate up to let's say 1000
> pending memory blocks. Restriction on single pending callback looks
> quite severe (may cause unnecessary blocking), so why not provide:
> int init_srcu_struct(struct srcu_struct *sp, int
> limit_of_pending_callbacks);
> ?
> While limit is not reached call_srcu() is non blocking, otherwise it
> waits for grace period (behaves like synchronize_srcu()). I think in
> many situations call_srcu() will be practically non-blocking (in
> common case), while still guaranteeing bounded memory consumption.
> Note that currently number of outstanding SRCU callbacks is
> "unbounded" anyway (equal to number_of_threads), so changing number_of_threads
> to number_of_threads+N must not have any bad consequences.
> Or it's just not worth doing (because of the additional implementation
> complexity)?
> Thanks.

The short answer is, as you guessed, because it is not (yet) worth doing.
This is at least in part because SRCU is not heavily used.

The philosophy behind the limitation is that the memory overhead of
the blocks is a small fraction of the memory required to represent
a thread.  As you say, there are a number of other strategies that can
be pursued, but the current strategy has the advantage of simplicity.
In particular, the current strategy does not require a failure return
from an as-yet-nonexistent call_srcu().  Handling such a failure return
is certainly possible, but someone would have to show me an extremely
good reason for putting up with this.  ;-)

							Thanx, Paul

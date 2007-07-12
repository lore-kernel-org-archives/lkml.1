Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbXGLCtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbXGLCtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 22:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXGLCtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 22:49:00 -0400
Received: from ozlabs.org ([203.10.76.45]:50477 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933218AbXGLCs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 22:48:59 -0400
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Cc: hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20070711.192829.08323972.davem@davemloft.net>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070711122324.GA21714@lst.de>
	 <1184203311.6005.664.camel@localhost.localdomain>
	 <20070711.192829.08323972.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 12:48:41 +1000
Message-Id: <1184208521.6005.695.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 19:28 -0700, David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Thu, 12 Jul 2007 11:21:51 +1000
> 
> > To do inter-guest (ie. inter-process) I/O you really have to make sure
> > the other side doesn't go away.
> 
> You should just let it exit and when it does you receive some kind of
> exit notification that resets your virtual device channel.
> 
> I think the reference counting approach is error and deadlock prone.
> Be more loose and let the events reset the virtual devices when
> guests go splat.

There are two places where we grab task refcnt.  One might be avoidable
(will test and get back) but the deferred wakeup isn't really:

        /* We cache one process to wakeup: helps for batching & wakes outside locks. */
        void set_wakeup_process(struct lguest *lg, struct task_struct *p)
        {
        	if (p == lg->wake)
        		return;
        
        	if (lg->wake) {
        		wake_up_process(lg->wake);
        		put_task_struct(lg->wake);
        	}
        	lg->wake = p;
        	if (lg->wake)
        		get_task_struct(lg->wake);
        }

We drop the lock after I/O, and then do this wakeup.  Meanwhile the
other task might have exited.

I could get rid of it, but I don't think there's anything wrong with the
code...

Cheers,
Rusty.



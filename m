Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbXLVXQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbXLVXQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 18:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbXLVXQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 18:16:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42280 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbXLVXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 18:16:42 -0500
Subject: Re: Mysterious lockdep warning from the SCSI workqueue code
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200712222356.27311.rjw@sisk.pl>
References: <1198344452.3478.9.camel@localhost.localdomain>
	 <200712222356.27311.rjw@sisk.pl>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 00:16:45 +0100
Message-Id: <1198365406.30889.14.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 23:56 +0100, Rafael J. Wysocki wrote:
> On Saturday, 22 of December 2007, James Bottomley wrote:
> > I've no idea why this is occurring:
> > 
> > WARNING: at kernel/lockdep.c:700 look_up_lock_class()
> > Pid: 2068, comm: scsi_wq_3 Not tainted 2.6.24-rc6 #38
> >  [<c010535a>] show_trace_log_lvl+0x1a/0x30
> >  [<c0105ce2>] show_trace+0x12/0x20
> >  [<c010601c>] dump_stack+0x6c/0x80
> >  [<c014696d>] __lock_acquire+0x46d/0x10b0
> >  [<c0147628>] lock_acquire+0x78/0xa0
> >  [<c0136d18>] run_workqueue+0x128/0x1d0
> >  [<c013795c>] worker_thread+0x8c/0xf0
> >  [<c013ab32>] kthread+0x42/0x70
> >  [<c0104f47>] kernel_thread_helper+0x7/0x10
> >  =======================
> > 
> > it looks to be happening on the initial workqueue.c:run_workqueue()
> > 
> > 	spin_lock_irq(&cwq->lock);
> > 
> > It's caused by lockdep.c:look_up_lock_class()
> > 
> > 	WARN_ON_ONCE(class->name != lock->name);
> > 
> > but I'm not entirely sure what this actually means, not fully
> > understanding lockdep classes and how we acquire them in scsi.
> 
> I guess Ingo and/or Peter should have a look at this.

This makes me think of an invalid use of lockdep_set_class(). The
typical way to trigger this is:

struct lock_class_key my_keys[10];

struct my_obj *create_my_obj1()
{
	...
	spin_lock_init(&my_obj.lock);
	lockdep_set_class(&my_obj.lock, my_keys + foo);
	...
}

struct my_obj *create_my_obj2()
{
	...
	spin_lock_init(&my_obj.lock);
	lockdep_set_class(&my_obj.lock, my_keys + bar);
	...
}

This initializes &my_obj.lock to the same class (provides foo and bar
evaluate to the same), but give it a different name.

#define lockdep_set_class(lock, key) \
                lockdep_init_map(&(lock)->dep_map, #key, key, 0)

The name is #key, so: "my_keys + foo" vs "my_keys + bar"

The possible fixes are:
  - make key identical by changing the expression
  - use lockdep_set_class_and_name() and specify a
    consistent name by hand.




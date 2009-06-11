Return-Path: <linux-kernel-owner+w=401wt.eu-S1763198AbZFKLge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763198AbZFKLge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762918AbZFKLg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:36:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761644AbZFKLgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:36:25 -0400
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
 deadloop
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1244709196.2560.287.camel@ymzhang>
References: <1244689688.2560.268.camel@ymzhang>
	 <1244699756.6691.4.camel@laptop>  <1244701128.6691.5.camel@laptop>
	 <1244709196.2560.287.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Jun 2009 13:36:23 +0200
Message-Id: <1244720183.6691.214.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 16:33 +0800, Zhang, Yanmin wrote:
> On Thu, 2009-06-11 at 08:18 +0200, Peter Zijlstra wrote:
> > On Thu, 2009-06-11 at 07:55 +0200, Peter Zijlstra wrote:
> > > On Thu, 2009-06-11 at 11:08 +0800, Zhang, Yanmin wrote:
> > > > I investigate a fio hang issue. When I run fio multi-process
> > > > testing on many disks, fio traps into kernel and doesn't exit
> > > > (mostly hit once after runing sub test cases for ﻿hundreds of times).
> > > > 
> > > > Oprofile data shows kernel consumes time with some futex functions.
> > > > Command kill couldn't kill the process and machine reboot also hangs.
> > > > 
> > > > Eventually, I locate the root cause as a bug of futex. Kernel enters
> > > > a deadloop between 'retry' and 'goto retry' in function futex_wake_op.
> > > > By unknown reason (might be an issue of fio or glibc), parameter uaddr2
> > > > points to an area which is READONLY. So futex_atomic_op_inuser returns
> > > > -EFAULT when trying to changing the data at uaddr2, but later get_user
> > > > still succeeds becasue the area is READONLY. Then go back to retry.
> > > > 
> > > > I create a simple test case to trigger it, which just shmat an READONLY
> > > > area for address uaddr2.
> > > > 
> > > > It could be used as a DOS attack.
> > 
> > /me has morning juice and notices he sent the wrong commit...
> > 
> > commit 64d1304a64477629cb16b75491a77bafe6f86963
> > Author: Thomas Gleixner <tglx@linutronix.de>
> > Date:   Mon May 18 21:20:10 2009 +0200
> 2.6.30 includes the new commit. I did a quick testing with my simple
> test case and it traps into kernel without exiting.
> 
> The reason is I use flag FUTEX_PRIVATE_FLAG. So the fshared part in function
> get_futex_key should be deleted. That might hurt performance.

FWIW, using a private futex on a shm section is wrong in and of itself.

tglx: should we create CONFIG_DEBUG_FUTEX and do a vma lookup to
validate that private futexes are indeed in private anonymous memory?

But you would be able to trigger the same using an PROT_READ anonymous
mmap().

It appears access_ok() isn't as strict as we'd like it to be:

/*
...
 * Note that, depending on architecture, this function probably just
 * checks that the pointer is in the user space range - after calling
 * this function, memory access functions may still return -EFAULT.
 */
#define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))

Thomas is working on a fix for this.


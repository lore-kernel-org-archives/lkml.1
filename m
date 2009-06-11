Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZFKGTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZFKGTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 02:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZFKGSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 02:18:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:47908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZFKGSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 02:18:52 -0400
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
 deadloop
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1244699756.6691.4.camel@laptop>
References: <1244689688.2560.268.camel@ymzhang>
	 <1244699756.6691.4.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Jun 2009 08:18:48 +0200
Message-Id: <1244701128.6691.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 07:55 +0200, Peter Zijlstra wrote:
> On Thu, 2009-06-11 at 11:08 +0800, Zhang, Yanmin wrote:
> > I investigate a fio hang issue. When I run fio multi-process
> > testing on many disks, fio traps into kernel and doesn't exit
> > (mostly hit once after runing sub test cases for ﻿hundreds of times).
> > 
> > Oprofile data shows kernel consumes time with some futex functions.
> > Command kill couldn't kill the process and machine reboot also hangs.
> > 
> > Eventually, I locate the root cause as a bug of futex. Kernel enters
> > a deadloop between 'retry' and 'goto retry' in function futex_wake_op.
> > By unknown reason (might be an issue of fio or glibc), parameter uaddr2
> > points to an area which is READONLY. So futex_atomic_op_inuser returns
> > -EFAULT when trying to changing the data at uaddr2, but later get_user
> > still succeeds becasue the area is READONLY. Then go back to retry.
> > 
> > I create a simple test case to trigger it, which just shmat an READONLY
> > area for address uaddr2.
> > 
> > It could be used as a DOS attack.

/me has morning juice and notices he sent the wrong commit...

commit 64d1304a64477629cb16b75491a77bafe6f86963
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon May 18 21:20:10 2009 +0200

    futex: setup writeable mapping for futex ops which modify user space data

    The futex code installs a read only mapping via get_user_pages_fast()
    even if the futex op function has to modify user space data. The
    eventual fault was fixed up by futex_handle_fault() which walked the
    VMA with mmap_sem held.

    After the cleanup patches which removed the mmap_sem dependency of the
    futex code commit 4dc5b7a36a49eff97050894cf1b3a9a02523717 (futex:
    clean up fault logic) removed the private VMA walk logic from the
    futex code. This change results in a stale RO mapping which is not
    fixed up.

    Instead of reintroducing the previous fault logic we set up the
    mapping in get_user_pages_fast() read/write for all operations which
    modify user space data. Also handle private futexes in the same way
    and make the current unconditional access_ok(VERIFY_WRITE) depend on
    the futex op.

    Reported-by: Andreas Schwab <schwab@linux-m68k.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    CC: stable@kernel.org




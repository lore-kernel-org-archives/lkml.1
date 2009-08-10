Return-Path: <linux-kernel-owner+w=401wt.eu-S1751713AbZHJIO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbZHJIO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZHJIOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:14:25 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:64424 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZHJIOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:14:24 -0400
Date: Mon, 10 Aug 2009 10:13:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [Patch/RFC 0/4] Allow inlined spinlocks (again)
Message-ID: <20090810081324.GA30276@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set allows to have inlined spinlocks (again).

The rationale behind this is that function calls on at least s390 are
expensive.
If one considers that server kernels are usually compiled with
!CONFIG_PREEMPT a simple spin_lock is just a compare and swap loop.
The extra overhead for a function call is significant.
With inlined spinlocks overall cpu usage gets reduced by 1%-5% on s390.
These numbers were taken with some network benchmarks. However I expect
any workload that calls frequently into the kernel and which grabs a few
spinlocks to perform better.

Please note: I'm aware that this implementation is a bit ;) ugly and
might also contain bugs. But the performance improvements show that its
worth to do something in this area.

The actual implemtation is quite simple: move the spinlock C code to
a header file and add some wrappers. Configuration dependent this
file gets included into a C file and normal spinlock functions like
we them currently will generated. Otherwise the inline variants
will be generated as we had them before the out of line code was
introduced:

A standard spinlock function like this

void __lockfunc _spin_lock(spinlock_t *lock)
{
...
}
EXPORT_SYMBOL(_spin_lock);

gets converted to

LOCKFUNC void _spin_lock(spinlock_t *lock)
{
...
}
SPIN_EXPORT_SYMBOL(_spin_lock);

where LOCKFUNC and SPIN_EXPORT_SYMBOL get expanded dependent
on CONFIG_SPINLOCK_INLINE:

#ifdef CONFIG_SPINLOCK_INLINE

#define LOCKFUNC                 static inline
#define SPIN_EXPORT_SYMBOL(func)

#else /* CONFIG_SPINLOCK_INLINE */

#define LOCKFUNC                 __lockfunc
#define SPIN_EXPORT_SYMBOL(func) EXPORT_SYMBOL(func)

#endif /* CONFIG_SPINLOCK_INLINE */

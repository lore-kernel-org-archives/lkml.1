Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZCJK7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZCJK7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZCJK7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:59:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35514
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbZCJK73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:59:29 -0400
Date: Tue, 10 Mar 2009 03:59:15 -0700 (PDT)
Message-Id: <20090310.035915.149277356.davem@davemloft.net>
To: tj@kernel.org
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, lethal@linux-sh.org,
       rmk@arm.linux.org.uk, starvik@axis.com, ralf@linux-mips.org,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Tue, 10 Mar 2009 16:53:46 +0900

> This patchset converts all SMP-capable arches other than three
> non-trivial ones - powerpc64, sparc64 and ia64 - to use dynamic percpu
> allocator.  The affected archs are
...
> The only differences are 1. there can be more space between percpu
> areas for each cpu to accomodate minimum allocation size and first
> chunk dynamic reserve and 2. dynamic percpu variables use the same
> address translation mechanism as static ones.
> 
> #1 shouldn't cause any trouble and #2 shouldn't too because the
> offsets for dynamic percpu variables are carried in full pointer-width
> variables, so as long as the calculations don't make wrong assumptions
> (should be masked by RELOC_HIDE), it should be okay, but if your arch
> has addressing limitations (alpha, s390), please take a second look.

The one thing sparc64 does is calculate the base of the per-cpu
area using a base (contained in a fixed global register) a shift.

>From arch/sparc/include/asm/percpu_64.h

register unsigned long __local_per_cpu_offset asm("g5");
extern unsigned long __per_cpu_base;
extern unsigned long __per_cpu_shift;
#define __per_cpu_offset(__cpu) \
	(__per_cpu_base + ((unsigned long)(__cpu) << __per_cpu_shift))
#define per_cpu_offset(x) (__per_cpu_offset(x))
#define __my_cpu_offset __local_per_cpu_offset

I hope this won't cause problems for what you're trying to accomplish.

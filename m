Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbZGCPwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbZGCPwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 11:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZGCPvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 11:51:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbZGCPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 11:51:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: making asm-generic/futex.h completely usable
Date: Fri, 3 Jul 2009 17:51:46 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-10-generic; KDE/4.2.95; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
References: <8bd0f97a0907030114g459863e9l829a6291e990b9cf@mail.gmail.com>
In-Reply-To: <8bd0f97a0907030114g459863e9l829a6291e990b9cf@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200907031751.46280.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/QcPFBTDP6uO3J7z+XXdUFyUyvTv0imDzXD3p
 kO1/Pw5hv2jg/9JwpATKy8Dax18f06eqdDOWMICteZogUtfJuH
 A+cYOzl43KI4ibAnVl9lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009, Mike Frysinger wrote:
> ive been reading up on futexes of late and have been poking around the
> futex kernel pieces to see what is needed to get Blackfin working with
> it.
> 
> Blackfin falls into the "no hardware atomic instructions" category as
> can easily be seen in our atomic.h: disable interrupts, do
> load/stores, restore interrupts.  my understanding of the
> futex_atomic_op_inuser() function is that this runs in process
> context, so this same interrupt trick should work fine.  which leads
> me to wonder why doesnt the asm-generic/futex.h header already take
> this approach ?

The code does not run in user space, the name indicates that it
operates on variables in user space while running in the kernel.

The irq-disable trick fundamentally does not work on SMP systems,
which need architecture specific atomic operations for this.

> seems to me that the SuperH implementation fits the bill nicely.
> their arch/sh/include/asm/futex-irq.h looks like it could be literally
> straight copied into asm-generic/futex.h thus making it fully
> functional for everyone by default.

That sounds reasonable for the arch/sh/include/asm/futex.h file, but
the futex-irq.h file would still be reserved for non-SMP architectures.
I believe that out of the architectures currently using asm-generic/futex.h,
blackfin is the only one that supports SMP, so you still lose ;-)

On blackfin, being NOMMU, you could problably do a respective implementation
for SMP, along the lines of

/* include/asm-generic/futex-nommu-smp.h */
static inline int atomic_futex_op_xchg_set(int oparg, int __user *uaddr,
                                           int *oldval)
{
	int *addr = (__force void *)uaddr; /* only valid on NOMMU */
	if (!access_ok(VERIFY_WRITE, uaddr, 4))
		return -EFAULT;
	*oldval = xchg(addr, oparg);
        return 0;
}

static inline int atomic_futex_op_xchg_add(int oparg, int __user *uaddr,
                                           int *oldval)
{
	int *addr = (__force void *)uaddr; /* only valid on NOMMU */
	int tmp;
	if (!access_ok(VERIFY_WRITE, uaddr, 4))
		return -EFAULT;
	tmp = *addr;
	while ((*oldval = cmpxchg(addr, tmp, tmp + oparg)) != tmp)
		tmp = *oldval;
        return 0;
}

I.e. if your user space access is trivial, you can implement this using
the standard cmpxchg and xchg functions even on SMP.

	Arnd <><

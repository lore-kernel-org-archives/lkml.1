Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403Ab0AMT6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0AMT6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141Ab0AMT6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:58:37 -0500
Received: from science.horizon.com ([71.41.210.146]:24325 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754288Ab0AMT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:58:36 -0500
Date: 13 Jan 2010 14:58:28 -0500
Message-ID: <20100113195828.2611.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@zytor.com
Subject: Re: x86-32: clean up rwsem inline asm statements
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I can tell, very few of these assembly statements actually
> need a size at all -- the very first inc statement is purely to memory,
> and as such it needs a size marker, but almost any operation which is
> register-register or register-memory will simply take its size from the
> register operand.  For those, it seems cleaner to simply drop the size
> suffix, and in fact this is the style we have been pushing people
> towards (use the suffix where mandatory or where the size is fixed
> anyway, to help catch bugs; use no suffix where the size can vary and is
> implied by the operands.)

The one thing is that for a register-memory operation, using the
size of the memory operand can catch bugs where it doesn't match
the size of the register operand.

GCC's inline asm doesn't make operand size very implicit, and it's
awkward to cast output operands, so there's a potential for bugs.
I especially get nervous when the operand itself is an immediate
constant, as I can't remember the ANSI rules for the type very well.
(Quick: is 0x80000000 an unsigned 32-bit int or a signed 64-bit one?
What about 2147483648 or 1<<31?)

Since this is mostly inline functions, it's not so big a problem, but
I'd consider something like:

static inline void __up_write(struct rw_semaphore *sem)
{
       unsigned long tmp;
	asm volatile("# beginning __up_write\n\t"
		     LOCK_PREFIX "  xadd%z0	%1,(%2)\n\t"
		     /* tries to transition
			0xffff0001 -> 0x00000000 */
		     "  jz	1f\n"
		     "  call call_rwsem_wake\n"
		     "1:\n\t"
		     "# ending __up_write\n"
       	     : "+m" (sem->count), "=d" (tmp)
       	     : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
       	     : "memory", "cc");
}

Just in case the size of -RWSEM_ACTIVE_WRITE_BIAS doesn't match that
of sem->count.  It'll explode when you try to run it, of course, but
there's something to be said for compile-time errors.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZHNL4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZHNL4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZHNL4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:56:01 -0400
Received: from www.lumino.de ([85.159.12.10]:49675 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754582AbZHNL4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:56:00 -0400
Message-ID: <4A8550CF.8000003@lumino.de>
Date: Fri, 14 Aug 2009 13:55:59 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: implementing Futex
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de>
In-Reply-To: <200908131839.41803.arnd@arndb.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:,
>> From reading the code (futex_atomic_op_inuser() seems only to be called
>> once (in futex.c) ), it seems that futex_atomic_op_inuser() is not
>> really used at all. It seems that it'd only called for futex_wake, and
>> here the "Operation" is derived from the last parameter of the system
>> call, which the man page says is ignored.  So, are all the operations
>> implemented there really necessary or just "nice to have" ?
>
> You misread futex_wake_op(). The operation comes from the second parameter
> of the syscall, not the last one.

Really ?

In futex.c, I see

static int
futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
	      int nr_wake, int nr_wake2, int op) {
  ..
 retry_private:
	op_ret = futex_atomic_op_inuser(op, uaddr2);
  ..
}
...
long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
		u32 __user *uaddr2, u32 val2, u32 val3) {	
  ..
  case   FUTEX_WAKE_OP:
		ret = futex_wake_op(uaddr, fshared, uaddr2,
                      val, val2, val3);
  ..
};
...
SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
		struct timespec __user *, utime, u32 __user *, uaddr2,
		u32, val3) {
  ..	
  return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
  ..
}

I don't see that the value in question is modified anywhere in that code.

What am I getting wrong ?

But I also don't see how this makes any sense.

-Michael

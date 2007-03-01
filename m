Return-Path: <linux-kernel-owner+w=401wt.eu-S964771AbXCAJpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771AbXCAJpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964774AbXCAJpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:45:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36782 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964771AbXCAJpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:45:32 -0500
Date: Thu, 1 Mar 2007 01:45:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Mathieu Desnoyers <compudj@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Thread flags modified without set_thread_flag() (non
 atomically)
Message-Id: <20070301014523.e45c3cc5.akpm@linux-foundation.org>
In-Reply-To: <20070301103451.2618cc35@dhcp-252-105.norway.atmel.com>
References: <45E33EBD.6020603@google.com>
	<20070228220349.b42bf571.akpm@linux-foundation.org>
	<20070301103451.2618cc35@dhcp-252-105.norway.atmel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 10:34:51 +0100 Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> > On Mon, 26 Feb 2007 12:10:37 -0800 Mathieu Desnoyers <compudj@google.com> wrote:
> 
> > > avr32/kernel/ptrace.c:          ti->flags |= _TIF_BREAKPOINT;
> > 
> > No, I don't immediately see anything in the flush_old_exec() code path
> > which tells us that nobody else can look up this thread_info (or be holding
> > a ref to it) in this context.
> > 
> > 
> > > avr32/kernel/ptrace.c:                  ti->flags |= TIF_SINGLE_STEP;
> > 
> > heh.  Haarvard, you got a bug.
> 
> Heh, yeah. That would indeed explain some strange gdb behaviour. It
> will only trigger when single-stepping into an exception or interrupt
> handler so thanks for pointing it out; I would have had a hard time
> figuring it out on my own...

yup, tricky.

If there's a lesson here, it is "don't provide #defines in the header for
both versions".

The block code does a similar thing:

#define REQ_RW          (1 << __REQ_RW)
#define REQ_FAILFAST    (1 << __REQ_FAILFAST)
#define REQ_SORTED      (1 << __REQ_SORTED)
#define REQ_SOFTBARRIER (1 << __REQ_SOFTBARRIER)

and I've caught Jens using the wrong identifier at least twice in the past.

It's better I think to just provide #defines for the bit offsets and
open-code the shifting if needed.  Like PG_foo and BH_Foo.

> I don't think either of those need to be atomic though, since both of
> them happen in monitor mode with interrupts disabled.

That's true until you implement SMP ;)

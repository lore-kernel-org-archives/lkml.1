Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbYLPGdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbYLPGdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYLPGdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:33:09 -0500
Received: from ozlabs.org ([203.10.76.45]:54708 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbYLPGdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:33:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: local_add_return
Date: Tue, 16 Dec 2008 17:03:00 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161703.00697.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008 00:17:35 Steven Rostedt wrote:
> Shouldn't local_add_return be a way for archs that can increment a memory 
> location atomically against interrupts to use that infrastructure? It can 
> simply fall back to atomic_add_return for those archs that do not have 
> a lesser equivalent of atomic_add_return.

local_t was originally introduced (but actually never used for) the
SNMP counters.  They use two counters to avoid atomics, but as the ancient
comment says:

/* 
 * FIXME: On x86 and some other CPUs the split into user and softirq parts
 * is not needed because addl $1,memory is atomic against interrupts (but 
 * atomic_inc would be overkill because of the lock cycles). Wants new 
 * nonlocked_atomic_inc() primitives -AK
 */ 
#define DEFINE_SNMP_STAT(type, name)	\
	__typeof__(type) *name[2]

Then last year Mathieu sent (and Andrew accepted) a "rich set of atomic
operations", including excellent documentation "local_ops.txt".  Except
he thought they were atomics, so treated them accordingly.  Also, there
were no users (you're now the only one).

But if these new operations are to become the norm, it changes how archs
should implement local_t.  eg. trivalue becomes less attractive, atomic_long
more.  x86 has its own implementation so doesn't have these issues.

Now, I posted a benchmark patch before for archs to test.  I'm interested
in Sparc64.  Does any arch win from using multiple counters?  PowerPC has
soft interrupt disable, so that solution wins over atomic_long_t for them.

Cheers,
Rusty.

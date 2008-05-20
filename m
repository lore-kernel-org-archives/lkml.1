Return-Path: <linux-kernel-owner+w=401wt.eu-S934408AbYETWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbYETWGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761109AbYETWGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:06:06 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:63327 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915AbYETWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:06:05 -0400
Date: Tue, 20 May 2008 15:00:45 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
In-Reply-To: <1211318219.8297.177.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0805201425250.7453@t2.domain.actdsltmp>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
 <1211318219.8297.177.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Benjamin Herrenschmidt wrote:
> On Tue, 2008-05-20 at 13:40 -0700, Trent Piepho wrote:
>> There was some discussion on a Freescale list if the powerpc I/O accessors
>> should be strictly ordered w.r.t.  normal memory.  Currently they are not.  It
>> does not appear as if any other architecture's I/O accessors are strictly
>> ordered in this manner.  memory-barriers.txt explicitly states that the I/O
>> space (inb, outw, etc.) are NOT strictly ordered w.r.t. normal memory
>> accesses and it's implied the other I/O accessors (e.g., writel) are the same.
>>
>> However, it is somewhat harder to program for this model, and there are almost
>> certainly a number of drivers using coherent DMA which have subtle bugs because
>> the do not include the necessary barriers.
>>
>> But clearly and change to this would be a subject for a different patch.
>
> The current accessors should provide all the necessary ordering
> guarantees...

Depends on what you define as "necessary".  It's seem clear that I/O accessors
_no not_ need to be strictly ordered with respect to normal memory accesses,
by what's defined in memory-barriers.txt.  So if by "necessary" you mean what
the Linux standard for I/O accessors requires (and what other archs provide),
then yes, they have the necessary ordering guarantees.

But, if you want them to be strictly ordered w.r.t to normal memory, that's
not the case.

For example, in something like:

u32 *dmabuf = kmalloc(...);
...
dmabuf[0] = 1;
out_be32(&regs->dmactl, DMA_SEND_BUFFER);
dmabuf[0] = 2;
out_be32(&regs->dmactl, DMA_SEND_BUFFER);

gcc might decide to optimize this code to:

out_be32(&regs->dmactl, DMA_SEND_BUFFER);
out_be32(&regs->dmactl, DMA_SEND_BUFFER);
dmabuf[0] = 2;

gcc will often not do this optimization, because there might be aliasing
between "&regs->dmact" and "dmabuf", but it _can_ do it.  gcc can't optimize
the two identical out_be32's into one, or re-order them if they were to
different registers, but it can move the normal memory accesses around them.

Here's a quick hack I stuck in a driver to test.  compile with -save-temps and
check the resulting asm.  gcc will do the optimization I described above.

static void __iomem *baz = (void*)0x1234;
static struct bar {
     u32 bar[256];
} bar;

void foo(void) {
     bar.bar[0] = 44;
     out_be32(baz+100, 200);
     bar.bar[0] = 45;
     out_be32(baz+101, 201);
}

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbYELL5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbYELL5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759222AbYELL4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:56:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46218 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071AbYELL4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:56:44 -0400
Date: Mon, 12 May 2008 05:56:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make for_each_cpu_mask a bit smaller
Message-ID: <20080512115626.GE19219@parisc-linux.org>
References: <20080511135039.GA3286@mailshack.com> <20080511152440.GX19219@parisc-linux.org> <1210522779.16917.1252546109@webmail.messagingengine.com> <20080511220111.GC19219@parisc-linux.org> <1210590294.13136.1252653345@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210590294.13136.1252653345@webmail.messagingengine.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 01:04:54PM +0200, Alexander van Heukelum wrote:
> > #define for_each_cpu_mask(cpu, mask)				\
> > 	for ((cpu) = -1;					\
> > 	     (cpu) < NR_CPUS;					\
> > 	     (cpu) = find_next_cpu_mask((cpu), &(mask)))
> > 
> > int find_next_cpu_mask(int n, const cpumask_t *srcp)
> > {
> > 	return find_next_bit(srcp->bits, NR_CPUS, ++n);
> > }
> > 
> > That actually behaves the way I'd expect a function called
> > 'find_next_cpu_mask' to work.  It also abuses the 'for' condtion
> > less and might take a little less text space.
> 
> But it does not work.

You're right, of course.  Either of these should work:

#define for_each_cpu_mask(cpu, mask)				\
	for ((cpu) = find_next_cpu_mask(-1, &(mask));		\
	     (cpu) < NR_CPUS;					\
	     (cpu) = find_next_cpu_mask((cpu), &(mask)))

#define for_each_cpu_mask(cpu, mask)				\
	for ((cpu) = -1;					\
	     (cpu) = find_next_cpu_mask((cpu), &(mask)), (cpu) < NR_CPUS; \
	     )

int find_next_cpu_mask(int n, const cpumask_t *srcp)
{
	return find_next_bit(srcp->bits, NR_CPUS, ++n);
}

> I think of find_next_cpu_mask(cpu, mask) as: "find next
> cpu-index in mask, starting at index cpu". And similar
> with find_next_bit.

If you're determined to stick to your original formulation, renaming it
to find_valid_cpu_mask() would work better.

> As for the text-space argument, I think you might be right.
> Just not on i386/x86_64 where initialising a register to -1
> can be done in three bytes, initialising to 0 in two bytes
> and an increment in one byte :-).

While the initialisation may take one extra byte, the increment is
done in the function, and so takes at least one byte out of the loop.
Of course on other instruction sets, that's probably 4 bytes out of the
loop and they can initialise to -1 as cheaply as init to 0, so it's a
win on non-x86 and neutral on x86.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXKRXLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXKRXLp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 18:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbXKRXLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 18:11:38 -0500
Received: from ozlabs.org ([203.10.76.45]:38748 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXKRXLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 18:11:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (simplified)
Date: Mon, 19 Nov 2007 10:11:17 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071113185800.436425570@polymtl.ca> <200711152206.07519.rusty@rustcorp.com.au> <20071116140334.GA14930@Krystal>
In-Reply-To: <20071116140334.GA14930@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711191011.18634.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2007 01:03:35 Mathieu Desnoyers wrote:
> x86 optimization of the immediate values which uses a movl with code
> patching to set/unset the value used to populate the register used as
> variable source.

Since immediate values are by definition an optimization, I think it makes
sense to insist they be 1, 2, 4 or 8 bytes.  A BUILD_BUG_ON() in the right
place should ensure this (probably in generic code rather than x86).

> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/kernel/traps_32.c

I don't think you need any modification to this file now.

> + * Create the instruction in a discarded section to calculate its size. This is
> + * how we can align the beginning of the instruction on an address that will 
> + * permit atomic modificatino of the immediate value without knowing the size of 
> + * the opcode used by the compiler. The operand size is known in advance.
> + */ 

This alignment is also now unnecessary.

> +++ linux-2.6-lttng/arch/x86/kernel/immediate.c	2007-11-16
> 08:56:22.000000000 -0500 @@ -0,0 +1,143 @@
> +/*
> + * Immediate Value - x86 architecture specific code.

This is now almost entirely generic code, but I suppose we can let the next
architecture hoist it out.

> +/**
> + * arch_immediate_update_early - update one immediate value at boot time
> + * @immediate: pointer of type const struct __immediate to update
> + *
> + * Update one immediate value at boot time.
> + */
> +void arch_immediate_update_early(const struct __immediate *immediate)

I think it would be easier to just fast-path the num_online_cpus == 1 case,
even if you want to keep this "update_early" interface.

But I like your IPI algorithm: very tight.

Thanks,
Rusty.

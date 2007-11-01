Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbXKAUCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbXKAUCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXKAUCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:02:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbXKAUCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:02:00 -0400
Message-ID: <472A30A9.7040203@redhat.com>
Date: Thu, 01 Nov 2007 16:01:45 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de>
In-Reply-To: <20071101140320.GC26879@wotan.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2007 10:03 AM, Nick Piggin wrote:

[edited to show the resulting code]

> +	__asm__ __volatile__ (
> +		LOCK_PREFIX "xaddw %w0, %1\n"
> +		"1:\t"
> +		"cmpb %h0, %b0\n\t"
> +		"je 2f\n\t"
> +		"rep ; nop\n\t"
> +		"movb %1, %b0\n\t"
> +		/* don't need lfence here, because loads are in-order */
>  		"jmp 1b\n"
> +		"2:"
> +		:"+Q" (inc), "+m" (lock->slock)
> +		:
> +		:"memory", "cc");
>  }

If you really thought you might get long queues, you could figure out
how far back you are and use that to determine how long to wait before
testing the lock again. That cmpb could become a subb without adding
overhead to the fast path -- that would give you the queue length (or
its complement anyway.)


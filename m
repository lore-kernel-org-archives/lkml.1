Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYJZLUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYJZLUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYJZLUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:20:25 -0400
Received: from h4.dl5rb.org.uk ([81.2.74.4]:39250 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751962AbYJZLUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:20:24 -0400
Date: Sun, 26 Oct 2008 10:18:26 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC patch 05/15] get_cycles() : MIPS HAVE_GET_CYCLES_32
Message-ID: <20081026101826.GB24378@linux-mips.org>
References: <20081016232729.699004293@polymtl.ca> <20081016234656.224625422@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016234656.224625422@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 07:27:34PM -0400, Mathieu Desnoyers wrote:

> partly reverts commit efb9ca08b5a2374b29938cdcab417ce4feb14b54. Selects
> HAVE_GET_CYCLES_32 only on CPUs where it is safe to use it.
> 
> Currently consider the "_WORKAROUND" cases for 4000 and 4400 to be unsafe, but
> should probably add other sub-architecture to the blacklist.
> 
> Do not define HAVE_GET_CYCLES because MIPS does not provide 64-bit tsc (only
> 32-bits).

[...]

> Index: linux-2.6-lttng/include/asm-mips/timex.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-mips/timex.h	2008-10-16 12:25:47.000000000 -0400
> +++ linux-2.6-lttng/include/asm-mips/timex.h	2008-10-16 12:34:18.000000000 -0400
> @@ -29,14 +29,39 @@
>   * which isn't an evil thing.
>   *
>   * We know that all SMP capable CPUs have cycle counters.
> + *
> + * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + * HAVE_GET_CYCLES makes sure that this case is handled properly :
> + *
> + * Ralf Baechle <ralf@linux-mips.org> :
> + * This avoids us executing an mfc0 c0_count instruction on processors which
> + * don't have but also on certain R4000 and R4400 versions where reading from
> + * the count register just in the very moment when its value equals c0_compare
> + * will result in the timer interrupt getting lost.
>   */

The usual workaround for this processor bug is to check if the value of
the c0_count and c0_compare registers are close.  Clone, not identical to
allow for the time skew in the pipeline.  If they are close, then
execute the timer interrupt handler.  See also the R4000/R4400 errata.

  Ralf

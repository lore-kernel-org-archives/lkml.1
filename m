Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbYKXCfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbYKXCfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 21:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYKXCfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 21:35:01 -0500
Received: from ozlabs.org ([203.10.76.45]:45011 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYKXCfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 21:35:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18730.1723.708467.812600@drongo.ozlabs.ibm.com>
Date: Mon, 24 Nov 2008 12:43:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] powerpc: ftrace, convert to new dynamic ftrace arch API
In-Reply-To: <20081120191149.285359258@goodmis.org>
References: <20081120190948.057007623@goodmis.org>
	<20081120191149.285359258@goodmis.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> Thanks to Paul Mackennas for pointing out the mistakes of my original

Mackerras

> +static int test_24bit_addr(unsigned long ip, unsigned long addr)
> +{
> +	long diff;
> +
> +	/*
> +	 * Can we get to addr from ip in 24 bits?
> +	 *  (26 really, since we mulitply by 4 for 4 byte alignment)
> +	 */
> +	diff = addr - ip;
> +
> +	/*
> +	 * Return true if diff is less than 1 << 25
> +	 *  and greater than -1 << 26.
> +	 */
> +	return (diff < (1 << 25)) && (diff > (-1 << 26));

I think this still isn't right, and the comment is one of those ones
that is only useful to people who can't read C, as it's just a
transliteration of the code.

The comment should say something like "Return true if diff can be
represented as a 26-bit twos-complement binary number" and the second
part of the test should be (diff >= (-1 << 25)).  However, since you
define a test_offset() function in patch 4/5 that does the same test
but using only one comparison instead of two, why don't you just say:

	return !test_offset(diff);

(having first moved test_offset() before test_24bit_addr)?

Paul.

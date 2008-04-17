Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYDQUan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYDQUan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 16:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYDQUae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 16:30:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbYDQUad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 16:30:33 -0400
Date: Thu, 17 Apr 2008 13:29:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: mingo@elte.hu, hpa@zytor.com, jeremy@goop.org, rostedt@goodmis.org,
       fche@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v5)
Message-Id: <20080417132919.533e9667.akpm@linux-foundation.org>
In-Reply-To: <20080417201410.GB31616@Krystal>
References: <20080417165839.GA25198@Krystal>
	<20080417165944.GB25198@Krystal>
	<20080417201410.GB31616@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 16:14:10 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> +#define nmi_enter()					\
> +	do {						\
> +		lockdep_off();				\
> +		BUG_ON(hardnmi_count());		\
> +		add_preempt_count(HARDNMI_OFFSET);	\
> +		__irq_enter();				\
> +	} while (0)

<did it _have_ to be a macro?>

Doing BUG() inside an NMI should be OK most of the time.  But the
BUG-handling code does want to know if we're in interrupt context - at
least for the "fatal exception in interrupt" stuff, and probably other
things.

But afacit the failure to include HARDNMI_MASK in

 #define irq_count()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK))

will prevent that.

So.

Should we or should we not make in_interrupt() return true in NMI? 
"should", I expect.

If not, we'd need to do something else to communicate the current
processing state down to the BUG-handling code.


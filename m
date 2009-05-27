Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbZE0WN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbZE0WN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZE0WNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:13:18 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:37094 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZE0WNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:13:17 -0400
X-IronPort-AV: E=Sophos;i="4.41,261,1241395200"; 
   d="scan'208";a="191032945"
From: Roland Dreier <rdreier@cisco.com>
To: peterz@infradead.org
Cc: lkml@MoreThan.org, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org>
	<200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com>
	<200905230544.54657.lkml@morethan.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 27 May 2009 15:13:19 -0700
In-Reply-To: <200905230544.54657.lkml@morethan.org> (Michael S. Zick's message
	of "Sat, 23 May 2009 05:44:52 -0500")
Message-ID: <adar5ya5h4w.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2009 22:13:19.0480 (UTC) FILETIME=[575EA780:01C9DF18]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > The only objective information is posted here:
 > http://lkml.org/lkml/2009/5/20/342

Not sure if you've looked at this, but it's a lockdep trace that looks
to be a valid lockdep report due to non-annotated code (I don't *think*
it's a bug).  To summarize, there is the code path in
kernel/irq/spurious.c that does:

    poll_spurious_irq_timer ->
      poll_spurious_irqs()     [from timer, with hard IRQs on] ->
      poll_all_shared_irqs()   [if we think an IRQ got stuck] ->
      try_one_irq() ->
      spin_lock(&desc->lock)   [as above -- hard IRQs on]

while kernel/irq/chip.c has:

    handle_level_irq()         [called with hard IRQs off] ->
      spin_lock(&desc->lock)   [as above -- hard IRQs off]

and lockdep can't tell that the interrupt corresponding to desc has been
disabled if we ever actually reach try_one_irq(), so there's no risk of
the interrupt coming in and deadlocking while the try_one_irq() code
holds desc->lock.

Unfortunately I don't know how to annotate this...

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYD2XaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYD2XaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 19:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYD2XaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 19:30:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41066
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbYD2XaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 19:30:09 -0400
Date: Tue, 29 Apr 2008 16:30:07 -0700 (PDT)
Message-Id: <20080429.163007.59388708.davem@davemloft.net>
To: tglx@linutronix.de
Cc: torvalds@linux-foundation.org, harvey.harrison@gmail.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops: remove "optimizations"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080429.155824.183713623.davem@davemloft.net>
References: <20080429.053412.15412725.davem@davemloft.net>
	<alpine.LFD.1.10.0804291843550.6003@apollo.tec.linutronix.de>
	<20080429.155824.183713623.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 29 Apr 2008 15:58:24 -0700 (PDT)

> Given that others who tested could not find one case where the
> optimization cases actually applied, and it's breaking things for me,
> my theory is that it's triggering for some obscure case on sparc64 and
> thus showing a bug in these optimizations since in practice I'm the
> only person to actually test this new code.

Ok, I think I see the problem.

The core issue is that (X << N) is undefined when N is >= the
word size, but that's exactly what the find_next_bit() inline
optimizations do.

This optimization code will trigger on 64-bit if NR_CPUS is set
to 64, and you actually have 64 cpus.  It should also occur
on 32-bit if NR_CPUS=32 and you have 32 cpus.

The bogus expansion occurs in lib/cpumask.c:__next_cpu()

After processing cpu 63, we'll use offset==64 and thus try
to make the undefined shift I described above, causing the
caller's cpumask iteration loop to run forever.

This code was really not tested very well at all.

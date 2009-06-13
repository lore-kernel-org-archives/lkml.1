Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZFMFd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZFMFd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 01:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZFMFdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 01:33:19 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:33311 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbZFMFdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 01:33:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18995.11516.586276.479986@cargo.ozlabs.ibm.com>
Date: Sat, 13 Jun 2009 14:37:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Frysinger <vapier@gentoo.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open
	when supported
In-Reply-To: <20090612120507.GH16044@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org>
	<20090612120507.GH16044@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> PMU support is not required to get perfcounters support: if an 
> architecture hooks up the syscall it will get generic software 
> counters and the tools will work as well.

It looks to me that to work properly, each architecture has to provide
set_perf_counter_pending() and some way to arrange to call
perf_counter_do_pending() once interrupts get re-enabled.  We need
this because some software counters (the context-switch counter at
least, as well as all the tracepoint counters) use nmi = 1 because
their events happen at times when we can't do a wakeup.

Actually, as far as the tracepoints are concerned, I can't see any
reason to be sure that interrupts will be disabled when a tracepoint
event occurs.  On powerpc, calling set_perf_counter_pending() when
interrupts are enabled won't result in perf_counter_do_pending()
getting called right away; the perf_counter_do_pending() call won't
happen until something disables and re-enables interrupts.

Paul.

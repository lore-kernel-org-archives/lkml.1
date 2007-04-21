Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXDUVy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXDUVy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXDUVy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:54:26 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:52345 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbXDUVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:54:22 -0400
Subject: Re: Fault Injection issues: stacktrace x86_64 and failslab NUMA
From: Scott Porter <scott@opengridcomputing.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Akinobu Mita <Akinobu.Mita@gmail.com>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1177095354.25165.48.camel@scott-desktop.site>
References: <1177095354.25165.48.camel@scott-desktop.site>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 16:52:43 -0500
Message-Id: <1177192363.25165.101.camel@scott-desktop.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 13:55 -0500, Scott Porter wrote:
> I'm attempting to use Fault Injection stacktrace filtering on an x86_64
> platform (see config details below) and finding problems:
> 
> (1) Apparently stacktrace on x86_64 isn't always reliable but the fault
> injection code path to save a stack trace looks *completely* unreliable
> 

An update after a closer look at the x86_64 stacktrace code:

There is no FRAME_POINTER support in the x86_64 code.  Apparently it was
removed when the unwind code was added but now that has been removed as
well!

Anyways, the current dump_trace() code scans the *entire* process-level
kernel stack looking for anything resembling a kernel text address.
Guess where Fault Injection saves the stacktrace entries it is going to
compare -- on the same kernel stack!  So, the code is tripping over
itself such that once Fault Injection with stacktrace has been enabled
for a while the stack is littered with saved kernel text addresses.
This causes false positives in fail_stacktrace() when matching stale
addresses from prior call chains as well as missed matches due to the
buffer filling up with these stale entries.  Not to mention the fact
that dump_stack() happily reports all these stale addresses in the trace
back!

Digging around in the archives it looks like Andi Kleen knew this was an
issue with the x86_64 fallback stacktrace code.  Now that there is no
unwind code to even attempt to avoid the problem what should be done?
How about:

(1) Make it clear the Fault Injection with STACKTRACE on x86_64 is at
best "Russian Roulette" -- maybe a !X86_64 in Kconfig.debug?

(2) Introduce FRAME_POINTER support back into the x86_64 code.  This is
what Fault Injection really wants.

(3) Keep the saved stack address entries array out of sight of the
fallback save_stack_trace() code.  Lockdep does this by storing it in
static space but this requires locking which would be ugly for Fault
Injection.  Another option is to mask the saved addresses so they fail
the __kernel_text_address() test but fail_stacktrace() uses the same
mask to make it's comparisons.  There's still the problem of avoiding
kernel text addresses stored on the stack by other code (that is, other
than the expected stack chain uses).

Comments?

- Scott

P.S. The good news is if/when the unwind code is ready to merge back in
there is a testcase ready and waiting -- just enable Fault Injection
with failslab and the stacks will get unwound on every Kmalloc call!



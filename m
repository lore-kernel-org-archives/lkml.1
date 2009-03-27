Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZC0M7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZC0M7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZC0M7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:59:34 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:34100 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbZC0M7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:59:33 -0400
Subject: Re: Anyone working on ftrace function graph support on ARM?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <49CA5CFF.8090908@am.sony.com>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere>
	 <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere>
	 <20090325084248.GF4697@n2100.arm.linux.org.uk>
	 <49CA5CFF.8090908@am.sony.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 27 Mar 2009 12:58:08 +0000
Message-Id: <1238158688.9698.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2009 12:58:39.0078 (UTC) FILETIME=[BF819060:01C9AEDB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 09:34 -0700, Tim Bird wrote:
> Russell King - ARM Linux wrote:
> > As pointed out in my previous mail, identifying where on the stack the
> > return address is stored is only possible for OABI with frame pointers.
> > 
> > EABI will probably be possible with the stack unwinding code, but it
> > probably won't be cheap.  The EABI unwinder is scheduled for merging
> > during the present now-open merge window.
> 
> -finstrument-functions is looking better and better.  I know it
> adds more overhead than the mcount call, and may wreak havoc with
> the dynamic ftrace mechanisms, but at least the callouts are
> simple, clear, and you get both entry and exit, at fixed
> costs.  

This approach would work even with Thumb-2 compiled kernels (not in
mainline) where the frame pointer is useless wrt backtraces. The Thumb-2
kernel cannot currently be compiled with frame pointer because there is
some inline assembly where gcc fail to allocate lower registers (in
Thumb, the frame pointer is r7).

Anyway, the EABI toolchain I have (from CodeSourcery) generates
something like below with -pg for both ARM and Thumb code (so that it
doesn't rely on the frame pointer):

	push	{lr}
	bl	__gnu_mcount_nc

I think this will be (was?) merged into the mainline gcc for ARM. The
-pg option is still incompatible with -fomit-frame-pointer but maybe it
shouldn't be anymore.

> I'll take a look at the EABI unwinder to see
> what kind of variability it introduces (e.g. if it does a stack
> scan or something).

It's not cheap - it looks up the function address in a binary tree and
it reads some bytecodes (either from the tree or from a different table
pointed to by the tree) which it interprets to perform the equivalent of
a return from the current function (reading registers from the stack and
changing SP, LR).

-- 
Catalin


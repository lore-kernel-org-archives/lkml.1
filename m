Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZCYIgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZCYIgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZCYIgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:36:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33492 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZCYIgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:36:35 -0400
Date: Wed, 25 Mar 2009 08:36:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325083602.GE4697@n2100.arm.linux.org.uk>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere> <20090324221439.GE29509@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324221439.GE29509@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:14:39PM +0100, Ingo Molnar wrote:
> So the rule is: mcount must not destroy _any_ register state. 
> (beyond flags)

As has already been discussed on the ARM lists, we have a problem with
using mcount along with EABI, or OABI without frame pointers.  We can
not avoid destroying 'lr' - the return address for the function.

OABI works around this by assuming that the parent function saved a
stack frame, which means it's at a known offset from the frame pointer
(provided frame pointers are enabled.)  mcount reloads 'lr' before
returning:

ENTRY(mcount)
        stmdb sp!, {r0-r3, lr}
        mov r0, lr
        sub r0, r0, #MCOUNT_INSN_SIZE

        .globl mcount_call
mcount_call:
        bl ftrace_stub
        ldr lr, [fp, #-4]                       @ restore lr
        ldmia sp!, {r0-r3, pc}

So I think if Tim is expecting to be able to use this feature on EABI
kernels, he's going to struggle.

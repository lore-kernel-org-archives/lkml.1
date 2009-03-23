Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZCWNlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZCWNlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZCWNk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:40:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:56142 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZCWNk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cy2NkCFlU6vssycq3Dn0p7jnkz4vALRMS7nidY+9QEePzIB2t7O8PL46qJc0mSAlEe
         HQyHpV3SsT3r7RyfSM0v/N8mN/ftbZVx7CcDQE6znmC7+CUOmYU+ObhJIdKBs8n+vp8p
         VLFk6nB/F9VQyqn4ePn6oKrUdn3+8fPHC6xdU=
Date: Mon, 23 Mar 2009 16:48:13 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090323134813.GA18219@x200.localdomain>
References: <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090322123749.GF19826@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322123749.GF19826@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 01:37:49PM +0100, Ingo Molnar wrote:
> The ptrace bits and signoffs from Oleg and Alexey would certainly 
> help (me) in trusting it. (I've Cc:-ed Oleg and Alexey)

The further utrace stays away from mainline, the better.
That's from my experience with this code.

But let's see how ptrace(2) rewrite will look like because this is
the biggest thing that matters. All those cool virtual machines,
fancy tracers and what not aren't even comparable.

Right now with ptrace(2) rewrite the following is easily triggerable:

WARNING: at kernel/ptrace.c:515 ptrace_report_signal+0x2c1/0x2d0()
Pid: 4814, comm: exe Not tainted 2.6.29-rc8-utrace #1
Call Trace:
 [<c0126df1>] warn_slowpath+0x81/0xa0
 [<c014c359>] ? validate_chain+0xe9/0x1150
 [<c014d606>] ? __lock_acquire+0x246/0xa50
 [<c0232959>] ? __delay+0x9/0x10
 [<c014b8eb>] ? mark_held_locks+0x6b/0x80
 [<c03d3dd2>] ? _spin_unlock_irq+0x22/0x50
 [<c012fdd1>] ptrace_report_signal+0x2c1/0x2d0
 [<c012fb10>] ? ptrace_report_signal+0x0/0x2d0
 [<c0154a79>] utrace_get_signal+0x1c9/0x660
 [<c0135478>] get_signal_to_deliver+0x288/0x330
 [<c01029e9>] do_notify_resume+0xb9/0x890
 [<c017edd2>] ? cache_free_debugcheck+0x232/0x2f0
 [<c014957b>] ? trace_hardirqs_off+0xb/0x10
 [<c03d3d79>] ? _spin_unlock_irqrestore+0x39/0x70
 [<c01015a0>] ? sys_execve+0x40/0x60
 [<c017f139>] ? kmem_cache_free+0x89/0xc0
 [<c014baad>] ? trace_hardirqs_on_caller+0xfd/0x190
 [<c014bb4b>] ? trace_hardirqs_on+0xb/0x10
 [<c010340a>] work_notifysig+0x13/0x19

It looks like WARN_ON is just bogus, but who knows.

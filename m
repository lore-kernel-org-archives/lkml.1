Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZA1X0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZA1X0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZA1X0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:26:00 -0500
Received: from ozlabs.org ([203.10.76.45]:43122 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZA1XZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:25:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: Buggy IPI and MTRR code on low memory
Date: Thu, 29 Jan 2009 09:55:38 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290955.38940.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009 03:08:14 Steven Rostedt wrote:
> 
> While developing the RT git tree I came across this deadlock.
> 
> To avoid touching the memory allocator in smp_call_function_many I forced 
> the stack use case, the path that would be taken if data fails to 
> allocate.
> 
> Here's the current code in kernel/smp.c:

Interesting.  I simplified smp_call_function_ma{sk,ny}, and introduced this bug (see 54b11e6d57a10aa9d0009efd93873e17bffd5d30).

We used to wait on OOM, yes, but we didn't do them one at a time.

We could restore that quiesce code, or call a function on all online cpus using on-stack data, and have them atomic_dec a counter when they're done (I'm not sure why we didn't do this in the first place: Nick?)

> The problem is that if we use the stack, then we must wait for the 
> function to finish. But in the mtrr code, the called functions are waiting 
> for the caller to do something after the smp_call_function. Thus we 
> deadlock! This mtrr code seems to have been there for a while. At least 
> longer than the git history.

I don't see how the *ever* worked then, even with the quiesce stuff.

> The patch creates another flag called CSD_FLAG_RELEASE. If we fail
> to alloc the data and the wait bit is not set, we still use the stack
> but we also set this flag instead of the wait flag. The receiving IPI 
> will copy the data locally, and if this flag is set, it will clear it. The 
> caller, after sending the IPI, will wait on this flag to be cleared.

Doesn't this break with more than one cpus?  I think a refcnt is needed for the general case...

Rusty.

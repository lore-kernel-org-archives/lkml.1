Return-Path: <linux-kernel-owner+w=401wt.eu-S1763790AbYA2NSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763790AbYA2NSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763616AbYA2NR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:17:56 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38946 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763604AbYA2NRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:17:54 -0500
Date: Tue, 29 Jan 2008 18:48:21 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: "Abhishek Sagar" <sagar.abhishek@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       "Masami Hiramatsu" <mhiramat@redhat.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
Message-ID: <20080129131821.GA27312@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <479C4A28.3020705@gmail.com> <20080129060203.GA15576@in.ibm.com> <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 04:10:58PM +0530, Abhishek Sagar wrote:
> On 1/29/08, Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> > > Non kprobe breakpoints in the kernel might lie inside the .kprobes.text section. Such breakpoints can easily be identified by in_kprobes_functions and can be caught early. These are problematic and a warning should be emitted to discourage them (in any rare case, if they actually occur).
> >
> > Why? As Masami indicated in an earlier reply, the annotation is to
> > prevent *only* kprobes.
> 
> May be I'm completely off the mark here, but shouldn't a small subset
> of this section simply be 'breakpoint-free' rather than 'kprobe-free'?
> Placing a breakpoint on kprobe_handler (say) can loop into a recursive
> trap without allowing the debugger's notifier chain to be invoked.

A well heeled debugger will necessarily take care of saving contexts
(using techniques like setjmp/longjmp, etc) to help it recover from such
nested cases (See xmon for example).

> I'm assuming that non-kprobe exception notifiers may (or even should) run
> after kprobe's notifier callback (kprobe_exceptions_notify).

Yes, any such notifier is invoked after kprobe's callback as the kprobe
notifier is always registered with the highest priority.

> > > For this, a check can route the trap handling of such breakpoints away from kprobe_handler (which ends up calling even more functions marked as __kprobes) from inside kprobe_exceptions_notify.
> >
> > Well.. we pass on control of a !kprobe breakpoint to the kernel. This is
> > exactly what permits debuggers like xmon to work fine now.
> 
> This will still happen. It doesn't stop non-kprobe breakpoints from
> being handled, wherever they may be.
> 
> > I don't see any harm in such breakpoints being handled autonomously
> > without any sort of kprobe influence.
> 
> Here's what seems to be happening currently:
> 
> int3 (non-kprobe) -> do_int3 ->kprobe_exceptions_notify ->
> kprobe_handler (passes the buck to the kernel) -> non-krpobe/debugger
> exception handler.
> 
> Here's what the patch will do:
> 
> int3 (non-kprobe) -> do_int3 ->kprobe_exceptions_notify ->
> WARN_ON/kprobe_handler -> non-kprobe/debugger exception handler.
> 
> The WARN_ON (and not a BUG_ON) will be hit iff:
> (in_kprobes_functions(addr) && !is_jprobe_bkpt(addr))

But that still is unneeded dmesg clutter, IMHO.

Ananth

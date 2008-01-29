Return-Path: <linux-kernel-owner+w=401wt.eu-S1750726AbYA2KlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750726AbYA2KlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 05:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYA2KlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 05:41:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:61312 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbYA2Kk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 05:40:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V17sNENA8hgL20lJkvIEkIZ5Njj3hLszydia9rMvNIoJbfQI25kasIsB4Y0AsvoLgN6BUt7j/UR15P+WnRGO737Bg0kjbrRkM2XXpW9RsPn4/ELUZ86VA6NIbk2YGiO1dz4EvjCCBDeJ911dBEAzv5lIYaqIzdQqWnz8TisBLC0=
Message-ID: <863e9df20801290240t6c724cb9x145fd6b1ca4f3c78@mail.gmail.com>
Date: Tue, 29 Jan 2008 16:10:58 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: ananth@in.ibm.com
Subject: Re: [PATCH 0/3][RFC] x86: Catch stray non-kprobe breakpoints
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       "Masami Hiramatsu" <mhiramat@redhat.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080129060203.GA15576@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479C4A28.3020705@gmail.com> <20080129060203.GA15576@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/08, Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> > Non kprobe breakpoints in the kernel might lie inside the .kprobes.text section. Such breakpoints can easily be identified by in_kprobes_functions and can be caught early. These are problematic and a warning should be emitted to discourage them (in any rare case, if they actually occur).
>
> Why? As Masami indicated in an earlier reply, the annotation is to
> prevent *only* kprobes.

May be I'm completely off the mark here, but shouldn't a small subset
of this section simply be 'breakpoint-free' rather than 'kprobe-free'?
Placing a breakpoint on kprobe_handler (say) can loop into a recursive
trap without allowing the debugger's notifier chain to be invoked. I'm
assuming that non-kprobe exception notifiers may (or even should) run
after kprobe's notifier callback (kprobe_exceptions_notify).

> > For this, a check can route the trap handling of such breakpoints away from kprobe_handler (which ends up calling even more functions marked as __kprobes) from inside kprobe_exceptions_notify.
>
> Well.. we pass on control of a !kprobe breakpoint to the kernel. This is
> exactly what permits debuggers like xmon to work fine now.

This will still happen. It doesn't stop non-kprobe breakpoints from
being handled, wherever they may be.

> I don't see any harm in such breakpoints being handled autonomously
> without any sort of kprobe influence.

Here's what seems to be happening currently:

int3 (non-kprobe) -> do_int3 ->kprobe_exceptions_notify ->
kprobe_handler (passes the buck to the kernel) -> non-krpobe/debugger
exception handler.

Here's what the patch will do:

int3 (non-kprobe) -> do_int3 ->kprobe_exceptions_notify ->
WARN_ON/kprobe_handler -> non-kprobe/debugger exception handler.

The WARN_ON (and not a BUG_ON) will be hit iff:
(in_kprobes_functions(addr) && !is_jprobe_bkpt(addr))

> Ananth

I hope I've understood the point you were making, or at least came close :-).

--
Thanks,
Abhishek

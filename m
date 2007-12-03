Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXLCNxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXLCNxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXLCNx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:53:29 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:3178 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbXLCNx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:53:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mjloESx33v/scK20FJsrZx9UctgPW4mRfCxSL65ixfw4jexWO5Pqo8Jq2IUXiQ+rzvk8gbijZyDMkgeq1Sjyx3NBgYiIjgDJmQ3zaZHHvxspukJ68dKXKjZUM61fR5V5cyqzs2JaGBNKKC9Oh5UCq1irYR2uEVpRR46bxO60LKY=
Message-ID: <a430082a0712030553v22e9b46bnb9da975a23b1c0db@mail.gmail.com>
Date: Mon, 3 Dec 2007 14:53:27 +0100
From: "Markus Metzger" <markus.t.metzger@googlemail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [patch 0/2] x86, ptrace: support for branch trace store(BTS)
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Andi Kleen" <ak@suse.de>, tglx@linutronix.de,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Michael Kerrisk" <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20071201074044.GA13974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com>
	 <20071129155940.7df70ac2.akpm@linux-foundation.org>
	 <029E5BE7F699594398CA44E3DDF5544401051EEF@swsmsx413.ger.corp.intel.com>
	 <200711301134.04719.ak@suse.de>
	 <029E5BE7F699594398CA44E3DDF554440105236A@swsmsx413.ger.corp.intel.com>
	 <20071130170655.GA10868@elte.hu> <20071201074044.GA13974@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Cool.  It's been on my list to look into exposing those features
> somehow. I hadn't planned on doing it until after the utrace stuff
> settles and there is a more coherent interface context in which to do
> it.

I'm looking very much forward to utrace. From what I read so far, this is
a much nicer interface.
I would expect that this feature, together with all other ptrace extensions,
would need to be adapted to utrace, once that is in.


> If they are tackling the MSR hacking and context switch and so forth,
> I'd like to see them start out by just adding block-step
> (debugctlmsr.btf) with the PTRACE_SINGLEBLOCK interface as ia64 has.
> That should lay some of the same groundwork needed here, but is much
> simpler.

There seems to be support for block stepping in arch/x86/kernel/step.c,
which is used by kernel/ptrace.c.

This is now another user for the DEBUGCTL MSR; the access needs to be
synchronized. I'll look into it.


> I am not really in favor of this new ptrace interface.  I think they
> should look around across arch's and think about sane general-purpose
> interfaces for features of this kind that might be built with some
> commonality across machines.

I looked at the include/asm-*/ptrace.h files and some arch/*/kernel/ptrace.c
files. Most arch's support a few variants of GET<whatever>REGS.
Most implementations simply copy_to_user the kernel structures for the
requested registers.

Sparc64 needs to convert pointer sizes and defines the returned struct
directly in the implementation.
Xtensa provides access to an array of FP regs of varying size. They provide
a ptrace command to query for the size, but otherwise also copy_to_user
the entire array.

I have not found any arch that does anything more fancy than return a single
integer value or an array of registers.
In all cases, the command carries enough information to interpret the result.

In our case, the array we're querying for can be rather big and
typically only some
of the information is interesting. The data we return is inhomogeneous.

The former may be true for register arrays as well, but they are
typically small
enough. The latter would compare to a general GETREGS command that returns
all registers in a self-describing format (that might be an
interesting extension, if
one got tired of yet another GET<new-type-of>REGS command).

Instead of providing the entire array in one command, we introduced commands to
handle that array.
Instead of carrying the information how to interpret the result in the
command itself,
we provide that information directly in the result.

I would argue that this interface may be directly (re)used and
extended by other arch's.


Do you have specific concerns regarding the interface?


> Also do it in a layered way from
> low-level, with something usable for kernel-mode too.

To disable cpl0-filtering should be fairly easy; we would simply clear
the cpl-bit
in the debugctl_mask. This way, you can trace the kernel
part of the application, but you would still debug the application.
You could call the ptrace_bts_ functions directly or we might add a new set of
interface functions that simply forward the request (or the other way round).

To provide a per-cpu trace instead of a per-thread trace would be a
completely new
feature that only has the configuration part in common with our patch.

What did you have in mind when you asked for kernel-mode support?

thanks and regards,
markus.

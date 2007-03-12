Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbXCLStK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbXCLStK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXCLStJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:49:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbXCLStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:49:07 -0400
Date: Mon, 12 Mar 2007 19:48:56 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
cc: 7eggert@gmx.de, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
In-Reply-To: <f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0703121803450.2313@be1.lrz>
References: <7WzUo-1zl-21@gated-at.bofh.it> <7WAx2-2pg-21@gated-at.bofh.it>
  <7WAGF-2Bx-9@gated-at.bofh.it> <7WB07-3g5-33@gated-at.bofh.it> 
 <7WBt7-3SZ-23@gated-at.bofh.it> <E1HQfLX-0000fk-68@be1.lrz>
 <f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX19YM6Hq8NtzExHc9ZzZ7/sJqtMflXfMo5cEBDX
 /Kb5Wb8EVQx3Eu5Dzx0PtW81VGbb2BnyO55s5HmsbwzBE4iaEA
 P9nZbvqzvRFYi/UXD7Gnw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Michael K. Edwards wrote:
> On 3/12/07, Bodo Eggert <7eggert@gmx.de> wrote:
> > Michael K. Edwards <medwards.linux@gmail.com> wrote:

> > > Actually, I think it would make the kernel (negligibly) faster to bump
> > > f_pos before the vfs_write() call.
> >
> > This is a security risk.

<snip>

> I don't entirely follow this.

I got it wrong, and I didn't CC myself so I couldn't correct it in time.

If it was a security risk, it would exist right now, too, because of 
other access patterns.

> > BTW: The best thing you can do to a program where two threads race for
> > writing one fd is to let it crash and burn in the most spectacular way
> > allowed without affecting the rest of the system, unless it happens to
> > be a pipe and the number of bytes written is less than PIPE_MAX.
> 
> That's fine when you're doing integration test, and should probably be
> the default during development.  But if the race is first exposed in
> the field, or if the developer is trying to concentrate on a different
> problem, "spectacular crash and burn" may do more harm than good.
> It's easy enough to refactor the f_pos handling in the kernel so that
> it all goes through three or four inline accessor functions, at which
> point you can choose your trade-off between speed and idiot-proofness
> -- at _kernel_ compile time, or (given future hardware that supports
> standardized optionally-atomic-based-on-runtime-flag operations) per
> process at run-time.

CONFIG_WOMBAT

Waste memory, brain and time in order to grant an atomic write which is 
neither guaranteed by the standard nor expected by any sane programmer, 
just in case some idiot tries to write to one file from multiple 
processes.

Warning: Programs expecting this behaviour are buggy and non-portable.

> Frankly, I think that unless application programmers poke at some sort
> of magic "I promise to handle short writes correctly" bit, write()
> should always return either the full number of bytes requested or an
> error code.

If you asume that you won't have short writes, your programs may fail on
e.g. solaris. There may be reasons for linux to use the same semantics at 
some time in the future, you never know.

If you asume you *may* have short writes, you have no problem.

>  If they do poke at that bit, the (development) kernel
> should deliberately split writes a few percent of the time, just to
> exercise the short-write code paths.  And in order to find out where
> that magic bit is, they should have to read the kernel code or ask on
> LKML (and get the "standard lecture").

I think it may be well-hidden in menuconfig.

> Really very IEEE754-like, actually.  (Harp, harp.)

-EYOULOSTME
-- 
"Try to look unimportant; they may be low on ammo."
-Infantry Journal

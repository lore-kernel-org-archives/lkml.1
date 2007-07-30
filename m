Return-Path: <linux-kernel-owner+w=401wt.eu-S967519AbXG3R5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967519AbXG3R5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965325AbXG3R5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:57:33 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:55975 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825AbXG3R5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=afYp0rTAXrLc/wzaRsYFWG1o/ox47bTUOwxNq6NrypDvK3rR0qBX9gAASqZVscaldoEYm64fWFXtLh7SeTSNoyCemmJsS+h8w93GB2EFswmRxq/shMYy6hSKY04DSkFRWWZsg8hi1E2fD11nQuf8G/UC4IOxYVmXusgGqWG6dzs=
Message-ID: <1158166a0707301057w13db2d0ema88892a0091dda87@mail.gmail.com>
Date: Mon, 30 Jul 2007 18:57:29 +0100
From: "Denis Vlasenko" <vda.linux@googlemail.com>
To: "Satyam Sharma" <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH 0/8] i386: bitops: Cleanup, sanitize, optimize
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

On Monday 23 July 2007 17:05, Satyam Sharma wrote:
> There was a lot of bogus stuff that include/asm-i386/bitops.h was doing,
> that was unnecessary and not required for the correctness of those APIs.
> All that superfluous stuff was also unnecessarily disallowing compiler
> optimization possibilities, and making gcc generate code that wasn't as
> beautiful as it could otherwise have been. Hence the following series
> of cleanups (some trivial, some surprising, in no particular order):

[I did read entire thread]

Welcome to the minefield.

This bitops and barrier stuff is complicated. It's very easy to
introduce bugs which are hard to trigger, or happen only with some
specific gcc versions, or only on massively parallel SMP boxes.

You can also make technically correct changes which relax needlessly
strict barrier semantics of some bitops and trigger latent bugs
in code which was unknowingly depending on it.

How you can proceed:

Make a change which you believe is right. Recompile allyesconfig
kernel with and without this change. Find a piece of assembly code
which become different. Check that new code is correct (and smaller
and/or faster). Post your patch together with example(s) of code
fragments that got better. Be as verbose as needed.

Repeat for each change separately.

This can be painfully slow, but less likely to be rejected outright
in fear of introducing difficult bugs.

> * Marking "memory" as clobbered for no good reason

I vaguely remember that "memory" clobbers are needed in some rather
obscure, non-obvious situations. Google for it - Linus wrote about it
to lkml (a few years ago IIRC).

> * Volatile-casting of memory addresses
>   (wholly unnecessary, makes gcc generate bad code)

Do you know any code difference resulting from this patch?

> * Unwarranted use of __asm__ __volatile__ even when those semantics
>   are not required

ditto

> * Unnecessarily harsh definitions of smp_mb__{before, after}_clear_bit()
>   (again, this was like *asking* gcc to generate bad code)

ditto

> My testbox boots/works fine with all these patches (uptime half an hour)

For this kind of things, you really need something more stressing.
Try to find big SMP people who is willing to give it a whirl.

> and the compressed bzImage is smaller by about ~2 KB for my .config --

At least it proves that _something_ changed.
--
vda

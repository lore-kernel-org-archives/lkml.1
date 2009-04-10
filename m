Return-Path: <linux-kernel-owner+w=401wt.eu-S1758441AbZDJICB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbZDJICB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZDJIBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:01:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44297 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbZDJIBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:01:49 -0400
Date: Fri, 10 Apr 2009 10:04:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090410080444.GC16512@elf.ucw.cz>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> x86, setup: "glove box" BIOS calls -- infrastructure
> 
> Impact: new interfaces (not yet used)
> 
> For all the platforms out there, there is an infinite number of buggy
> BIOSes.  This adds infrastructure to treat BIOS interrupts more like
> toxic waste and "glove box" them -- we switch out the register set,
> perform the BIOS interrupt, and then restore the previous state.
> 
> LKML-Reference: <49DE7F79.4030106@zytor.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>

Sounds quite sane. Disadvantage is that we will no longer detect those
buggy BIOSen.

> +/*
> + * "Glove box" for BIOS calls.  Avoids the constant problems with BIOSes
> + * touching memory they shouldn't be.
> + */

Touching memory? AFAICT it only prevents touching registers.

> +	.code16
> +	.text
> +	.globl	intcall
> +	.type	intcall, @function
> +intcall:
> +	/* Self-modify the INT instruction.  Ugly, but works. */
> +	cmpb	%al, 3f
> +	je	1f
> +	movb	%al, 3f
> +	jmp	1f		/* Synchronize pipeline */
> +1:

There are various CPU bugs with self-modifying code, but I guess we
are not using it heavily enough. Also we are single-threaded so that
should be ok.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

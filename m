Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXJWAVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXJWAVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 20:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbXJWAVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 20:21:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60521
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbXJWAVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 20:21:02 -0400
Date: Mon, 22 Oct 2007 17:21:23 -0700 (PDT)
Message-Id: <20071022.172123.78710569.davem@davemloft.net>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, matthew@wil.cx,
       arnd@arndb.de, ralf@linux-mips.org, adobriyan@gmail.com,
       viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
From: David Miller <davem@davemloft.net>
In-Reply-To: <471D0C54.7060207@garzik.org>
References: <20071022194714.GI27248@parisc-linux.org>
	<alpine.LFD.0.999.0710221254550.30120@woody.linux-foundation.org>
	<471D0C54.7060207@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Mon, 22 Oct 2007 16:47:16 -0400

> Let me add to the chorus of voices:  I continually see two cases where 
> real bugs crop up:
> 
> 1) hacker uses spin_lock_irq() in incorrect context (where it is not 
> safe to do a blind enable/disable)
> 
> 2) hacker uses spin_lock_irq() correctly, but the surrounding code 
> changes, thus invalidating prior assumptions.
> 
> I would even go so far as to support the drastic measure of deleting 
> spin_lock_irq().
> 
> spin_lock_irqsave() generates fewer bugs, is more future-proof, and by 
> virtue of 'flags' permits architectures a bit more flexibility.

Whilst I agree with you fully on the error-prone'ness argument,
reading the processor interrupt level to fill in the 'flags'
can have non-trivial cost.  I think it's about 9 cycles and
a full pipeline flush on most sparc64 chips for example.

The write to turn off interrupts costs about the same, so you'd
essentially be doubling the execution cost in every case that
you convert as you propose.

I seem to recall that on modern x86 chips the cost of dorking
around with eflags like this is even higher.

What's the relative cost of pushfl/popl/pushl/popfl vs.  cli/sti on
like a core2 duo or a k8?

For 64-bit powerpc's software interrupt disabling scheme it seems
to cost is about equal for both cases.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYFKFNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYFKFNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 01:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYFKFNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 01:13:42 -0400
Received: from ozlabs.org ([203.10.76.45]:49317 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbYFKFNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 01:13:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18511.24317.31038.926337@cargo.ozlabs.ibm.com>
Date: Wed, 11 Jun 2008 15:13:33 +1000
From: Paul Mackerras <paulus@samba.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
In-Reply-To: <200806111500.30789.nickpiggin@yahoo.com.au>
References: <1211852026.3286.36.camel@pasglop>
	<200806101656.51211.nickpiggin@yahoo.com.au>
	<18511.21025.978328.596571@cargo.ozlabs.ibm.com>
	<200806111500.30789.nickpiggin@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:

> > I just wish we had even one actual example of things going wrong with
> > the current rules we have on powerpc to motivate changing to this
> > model.
> 
> ~/usr/src/linux-2.6> git grep test_and_set_bit drivers/ | wc -l
> 506
> How sure are you that none of those forms part of a cobbled-together
> locking scheme that hopes to constrain some IO access?

My comment was precisely about the fact that this sort of argument is
actually FUD.  I want one example that is demonstrably wrong, not just
a "how sure are you".

> But surely you have to audit the drivers anyway to ensure they are OK
> with the current powerpc scheme. In which case, once you have audited
> them and know they are safe, you can easily convert them to the even
> _faster_ __readl/__writel, and just add the appropriate barriers.

The trouble is that as code gets maintained, using __writel + explicit
barriers is more fragile because some people will change the code, or
add new code, without understanding the barriers.  So whenever a
driver gets converted to using __writel + barriers, we will end up
having to watch every change that goes into it forever.  Whereas with
the current scheme there's a much smaller set of gotchas to watch out
for, and the gotchas are things that already raise red flags, such as
open-coded locking and any sort of "clever" lockless scheme.

Paul.

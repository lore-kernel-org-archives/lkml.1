Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYFUURM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYFUURM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 16:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYFUURA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 16:17:00 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39205 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYFUURA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 16:17:00 -0400
Date: Sat, 21 Jun 2008 22:17:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: link failure fix
Message-ID: <20080621201742.GA2061@uranus.ravnborg.org>
References: <20080620232621.GB8061@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620232621.GB8061@jurassic.park.msu.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 03:26:21AM +0400, Ivan Kokshaysky wrote:
> With built-in scsi disk driver, the final link fails with a following
> error:
> `.exit.text' referenced in section `.rodata' of drivers/built-in.o:
> defined in discarded section `.exit.text' of drivers/built-in.o
> 
> This happens with -Os (CONFIG_CC_OPTIMIZE_FOR_SIZE=y) with all gcc-4
> versions, and also with -O2 and gcc-4.3.
> 
> The problem is in sd.c:sd_major() being inlined into __exit function
> exit_sd(), and the compiler generating a jump table in .rodata section
> for the 'switch' statement in sd_major(). So we have references to
> discarded section.
> 
> Fixed with a big hammer in the form of -fno-jump-tables.
> 
> Note that jump tables vs. discarded sections is a generic problem,
> other architectures are just lucky not to suffer from it.
Most other architectures would only notice when the exit function
is called because they do late discardning og the exit section.
alpha (and sparc) are some of the few architectures that discard exit
section at link time thus you will see this much sooner
than the others.

> But with
> a slightly more complex switch/case statement it can be reproduced
> on x86 as well. So maybe at some point we should consider
> -fno-jump-tables as a generic compile option...
Are the any size penalties here?
I assume there are a minimal performance penalty.

	Sam

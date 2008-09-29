Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYI2JNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYI2JNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYI2JNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:13:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:39242 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYI2JNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZSUGZnbfbT3ry7cfIDWzKm060E9FcGfy0CHY5RfsSqSK/r7MzDgdmY3vBrgbH2SnxH
         beONuuWPokjFJaSU0fmrX1RyoeMskf7jwVLF5E9Xf7wgjQAuI8D7HxJ4Rt1ETuBzfHFo
         6qkiRrLMrEQell5jtmbScDEnLCnwJfVqzMC7I=
Message-ID: <19f34abd0809290213m54a2c485p5917fcd46747ad6@mail.gmail.com>
Date: Mon, 29 Sep 2008 11:13:14 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [GIT PULL] kmemcheck fixlets (for -tip)
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20080929085512.GA2190@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080928180652.GA8500@localhost.localdomain>
	 <20080929085512.GA2190@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 10:55 AM, Ingo Molnar <mingo@elte.hu> wrote:
> FYI, i've reactivated kmemcheck on one of the -tip auto-test boxes
> earlier today and it's looking good so far - for example a 32-bit
> allyesconfig-ish config booted in just fine with kmemcheck enabled.
> Also, the box is very usable interactively - while previous one could
> always tell whether there's kmemcheck active.

Oops. Probably kmemcheck was not enabled (for all the right caches).
Here's what may go wrong:

1. kmemcheck is in one-shot mode. Only one error is reported; after
that, box will start returning to normal speed.
2. SLUB debugging was enabled. kmemcheck will not track "debugged"
caches, so I suggest turning SLUB off in kernel config, or by booting
with "slub_debug=-". But I think that SLUB debug can be turned off in
kernel config as well, which means that your randconfig testing will
hit both cases eventually.

>
> [ only one CPU is active, but we knew that. We've still got this
>  test-commit:
>
>     21d01a4: x86: add functions for duplicating page tables
>
>  it's not in tip/master but we still have it around. ]
>
> btw., is there any easy way to tell from within a script what the
> current status of kmemcheck is? In particular, whether it's running.
> Normally i have this in the syslog:
>
>  [    0.448022] kmemcheck: "Bugs, beware!"
>  [    0.452002] kmemcheck: Limiting number of CPUs to 1.
>
> but this time the log was too large so this bit was snipped out and i
> was unsure about it - needed a second bootup with a larger buffer to
> make sure. With lockdep we've got the 'debug_locks' /proc/lockdep_stats.
>

You can read /proc/sys/kernel/kmemcheck. We also set a per-cache flag
in slabs, so I think you can get some information from SLUB sysfs. But
I agree -- it is not always easy to tell what kmemcheck is actually
doing. Maybe some counters and stats would be appropriate.

> also, all kmemcheck warnings follow the usual WARN_ON() format, so that
> automated tests can pick it up, correct? -tip testing does so many
> bootups that there's no chance to notice non-system-crashing bugs and
> printouts but via automated means.

Uhm, not correct. We need a few more infos (like read size, shadow,
etc.), also the stacktraces are saved, so the default stacktrace of
WARN is useless. But we can certainly try to emulate it. What text
should I insert in order for your scripts to pick it up?

Thanks!


Vegard

PS: Awaiting your fatal system crashing reports ;-)

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

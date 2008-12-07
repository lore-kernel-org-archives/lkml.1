Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYLGNKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYLGNKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 08:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYLGNKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 08:10:09 -0500
Received: from genesysrack.ru ([195.178.208.66]:41979 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbYLGNKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 08:10:08 -0500
Date: Sun, 7 Dec 2008 16:10:04 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207131004.GA25438@ioremap.net>
References: <20081206160927.GA498@ioremap.net> <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com> <20081206165634.GA2516@ioremap.net> <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com> <1228591926.3808.6.camel@nga> <20081206202620.GA9470@ioremap.net> <ac3eb2510812061956g6bb422d9r7c8032fb68552b4c@mail.gmail.com> <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <20081207114519.GA23247@ioremap.net> <20081207115820.1c595877@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081207115820.1c595877@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 11:58:20AM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Which nevertheless should not break boot process...
> 
> Now you are talking complete crap. If init crashes what happens. If I
> have the wrong root fs listed what happens ?
> 
> Gee it breaks. Early userspace actually does have to be correct.

Heh, if userspace writes more than kernel's buffer size, what happens?
We suddenly stopped to trust userspace? What if modprobe itself will do
that? Do not differentiate bugs by the nature of not-bad and bad-enough:
we do not trust userspace, even init, and it looking at the very end of
the mail you will find again why this loading crap is a kernel problem.

> > should not hung. Detect recursion, do not allow more than 1-2-3
> > simultaneous modprobes, whatever, but do not say, that kernel behaves
> > that bad just because userspace is allowed to do that.
> 
> Please read the code: that is what we do. That is *WHY* you got the
> runaway modprobe message. It was caught but despite that the broken
> initrd failed to recover. We've had that feature for years.

Apparently just reading the code does not magically fix kernel problems.
What's the cosmic rays should initird check when it is asked by kernel
to load the module? It tries to load it, which in turn tries to load it
again. Since initird does not use libastral yet, it is up to kernel to
decide what to load and when to ask userspace about that.

> > And what's the argument of being close to a release? Do you propose to
> > hide the head into the sand and point a finger to anyone else saying its
> > not a kernel's problem? If prerelease has a bug, it should be fixed, and
> > not hidden under the cover.
> 
> Its an incredibly obscure corner case. It is not appropriate to totally
> trash years of kernel testing by panic re-ordering some init functions
> just before a release. You will undoubtedly harm more people than you'll
> please.

Registering purely software class device not being backed by real
hardware since appropriate buses are not yet available? Apparently I
know how to fix this problem: I will write a simple console driver
called 'prayer', which will just sacrifice a little CPU's heat to the
Raa-god when anyone tries to write something to console. And this driver
will later be replaced with real console. Ooops, doesn't above patch
from Kay do the same?

> > What about storing a small stack of recently requested device ids, and
> > if new request is about to ask one from that stack, return error? I can
> > cook up the patch tomorrow.
> 
> That would be an interesting experiment for 2.6.29 however we do requests
> in lots of different formats so it might be a bit more complex. You could
> store the last few strings. However the existing runaway code caught it
> and will have resulted in the -ENXIO path occuring anyway so I don't see
> what your "change" will achieve.

It will not infinitely try to load module, which tries to load itself
again via obscure kernel pathes, return error and continue.

I remind again: all console/tty stuff in my setup is built-in, so there
should be no module request at all, but since earlier registered code
does not know that, kernel believes that console is somewhere in the
module. Having dumb device registered first is a fix for this problem.

-- 
	Evgeniy Polyakov

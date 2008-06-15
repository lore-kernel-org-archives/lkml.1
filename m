Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYFOBHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYFOBHR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 21:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYFOBHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 21:07:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54701
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754435AbYFOBHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 21:07:03 -0400
Date: Sat, 14 Jun 2008 18:07:03 -0700 (PDT)
Message-Id: <20080614.180703.147133112.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, bunk@kernel.org,
       akpm@linux-foundation.org, protasnb@gmail.com
Subject: Re: 2.6.26-rc6-git2: Reported regressions from 2.6.25
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0806141727390.2949@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0806141423500.2949@woody.linux-foundation.org>
	<20080614.163129.80352314.davem@davemloft.net>
	<alpine.LFD.1.10.0806141727390.2949@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Jun 2008 17:41:24 -0700 (PDT)

> IOW, I'm pretty damn sure that the bug entry above is very much a result
> of the tcp_defer_accept_check() thing, and that commit ec0a196626 fixed
> it by reverting it. 

I agree with the gist of your analysis.

And it seems that Apache does try to use the deferred accept socket
option.  So we may indeed have a hit on this IA64 bug.

The wording in the report about versions is a little confusing:

	With kernel 2.6.26-rc5 and a git kernel just between rc4
	and rc5, my kernel panic...

Does this mean that the problem appeared between rc4 and rc5?  Or
that all 2.6.26-rcX releases have the problem?  That's an important
fact because the change in question showed up in 2.6.26-rc1, as it
came in the inital networking merge for the 2.6.26 merge window.

> > The behavior of that bug would not usually be a crash, but
> > rather stuck connections, and I severely doubt anything in
> > that specweb test setup is using the deferred-accept option
> > which is a requirement for hitting those problems.
> 
> Hey, I might be wrong. But see above. I don't think I am. I think the 
> deferred-accept was just even buggier than you believed.

Because of the requirements to trigger the new code, this case is
not likely to match the revert.  SSH absolutely does not use the
deferred accept socket option.

Let's look at the change in question.

Every single code path touched in the data paths are guarded
with "tp->defer_tcp_accept.request" which will be NULL unless
1) defer-accept socket option enabled and 2) a new connection
got queued up there.

Nothing about the normal accept queue handling got modified by those
changes which were reverted.

And note that this means the behavior change only hits listening
sockets.  So if we have a report that client outgoing SSH
connections hang with the current kernel, that report cannot
reasonably match this revert.

I also anticipate that if this change could trigger problems for
non-deferred-accept cases, we'd see a ton more reports than we have.

And we did some research and one of the only major servers that use
this obscure defer-accept feature is distcc and apache.  It is this
element of Ingo's bug report (that he uses distcc heavily and it was a
distcc socket which hung) that helped us narrow things down.

The SSH report clearly states "With kernel 2.6.26-rc5, ssh connections
to _remote_ servers randomly hang".  So this is a report about SSH
client connections under 2.6.26-rc5, not SSH server connections and
therefore not listening sockets.

So right now I'd say that the IA64 case could definitely be a match
but the SSH case very much is not.

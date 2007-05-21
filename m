Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbXEUFPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbXEUFPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXEUFPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:15:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUFPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:15:05 -0400
Date: Sun, 20 May 2007 22:12:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Davi Arnaut <davi@haxent.com.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] signalfd: retrieve multiple signals with one read()
 call
Message-Id: <20070520221232.1c0aab31.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705202146560.22011@alien.or.mcafeemobile.com>
References: <464F912F.3040205@haxent.com.br>
	<20070520210210.9a895eec.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705202112230.22011@alien.or.mcafeemobile.com>
	<20070520212627.398ffd23.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705202146560.22011@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 22:05:00 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Sun, 20 May 2007, Andrew Morton wrote:
> 
> > > I think it fits the rule "buffer must be big enough for at least one sigingo".
> > > We use the special return 0; as indicator that the process we were 
> > > monitoring signals, detached the sighand.
> > > 
> > 
> > hm.  Kernel violates proper read() semantics in many places.  Looks like we
> > just did it again.
> 
> I think we can have the check that "if size == 0 return 0". The above 
> cited return-0-on-detch would still apply for enough sized buffers. So:
> 
> 1) size == 0, return 0 (POSIX wants this)
> 
> 2) size < sizeof(signalfd_siginfo), return EINVAL
> 
> 3) size >= sizeof(signalfd_siginfo) && DETACH, return 0
> 
> The signalfd falls into what POSIX defined as "special file", and can 
> return a lower-than-size result.
> 

hm, well.  I'd suggest that we do what makes most sense, rather than
warping things to try to obey the letter of posix.

> 
> > Unless we just remove the __clear_user() altogether.  Who said that "Unused
> > memebers should be zero"?
> 
> Because it is a typically used value for still-unused/reserved members? 
> Better than random values I think ;)
> Members validity is driven by si_code & SI_MASK anyway.

Sure.  And it'd be a bit rude to return 128 from the read() but to only
have written to a few bytes of the user's memory.

otoh, only-writing-a-few-bytes will be usefully quicker than zapping the
whole 128b, particularly on small-cacheline CPUs.


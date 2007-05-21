Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbXEUFFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbXEUFFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXEUFFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:05:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4339 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXEUFFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:05:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 20 May 2007 22:05:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Davi Arnaut <davi@haxent.com.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] signalfd: retrieve multiple signals with one read() call
In-Reply-To: <20070520212627.398ffd23.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705202146560.22011@alien.or.mcafeemobile.com>
References: <464F912F.3040205@haxent.com.br> <20070520210210.9a895eec.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705202112230.22011@alien.or.mcafeemobile.com>
 <20070520212627.398ffd23.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, Andrew Morton wrote:

> > I think it fits the rule "buffer must be big enough for at least one sigingo".
> > We use the special return 0; as indicator that the process we were 
> > monitoring signals, detached the sighand.
> > 
> 
> hm.  Kernel violates proper read() semantics in many places.  Looks like we
> just did it again.

I think we can have the check that "if size == 0 return 0". The above 
cited return-0-on-detch would still apply for enough sized buffers. So:

1) size == 0, return 0 (POSIX wants this)

2) size < sizeof(signalfd_siginfo), return EINVAL

3) size >= sizeof(signalfd_siginfo) && DETACH, return 0

The signalfd falls into what POSIX defined as "special file", and can 
return a lower-than-size result.


> Unless we just remove the __clear_user() altogether.  Who said that "Unused
> memebers should be zero"?

Because it is a typically used value for still-unused/reserved members? 
Better than random values I think ;)
Members validity is driven by si_code & SI_MASK anyway.


- Davide



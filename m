Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbYGJWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbYGJWIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 18:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYGJWID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 18:08:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbYGJWID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 18:08:03 -0400
Date: Thu, 10 Jul 2008 15:06:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080710215039.2A143154218@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Roland McGrath wrote:
> 
> There are many different scenarios that could hit this bug, most of
> them races.  The simplest one to demonstrate does not require any
> race: when one signal has done handler setup at the check before
> returning from a syscall, and there is another signal pending that
> should be handled.  The second signal's handler should interrupt the
> first signal handler before it actually starts (so the interrupted PC
> is still at the handler's entry point).  Instead, it runs away until
> the next kernel entry (next syscall, tick, etc).

I have this dim memory of at least _some_ of this being on purpose.

If you look at old kernels (_really_ old ones - I think it's way before 
even the historical git archive, but I didn't take a look), we used to set 
up several stack frames at once, so that we'd nest the stack frames 
completely.

In other words, the code in do_signal() used to literally be a loop, 
something like

	while ((signr = get_signal_to_deliver(&info, &ka, regs, NULL)) > 0) {
		.. setup signal frame ..

(No, I don't think that's at all accurate of the actual code we used to 
have - I just took the current do_signal() code as an example)

And that explicit loop was removed in order for us to have just a single 
outstanding signal at a time. I forget the exact details why.

But if you really want that behaviour, then re-introducing the loop would 
likely be the better approach (or should be combined), since I think you 
effectively just re-introduced it (at a much bigger granularity).

Hmm.

		Linus

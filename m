Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbXKZSp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbXKZSp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXKZSpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:45:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42454 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbXKZSpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:45:49 -0500
Date: Mon, 26 Nov 2007 19:45:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ulrich Drepper <drepper@redhat.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
Message-ID: <20071126184528.GA16071@elte.hu>
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com> <474323CA.9030306@zytor.com> <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711261003290.5869@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Quite frankly, I can't really see many other approaches. And of the 
> above three ones, the sys_indirect() approach really does seem to be 
> the simplest *and* the best-performing. It's basically faster to just 
> unconditionally load six registers off an indirect block than it would 
> be to have any conditionals based on which system call it is.

yeah. And even assuming for the sake of argument, that there was only 
one dominant architecture we care about, even there many of our existing 
syscall APIs are _already_ special-purpose APIs that do not encode 
parameters in a 'flat' way.

So it's not like sys_indirect() would break some magic pristine state of 
a flat parameter space - on the contrary, most of the nontrivial 
syscalls take pointers to structures or pointers to streams of 
information. The parameter count histogram i believe further underlines 
this point:

  #args   #syscalls
  -----------------
      0       22
      1       51
      2       83
      3       85
      4       40
      5       23
      6        8

the natural 'center' of function call parameter counts is around 1-4 
parameters, and that is natural. (most operators that the human brain 
prefers to operate with are like that - having higher complexity than 
that often defeats the purpose of getting an API used by ... humans.)

(side-note: in that sense, introducing some generic "arbitrary number of 
parameters" ABI design that was suggested instead of sys_indirect() 
would be _counter productive_ from a meta-design POV: it would not 
punish sucky, over-complicated APIs that expose way too many details in 
their main API call.)

	Ingo

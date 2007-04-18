Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbXDRKRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbXDRKRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXDRKRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:17:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44524 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXDRKR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:17:29 -0400
Date: Wed, 18 Apr 2007 12:17:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418101706.GA29031@elte.hu>
References: <20070415162508.GA4526@elte.hu> <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <20070418082744.GA14009@elte.hu> <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com> <20070418090117.GA20764@elte.hu> <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com> <20070418091714.GA23446@elte.hu> <19a3b7a80704180225x3c8d6d60g366126862f05150@mail.gmail.com> <20070418092805.GA23125@elte.hu> <19a3b7a80704180252j72c955bcna5df5cb7057e6756@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19a3b7a80704180252j72c955bcna5df5cb7057e6756@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Pfister <christophpfister@gmail.com> wrote:

> It's nearly impossible for me to find out which mutex is deadlocking.

i've disassembled the xine_play function, and here are the function 
calls in it:

  <unresolved widget call?>
 pthread_mutex_lock()
 xine_log()
  <unresolved widget call?>
 function pointer call
 right after it: pthread_mutex_lock()

this second pthread_mutex_lock() in question is the one that deadlocks. 
It comes right after that function pointer call, maybe that identifies 
it?

[some time passes]

i rebuilt the library from source and while the installed library is 
different from it, looking at the disassembly i'm quite sure it's this 
pthread_mutex_lock() in xine_play_internal():

  pthread_mutex_lock( &stream->demux_lock );

src/xine-engine/xine.c:1201

the function pointer call was:

  stream->xine->port_ticket->acquire(stream->xine->port_ticket, 1);

right before the pthread_mutex_lock() call.

> It would be great if you could reproduce the same problem with a 
> xine-lib which has been compiled with debug support (so you'd get line 
> numbers in the back trace - that makes life _a lot_ easier and maybe I 
> could identify the problem that way) and the least optimization 
> possible ... :-)

ok, i'll try that too (but it will take some more time), but given how 
hard it was for me to trigger it, i wanted to get maximum info out of it 
before having to kill the threads.

	Ingo

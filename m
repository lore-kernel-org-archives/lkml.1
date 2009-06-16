Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZFPK3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZFPK3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZFPK3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:29:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54276 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZFPK3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:29:24 -0400
Date: Tue, 16 Jun 2009 12:29:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090616102910.GA11011@elte.hu>
References: <alpine.DEB.2.00.0906160144340.26673@gandalf.stny.rr.com> <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk> <20090616100015.GD6432@elte.hu> <20090616110419.14bc9485@lxorguk.ukuu.org.uk> <20090616101240.GB28204@elte.hu> <20090616102509.GA32717@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616102509.GA32717@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > On bootup with a totally generic Fedora 11, thinkpad setup 
> > > with the kernel swapped for current git head. Will send the 
> > > .config off list and build it with a 1M entry stack trace 
> > > again.
> > 
> > Nah, dont waste your time on that for now - if it's reproducible 
> > on simple bootup then i will be able to trigger it once i have 
> > your config.
> 
> update: i do trigger it too with your config:
> 
> BUG: MAX_STACK_TRACE_ENTRIES too low!

I have a potential workaround, please disable:

  CONFIG_DMA_API_DEBUG

does it get you below the limit? Here it gives:

 lock-classes:                          549 [max: 8191]
 direct dependencies:                  3288 [max: 16384]
 indirect dependencies:                6753
 all direct dependencies:             49282
 dependency chains:                    3384 [max: 32768]
 dependency chain hlocks:              9901 [max: 163840]
 in-hardirq chains:                      21
 in-softirq chains:                     243
 in-process chains:                    3120
 stack-trace entries:                 81205 [max: 262144]
 combined max dependencies:        16753528

We are now well below the limit for stack-trace entries.

This is something we noticed recently: dma-debug uses a lot of lock 
classes and thus creates a really large lock-graph, depleting the 
reserves quickly.

	Ingo

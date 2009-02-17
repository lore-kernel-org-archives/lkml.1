Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZBQWZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZBQWZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZBQWZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:25:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46293 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbZBQWY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:24:57 -0500
Date: Tue, 17 Feb 2009 23:23:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mpm@selenic.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, xemul@openvz.org,
       Nathan Lynch <nathanl@austin.ibm.com>
Subject: Re: What can OpenVZ do?
Message-ID: <20090217222319.GA10546@elte.hu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu> <1234285547.30155.6.camel@nimitz> <20090211141434.dfa1d079.akpm@linux-foundation.org> <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <20090213105302.GC4608@elte.hu> <1234817490.30155.287.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234817490.30155.287.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Fri, 2009-02-13 at 11:53 +0100, Ingo Molnar wrote:
> > In any case, by designing checkpointing to reuse the existing LSM
> > callbacks, we'd hit multiple birds with the same stone. (One of
> > which is the constant complaints about the runtime costs of the LSM
> > callbacks - with checkpointing we get an independent, non-security
> > user of the facility which is a nice touch.)
> 
> There's a fundamental problem with using LSM that I'm seeing 
> now that I look at using it for file descriptors.  The LSM 
> hooks are there to say, "No, you can't do this" and abort 
> whatever kernel operation was going on.  That's good for 
> detecting when we do something that's "bad" for checkpointing.
> 
> *But* it completely falls on its face when we want to find out 
> when we are doing things that are *good*.  For instance, let's 
> say that we open a network socket.  The LSM hook sees it and 
> marks us as uncheckpointable.  What about when we close it?  
> We've become checkpointable again.  But, there's no LSM hook 
> for the close side because we don't currently have a need for 
> it.

Uncheckpointable should be a one-way flag anyway. We want this 
to become usable, so uncheckpointable functionality should be as 
painful as possible, to make sure it's getting fixed ...

> We have a couple of options:
> 
> We can let uncheckpointable actions behave like security 
> violations and just abort the kernel calls.  The problem with 
> this is that it makes it difficult to do *anything* unless 
> your application is 100% supported. Pretty inconvenient, 
> especially at first.  Might be useful later on though.

It still beats "no checkpointing support at all in the upstream 
kernel", by a wide merging. If an app fails, the more reasons to 
bring checkpointing support up to production quality? We dont 
want to make the 'interim' state _too_ convenient, because it 
will quickly turn into the status quo.

Really, the LSM approach seems to be the right approach here. It 
keeps maintenance costs very low - there's no widespread 
BKL-style flaggery.

	Ingo

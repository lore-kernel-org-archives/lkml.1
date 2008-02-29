Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbYB2Rnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbYB2Rnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760815AbYB2Rm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:42:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715AbYB2Rm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:42:56 -0500
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
In-Reply-To: <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>
	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
	 <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org>
	 <1204305488.6243.113.camel@lappy>
	 <alpine.LFD.1.00.0802290928200.17889@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 18:42:14 +0100
Message-Id: <1204306934.6243.119.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 09:29 -0800, Linus Torvalds wrote:
> 
> On Fri, 29 Feb 2008, Peter Zijlstra wrote:
> >
> > > ... and what's the point? We've never had it before, nobody has ever cared, 
> > > and the whole notion is just stupid. Why would we want to limit it? The 
> > > only thing that the kernel *cares* about is the stack size - any other 
> > > size limits are always going to be arbitrary.
> > 
> > Well, don't think of limiting it, but querying the limit.
> > 
> > Programs like xargs would need to know how much to stuff into argv
> > before starting a new invocation.
> 
> But they already can't really do that. 

I think they used to use sysconf(_SC_ARG_MAX) to do that.

> More importantly, isn't it better to just use the whole stack size then 

Well, we ran into trouble of freshly spawned tasks faulting on the first
stack grow. The /4 thing was to avoid that situation.

> (or just return "stack size / 4" or whatever)?

I'm all for that, trouble is that the POSIX folks specified that the
sysconf() value must be consistent during the lifetime of a process.
Which isn't true, because we can change rlimit_stack after asking. And
the linux implementation doesn't even seem to bother asking the kernel -
so there just isn't much we _can_ do here.

My suggestion was a kernel version check along with sysconf or
rlimit_stack. But I guess that made the userspace people puke :-)


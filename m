Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZASBmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZASBmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 20:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbZASBl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 20:41:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45515 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZASBl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 20:41:57 -0500
Date: Mon, 19 Jan 2009 02:41:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Menage <menage@google.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, miaox@cn.fujitsu.com,
       maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/3] cgroup: convert open-coded
	mutex_lock(&cgroup_mutex) calls into cgroup_lock() calls
Message-ID: <20090119014143.GA10271@elte.hu>
References: <496FEFCA.9050908@cn.fujitsu.com> <4970000E.7040902@cn.fujitsu.com> <20090116125738.22c21bf2.akpm@linux-foundation.org> <4972E2FD.1010902@cn.fujitsu.com> <20090118091038.GC27144@elte.hu> <6599ad830901181737m1d04bb85t7bb0b48e925733a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830901181737m1d04bb85t7bb0b48e925733a6@mail.gmail.com>
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


* Paul Menage <menage@google.com> wrote:

> On Sun, Jan 18, 2009 at 1:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > this just changes over a clean mutex call to a wrapped lock/unlock
> > sequence that has higher overhead in the common case.
> >
> > We should do the exact opposite, we should change this opaque API:
> >
> >  void cgroup_lock(void)
> >  {
> >         mutex_lock(&cgroup_mutex);
> >  }
> >
> > To something more explicit (and more maintainable) like:
> 
> I disagree - cgroup_mutex is a very coarse lock that can be held for 
> pretty long periods of time by the cgroups framework, and should never 
> be part of any fastpath code. So the overhead of a function call should 
> be irrelevant.
> 
> The change that you're proposing would send the message that 
> cgroup_mutex_lock(&cgroup_mutex) is appropriate to use in a 
> performance-sensitive function, when in fact we want to discourage such 
> code from taking this lock and instead use more appropriately 
> fine-grained locks.

Uhm, how does that 'discourage' its use in fastpath code?

It just hides the real lock and invites bad locking/work constructs like 
the one proposed in this thread.

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764789AbYHDWN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764789AbYHDWN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762816AbYHDWNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:13:05 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:37331
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762757AbYHDWND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:13:03 -0400
Date: Tue, 5 Aug 2008 00:12:57 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, davej@redhat.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, davem@davemloft.net,
       jeremy@goop.org, hugh@veritas.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
Message-ID: <20080804221257.GF12464@duo.random>
References: <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random> <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins> <20080804201514.GB12464@duo.random> <1217882242.3589.90.camel@twins> <20080804210954.GC12464@duo.random> <84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com> <20080804213018.GD12464@duo.random> <20080804144114.e323a47f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804144114.e323a47f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 02:41:14PM -0700, Andrew Morton wrote:
> lockdep will warn here about the ranking violation.  As soon as it
> occurs.  Even though the system never deadlocked.

Yes I wasn't aware of the AB BA feature that doesn't require the
inversion to happen on both cpus at the same time, despite having
spent weeks when it was kernel crashing systems at boot (which shows
it's not immediately easy to understand how that thing works by
reading the code).

static DEFINE_MUTEX(a);
static DEFINE_MUTEX(b);
static DEFINE_MUTEX(c);

void f1(void)
{
	mutex_lock(c);
	mutex_lock(a);
	mutex_lock(b);
	mutex_unlock(c);
	mutex_unlock(a);
	mutex_unlock(b);
}

void f2(void)
{
	mutex_lock(c);
	mutex_lock(b);
	mutex_lock(a);
	mutex_unlock(c);
	mutex_unlock(b);
	mutex_unlock(a);
}

void f3(void)
{
	mutex_lock(a);
	mutex_lock(b);
	mutex_unlock(a);
	mutex_unlock(b);
}

void f4(void)
{
	mutex_lock(b);
	mutex_lock(a);
	mutex_unlock(b);
	mutex_unlock(a);
}

void doit(void)
{
	f1();
	f2();
	stop_machine(f3);
	stop_machine(f4);
}

> It's very very clever and powerful.

I'm curious, does it also handle the above? I mean not a big deal to
refactor the code to shutdown lockdep warnings, but it doesn't look
that clever to me. It seems just clever the minimum enough to be
useful with its AB BA memory.

Now I see lockdep has a good point to exist, for the lock inversion
"memory" but this is by no mean a feature I can remotely like in
general given how inaccurate and prone for false positives it is. It
looks more a necessary evil to deal with, like I tried to do with my
patch (even before understanding it was more useful than what I
thought initially).

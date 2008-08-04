Return-Path: <linux-kernel-owner+w=401wt.eu-S1770881AbYHDVmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1770881AbYHDVmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1770874AbYHDVmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:42:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1770869AbYHDVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:42:19 -0400
Date: Mon, 4 Aug 2008 14:41:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, davej@redhat.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, davem@davemloft.net,
       jeremy@goop.org, hugh@veritas.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
 mm_take_all_locks
Message-Id: <20080804144114.e323a47f.akpm@linux-foundation.org>
In-Reply-To: <20080804213018.GD12464@duo.random>
References: <20080804162657.GI11476@duo.random>
	<1217867935.3589.35.camel@twins>
	<20080804172728.GJ11476@duo.random>
	<20080804174659.GK11476@duo.random>
	<20080804175730.GL11476@duo.random>
	<1217875739.3589.56.camel@twins>
	<20080804201514.GB12464@duo.random>
	<1217882242.3589.90.camel@twins>
	<20080804210954.GC12464@duo.random>
	<84144f020808041414x2c1c8b82n5939b82e9a2ca99d@mail.gmail.com>
	<20080804213018.GD12464@duo.random>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008 23:30:18 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> Now perhaps I misunderstood lockdep entirely

You did ;)

At runtime lockdep will "learn" the lock ordering rules, building a
graph in memory.  If it ever sees the thus-learnt rules violated, it
will warn.


Simple example:


static DEFINE_MUTEX(a);
static DEFINE_MUTEX(b);

void f1(void)
{
	mutex_lock(a);
	mutex_lock(b);
}

void f2(void)
{
	mutex_lock(b);
	mutex_lock(a);
}

void doit(void)
{
	f1();
	f2();
}



lockdep will warn here about the ranking violation.  As soon as it
occurs.  Even though the system never deadlocked.

It's very very clever and powerful.

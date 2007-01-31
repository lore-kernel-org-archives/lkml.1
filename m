Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbXAaGHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbXAaGHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 01:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbXAaGHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 01:07:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39880 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880AbXAaGHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 01:07:16 -0500
Date: Tue, 30 Jan 2007 22:06:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <45C02AFA.4080501@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0701302153520.3611@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <1170209044.26655.364.camel@localhost.localdomain>
 <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org>
 <45C02AFA.4080501@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Jan 2007, Nick Piggin wrote:
> 
> I always thought that the AIO people didn't do this because they wanted
> to avoid context switch overhead.

I don't think that scheduling overhead was ever a really the reason, at 
least not the primary one, and at least not on Linux. Sure, we can 
probably make cooperative thread switching a bit faster than even 
VM-sharing thread switching (maybe), but it's not going to be *that* big 
an issue.

Ifaik, the bigger issues were about setup costs (but also purely semantic 
- it was hard to do AIO semantics with threads).

And memory costs. The "one stack page per outstanding AIO" may end up 
still being too expensive, but threads were even more so.

[ Of course, that used to also be the claim by all the people who thought 
  we couldn't do native kernel threads for "normal" threading either, and 
  should go with the n*m setup. Shows how much they knew ;^]

But I've certainly _personally_ always wanted to do AIO with threads. I 
wanted to do it with regular threads (ie the "clone()" kind). It didn't 
fly. But I think we can possibly lower both the setup costs and the memory 
costs with the cooperative approach, to the point where maybe this one is 
more palatable and workable.

And maybe it also solves some of the scalability worries (threads have ID 
space and scheduling setup things that essentially go away by just not 
doing them - which is what the fibrils simply wouldn't have).

(Sadly, some of the people who really _use_ AIO are the database people, 
and they really only care about a particularly stupid and trivial case: 
pure reads and writes. A lot of other loads care about much more complex 
things: filename lookups etc, that traditional AIO cannot do at all, and 
that you really want something more thread-like for. But those other loads 
get kind of swamped by the DB needs, which are might tighter and trivial 
enough that you don't "need" a real thread for them).

		Linus

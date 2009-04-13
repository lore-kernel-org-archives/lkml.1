Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZDMVtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZDMVtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZDMVs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:48:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56295 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZDMVsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:48:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090413201348.GA16661@redhat.com>
References: <20090413201348.GA16661@redhat.com> <20090413201306.GA16653@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Serge Hallyn <serue@us.ibm.com>,
       Steve Dickson <steved@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_execute() needs mb() before test_bit(SLOW_WORK_PENDING)
Date: Mon, 13 Apr 2009 22:47:46 +0100
Message-ID: <32305.1239659266@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> clear_bit_unlock() implies release semantics, iow we have a one-way barrier
> before clear_bit().

That is correct.  The stuff before the clear_bit_unlock() must not leak out
past it.  SLOW_WORK_EXECUTING is a lock around the execution of the work item.

> But we need the mb() semantics after clear_bit(), before we test
> SLOW_WORK_PENDING. Otherwise we can miss SLOW_WORK_ENQ_DEFERRED if we race
> slow_work_enqueue().

But if you move the mb() to the other side, and reduce to clear_bit() you
break the above non-reentrancy guarantee.

> However, given that both clear_bit() and set_bit() use the same word,
> perhaps this is not possible.

I would assume clear_bit() and set_bit() on different bits of the same word
must interact as if they're on the same bit, with regard to atomiticity, but I
don't know for certain that it is guaranteed.

> But in that case I don't understand why do we need clear_bit_unlock(), not
> just clear_bit(), and how "mb is not needeed" could be derived from
> documentation.

As mentioned above, SLOW_WORK_EXECUTING is a lock against multiple entrance to
the execution function.

Perhaps I should amend the comments to make this clearer.

David

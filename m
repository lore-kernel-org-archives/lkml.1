Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYFCKWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYFCKWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYFCKW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:22:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbYFCKW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:22:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080530124554.GA14312@linux.vnet.ibm.com>
References: <20080530124554.GA14312@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Confused by smp_read_barrier_depends() in rxrpc_rotate_tx_window()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 03 Jun 2008 11:19:51 +0100
Message-ID: <27030.1212488391@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> I confess to being confused by the smp_read_barrier_depends() in
> rxrpc_rotate_tx_window().  It looks like it is ordering the prior
> fetch of tail from call->acks_tail with the subsequent use of

No.  call->acks_head vs [tail].

> tail as an index into the call->acks_window[] array, but then the
> code does an assignment to call->acks_tail a few lines later.
> 
> If we hold a lock protecting call->acks_tail, why do we need the
> smp_read_barrier_depends()?  If we don't hold such a lock, why
> is the assignment to call->acks_tail safe?

We don't hold a lock protecting call->acks_tail.  The head insertion and the
tail extraction are only protected by memory barriers.

	int tail = call->acks_tail, old_tail;
	int win = CIRC_CNT(call->acks_head, tail, call->acks_winsz);
	...
		smp_read_barrier_depends();
		_skb = call->acks_window[tail] & ~1;

In this bit of code, we must protect against seeing the item at '[tail]' set
after 'call->acks_head' itself is updated, hence why we need a barrier here.
Possibly it should be smp_rmb() rather than smp_read_barrier_depends().

		_skb = call->acks_window[tail] & ~1;
		...
		old_tail = tail;
		tail = (tail + 1) & (call->acks_winsz - 1);
		call->acks_tail = tail;

I believe this does not require a barrier between reading '[tail]' and updating
'tail' because there's no way we can update tail without first reading
'[tail]'.

David

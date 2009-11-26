Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZKZVxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZKZVxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZKZVxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:53:14 -0500
Received: from ozlabs.org ([203.10.76.45]:57131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZKZVxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:53:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19214.63688.860929.962005@cargo.ozlabs.ibm.com>
Date: Fri, 27 Nov 2009 08:53:12 +1100
From: Paul Mackerras <paulus@samba.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
In-Reply-To: <20091126202312.GA21945@redhat.com>
References: <20091124200127.GA5751@redhat.com>
	<20091125080342.GD2660@in.ibm.com>
	<20091125154052.GA6734@redhat.com>
	<20091126075335.GA18508@in.ibm.com>
	<20091126145051.GB4382@redhat.com>
	<20091126172524.GA14768@redhat.com>
	<20091126182226.GF12355@darkmag.usersys.redhat.com>
	<20091126202312.GA21945@redhat.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov writes:

> 	0xfeacd24
> 	0xfeacd28
> 	0xfeacd2c
> 	0xfeacd30
> 	0xfeacd34
> 	...
> 
> and so on forever,
...
> beg->	0x0feacd24 <__GI__IO_list_lock+68>:	lwarx   r0,0,r31
> 	0x0feacd28 <__GI__IO_list_lock+72>:	cmpw    r0,r11
> 	0x0feacd2c <__GI__IO_list_lock+76>:	bne-    0xfeacd38 <__GI__IO_list_lock+88>
> 	0x0feacd30 <__GI__IO_list_lock+80>:	stwcx.  r9,0,r31
> end->	0x0feacd34 <__GI__IO_list_lock+84>:	bne+    0xfeacd24 <__GI__IO_list_lock+68>
> 
> I don't even know whether this is user-space bug or kernel bug,
> the asm above is the black magic for me.

The lwarx and stwcx. work together to do an atomic update to the word
whose address is in r31.  They are like LL (load-linked) and SC
(store-conditional) on other architectures such as alpha.  Basically
the lwarx creates an internal "reservation" on the word pointed to by
r31 and loads its value into r0.  The stwcx. stores into that word but
only if the reservation still exists.  The reservation gets cleared
(in hardware) if any other cpu writes to that word in the meantime.
If the reservation did get cleared, the bne (branch if not equal)
instruction will be taken and we loop around to try again.

There is a difficulty when single-stepping through such a sequence
because the process of taking the single-step exception and returning
will clear the reservation.  Thus if you single-step through that
sequence it will never succeed.  I believe gdb has code to recognize
this kind of sequence and run through it without stopping until after
the bne, precisely to avoid this problem.

Paul.

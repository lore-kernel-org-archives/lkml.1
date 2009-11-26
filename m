Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZKZWmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZKZWmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 17:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZKZWmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 17:42:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZKZWmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 17:42:53 -0500
Date: Thu, 26 Nov 2009 23:37:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Mackerras <paulus@samba.org>
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
Message-ID: <20091126223703.GA28556@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com> <20091126172524.GA14768@redhat.com> <20091126182226.GF12355@darkmag.usersys.redhat.com> <20091126202312.GA21945@redhat.com> <19214.63688.860929.962005@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19214.63688.860929.962005@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Paul Mackerras wrote:
>
> Oleg Nesterov writes:
>
> > 	0xfeacd24
> > 	0xfeacd28
> > 	0xfeacd2c
> > 	0xfeacd30
> > 	0xfeacd34
> > 	...
> >
> > and so on forever,
> ...
> > beg->	0x0feacd24 <__GI__IO_list_lock+68>:	lwarx   r0,0,r31
> > 	0x0feacd28 <__GI__IO_list_lock+72>:	cmpw    r0,r11
> > 	0x0feacd2c <__GI__IO_list_lock+76>:	bne-    0xfeacd38 <__GI__IO_list_lock+88>
> > 	0x0feacd30 <__GI__IO_list_lock+80>:	stwcx.  r9,0,r31
> > end->	0x0feacd34 <__GI__IO_list_lock+84>:	bne+    0xfeacd24 <__GI__IO_list_lock+68>
> >
> > I don't even know whether this is user-space bug or kernel bug,
> > the asm above is the black magic for me.
>
> The lwarx and stwcx. work together to do an atomic update to the word
> whose address is in r31.  They are like LL (load-linked) and SC
> (store-conditional) on other architectures such as alpha.  Basically
> the lwarx creates an internal "reservation" on the word pointed to by
> r31 and loads its value into r0.  The stwcx. stores into that word but
> only if the reservation still exists.  The reservation gets cleared
> (in hardware) if any other cpu writes to that word in the meantime.
> If the reservation did get cleared, the bne (branch if not equal)
> instruction will be taken and we loop around to try again.
>
> There is a difficulty when single-stepping through such a sequence
> because the process of taking the single-step exception and returning
> will clear the reservation.  Thus if you single-step through that
> sequence it will never succeed.  I believe gdb has code to recognize
> this kind of sequence and run through it without stopping until after
> the bne, precisely to avoid this problem.

Thanks! This explains everything, I think.

Could you look at this

	ptrace-copy_process-should-disable-stepping.patch
	http://marc.info/?l=linux-mm-commits&m=125789789322573

patch? It is not clear to me how we can modify the test-case to
verify it fixes the original problem for powerpc.

At least, do you think this patch is good for powerpc ?

Oleg.


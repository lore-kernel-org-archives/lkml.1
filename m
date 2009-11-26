Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbZKZVKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbZKZVKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbZKZVKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:10:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbZKZVKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:10:30 -0500
Date: Thu, 26 Nov 2009 22:04:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: powerpc: fork && stepping (Was: [RFC,PATCH 0/14] utrace/ptrace)
Message-ID: <20091126210458.GA24597@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com> <20091126172524.GA14768@redhat.com> <20091126182226.GF12355@darkmag.usersys.redhat.com> <20091126202312.GA21945@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126202312.GA21945@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Oleg Nesterov wrote:
>
> Then it loops inside __GI__IO_list_lock
>
> 	0xfeacd24
> 	0xfeacd28
> 	0xfeacd2c
> 	0xfeacd30
> 	0xfeacd34
> 	...
>
> and so on forever,
>
> 	Dump of assembler code for function __GI__IO_list_lock:
> 	0x0feacce0 <__GI__IO_list_lock+0>:	mflr    r0
> 	0x0feacce4 <__GI__IO_list_lock+4>:	stwu    r1,-32(r1)
> 	0x0feacce8 <__GI__IO_list_lock+8>:	li      r11,0
> 	0x0feaccec <__GI__IO_list_lock+12>:	bcl-    20,4*cr7+so,0xfeaccf0 <__GI__IO_list_lock+16>
> 	0x0feaccf0 <__GI__IO_list_lock+16>:	li      r9,1
> 	0x0feaccf4 <__GI__IO_list_lock+20>:	stw     r0,36(r1)
> 	0x0feaccf8 <__GI__IO_list_lock+24>:	stw     r30,24(r1)
> 	0x0feaccfc <__GI__IO_list_lock+28>:	mflr    r30
> 	0x0feacd00 <__GI__IO_list_lock+32>:	stw     r31,28(r1)
> 	0x0feacd04 <__GI__IO_list_lock+36>:	stw     r29,20(r1)
> 	0x0feacd08 <__GI__IO_list_lock+40>:	addi    r29,r2,-29824
> 	0x0feacd0c <__GI__IO_list_lock+44>:	addis   r30,r30,16
> 	0x0feacd10 <__GI__IO_list_lock+48>:	addi    r30,r30,13060
> 	0x0feacd14 <__GI__IO_list_lock+52>:	lwz     r31,-6436(r30)
> 	0x0feacd18 <__GI__IO_list_lock+56>:	lwz     r0,8(r31)
> 	0x0feacd1c <__GI__IO_list_lock+60>:	cmpw    cr7,r0,r29
> 	0x0feacd20 <__GI__IO_list_lock+64>:	beq-    cr7,0xfeacd4c <__GI__IO_list_lock+108>
>
> beg->	0x0feacd24 <__GI__IO_list_lock+68>:	lwarx   r0,0,r31
> 	0x0feacd28 <__GI__IO_list_lock+72>:	cmpw    r0,r11
> 	0x0feacd2c <__GI__IO_list_lock+76>:	bne-    0xfeacd38 <__GI__IO_list_lock+88>
> 	0x0feacd30 <__GI__IO_list_lock+80>:	stwcx.  r9,0,r31
> end->	0x0feacd34 <__GI__IO_list_lock+84>:	bne+    0xfeacd24 <__GI__IO_list_lock+68>
>
> I don't even know whether this is user-space bug or kernel bug,
> the asm above is the black magic for me.

When I use gdb to step over __GI__IO_list_lock(), it doesn't loop.
I straced gdb and noticed that when the trace reaches

	0x0feacd24:	lwarx   r0,0,r31

gdb does PTRACE_CONT, not PTRACE_SINGLESTEP. After that the child
stops at 0x0feacd38, the next insn (isync).

> Anyone who knows something about powerpc can give me a hint?

Please ;)

Oleg.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZKZU3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZKZU3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 15:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZKZU3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 15:29:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZKZU3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 15:29:00 -0500
Date: Thu, 26 Nov 2009 21:23:12 +0100
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
Message-ID: <20091126202312.GA21945@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com> <20091125154052.GA6734@redhat.com> <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com> <20091126172524.GA14768@redhat.com> <20091126182226.GF12355@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126182226.GF12355@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Veaceslav doesn't have the time to continue, but he gave me
access to rhts machine ;)

The kernel is 2.6.31.6 btw.

On 11/26, Veaceslav Falico wrote:
>
> > Just noticed the test-case fails in handler_fail(). Most probably
> > this means it is killed by SIGALRM because either parent or child
> > hang in wait(). Perhaps we have another (ppc specific?) bug, but
> > currently I do not understand how this is possible, this should
> > not be arch-dependent.
>
> I can confirm that we have another bug on ppc arch. The test case below
> is spinning forever,
>
> [...]
>
> it doesn't hang, the parent is spinning around for, the test case
> isn't printing anything. Seems like fork() can't complete under
> PTRACE_SINGLESTEP.

Yep, thanks a lot Veaceslav.

I modified this test-case to print si_addr:

	int main(void)
	{
		int pid, status;

		if (!(pid = fork())) {
			assert(ptrace(PTRACE_TRACEME) == 0);
			kill(getpid(), SIGSTOP);

			if (!fork())
				return 0;

			printf("fork passed..\n");

			return 0;
		}

		for (;;) {
			siginfo_t info;

			assert(pid == wait(&status));
			assert(status = 0x57f);

			assert(ptrace(PTRACE_GETSIGINFO, pid, 0,&info) == 0);
			printf("%p\n", info.si_addr);

			if (WIFEXITED(status))
				break;
			assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);
		}

		printf("Parent exit.\n");

		return 0;
	}

the output is:

	...
	0xfedf880
	0xfedf884
	...
	0xfedf96c
	0xfedf970

this is fork which calls __GI__IO_list_lock

	Dump of assembler code for function fork:
	0x0fedf880 <fork+0>:	mflr    r0
	...
	0x0fedf96c <fork+236>:	li      r28,0
	0x0fedf970 <fork+240>:	bl      0xfeacce0 <__GI__IO_list_lock>

Then it loops inside __GI__IO_list_lock

	...
	0xfeacd24
	0xfeacd28
	0xfeacd2c
	0xfeacd30
	0xfeacd34

	0xfeacd24
	0xfeacd28
	0xfeacd2c
	0xfeacd30
	0xfeacd34

	0xfeacd24
	0xfeacd28
	0xfeacd2c
	0xfeacd30
	0xfeacd34
	...

and so on forever,

	Dump of assembler code for function __GI__IO_list_lock:
	0x0feacce0 <__GI__IO_list_lock+0>:	mflr    r0
	0x0feacce4 <__GI__IO_list_lock+4>:	stwu    r1,-32(r1)
	0x0feacce8 <__GI__IO_list_lock+8>:	li      r11,0
	0x0feaccec <__GI__IO_list_lock+12>:	bcl-    20,4*cr7+so,0xfeaccf0 <__GI__IO_list_lock+16>
	0x0feaccf0 <__GI__IO_list_lock+16>:	li      r9,1
	0x0feaccf4 <__GI__IO_list_lock+20>:	stw     r0,36(r1)
	0x0feaccf8 <__GI__IO_list_lock+24>:	stw     r30,24(r1)
	0x0feaccfc <__GI__IO_list_lock+28>:	mflr    r30
	0x0feacd00 <__GI__IO_list_lock+32>:	stw     r31,28(r1)
	0x0feacd04 <__GI__IO_list_lock+36>:	stw     r29,20(r1)
	0x0feacd08 <__GI__IO_list_lock+40>:	addi    r29,r2,-29824
	0x0feacd0c <__GI__IO_list_lock+44>:	addis   r30,r30,16
	0x0feacd10 <__GI__IO_list_lock+48>:	addi    r30,r30,13060
	0x0feacd14 <__GI__IO_list_lock+52>:	lwz     r31,-6436(r30)
	0x0feacd18 <__GI__IO_list_lock+56>:	lwz     r0,8(r31)
	0x0feacd1c <__GI__IO_list_lock+60>:	cmpw    cr7,r0,r29
	0x0feacd20 <__GI__IO_list_lock+64>:	beq-    cr7,0xfeacd4c <__GI__IO_list_lock+108>

beg->	0x0feacd24 <__GI__IO_list_lock+68>:	lwarx   r0,0,r31
	0x0feacd28 <__GI__IO_list_lock+72>:	cmpw    r0,r11
	0x0feacd2c <__GI__IO_list_lock+76>:	bne-    0xfeacd38 <__GI__IO_list_lock+88>
	0x0feacd30 <__GI__IO_list_lock+80>:	stwcx.  r9,0,r31
end->	0x0feacd34 <__GI__IO_list_lock+84>:	bne+    0xfeacd24 <__GI__IO_list_lock+68>

I don't even know whether this is user-space bug or kernel bug,
the asm above is the black magic for me.

Anyone who knows something about powerpc can give me a hint?

Oleg.


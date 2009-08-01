Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZHAA3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZHAA3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 20:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZHAA3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 20:29:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbZHAA3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 20:29:53 -0400
Date: Fri, 31 Jul 2009 17:28:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] information leak in sigaltstack
In-Reply-To: <4A73641C.7070404@redhat.com>
Message-ID: <alpine.LFD.2.01.0907311716220.3304@localhost.localdomain>
References: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.01.0907311407040.24841@localhost.localdomain> <alpine.LFD.2.01.0907311428370.3304@localhost.localdomain> <4A73641C.7070404@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Cc'ing jakub, since that code generation looks crappy, and I think he 
  has worked on gcc memset(). I wonder if it's because we use -Os, and gcc 
  tries to avoid one REX prefix on the 'stosq'.

  I also wonder why gcc doesn't just notice that it should really only 
  initialize a single 4-byte word (no rep, no prefix, no nothing, just a 
  single "movl $0,44(%ebp)") - so even with the -Os, that is just wrong, 
  and it would have been better to do as multiple stores and then noticing 
  that most of them end up dead ]

On Fri, 31 Jul 2009, Ulrich Drepper wrote:
> 
> I was just composing a reply with basically this.  So  you'll apply this
> and don't wait for me to send a new version of the patch, right?

Grr. Gcc creates truly crap code for this trivial 24-byte memset. Why does 
it do that?

gcc knows the alignment is 8 bytes, but it still uses 6 4-byte stores 
instead of 3 8-byte ones. And it does it with this:

        xorl    %eax, %eax      # tmp88
        leaq    -48(%rbp), %rsi #, tmp86
        movl    $6, %ecx        #, tmp89
        movq    %rsi, %rdi      # tmp86, tmp87
        rep stosl

which is just incredibly lame in so many ways.

And it doesn't optimize anything away, even though the next lines will 
then re-initialize 20 of the 24 bytes.

Now, maybe this isn't performance-critical, but it just makes me feel that 
there has to be a better way to make gcc DTRT. 

Here's the patch I used, just for posterity. I can't decide if I really 
want to commit this crap. But at least on 32-bit architectures the 
"alignof" testing should remove the horrid code. I do wonder why gcc 
thinks that 32-bit writes are a good idea in this case, though.

		Linus

---
 kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ccf1cee..b990dc8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2455,6 +2455,9 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 	int error;
 
 	if (uoss) {
+		/* Fill cracks around 'ss_flags' */
+		if (__alignof__(oss.ss_flags) != __alignof__(oss))
+			memset(&oss, 0, sizeof(oss));
 		oss.ss_sp = (void __user *) current->sas_ss_sp;
 		oss.ss_size = current->sas_ss_size;
 		oss.ss_flags = sas_ss_flags(sp);

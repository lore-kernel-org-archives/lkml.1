Return-Path: <linux-kernel-owner+w=401wt.eu-S1764216AbXGFVKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764216AbXGFVKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760067AbXGFVKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:10:08 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:51653 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbXGFVKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:10:06 -0400
Date: Fri, 6 Jul 2007 17:09:58 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Kegel <dank@kegel.com>, linux-kernel@vger.kernel.org,
       Robert Walsh <rjwalsh@durables.org>
Subject: Re: Valgrinding the kernel?
Message-ID: <20070706210958.GA13291@c2.user-mode-linux.org>
References: <a71bd89a0707052114u28fed408h4326913c502a43ac@mail.gmail.com> <468DD6A5.4020705@goop.org> <20070706172513.GD10670@c2.user-mode-linux.org> <a71bd89a0707061030s15572cj49cb748bf274593b@mail.gmail.com> <20070706194252.GA12311@c2.user-mode-linux.org> <468E9D3F.4030406@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468E9D3F.4030406@goop.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 12:51:27PM -0700, Jeremy Fitzhardinge wrote:
> The virtual CPU code has been competely rewritten since then.  If its a 
> non-gcc generated instruction, its possible the new code 
> parser/generator hasn't been taught to deal with it.

It's not from gcc - it's from the i386 bitops.h:

static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
{
	int d0, d1, d2;
	int res;

	if (!size)
		return 0;
	/* This looks at memory. Mark it volatile to tell gcc not to move it around */
	__asm__ __volatile__(
		"movl $-1,%%eax\n\t"
		"xorl %%edx,%%edx\n\t"
		"repe; scasl\n\t"
		"je 1f\n\t"
		"xorl -4(%%edi),%%eax\n\t"
		"subl $4,%%edi\n\t"
		"bsfl %%eax,%%edx\n"
		"1:\tsubl %%ebx,%%edi\n\t"
		"shll $3,%%edi\n\t"
		"addl %%edi,%%edx"
		:"=d" (res), "=&c" (d0), "=&D" (d1), "=&a" (d2)
		:"1" ((size + 31) >> 5), "2" (addr), "b" (addr) : "memory");
	return res;
}

				Jeff

-- 
Work email - jdike at linux dot intel dot com

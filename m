Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbXJVPpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbXJVPpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXJVPpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:45:21 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:40051 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbXJVPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:45:19 -0400
Date: Mon, 22 Oct 2007 11:40:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20071022154006.GA32642@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20071020164721.GA6614@Krystal> <471A49AA.6090407@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <471A49AA.6090407@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:29:33 up 84 days, 15:48,  4 users,  load average: 0.84, 0.58, 0.73
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
> >
> >I have tried generating asm-to-"register" c variables for char, short
> >and int on i386 and I do not see this happening. The char opcode is
> >always 1 byte, short 2 bytes and int 1 byte. Result:
> >
> 
> The comment was referring to x86-64, but I incorrectly remembered that 
> applying to "movq $imm,%reg" as opposed to loading from an absolute 
> address.  gas actually has a special opcode (movabs) for the 64-bit 
> version of the latter variant, which is only available with %rax and its 
> subregisters.
> 
> Nevermind, in other words.  It's still true, though, that the immediate 
> will always be the last thing in the instruction -- that's a fixture of 
> the instruction format.
> 

Hrm, some basic testing shows me that, on x86_64:

        register long var, var2, var3, var4, var5;
        asm ("movq $0xFFFFFFFF,%0;\n\t" : "=r" (var) :);
        asm ("movq $0x100000000,%0;\n\t" : "=r" (var2) :);
        asm ("movq $0,%0;\n\t" : "=r" (var3) :);
        asm ("movq $0xFFFFFFFFFFFFFFFF,%0;\n\t" : "=r" (var4) :);
        asm ("movq $0xFEFEFEFE01010101,%0;\n\t" : "=r" (var5) :);

generates:

  ae:   48 be ff ff ff ff 00    mov    $0xffffffff,%rsi
  b5:   00 00 00 
  b8:   48 bf 00 00 00 00 01    mov    $0x100000000,%rdi
  bf:   00 00 00 
  c2:   48 c7 c1 00 00 00 00    mov    $0x0,%rcx
  c9:   48 c7 c2 ff ff ff ff    mov    $0xffffffffffffffff,%rdx
  d0:   48 b8 01 01 01 01 fe    mov    $0xfefefefe01010101,%rax
  d7:   fe fe fe 

So we have to deal with the fact that gas produces opcodes of
different size (2 and 3 bytes) and with different immediate value sizes
for 8 bytes load immediates, depending on the immediate value to load.
There even seems to be an implicit duplication of the value when the
lower and higher 32 bits of the immediate value are the same (the
0xFFFFFFFFFFFFFFFF case).

Therefore, I propose the following. We should use the

asm ("movq $0xFEFEFEFE01010101,%0;\n\t" : "=r" (var5) :);

to make sure we always deal with the same instruction and have a 8 bytes
immediate value. We don't really care about the static value given
because we always update it dynamically before the first time it is
executed.

> >gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)
> >
> >   8:   b3 02                   mov    $0x2,%bl
> >   a:   b1 03                   mov    $0x3,%cl
> >   c:   b2 04                   mov    $0x4,%dl
> >   e:   b0 05                   mov    $0x5,%al
> >
> >  4f:   66 be 06 00             mov    $0x6,%si
> >  53:   66 bb 07 00             mov    $0x7,%bx
> >  57:   66 b9 08 00             mov    $0x8,%cx
> >  5b:   66 ba 09 00             mov    $0x9,%dx
> >  5f:   66 b8 0a 00             mov    $0xa,%ax
> >
> >  9f:   bb 0b 00 00 00          mov    $0xb,%ebx
> >  a4:   be 0c 00 00 00          mov    $0xc,%esi
> >  a9:   b9 0d 00 00 00          mov    $0xd,%ecx
> >  ae:   ba 0e 00 00 00          mov    $0xe,%edx
> >  b3:   b8 0f 00 00 00          mov    $0xf,%eax
> >
> >
> >I notice that having a "=r" inline assembly that outputs to the first
> >"register char" variable seems to be problematic. It fails with the
> >following error:
> >
> >/tmp/ccy35Hq1.s: Assembler messages:
> >/tmp/ccy35Hq1.s:15: Error: bad register name `%sil'
> 
> 'r' is wrong for 8-bit variables on i386.  It needs to be 'q'.
> 

Will fix. I noticed that it was because I had too much "register" char
variables declared and used at the same time. Putting a "g" constraint
gave the same result.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

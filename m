Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbXJTQrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbXJTQrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 12:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbXJTQrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 12:47:24 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:62740 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025AbXJTQrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:47:24 -0400
Date: Sat, 20 Oct 2007 12:47:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20071020164721.GA6614@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46F050E8.5020206@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:30:33 up 82 days, 16:49,  1 user,  load average: 0.00, 0.11, 0.40
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> H. Peter Anvin wrote:
> > Allowing different registers should be doable, but if so, one would have
> > to put 0: at the *end* of the instruction and use (0f)-4 instead, since
> > the non-%eax forms are one byte longer.
> >   
> 
> OK, that's already a problem since its using "=r" as the constraint.
> 

Hi Jeremy,

I have tried generating asm-to-"register" c variables for char, short
and int on i386 and I do not see this happening. The char opcode is
always 1 byte, short 2 bytes and int 1 byte. Result:

gcc version 4.1.3 20070812 (prerelease) (Debian 4.1.2-15)

   8:   b3 02                   mov    $0x2,%bl
   a:   b1 03                   mov    $0x3,%cl
   c:   b2 04                   mov    $0x4,%dl
   e:   b0 05                   mov    $0x5,%al

  4f:   66 be 06 00             mov    $0x6,%si
  53:   66 bb 07 00             mov    $0x7,%bx
  57:   66 b9 08 00             mov    $0x8,%cx
  5b:   66 ba 09 00             mov    $0x9,%dx
  5f:   66 b8 0a 00             mov    $0xa,%ax

  9f:   bb 0b 00 00 00          mov    $0xb,%ebx
  a4:   be 0c 00 00 00          mov    $0xc,%esi
  a9:   b9 0d 00 00 00          mov    $0xd,%ecx
  ae:   ba 0e 00 00 00          mov    $0xe,%edx
  b3:   b8 0f 00 00 00          mov    $0xf,%eax


I notice that having a "=r" inline assembly that outputs to the first
"register char" variable seems to be problematic. It fails with the
following error:

/tmp/ccy35Hq1.s: Assembler messages:
/tmp/ccy35Hq1.s:15: Error: bad register name `%sil'

But it seems to be specific to "register" variables, which I do not use
in my immediate values.


> > This also seems "safer", since an imm32 is always the last thing in the
> > instruction.
> 
> Good idea.  If gas/gcc generates entirely the wrong addressing mode,
> then we've got bigger problems.
> 

I am still trying to figure out if we must assume that gas will produce
different length opcodes for mov instructions. The choice is:

- Either I use a "r" constraint and let gcc produce the instructions,
  that I need to assume to have correct size so I can align their
  immediate values (therefore, taking the offset from the end of the
  instruction will not help). Here, if gas changes its behavior
  dramatically for a given immediate value size, it will break.

- Second choice is to stick to a particular register, choosing the one
  with the less side-effect, and encoding the instruction ourselves. I
  start to think that this second solution might be safer, even though
  we wouldn't let the compiler select the register which has the less
  impact by itself.

Any comments about this ?

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

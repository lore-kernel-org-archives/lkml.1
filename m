Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbXISNBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbXISNBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXISNB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:01:27 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:57829 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511AbXISNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:01:26 -0400
Date: Wed, 19 Sep 2007 09:01:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070919130122.GA21750@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46F050E8.5020206@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:26:57 up 51 days, 12:45,  5 users,  load average: 0.65, 0.35, 0.38
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
> > This also seems "safer", since an imm32 is always the last thing in the
> > instruction.
> 
> Good idea.  If gas/gcc generates entirely the wrong addressing mode,
> then we've got bigger problems.
> 

Ok, let's have a good look at what we want:

1 - get a pointer to the beginning of the immediate value within the
    instruction.
2 - make sure that the immediate value, within the instruction, is
    written to atomically wrt all CPUs, even on older architectures
    where non aligned writes are not atomic.

Effectively, placing a label at the end of the instruction, and then
offsetting backward from there, will give us (1).

Then, for the alignment, we have to give a good look at the instruction
set reference, mov instruction, to see what the variants of mov
immediate value to register are on i386.

First, let's look at the possible prefixes:
- Lock and repeat prefixes : no
- Segment override prefixes: no memory reference there, so doesn't
  apply.
- Branch hints : no, it's a mov instruction
- Operand-size override prefix: *yes*, can be used for 2 bytes mov
- Address-size override prefix: no address in there, only immediate
  value and register.

(looking at the Compat/Leg Mode)

3 cases:

* 1 byte
B0 + rb         MOV r8, imm8     (1 byte opcode)
REX + B0 + rb   MOV r8, imm8     (only on 64 bits archs, never generated)
C6 /0           MOV r/m8, imm8   (2 bytes opcode)
(this one doesn't require alignment at all, since we do a 1 byte write)

* 2 bytes
B8 + rw         MOV r16, imm16   (1 byte opcode)
66 B8 + rd      MOV r16, imm16   (2 bytes opcode) (with 66H prefix)
C7 /0           MOV r/m16, imm16 (2 bytes opcode)
(Alignment on 4 bytes boundaries would be required because of the
possible 1 byte opcode ? Or is the 66H prefix mandatory there ? If it
is, then we can safely align on 2 bytes boundaries.)

* 4 bytes
B8 + rd         MOV r32, imm32   (1 byte opcode)
C7 /0           MOV r/m32, imm32 (2 bytes opcode)
(the 2 bytes opcode can be a problem)

I have missed anything ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

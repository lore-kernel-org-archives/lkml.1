Return-Path: <linux-kernel-owner+w=401wt.eu-S935114AbYD1OtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114AbYD1OtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933696AbYD1OtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:49:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933541AbYD1OtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:49:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1209219236.3113.6.camel@localhost.localdomain>
References: <1209219236.3113.6.camel@localhost.localdomain> <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-2-git-send-email-jens.axboe@oracle.com> <20080425231100.b93a1601.akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 28 Apr 2008 15:25:27 +0100
Message-ID: <18470.1209392727@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Erm, that's a bug in the frv toolchain, isn't it?  The linker should
> *never* rely on C code annotation for jump lengths ... mainly because
> you can screw it all up again in the linker script, so the sectional
> annotations should only be in the function body (think
> -ffunction-sections)

The problem with FRV has to do with global variables, not functions.

With FRV, we attempt to pack as many small variables into the "small data
section" (.sdata) as we can, and then retain a pointer to it in a register.
Thus for small variables, we can use a single instruction, such as:

	LDI	@(GR16,%gprel(my_variable)),GRx

to access it.  However, this limits the offset of my_variable to be +/-2048
from GR16 because all the instructions are the same size, and that's the size
of the offset field therein.

Alternatively, we can use:

	SETHI.P	%hi(my_variable),GRy
	SETLO	%lo(my_variable),GRy
	LD	@(GRy,GR0),GRx

which obviously takes two more instructions, although they can be executed
simultaneously, and 8 more bytes of RAM/icache.

However, the compiler will assume that it should access _all_ global variables
using GPREL-addressing unless it is told otherwise.  This means that if a
global variable should not be GPREL-addressed, its *declaration* should be
annotated, as this affects how it is addressed.  Furthermore, if the variable
is *defined* in C, that definition should be annotated the same as the
declaration, otherwise it'll eat storage from .sdata rather than the
appropriate section.


Global functions are another matter.  The FRV's PC+offset call and branch
instructions have 24-bit displacements, which is fine for leaping about within
the kernel core with a single instruction.

In modules, we instead (a) suppress GPREL addressing entirely because we can't
put module variables in .sdata, and (b) make all interfunction jumps that the
assembler can't resolve into:

	SETHI.P	%hi(that_function),GRy
	SETLO	%lo(that_function),GRy
	JMPL	@(GRy,GR0)

because a 24-bit offset can only span 16MB, which isn't far enough.


We could use a GOT, but I believe that would add an extra memory access to any
memory access or jump - which I'd prefer to avoid.

David

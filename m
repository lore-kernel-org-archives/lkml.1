Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbXKESNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbXKESNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXKESNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:13:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbXKESNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:13:36 -0500
Date: Mon, 5 Nov 2007 10:12:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
In-Reply-To: <472F5941.2060507@zytor.com>
Message-ID: <alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>
 <alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>
 <472F5941.2060507@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, H. Peter Anvin wrote:
> 
> Well, we *could* do a 16-bit PM segment (and do two far jumps), but that seems
> rather silly.  We'd have to patch the GDT for the base in that case, anyway.

Yeah, there is no point in having two far jumps. One is enough.

The point being that since apparently the new boot standards say that the 
32-bit code is entered with segments etc set to specific values, then we 
shouldn't do the jump to that 32-bit standard with a far jump: we should 
do it as a regular jump, because we'd want to to set up the segments etc 
in 32-bit mode anyway.

> This is more or less the same code I had for the first version of the patch,
> modulo moving the short jump of course.  I do like making the 32-bit code a
> separate function, but it really should be "movl %ecx,..." in the 32-bit code.

At least my assembler does the right thing with just the plain "mov" for 
segments, but yes, there may be old assemblers that add a useless data 
size override. So "movl %ecx,%*s" is probably the right thing to do to 
make sure they don't do anything stupid..

Btw, on that same kind of thread: I think we should move the clearing of 
the registers into the 32-bit mode too, since that makes the instructions 
shorter (no operand size override), and makes more sense anyway (then we 
can also clean %edx/%ecx.

Final comment: shouldn't we set up %esp to be correct for the new %ss too?

			Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbXKEAA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbXKEAA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXKEAAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:00:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbXKEAAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:00:18 -0500
Date: Sun, 4 Nov 2007 15:59:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
In-Reply-To: <472E551E.2010507@zytor.com>
Message-ID: <alpine.LFD.0.999.0711041546510.15101@woody.linux-foundation.org>
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org>
 <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
 <472E551E.2010507@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Nov 2007, H. Peter Anvin wrote:
> 
> It's not an instruction-decoding issue at all (that's a 16- vs 32-bit issue,
> which can only be changed by a ljmp).  Apparently the 486DX4 mis-executes the
> load to segment register, which is an EU function in that context.  (And yes,
> it's sort-of-documented behaviour in the sense that the documentation says "do
> things this way", but the Intel docs are unfortunately full of "do things this
> way" which don't make sense and occasionally are actively harmful, too.)

I still disagree.

I took out "Programming the 80386" just to check, and the documentation 
very clearly states that when changing the CR0 bits (I quote):

	"The program must execute a jump instruction immediately after 
	 changing the value of the PE bit in order to flush the execution 
	 pipeline of any instructions that may have been fetched in the 
	 wrong mode. [...]"

In other words, not only is this documented since day 1, it makes total 
sense, and they even said exactöy *why* that jump had to be done.

In fact, there's even a code example. It's page 624 in my copy of the 
book, and yes, it has a short jump to flush things, followed by a long 
jump. The code there looks like this:

	; *****
	; ** [4] Enter Protected Mode
	; *****
		SMSW AX
		OR   AX, PE
		LMSW AX
		JMP  Flush
	Flush:
		JMP far ptr Start32


which is pretty damn conclusive. It's documented, it has examples, it 
works. In other words, it's how you should do things.

And Linux always did it correctly. I don't understand why you disagree, 
and why Jeremy says

	"Having successfully broken the rules for a long time so far, 
	 maybe we can get away with still cutting corners..."

when the fact is, we used to *not* cut corners, we used to *not* break the 
rules, and what we used to do (a short jump immediately after setting PE) 
was exactly what Intel always said you should do, and there is no question 
what-so-ever about it.

So here's a suggestion:

 - make the code do what it used to do. A regular jump to flush the 
   pipeline. Which is what Intel has always said should be done.

and I really don't see that there is any argument about this. 

			Linus

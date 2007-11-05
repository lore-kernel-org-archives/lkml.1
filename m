Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXKEBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXKEBLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 20:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXKEBLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 20:11:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139AbXKEBLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 20:11:10 -0500
Date: Sun, 4 Nov 2007 17:10:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
In-Reply-To: <m1ve8ha5e5.fsf@ebiederm.dsl.xmission.com>
Message-ID: <alpine.LFD.0.999.0711041649030.15101@woody.linux-foundation.org>
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org>
 <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
 <472E551E.2010507@zytor.com> <alpine.LFD.0.999.0711041546510.15101@woody.linux-foundation.org>
 <472E5DAB.8080804@zytor.com> <m1ve8ha5e5.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Nov 2007, Eric W. Biederman wrote:
> 
> I do seem to recall etherboot having a far jump in that spot and it
> working on everything from a 386 on up.  So I'm not certain if the
> kind of jump matters.  Still the kernel has a lot more exposure.

I actually suspect you could have just about anything in there, including 
just a couple of nops, or just avoiding certain instructions for a few 
cycles.

The i386/i486 pipeline isn't actually all that long (I ca't find it here, 
but I want to say it was just five stages), and the whole/only issue with 
writing to cr0 on those CPU's is literally that there isn't any forwarding 
of the cr0 state, so any instruction that actually has depend on the cr0 
value needs to have that value stable in the register by the time it 
executes.

So I literally suspect that just a couple of no-ops in between the move to 
cr0 and any instruction that depends on the state of the PE bit would be 
ok. And there aren't that many instructions that do, it's generally just 
the ones that load a segment that can care.

But I'd actually be worried about a ljmp directly after the "move to 
cr0", exactly because an ljump actually does have semantic dependencies on 
the PE bit. But it's quite likely that ljmp is microcoded (it takes 12+ 
cycles even in real mode), and since microcode was nonpipelined, that 
would hide it.

But "move to segment" is definitely *not* microcoded in real mode (it's 
documented as just two cycles for reg->seg), so I'm not at all surprised 
that "mov->cr0" followed immediately by "mov->seg" will not work.

In short:

 - far jumps are in the "dangerous instruction" category after a change to 
   PE. I would suggest not using it, although I also suspect that it 
   probably works if only because it's probably microcoded on at least an 
   i386.

 - instead of a short taken jump, you can almost certainly use anything 
   that is microcoded or just otherwise takes enough cycles (where 
   "enough" is likely in the 5-10 range) to make sure the writeback to CR0 
   is stable by the time any instruction uses it.

 - almost anything that doesn't actually involve a segment descriptor 
   lookup is probably not going to care at all about the value of PE. The 
   PE bit really doesn't affect all that much of the x86 instruction set, 
   and if an instruction doesn't care, it doesn't matter whether it's 
   executed with the old or the new value.


		Linus

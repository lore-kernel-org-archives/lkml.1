Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZKDCmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZKDCmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZKDCmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:42:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZKDCmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:42:53 -0500
Subject: Re: Ftrace for Microblaze - notrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Williams <john.williams@petalogix.com>
Cc: monstr@monstr.eu, Steven Rostedt <srostedt@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <1d3f23370911031826u1a601db1jab678030eafd200e@mail.gmail.com>
References: <4AF030EE.7050609@monstr.eu>
	 <1257266154.31359.14.camel@localhost.localdomain>
	 <4AF05E0C.5090305@monstr.eu>
	 <1257269575.26028.3355.camel@gandalf.stny.rr.com>
	 <4AF0725C.1050106@monstr.eu>
	 <1257300186.26028.3817.camel@gandalf.stny.rr.com>
	 <1d3f23370911031826u1a601db1jab678030eafd200e@mail.gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 03 Nov 2009 21:42:56 -0500
Message-Id: <1257302576.26028.3827.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 12:26 +1000, John Williams wrote:
> >>  From my test I don't understand MCOUNT_INSN_SIZE - and which function
> >> doesn't care about. There is this line of pseudocode in your doc
> >> (unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;) but what
> >> the reason is to do that. If I understand correct selfpc and frompc just
> >> give addresses which functions called that mcount and has impact to log.
> >> I mean that if that address is not proper begin of function is found
> >> (not sure if the code do it or not) function name (and function) which
> >> contain that address. Or is there any special reason why to substract
> >> that MCOUNT_INSN_SIZE - for timing or anything like that?
> >
> > The passed in address to mcount is really the return address and not the
> > caller to mcount. We want the actual address to the mcount caller. To
> > get that we must subtract size of the call to mcount from the address
> > passed in.
> 
> Is it critical that mcount calculate and use the exact entry point of
> the calling function, or just that it be consistent and be located
> "inside" the caller's footprint?  If so, MCOUNT_INSN_SIZE would be
> superfluous?...

No no no.

I may not have articulated this well enough.

The address is of the actual call to mcount, not the entry point of the
function. For example:

ffffffff812dcb3c <schedule>:
ffffffff812dcb3c:       55                      push   %rbp
ffffffff812dcb3d:       48 89 e5                mov    %rsp,%rbp
ffffffff812dcb40:       41 57                   push   %r15
ffffffff812dcb42:       41 56                   push   %r14
ffffffff812dcb44:       41 55                   push   %r13
ffffffff812dcb46:       41 54                   push   %r12
ffffffff812dcb48:       53                      push   %rbx
ffffffff812dcb49:       48 83 ec 68             sub    $0x68,%rsp
ffffffff812dcb4d:       e8 6e ee d2 ff          callq  ffffffff8100b9c0 <mcount>
ffffffff812dcb52:       bf 01 00 00 00          mov    $0x1,%edi
ffffffff812dcb57:       e8 e4 91 d5 ff          callq  ffffffff81035d40 <add_preempt_count>

When mcount is called in the above code, the stack contains the address
0xffffffff812dcb52 which is the mov    $0x1,%edi.  But the dynamic
ftrace functionality needs to modify the call co mcount itself. To do
so, we must subtract the MCOUNT_INSN_SIZE (which for x86 is 5). This
gives us the actual call site to mcount (0xffffffff812dcb4d).

The generic code only uses that macro for debugging purposes. If
something goes wrong, we write out what was at the address of mcount, by
showing MCOUNT_INSN_SIZE bytes.

That macro is used in the arch specific code to modify the .text. It is
used as the size parameter.


> 
> MicroBlaze gcc currently inserts the mcount call after the function
> prologue, and the prologue will differ in length depending upon how
> much stack and register shuffling is required for that function.  So,
> a single constant cannot correctly describe the offset of the mcount
> call site to the function's true entry point.
> 
> Or, perhaps the entry point is defined as "the first opcode after the
> prologue", in which case MCOUNT_INSN_SIZE can just be the size of the
> "bralid r15, _mcount; nop" sequence that we are generating (ie 8
> bytes).
> 
> There is a simple GCC #define that will force the mcount branch before
> the prologue, but that makes things a little trickier because our
> mcount hook must take care of saving away the branch link register.
> If we call after the prologue, gcc has already done that for us.

You want MCOUNT_INSN_SIZE to be the number of bytes to back up to get to
the actual call to mcount (the bralid r15, mcount).

-- Steve



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZKDC0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZKDC0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZKDC0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:26:38 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:46153 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbZKDC0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:26:37 -0500
MIME-Version: 1.0
In-Reply-To: <1257300186.26028.3817.camel@gandalf.stny.rr.com>
References: <4AF030EE.7050609@monstr.eu>
	 <1257266154.31359.14.camel@localhost.localdomain>
	 <4AF05E0C.5090305@monstr.eu>
	 <1257269575.26028.3355.camel@gandalf.stny.rr.com>
	 <4AF0725C.1050106@monstr.eu>
	 <1257300186.26028.3817.camel@gandalf.stny.rr.com>
Date: Wed, 4 Nov 2009 12:26:42 +1000
Message-ID: <1d3f23370911031826u1a601db1jab678030eafd200e@mail.gmail.com>
Subject: Re: Ftrace for Microblaze - notrace
From: John Williams <john.williams@petalogix.com>
To: rostedt@goodmis.org
Cc: monstr@monstr.eu, Steven Rostedt <srostedt@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  From my test I don't understand MCOUNT_INSN_SIZE - and which function
>> doesn't care about. There is this line of pseudocode in your doc
>> (unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;) but what
>> the reason is to do that. If I understand correct selfpc and frompc just
>> give addresses which functions called that mcount and has impact to log.
>> I mean that if that address is not proper begin of function is found
>> (not sure if the code do it or not) function name (and function) which
>> contain that address. Or is there any special reason why to substract
>> that MCOUNT_INSN_SIZE - for timing or anything like that?
>
> The passed in address to mcount is really the return address and not the
> caller to mcount. We want the actual address to the mcount caller. To
> get that we must subtract size of the call to mcount from the address
> passed in.

Is it critical that mcount calculate and use the exact entry point of
the calling function, or just that it be consistent and be located
"inside" the caller's footprint?  If so, MCOUNT_INSN_SIZE would be
superfluous?...

MicroBlaze gcc currently inserts the mcount call after the function
prologue, and the prologue will differ in length depending upon how
much stack and register shuffling is required for that function.  So,
a single constant cannot correctly describe the offset of the mcount
call site to the function's true entry point.

Or, perhaps the entry point is defined as "the first opcode after the
prologue", in which case MCOUNT_INSN_SIZE can just be the size of the
"bralid r15, _mcount; nop" sequence that we are generating (ie 8
bytes).

There is a simple GCC #define that will force the mcount branch before
the prologue, but that makes things a little trickier because our
mcount hook must take care of saving away the branch link register.
If we call after the prologue, gcc has already done that for us.

Thanks,

John
-- 
John Williams
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663

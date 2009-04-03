Return-Path: <linux-kernel-owner+w=401wt.eu-S1763523AbZDCXpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763523AbZDCXpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 19:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759182AbZDCXpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 19:45:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320AbZDCXpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 19:45:34 -0400
Message-ID: <49D69F39.4010101@zytor.com>
Date: Fri, 03 Apr 2009 16:43:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip 3/6 V4.1] x86: instruction decorder API
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>
In-Reply-To: <49D69BCA.8060506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Add x86 instruction decoder to arch-specific libraries. This decoder
> can decode all x86 instructions into prefix, opcode, modrm, sib,
> displacement and immediates. This can also show the length of
> instructions.
> 
> changes from v4:
>  - make bitmap tables static.

Hi Masami,

On the surface the overall structure looks fine, but I have a couple of 
concerns:

1. is this meant to be able to decode userspace code or just kernel 
code?  If it is supposed to be able to decode userspace code, is there a 
reason you're not dealing with 16-bit or V86 mode code at all?  If not, 
why are you including the 32-bit decoder in a 64-bit kernel (as well as 
instructions which we're pretty much guaranteed to never use in the 
kernel, such as ENTER.)

2. you're already not dealing with all existing three-byte opcode 
spaces, nor with DREX or VEX encodings for upcoming processors.  This 
doesn't matter so much for the kernel, but it does matter if this is 
supposed to be used for user-space code.

3. is there any need to deal with instruction set differences among 
processors?  (Again, this depends on the usage model.)

4. you have a bunch of magic opcode constants all over the place.  This 
means that as new instructions come in -- and they're going to be coming 
in -- this is going to be hard to update.  It would be cleaner if we 
could have an intermediate format that preprocesses down to all the 
relevant tables and perhaps even some of the code rather than 
open-coding everything in C.

This matters... for example you have:

+		} else if (opcode == 0xea /* jmp far seg:offs */) {
+			__get_immptr(insn);

... but nothing similar for opcode 0x9a.  This is extremely hard to spot 
with this kind of structure.

The more data-driven we can make it (without bloating the code too much) 
the better off we are, I believe.

	-hpa

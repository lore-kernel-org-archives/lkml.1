Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZDPXcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZDPXcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 19:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZDPXbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 19:31:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZDPXbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 19:31:51 -0400
Message-ID: <49E7BFDC.8040305@redhat.com>
Date: Thu, 16 Apr 2009 19:31:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
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
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com> <1239058135.5212.43.camel@localhost.localdomain> <49DA8857.8030607@zytor.com>
In-Reply-To: <49DA8857.8030607@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jim Keniston wrote:
>> For user-space probing, we've been concentrating on native-built
>> executables.  Am I correct in thinking that we'll see 16-bit or V86 mode
>> only on legacy apps built elsewhere?  In any case, it only makes sense
>> to build on the kvm folks' work in this regard.
>>
>
> That's a fair assumption; you will of course need to test it and take
> appropriate action if it doesn't pan out.
>
>> As noted, the INAT tables follow the kvm model of one fat bitmap of
>> attributes per opcode, rather than the kprobes/uprobes model of one or
>> two 256-bit tables per attribute.  (This latter approach was due to the
>> gradual accumulation of tables over the years.)
>>
>> I like the bitmap-per-opcode approach because it's relatively easy to
>> see in one place everything you're saying about a particular opcode.
>> But with all the potential clients for this service, it's not clear that
>> we'll get by with a single bitmap for every opcode.  (x86 kvm uses 32
>> bits per opcode, I think, and the INAT tables use 10.  Seems like we
>> could overrun 64 bits pretty quickly.)  So I guess that means we'll have
>> to get a little creative as to how we expose these attribute sets to the
>> client.
>>
>
> This is another very good reason to use an instruction table which is
> preprocessed into a usable format: it means that if the internal data
> structures change -- and they almost certainly will have to at some
> point -- the raw data isn't lost.

Hmm, I have an idea about instruction table. Usually, instruction tables
are encoded with code defined by each decoder/emulator. This method
will show their internal code directly, and is hard to maintain when
the opcode map is updated. Instead of that, I'd like to suggest using
the expressions in the opcode maps in a vender's genuine document (in
this case, Intel/AMD's manual) or www.sandpile.org for instruction
tables.

e.g.

const insn_attr_t onebyte_attr_table[ATTR_TABLE_SIZE] = {
/* 0x00-0x0f */
AT2(Eb,Gb), AT2(Ev,Gv),  AT2(Gb,Eb),  AT2(Gv,Ev),
AT2(AL,Ib), AT2(rAX,Iz), AT2(ES,i64), AT2(ES,i64),
AT2(Eb,Gb), AT2(Ev,Gv),  AT2(Gb,Eb),  AT2(Gv,Ev),
AT2(AL,Ib), AT2(rAX,Iz), AT2(CS,i64), AT(ESC),
...

Here, AT and AT2 macros are defined as follows:

#define AT(a) (INAT_OMEXP_##a)
#define AT2(a1, a2) (INAT_OMEXP_##a1 | INAT_OMEXP_##a2)

(OMEXP means Opcode Map Expression)
And each INAT_OMEXP_* is translated into internal format.

#define INAT_OMEXP_Eb	INAT_ENCODE_RM(TYPE_MEMREG, SIZE_BYTE)
#define INAT_OMEXP_Gb	INAT_ENCODE_REG(TYPE_MEMREG, SIZE_BYTE)
...

This idea will allow everyone to easily maintain instruction tables
by comparing instruction tables with vender's opcode map.

Designing internal instruction tables is harder. Currently, I'm
working on below layout.
Comments are welcome!

Instruction Attribute Encoding
==============================

Bitmap layout:
[ESC]
 0 0 [(padding)][OPFLG][IMM][REG][RGT][RGS][RM][RMT][RMS]
 0 1 [(padding)][PFXGRP][PFXEXT][Prefix code]
 1 0 [(padding)][EID]
 1 1 [(padding)][GID]

ESC(2): Switching normal/escape/group/prefix.
     (0:normal opcode, 1:(Legacy)Prefix, 2:Escape, 3:Group)

- Normal opcodes
OPFLG(7): Flag bits: [REX][LPFX][I64][F64][NOPR][EREG][AIMM]
     REX(1): Opcode is a REX prefix.
     LPFX(1): Opcode can be modified by Last Prefix(SSE2-4)
     I64(1): Opcode is invalid in 64bit mode.
     F64(1): Oprand is 64bits width in 64bit mode.
     NOPR(1): Opcode has no operand.
     EREG(1) : Opcode byte encodes Registers
     AIMM(1) : Opcode has another 1 byte Immediate(2nd Immediate).
IMM(3): Immediate size bits
     (0:none, 1:byte, 2:word, 3:dword, 4:qword, 5:pointer,
      6:word/dword, 7:word/dword/qword)
REG(1): Opcode has ModRM 'reg'
RGT(3): ModRM 'reg' type or special operand bits
     (0:none,
      REG=0: 1:DS/SI
      REG=1: 1:GPR, 2:MMX, 3:XMM, 4:DBG, 5:CTR, 6:FP, 7:SR)
RGS(3): ModRM 'reg' or special operand size bits
     (GPR: 1:byte, 2:word, 3:dword, 4:qword, 5:N/A, 6:word/dword,
      7:word/dword/qword)
     (MMX: 3:dword, 4:qword)
     (XMM: 2:Scalar-SingleFP, 3:Scaler-DoubleFP, 4:qword, 5:d-qword,
      6:Packed-SingleFP, 7:Packed-DoubleFP)
     (FP: ?)
     (Others: same as GPR)
RM(1) : Opcode has ModRM 'rm'
RMT(3) : ModRM 'rm' type or special operand bits
     (0:none,
      RM=0: 1:ES/DI
      RM=1: 1:GPR, 2:MMX, 3:XMM, 4:Memory, 5:GPR/Mem, 6:MMX/MEM, 7:XMM/Mem)
RMS(3): ModRM 'rm' or special operand size bits. see RGS.

- Legacy prefixes
PFXGRP(4): Prefix group bits: [PGRP1][PGRP2][PGRP3][PGRP4]
     PGRP1(1): opcode is prefix group1
     PGRP2(1): opcode is prefix group2
     PGRP3(1): opcode is prefix group3
     PGRP4(1): opcode is prefix group4
PFXEXT(2): Mandatory prefix extent
     (0:none, 1:66H, 2:F2H, 3:F3H)
Prefix code(11): Prefix code bits

- Escape opcode
EID(2): Escape code id.
     (0:2byte escape, 1:FPU escape, 2:3byte escape1, 3:3byte escape2)

- Group opcode
GID(5): Group Number
     (0:Group1, 1:Group1A, 2:Group2, ... 16:Group16)


Thanks,



-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


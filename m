Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZDVASl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZDVASl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZDVAS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:18:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45247 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZDVAS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:18:26 -0400
Message-ID: <49EE6235.20706@redhat.com>
Date: Tue, 21 Apr 2009 20:17:57 -0400
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
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com>	 <1239058135.5212.43.camel@localhost.localdomain>	 <49DA8857.8030607@zytor.com>  <49E7BFDC.8040305@redhat.com> <1239926776.5883.17.camel@dyn9047018094.beaverton.ibm.com> <49E7C87E.8000202@zytor.com>
In-Reply-To: <49E7C87E.8000202@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jim Keniston wrote:
>> It looks like AT2(Ev,Gv) would yield the same bits as AT2(Gv,Ev).  It'd
>> be nice not to lose the operand-order information.  And we'd have to
>> make clear whether which notation we're using -- src,dest as in the gnu
>> assembler, or dest,src as in the AMD (and Intel?) manuals.
>>
> 
> Since the information would come from the manuals, I would recommend 
> following them (dst first.)
>

Hi Peter and Jim,

Now what I'm doing is making opcode tables like this.

Table: 1-byte opcode
Alias: none
00: ADD Eb,Gb
01: ADD Ev,Gv
02: ADD Gb,Eb
03: ADD Gv,Ev
04: ADD AL,Ib
05: ADD rAX,Iz
06: PUSH ES (i64)
07: POP ES (i64)
08: OR Eb,Gb
09: OR Ev,Gv
0a: OR Gb,Eb
0b: OR Gv,Ev
0c: OR AL,Ib
0d: OR rAX,Iz
0e: PUSH CS
0f: 2-byte escape
...

and a parser script which parses them into,

const insn_attr_t primary_table[INAT_TABLE_SIZE] = {
	[0x04] = INAT_IMM(IMM_SIZE_BYTE)
	[0x05] = INAT_IMM(IMM_SIZE_VWORD32)
	[0x0c] = INAT_IMM(IMM_SIZE_BYTE)
	[0x0d] = INAT_IMM(IMM_SIZE_VWORD32)
	[0x0f] = INAT_ESC(IMM_ESC_2BYTE)
...

(note, instructions which has no attributes for decoder, are just ignored)


By the way, I'm worried about legal things of Intel's instruction
encoding expressions. Would you think there is any problem if we
have those tables in the kernel tree?

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


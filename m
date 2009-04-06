Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZDFWsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZDFWsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759128AbZDFWsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:48:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47783 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041AbZDFWse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:48:34 -0400
Subject: Re: [PATCH -tip 3/6 V4.1] x86: instruction decorder API
From: Jim Keniston <jkenisto@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <49D6ABD1.7040704@redhat.com>
References: <49D4F4E6.6060401@redhat.com> <49D69BCA.8060506@redhat.com>
	 <49D69F39.4010101@zytor.com>  <49D6ABD1.7040704@redhat.com>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 15:48:55 -0700
Message-Id: <1239058135.5212.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 20:37 -0400, Masami Hiramatsu wrote:
> Hi Peter,
> 
> H. Peter Anvin wrote:
> > Masami Hiramatsu wrote:
> >> Add x86 instruction decoder to arch-specific libraries. This decoder
> >> can decode all x86 instructions into prefix, opcode, modrm, sib,
> >> displacement and immediates. This can also show the length of
> >> instructions.
> >>
...
> > 
> > Hi Masami,
> > 
> > On the surface the overall structure looks fine, but I have a couple of 
> > concerns:
> > 
> > 1. is this meant to be able to decode userspace code or just kernel 
> > code?  If it is supposed to be able to decode userspace code, is there a 
> > reason you're not dealing with 16-bit or V86 mode code at all?  If not, 
> > why are you including the 32-bit decoder in a 64-bit kernel (as well as 
> > instructions which we're pretty much guaranteed to never use in the 
> > kernel, such as ENTER.)
> 
> Actually, this aims to decode both of user space and kernel code.
> At this point, it just needs to cover kernel code, because kprobes
> just want to decode kernel binary.
> However, this is just a starting point, uprobe developers want to
> use it to decode user-space code. In that case, it needs to be
> enhanced.

For user-space probing, we've been concentrating on native-built
executables.  Am I correct in thinking that we'll see 16-bit or V86 mode
only on legacy apps built elsewhere?  In any case, it only makes sense
to build on the kvm folks' work in this regard.

...
> 
> > 
> > 4. you have a bunch of magic opcode constants all over the place.  This 
> > means that as new instructions come in -- and they're going to be coming 
> > in -- this is going to be hard to update.  It would be cleaner if we 
> > could have an intermediate format that preprocesses down to all the 
> > relevant tables and perhaps even some of the code rather than 
> > open-coding everything in C.
> > 
> > This matters... for example you have:
> > 
> > +		} else if (opcode == 0xea /* jmp far seg:offs */) {
> > +			__get_immptr(insn);
> > 
> > ... but nothing similar for opcode 0x9a.  This is extremely hard to spot 
> > with this kind of structure.
> 
> Oops, that should be a bug. Hmm, I think we'd better bit-flags tables
> for classifying opcodes.
> Jim, can your INAT idea help this situation?
> 
> http://sources.redhat.com/ml/systemtap/2009-q2/msg00109.html
> 

As noted, the INAT tables follow the kvm model of one fat bitmap of
attributes per opcode, rather than the kprobes/uprobes model of one or
two 256-bit tables per attribute.  (This latter approach was due to the
gradual accumulation of tables over the years.)

I like the bitmap-per-opcode approach because it's relatively easy to
see in one place everything you're saying about a particular opcode.
But with all the potential clients for this service, it's not clear that
we'll get by with a single bitmap for every opcode.  (x86 kvm uses 32
bits per opcode, I think, and the INAT tables use 10.  Seems like we
could overrun 64 bits pretty quickly.)  So I guess that means we'll have
to get a little creative as to how we expose these attribute sets to the
client.

...
> 
> Thank you for good advice!
> 

Ditto.
Jim Keniston


Return-Path: <linux-kernel-owner+w=401wt.eu-S932720AbZJFObg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbZJFObg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932615AbZJFObf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:31:35 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:48899 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932577AbZJFObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:31:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAAvxykpMROOX/2dsb2JhbACBUtINhCoEgVM
Date: Tue, 6 Oct 2009 10:30:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, rth@redhat.com
Subject: Re: [PATCH 0/4] jump label patches
Message-ID: <20091006143056.GB3951@Krystal>
References: <cover.1253831945.git.jbaron@redhat.com> <20091006060410.CAF2528@magilla.sf.frob.com> <4ACB5082.6050902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4ACB5082.6050902@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:23:40 up 49 days,  1:13,  3 users,  load average: 0.65, 0.34,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Roland McGrath wrote:
> > I think text_poke_fixup() is a good safe place to start, and it seems wise
> > to merge a version using that before worrying anything subtler.  But it's
> > almost surely overkill and makes the enable/disable switching cost pretty
> > huge.  The rules as documented by Intel seem to indicate that simple
> > self-modification can work for UP and for SMP there should be some scheme
> > with IPIs that is not too terrible.  
> > 
> > Those can entail a multi-phase modification like the int3 patching style,
> > but int3 is not the only way to do it.  int3 has the benefit of being a
> > one-byte instruction you can patch in, but also the downside of requiring
> > the trap handling hair.
> 
> Hmm, would you want to put tracepoint on the path of int3 handling?
> 
> >  Another approach is:
> > 
> > start:
> > 	   .balign 2
> > 	2: nopl
> > 	7: ...
> > 
> > phase 1:
> > 	2: jmp 7
> > 	4: <last 3 bytes of nopl>
> > 	7: ...
> > 
> > phase 2:
> > 	2: jmp 7
> > 	4: {last 3 bytes of "jmp .Ldo_trace"}
> > 	7: ...
> > 
> > phase 3:
> > 	2: jmp .Ldo_trace
> > 	7: ...
> > 
> > A scheme like that requires that the instruction to be patched be 2-byte
> > aligned so that the two-byte "jmp .+3" can be an atomic store not
> > straddling a word boundary.  On x86-64 (and, according to the Intel book,
> > everything >= Pentium), you can atomically store 8 bytes when aligned.  So
> > there you will usually actually be able to do this in one or two phases to
> > cover each particular 5 byte range with adequately aligned stores.
> 
> It is unclear whether we can atomically modify 2 bytes in icache (also, it
> can across cache lines or pages.)
> I think int3 bypassing is more generic way to patching if you don't mind
> tracing int3 path :-)

I think their point is that by only changing the 2nd byte of a 2-byte
jmp instruction, leaving the opcode as-is, they think the processor will
either choose one or the other branch, seeing two "coherent"
instructions.

However, as I point out in the immediate values thread, the problem
might run deeper, which would be that CPU need to see consistent
instructions across multiple reads in the same code region (due to
pipeline effects of some sorts). Mere atomicity of the modification does
not seem to be enough. What I gathered by discussing with Richard J
Moore is that we really need a synchronizing instruction between the
moments CPUs see the old and new version. int3/iret is one. Sending an
IPI doing a mfence or cpuid is another. Both seem needed to ensure
SMP-safe code modification.

See the immediate values thread for details. We are waiting for Intel
ruling on the int3+IPI scheme.

Mathieu

> 
> 
> Thank you,
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

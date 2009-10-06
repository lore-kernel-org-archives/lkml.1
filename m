Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbZJFOMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbZJFOMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932688AbZJFOMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:12:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639AbZJFOMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:12:16 -0400
Message-ID: <4ACB5082.6050902@redhat.com>
Date: Tue, 06 Oct 2009 10:13:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, rth@redhat.com
Subject: Re: [PATCH 0/4] jump label patches
References: <cover.1253831945.git.jbaron@redhat.com> <20091006060410.CAF2528@magilla.sf.frob.com>
In-Reply-To: <20091006060410.CAF2528@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I think text_poke_fixup() is a good safe place to start, and it seems wise
> to merge a version using that before worrying anything subtler.  But it's
> almost surely overkill and makes the enable/disable switching cost pretty
> huge.  The rules as documented by Intel seem to indicate that simple
> self-modification can work for UP and for SMP there should be some scheme
> with IPIs that is not too terrible.  
> 
> Those can entail a multi-phase modification like the int3 patching style,
> but int3 is not the only way to do it.  int3 has the benefit of being a
> one-byte instruction you can patch in, but also the downside of requiring
> the trap handling hair.

Hmm, would you want to put tracepoint on the path of int3 handling?

>  Another approach is:
> 
> start:
> 	   .balign 2
> 	2: nopl
> 	7: ...
> 
> phase 1:
> 	2: jmp 7
> 	4: <last 3 bytes of nopl>
> 	7: ...
> 
> phase 2:
> 	2: jmp 7
> 	4: {last 3 bytes of "jmp .Ldo_trace"}
> 	7: ...
> 
> phase 3:
> 	2: jmp .Ldo_trace
> 	7: ...
> 
> A scheme like that requires that the instruction to be patched be 2-byte
> aligned so that the two-byte "jmp .+3" can be an atomic store not
> straddling a word boundary.  On x86-64 (and, according to the Intel book,
> everything >= Pentium), you can atomically store 8 bytes when aligned.  So
> there you will usually actually be able to do this in one or two phases to
> cover each particular 5 byte range with adequately aligned stores.

It is unclear whether we can atomically modify 2 bytes in icache (also, it
can across cache lines or pages.)
I think int3 bypassing is more generic way to patching if you don't mind
tracing int3 path :-)


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


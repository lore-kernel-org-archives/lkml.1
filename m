Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZKXDO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZKXDO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 22:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbZKXDOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 22:14:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45470 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734AbZKXDOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 22:14:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TH/CbQ3vzHDjRH9kOQs3xvWUF/ONiWrrZewNxxfJA5OvotqX6dame46O3Cwt1gMSqj
         bj2EMMPh0O4wV4qIHIvLQjMTNAJqGOzp+9q1Glh0Wk+vyZrWpop7aoXGgEKfOqmZbq4r
         QH+++TeMgmf6ywpNrpKyklxDZShxHSnqN+mtY=
Date: Tue, 24 Nov 2009 04:14:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 07/10] kprobes/x86: Support kprobes jump
	optimization on x86
Message-ID: <20091124031456.GC6752@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232211.22071.58974.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123232211.22071.58974.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 06:22:11PM -0500, Masami Hiramatsu wrote:
> Introduce x86 arch-specific optimization code, which supports both of
> x86-32 and x86-64.
> 
> This code also supports safety checking, which decodes whole of a function
> in which probe is inserted, and checks following conditions before
> optimization:
>  - The optimized instructions which will be replaced by a jump instruction
>    don't straddle the function boundary.
>  - There is no indirect jump instruction, because it will jumps into
>    the address range which is replaced by jump operand.
>  - There is no jump/loop instruction which jumps into the address range
>    which is replaced by jump operand.
>  - Don't optimize kprobes if it is in functions into which fixup code will
>    jumps.
> 
> This uses stop_machine() for corss modifying code from int3 to jump.
> It doesn't allow us to modify code on NMI/SMI path. However, since
> kprobes itself doesn't support NMI/SMI code probing, it's not a
> problem.
> 
> Changes in v5:
>  - Introduce stop_machine-based jump replacing.



I realize now that int 3 live patching doesn't need stop_machine().
But still, I don't understand the int 3 unecessary step.

You first force int 3 patching, and later try to optimize
with a jump, using stop_machine().

But why the int 3 is a necessary first step? I guess it was
necessary first when you used it as a gate:

- patch with int 3, go to handler, go to old instruction
  that was patched, jump to original code that folows
  instruction that was patched
- set up detour buffer, execute handler (from int 3)
  then route to detour buffer, and original code that
  follows
- the code to be patched with the jump is now a
  dead code, jump to it

And now that you use stop_machine(), the complexity could be
reduced to:

- decide kprobe mode
- if int 3, then do like usual
- if jmp, then prepare detour buffer, and patch with the jump,
  without worrying about routing int 3 to the detour buffer
  to create a dead code area. It is now safe because of stop_machine()

Of course it's possible I completely misunderstood the whole
thing :)


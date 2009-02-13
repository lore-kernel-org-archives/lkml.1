Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbZBMEUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbZBMEUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbZBMEU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:20:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbZBMEU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:20:27 -0500
Date: Thu, 12 Feb 2009 23:20:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/7][RFC] powerpc64, tracing: add function graph tracer
 with dynamic tracing
In-Reply-To: <1234498509.26036.35.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0902122319300.15469@gandalf.stny.rr.com>
References: <20090212011051.265346435@goodmis.org>  <20090212011343.074329920@goodmis.org> <1234498509.26036.35.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Feb 2009, Benjamin Herrenschmidt wrote:

> 
> > @@ -55,8 +56,9 @@ static unsigned char *ftrace_call_replace(unsigned
> > long ip, unsigned long addr)
> >  	 */
> >  	addr = GET_ADDR(addr);
> >  
> > -	/* Set to "bl addr" */
> > -	op = 0x48000001 | (ftrace_calc_offset(ip, addr) & 0x03fffffc);
> > +	/* if (link) set op to 'bl' else 'b' */
> > +	op = 0x48000000 | (link ? 1 : 0);
> > +	op |= (ftrace_calc_offset(ip, addr) & 0x03fffffc);
> 
> Any reason why you aren't using the code in
> arch/powerpc/lib/code-patching.c here ?
> 
> > 	new = ftrace_call_replace(ip, stub, 0);
> > +	memcpy(old, new, MCOUNT_INSN_SIZE);
> > +	new = ftrace_call_replace(ip, addr, 0);
> > +
> > +	return ftrace_modify_code(ip, old, new);
> > +}
> 
> Heh, memcpy of 4 bytes :-) I hope gcc is smart enough to turn that into
> a simple load/store ..

hehe, I hated writing that. I just did not want to touch the (already 
working code) of the dynamic ftrace. I guess I could still use longs and 
then typecast them to char pointers for the ftrace_modify_code.

Thanks,

-- Steve


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835Ab0ANPjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0ANPjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679Ab0ANPjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:39:11 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:36522 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142Ab0ANPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:39:11 -0500
Date: Thu, 14 Jan 2010 10:39:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20100114153908.GA3487@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263483139.28171.3857.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:36:58 up 28 days, 23:55,  4 users,  load average: 0.33, 0.22,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2010-01-12 at 11:26 -0500, Jason Baron wrote:
> 
> > +/**
> > + * text_poke_fixup() -- cross-modifying kernel text with fixup address.
> > + * @addr:	Modifying address.
> > + * @opcode:	New instruction.
> > + * @len:	length of modifying bytes.
> > + * @fixup:	Fixup address.
> > + *
> > + * Note: You must backup replaced instructions before calling this,
> > + * if you need to recover it.
> > + * Note: Must be called under text_mutex.
> > + */
> > +void *__kprobes text_poke_fixup(void *addr, const void *opcode, size_t len,
> > +				void *fixup)
> > +{
> > +	static const unsigned char int3_insn = BREAKPOINT_INSTRUCTION;
> > +	static const int int3_size = sizeof(int3_insn);
> > +
> > +	/* Replacing 1 byte can be done atomically. */
> > +	if (unlikely(len <= 1))
> > +		return text_poke(addr, opcode, len);
> 
> This part bothers me. The text_poke just writes over the text directly
> (using a separate mapping). But if that memory is in the pipeline of
> another CPU, I think this could cause a GPF.

It looks like we are thinking along the same lines.

I'm under the impression that I pointed out this exact same issue in the
previous round of review a few weeks ago. Does this submission reflect
the up-to-date state of this patch ?

Thanks,

Mathieu

> 
> -- Steve
> 
> > +
> > +	/* Preparing */
> > +	patch_fixup_addr = fixup;
> > +	wmb();
> > +	patch_fixup_from = (u8 *)addr + int3_size; /* IP address after int3 */
> > +
> > +	/* Cap by an int3 */
> > +	text_poke(addr, &int3_insn, int3_size);
> > +	sync_core_all();
> > +
> > +	/* Replace tail bytes */
> > +	text_poke((char *)addr + int3_size, (const char *)opcode + int3_size,
> > +		  len - int3_size);
> > +	sync_core_all();
> > +
> > +	/* Replace int3 with head byte */
> > +	text_poke(addr, opcode, int3_size);
> > +	sync_core_all();
> > +
> > +	/* Cleanup */
> > +	patch_fixup_from = NULL;
> > +	wmb();
> > +	return addr;
> > +}
> > +
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811Ab0ARQwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0ARQwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497Ab0ARQwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:52:36 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:36762 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab0ARQwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:52:34 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4FAM8bVEuuWOiG/2dsb2JhbACBRtRwhDME
Date: Mon, 18 Jan 2010 11:52:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, rostedt@goodmis.org,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20100118165231.GA29764@Krystal>
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <1263483139.28171.3857.camel@gandalf.stny.rr.com> <4B4F3A1A.2030906@zytor.com> <20100117185539.GF9008@Krystal> <20100117111608.35a98ee2@infradead.org> <4B548562.6030008@redhat.com> <4B548B09.7040309@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B548B09.7040309@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:37:36 up 33 days, 56 min,  5 users,  load average: 0.25, 0.11,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 01/18/2010 07:59 AM, Masami Hiramatsu wrote:
> >>>>>
> >>>>> This part bothers me. The text_poke just writes over the text
> >>>>> directly (using a separate mapping). But if that memory is in the
> >>>>> pipeline of another CPU, I think this could cause a GPF.
> >>>>>
> >>>>
> >>>> Could you clarify why you think that?
> >>>
> >>> Basically, what Steven and I were concerned about in this particular
> >>> patch version is the fact that this code took a "shortcut" for
> >>> single-byte text modification, thus bypassing the int3-bypass scheme
> >>> altogether.
> >>
> >> single byte instruction updates are likely 100x safer than any scheme
> >> of multi-byte instruction scheme that I have seen, other than a full
> >> stop_machine().
> >>
> >> That does not mean it is safe, it just means it's an order of
> >> complexity less to analyze ;-)
> > 
> > Yeah, so in the latest patch, I updated it to use int3 even if
> > len == 1. :-)
> > 
> 
> This really doesn't make much sense to me.  The whole basis for the int3
> scheme itself is that single-byte updates are atomic, so if single-byte
> updates can't work -- and as I stated, we at Intel OTC currently believe
> it safe -- then int3 can't work either.

The additional characteristic of the int3 instruction (compared to the
general case of a single-byte instruction) is that, when executed, it
will trigger a trap, run a trap handler and return to the original code,
typically with iret. This therefore implies that a serializing
instruction is executed before returning to the instructions following
the modification site when the breakpoint is hit.

So I hand out to Intel's expertise the question of whether single-byte
instruction modification is safe or not in the general case. I'm just
pointing out that I can very well imagine an aggressive superscalar
architecture for which pipeline structure would support single-byte int3
patching without any problem due to the implied serialization, but would
not support the general-case single-byte modification due to its lack of
serialization.

As we might have to port this algorithm to Itanium in a near future, I
prefer to stay on the safe side. Intel's "by the book" recommendation is
more or less that a serializing instruction must be executed on all CPUs
before new code is executed, without mention of single-vs-multi byte
instructions. The int3-based bypass follows this requirement, but the
single-byte code patching does not.

Unless there is a visible performance gain to special-case the
single-byte instruction, I would recommend to stick to the safest
solution, which follows Intel "official" guide-lines too.

Thanks,

Mathieu

> 
> The one thing to watch out for is that unless you force an IPI/IRET
> cycle afterwards, you can't know when any particular remote processor
> will see the update.
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

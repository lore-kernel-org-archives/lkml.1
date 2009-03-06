Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZCFSMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZCFSMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZCFSMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:12:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZCFSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:12:22 -0500
Date: Fri, 6 Mar 2009 13:12:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip 0/4] Text edit lock and atomic text_poke()
In-Reply-To: <20090306180911.GB14236@Krystal>
Message-ID: <alpine.DEB.2.00.0903061310550.23248@gandalf.stny.rr.com>
References: <49B1428A.9050500@redhat.com> <20090306180911.GB14236@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Mar 2009, Mathieu Desnoyers wrote:

> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> > Hi,
> > 
> > Here is a series of patches which introduce text_mutex for protecting
> > editing kernel text from each other subsystems, and make text_poke()
> > atomic by using fixmap.
> > 
> > BTW,
> > 
> > > Paravirt and alternatives are always done when SMP is inactive, so there is no
> > > need to use locks.
> > 
> > Mathieu, I'm not sure that means. alternatives will be called from module
> > init code and other place where the system has already been running multi-
> > -threads(and they use smp_alt mutex). So, is it possible that those functions
> > will sleep or yield to another process?
> > 
> 
> As I remember, module code uses text_poke_early when modifying the
> module text _before_ the module is made available to the rest of the
> kernel. Therefore, it behaves as if it was in a UP system, and that's
> ok, because only one CPU has to touch the text. Therefore, there is no
> need to use text_poke, and therefore no need to take the text mutex.
> 
> Or maybe has it changed ? But I doubt so.
> 

That is correct. Currently ftrace simply does a probe_kernel_write on 
module code to convert the calls to mcount into nops. This is done before 
the module is available, and does not require stop_machine nor break 
points. Since modules are not included in the DEBUG_RODATA there's no need 
to play games with the page tables either.

-- Steve


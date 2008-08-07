Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYHGV3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYHGV3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYHGV3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:29:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46384 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYHGV3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:29:44 -0400
Date: Thu, 7 Aug 2008 17:29:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <489B6511.7000208@goop.org>
Message-ID: <alpine.DEB.1.10.0808071721200.10092@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <489B6511.7000208@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 7 Aug 2008, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > Now, this was no easy task. We needed to add a section to every object
> > file with a list of pointers to the call sites to mcount. The idea I came
> > up with was to make a tmp.s file for every object just after it is compiled.
> > This tmp.s would then be compiled and relinked into the original object.
> > The tmp.s file would have something like:
> > 
> >   .section __mcount_loc,"a",@progbits
> >   .quad location_of_mcount1
> >   .quad location_of_mcount2
> >   (etc)
> >   
> 
> I have  a few concerns about this scheme:
> 
> One is that you assume that all text is in a .text section, and that the
> offsets you compute on a per-section basis are going to be valid in the final
> kernel image.  At the very least you should make each offset relative to its
> own function rather than inter-function.

I assume neither ;-)

This works with .text.sched .text.init .text.cpu etc. I use the first 
function in each section as my reference point.  This is the key.

> 
> But it seems pretty fragile overall.  Things like -ffunction-sections and
> section gc will invalidate the table you build up.

I don't see how. I'm referencing a function as my pointer. If this was
true, then I wouldn't be able to do

  static void my_func(void) { [...] }
  struct func_struct {
     void (*func)(void);
  } f = { my_func; };

My references end up exactly the same as the "f->func" reference does.
If my references are broken, so is this f->func. Which would be bad to
say the least.

> 
> It seems to me that you can acheive the same effect by:
> 
>   1. link vmlinux with "ld -q", which will leave the relocation
>      information intact in the final object
>   2. use "readelf -r" to extract the relocation info, find the
>      references to mcount and build a table
>   3. link that table into the kernel image
>   4. repeat to get a stable result

This doesn't seem any less complex than what I did. With this, I would 
have to come up with another way to handle modules. This will make
things a lot more complex.

> 
> Note that steps 2-4 are identical to kallsyms, both in intent and detail.  The
> only difference is the precise table you build and the command you use to
> extract the info from the kernel.  From a quick peek at the way Makefile
> implements kallsyms, it looks to me like it would be fairly easy to generalize
> so that you can do the mcount reloc processing in the same relink passes as
> kallsyms with minimal overhead on the kernel build time.

I could work on this. But again, this will put more work into module.c 
that I would like to avoid.

> 
> It just seems incredibly fiddly to be doing all this per-object.

Actually, this isn't that much fiddling. What I did was simply make a list
of pointers to the call sites to mcount. The pointers used the first 
function of each section to offset against. I relinked in the list making 
it just like a list done within C.  All relocations and magic after this
will be handled just fine.

-- Steve


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZGYC4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZGYC4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 22:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZGYC4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 22:56:50 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:41780 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZGYC4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 22:56:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tZUGEaJ7dluqgbiFykd8vIobxW+rztUEM/vHStg6ZzVEwHlF4qrxk6XmYCRJkKyms0
         J6qDX0uZ1s9JWWjAfaceppRsmOgNmGAlNUhNMEBGNLEsXC0cu+iRhDIvdmCAANwShfDT
         ZljUJfe95V30B8YA3UicldkAW1pabACpozUOM=
Date: Sat, 25 Jul 2009 04:56:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/5] hw-breakpoints: Make kernel breakpoints API
	truly generic
Message-ID: <20090725025644.GC5100@nowhere>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-2-git-send-email-fweisbec@gmail.com> <20090721111517.GC5804@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721111517.GC5804@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 04:45:17PM +0530, K.Prasad wrote:
> On Mon, Jul 20, 2009 at 01:08:03PM -0400, Frederic Weisbecker wrote:
> > To define a kernel hardware breakpoint, one need to define the
> > address, type and length of the breakpoint using arch specific
> > operations and then register it using a core helper.
> > 
> > The first stage is truly not scalable with respect to the number of
> > archictures, because for each of them that support hardware
> > breakpoints, we would need a seperate specific field definition for
> > the breakpoint.
> > 
> > However, the supported breakpoint functionalities may be very different
> > between architectures.
> > Then this new API tries to compose with the following constraints:
> > 
> > - a given architecture may perhaps not support the triggering on one
> >   of the usual memory access (read-write/read/write/execute)
> > 
> > - a given architecture may perhaps not support the ability to trigger
> >   a breakpoint only on specific memory access size lower than the word
> >   size for this arch.
> > 
> > - a given architecture may perhaps not support breakpoints on addresses
> >   range.
> > 
> > The new API changes the following prototype for a kernel breakpoint
> > registration:
> > 
> >  int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > 
> > into:
> > 
> >  int register_kernel_hw_breakpoint(struct hw_breakpoint *bp,
> >                                    unsigned long addr,
> > 				   int len, enum breakpoint_type type)
> 
> It is not clear how adding these new parameters to the interface would
> help it become generic, as opposed to moving them to 'struct
> hw_breakpoint'.
> 
> It would make the usage cumbersome of some architectures - say for
> instance the PPC64 which always has a breakpoint length of 8 bytes. So
> the user needs to specify either '8' always or '0' to indicate variable
> length not supported (but it is counter-intuitive..may be interpreted as
> zero-length).


Hm, so may be we should only push the target and the type and set the most
intuitive access length automatically? ie: 1 for x86 so that it triggers
for every accesses, and 8 for ppc?

Also how is actually interpreted an 8 bytes access on ppc? Ie: is a single
byte access actually interpreted through an 8 byte access because of memory
access constraints?


 
> > 
> > The choice of passing the breakpoint settings as parameters of the
> > registration helper and not by adding generic fields into the breakpoint
> > structure is motivated by the need of a very specific per arch
> > representation of the breakpoint:
> > 
> > - the arch may only need an address, but could also need a couple for
> >   breakpoints in ranges.
> > - the type is subject to arch interpretation (values of debug registers)
> > - the length too.
> > 
> > Then, to get back these values from a generic breakpoint structure that have
> > specific encodings into the arch fields, this API comes along with abstract
> > accessors which implementation is arch specific:
> > 
> > - type hw_breakpoint_type(bp)
> > - addr hw_breakpoint_addr(bp)
> > 
> > However, open debates come along this RFC patch:
> > 
> > - the address could be a generic field in struct hw_breakpoint. If we
> >   are dealing with a range breakpoint, then we would just need to
> >   compute addr + length to get the end of the range.
> > 
> > - the length and type could also be generic fields of
> >   struct hw_breakpoint. It would then be up to the arch to get a
> >   translation between such generic values and per arch needs.
> >
> 
> While the issues have been enumerated above, the patchset only pushes
> the issue into a different domain i.e. make the user determine if a
> breakpoint type or len is supported in a given architecture vs the existing
> implementation in which the user determines if a constant pertaining to
> a given len/type is defined. But the accessor-routines
> hw_breakpoint_type() and hw_breakpoint_addr() make it much easier to use
> and is a good addition.
> 
> To make the usage much easier, I would see a combination of the
> following:
> 
> - Define constants/enums for length and type that are common to all
>   architectures.


Indeed, in the hope that most basic types of breakpoints are supported
by every architectures (x and rw).


> - Define accessor routines that help determine if a given type/len is
>   supported on the host processor.


Or may be we should forget about the length as stated above?

But indeed we can think about an arch routine that reports the supported
types, that would provide a better granularity of error message than getting
a "non implemented" error while registering a breakpoint.


> - Move fields such as address, len and type to generic breakpoint
>   structure (if it still matters despite the two changes above).


Ok, I guess that would indeed be better to do that than using abstract
accessors. Let the arch interpret these generic informations by itself.

Thanks!


> Let me know what you think.
> 
> Thanks,
> K.Prasad
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


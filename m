Return-Path: <linux-kernel-owner+w=401wt.eu-S1759709AbYGPXDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709AbYGPXDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbYGPXDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:03:08 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41214 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758106AbYGPXDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:03:06 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <487E78ED.30804@redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <487E78ED.30804@redhat.com>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 18:03:03 -0500
Message-Id: <1216249383.3358.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 18:40 -0400, Masami Hiramatsu wrote:
> James Bottomley wrote:
> > One of the big nasties of systemtap is the way it tries to embed
> > virtually the entirety of the kernel symbol table in the probe modules
> > it constructs.  This is highly undesirable because it represents a
> > subversion of the kernel API to gain access to unexported symbols.  At
> > least for kprobes, the correct way to do this is to specify the probe
> > point by symbol and offset.
> > 
> > This patch converts systemtap to use the correct kprobe
> > symbol_name/offset pair to identify the probe location.
> 
> Hi James,
> 
> I think your suggestion is a good step. Of course, it might
> have to solve some issues.
> 
> Unfortunately, current kprobe's symbol_name interface is not
> so clever. For example, if you specify a static function
> which is defined at several places in the kernel(ex. do_open),
> it always pick up the first one in kallsyms, even if systemtap
> can find all of those functions.
> (you can find many duplicated symbols in /proc/kallsyms)

Right, but realistically only functions which have a strict existence
(i.e. those for whom an address could be taken) can be used; functions
which are fully inlined (as in have no separate existence) can't.
That's why the patch finds the closest function with an address to match
on.

> So, we might better improve kallsyms to treat this case
> and find what is a better way to specify symbols and addresses.

Well, both the dwarf and the kallsyms know which are the functions that
have a real existence, so the tool can work it out.  It has a real
meaning too because the chosen symbol must be the parent routine of all
the nested inlines.

> > This only represents a baby step:  after this is done, there are at
> > least three other consumers of the systemtap module relocation
> > machinery:
> > 
> >      1. unwind information.  I think the consumers of this can be
> >         converted to use the arch specific unwinders that already exist
> >         within the kernel
> >      2. systemtap specific functions that use kernel internals.  This
> >         was things like get_cycles() but I think they all now use a
> >         sanctioned API ... need to check
> 
> Sure, those functions must be well isolated from other parts of kernel.
> unfortunately, relayfs is not enough isolated. see below;
> http://sources.redhat.com/bugzilla/show_bug.cgi?id=6487

This is just "who guards the guards" or in this case, you can't probe
pieces of the kernel that the probe internals use.  However, as long as
the separation is tight this shouldn't be too much of a problem.

> >      3. Access to unexported global variables used by the probes.  This
> >         one is a bit tricky; the dwarf gives a probe the ability to
> >         access any variable available from the probed stack frame,
> >         including all globals.  We could just make the globals off
> >         limits, but that weakens the value of the debugger.
> >         Alternatively, we could expand the kprobe API to allow probes
> >         access to named global variables (tricky to get right without
> >         effectively giving general symbol access).  Thoughts?
> 
> Could we provide a separated GPL'd interface to access named global
> symbols which is based on kallsyms?

Yes, I think so ... it's just a case of working out what and how; but to
do that we need a consumer of the interface.

James



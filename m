Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYGVDxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYGVDxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbYGVDxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:53:14 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49495 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869AbYGVDxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:53:13 -0400
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <y0mprp68zg9.fsf@ton.toronto.redhat.com>
References: <1216676595.3433.80.camel@localhost.localdomain>
	 <y0mprp68zg9.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 22:53:08 -0500
Message-Id: <1216698788.3433.116.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 21:44 -0400, Frank Ch. Eigler wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > [...]  Fix all of this by prefixing local symbols with the actual C
> > file name they occur in separated by '|' (I had to use '|' since ':'
> > is already in use for module prefixes in kallsyms lookups.  [...]
> > Comments?
> 
> Can we take some time to review how we got here?
> 
> 
> - You disprefer systemtap's use of an established, non-deprecated API
>   for placing kernel probes.  (We calculate addresses by a mixture of
>   elf-analysis and runtime user-space lookup means.  That's partly
>   since kallsyms_lookup was unexported over our objections.)  There is
>   nothing outright broken (e.g. incorrect numbers) with what systemtap
>   has been doing for years.

You mean embedding half a megabyte of symbols simply so you can avoid
the inconvenience of using a kernel API? yes, I think it's ...
suboptimal.

> - You argue that symbols+offset kprobing is better.  We can see that,
>   in some sense, but ...
> 
> - I explain that we are used to final address calculating, as we'll
>   have to do that regardless for user-space probes.  Plus we need to
>   work with kernels that predate the symbol+offset kprobe api
>   extension.  So this change would not simplify systemtap in any way.
>   You do not respond.

There is no current userspace infrastructure, since utrace still isn't
in the kernel, so you're predicating this argument on an event which
hasn't happened.

Even assuming utrace is accepted, embedding the symbol table of every
user space process in the probes is still daft.  It's this constant
assertion that "it must be done my way" that's causing such a drag on
the open source process.  For instance, the obvious way to me of doing
this would be to map the user space stack into the systemtap runtime and
unwind it from there instead of vectoring it into the kernel.

> - I offer _stext+offset (for the kernel) and (.text*)+offset (for
>   modules) kprobes: basically to use the "better" symbol+offset
>   kprobes api, but use the same single reference addresses we already
>   do, and leaving just the final addition to the kernel.  You do not
>   respond materially.

I thought this and subsequent emails addressed the points pretty well:

http://marc.info/?l=linux-kernel&m=121632572409118

> - You argue that it cannot only be any symbol+offset ... but the actual
>   nearest symbol+offset.  But that doesn't work for local symbols.  So
>   you fix that to the nearest globally visible symbol+offset.  But this
>   requires:
>   - yet more extra work and code from systemtap

I'm afraid that's how open source development works ... you iterate to
find the best solution

>   - extension to the kernel build system, and kallsyms runtime data to
>     fix the current local-symbol-ambiguity problem

Finding weaknesses in APIs and fixing them is what it's all about.

>   - storage of all that new file name data in permanent unswappable
>     kernel data (>>100kB, if done simply prefixing local symbol names
>     file file names).

I'd check my facts before making assertions.  The kernel symbol table is
stored in a compressed form that actually eliminates most of these
repetitions.

>   - possible further complications related to filename string matching

Any substantiation of that?

> - You have yet to invent a scheme to allow offloading *data* address
>   calculations to the kernel.  Without that (and perhaps more),
>   systemtap will *still* have to fetch same base _stext etc.
>   addresses at run time that it currently does -- even if it did not
>   use them to compute kprobes addresses.

That would be because I haven't actually started looking at this one
yet.  Of course, that would make it a great starting point for others
who wished to help.

> In total, this path would end up with both systemtap and the kernel
> more complex, larger and a bit slower too.

Really?  I count the reduction of the probe modules from 500kb to 50kb a
worthwhile saving.  I don't even see where anything became larger.

>   Does that still seem an
> acceptable cost, just to get systemtap to change its preferred kprobes
> api?

James



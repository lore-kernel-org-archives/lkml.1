Return-Path: <linux-kernel-owner+w=401wt.eu-S933906AbXLRHYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbXLRHYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXLRHYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:24:08 -0500
Received: from ozlabs.org ([203.10.76.45]:54336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXLRHYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:24:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Subject: Re: [RFC] [patch 1/2] add non_init_kernel_text_address
Date: Tue, 18 Dec 2007 18:23:53 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: ananth@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
References: <200712141225.30099.srinivasa@in.ibm.com> <200712181557.35712.rusty@rustcorp.com.au> <47676CB7.4060203@in.ibm.com>
In-Reply-To: <47676CB7.4060203@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181823.54382.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 17:46:15 Srinivasa Ds wrote:
> Rusty Russell wrote:
> > On Friday 14 December 2007 18:51:06 Ananth N Mavinakayanahalli wrote:
> >> On Thu, Dec 13, 2007 at 11:09:16PM -0800, Andrew Morton wrote:
> >>> regular_kernel_text_address()?  Dunno.
> >>
> >> Sounds better :-)
> >
> > The better answer was to invert it and use
> > "discarded_kernel_text_address()", which is what you actually care about
> > (rather than the details of whether it was init or not).
>
> Requirement is to ensure the address is really a kernel_text address and
> doesn't lie in __init section. Hence I used
> persistent_kernel_text_address().

Hi Srinivasa!

    That's not my point.  What you care about is that the text still be there.  
The fact that it's the __init section which is discarded is a detail; if some 
other text section were discarded you'd want that excluded too.  Hence 
non_init_ was a bad name; persistent is a bad name because it usually means 
something else in operating systems...

> > However, you have, in fact, located a potential bug.  If someone were to
> > kmalloc module text, then symbol_put() could fail.
>
> I don't think so, symbol_put() makes use of lookup_symbol() within
> __start_ksymtab and  stop_ksymtab.

Sorry, I meant symbol_put_addr().

> > How's this?
> > ---
> > Don't report discarded init pages as kernel text.
> >
> > In theory this could cause a bug in symbol_put() if an arch used for
> > a module: we might think the symbol belongs to the core kernel.
>
> Yes, usage of symbol_put_addr() cause the BUG() if it fails
> to find the address in core kernel.

No, symbol_put_addr() will fail to decrement the module count, thinking it's 
part of the (now-discarded) init section.

> > The downside is that this might make backtraces through (discarded)
> > init functions harder to read on some archs.
>
> I think it is better to make use of new function than sacrificing
> __init function symbol information in backtrace.

Perhaps, but two new functions is v. ugly.  I'll try to come up with something 
neater, and audit all the callers.

Thanks,
Rusty.
